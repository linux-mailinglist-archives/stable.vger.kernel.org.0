Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086B1541CA5
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382484AbiFGWCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382702AbiFGV7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:59:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267EF24E009;
        Tue,  7 Jun 2022 12:14:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3E056187F;
        Tue,  7 Jun 2022 19:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A428C385A2;
        Tue,  7 Jun 2022 19:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629241;
        bh=5NVwfizFJYa+rVoBcHgPIn0dLHQ3kWh10mrNptlL5ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puvmC65iLdPQEPaDzBB6WZ+9hwWLdiYexgbeKbCiT8CQNA3n/olqlt3DcsogJQYQl
         g0dlelLIFyj9EE2Zins/eJJ2CtCYGjsg+nd3HDxNpQd31q4AMk3D3c53s2D8i9Kxy6
         YpvP/fKtAs9Hp5Idre44q0LRsIjN9LhCS9dBnM18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 619/879] module: fix [e_shstrndx].sh_size=0 OOB access
Date:   Tue,  7 Jun 2022 19:02:17 +0200
Message-Id: <20220607165020.817539600@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 6cea788fd965..6529c84c536f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3033,6 +3033,10 @@ static int elf_validity_check(struct load_info *info)
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



