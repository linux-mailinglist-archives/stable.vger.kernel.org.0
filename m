Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6543C56FD7C
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbiGKJ4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234024AbiGKJzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:55:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F236B196F;
        Mon, 11 Jul 2022 02:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EAF361366;
        Mon, 11 Jul 2022 09:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1233C34115;
        Mon, 11 Jul 2022 09:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531582;
        bh=jnOphOWqpgoZV4dWNukkzUVmQEoSgCbpw4TlAg2/yL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXQEODg9HeXN3v+3RAmA+MFIt1hw1C7E3vud1LJW66htzynH6ZmY/pWWqoedOOYVY
         KFBpuxMlUqigaP+/Xzv0KbgUyJmfuBHzofQ/eMyWAAc+cp6M1NuGjy6uPv8fOItz8q
         FJILZKirxYatbUHxqSlrl4cQj83R+2hJ7LuEDFZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/230] module: fix [e_shstrndx].sh_size=0 OOB access
Date:   Mon, 11 Jul 2022 11:06:53 +0200
Message-Id: <20220711090608.514645585@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 391e982bfa632b8315235d8be9c0a81374c6a19c ]

It is trivial to craft a module to trigger OOB access in this line:

	if (info->secstrings[strhdr->sh_size - 1] != '\0') {

BUG: unable to handle page fault for address: ffffc90000aa0fff
PGD 100000067 P4D 100000067 PUD 100066067 PMD 10436f067 PTE 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 7 PID: 1215 Comm: insmod Not tainted 5.18.0-rc5-00007-g9bf578647087-dirty #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/01/2014
RIP: 0010:load_module+0x19b/0x2391

Fixes: ec2a29593c83 ("module: harden ELF info handling")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
[rebased patch onto modules-next]
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index 256b3c80a771..ef79f4dbda87 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3029,6 +3029,10 @@ static int elf_validity_check(struct load_info *info)
 	 * strings in the section safe.
 	 */
 	info->secstrings = (void *)info->hdr + strhdr->sh_offset;
+	if (strhdr->sh_size == 0) {
+		pr_err("empty section name table\n");
+		goto no_exec;
+	}
 	if (info->secstrings[strhdr->sh_size - 1] != '\0') {
 		pr_err("ELF Spec violation: section name table isn't null terminated\n");
 		goto no_exec;
-- 
2.35.1



