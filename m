Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804BC54154E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378219AbiFGUfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359600AbiFGU3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:29:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129F91DF103;
        Tue,  7 Jun 2022 11:34:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F9E961578;
        Tue,  7 Jun 2022 18:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94134C385A2;
        Tue,  7 Jun 2022 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626851;
        bh=UxbhR46gJUd+PJemqjtAXlkwz/NFwLdLTfbOQ5t3pJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8Ro7JHv3GdOf1dZ5B03pqk4sMpyatgK1G2iU8JO1x8wnOqKhh3CLFN6cvZWDGdNM
         gQzfXhQnMJ09tAtQR7djHewNUAxwRDPZL5sX6zc3gcH8z4k2rXdCOCjb4LxtKcvpPr
         7zbDoQrlwRba5k0bVslfkA1xhzByLWLNxLkyLGJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 528/772] module: fix [e_shstrndx].sh_size=0 OOB access
Date:   Tue,  7 Jun 2022 19:02:00 +0200
Message-Id: <20220607165004.532150453@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 46a5c2ed1928..740323cff545 100644
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



