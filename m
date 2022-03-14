Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8175C4D7D34
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 09:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237571AbiCNIG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 04:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239408AbiCNIFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 04:05:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF84E1D0CE
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 01:04:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B3D161206
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 08:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2287C340E9;
        Mon, 14 Mar 2022 08:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647245050;
        bh=2f62XjVOGYN77+KCov77aMxQKFaY67/rz5VcGJUMoVk=;
        h=Subject:To:Cc:From:Date:From;
        b=IEB56Gsv5iHhbQHWzgMWutqKCJ2xgoshANbgdU6Cv296JcAFbzD0d5UdsLA61U+Tb
         xzC5Bt8efaat+ffXxVQLXkbbsGT0uJMNP3y3CTXAVfIO60+Tsar6qtoQoBmtZ3H7Do
         hBk9v5/wnvmzRlD8FqQpHUc+uYJ+p3NYCBkn2SdE=
Subject: FAILED: patch "[PATCH] x86/module: Fix the paravirt vs alternative order" failed to apply to 5.15-stable tree
To:     peterz@infradead.org, bp@suse.de, mbenes@suse.cz,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Mar 2022 09:04:06 +0100
Message-ID: <1647245046133115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5adf349439d29f92467e864f728dfc23180f3ef9 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 3 Mar 2022 12:23:23 +0100
Subject: [PATCH] x86/module: Fix the paravirt vs alternative order

Ever since commit

  4e6292114c74 ("x86/paravirt: Add new features for paravirt patching")

there is an ordering dependency between patching paravirt ops and
patching alternatives, the module loader still violates this.

Fixes: 4e6292114c74 ("x86/paravirt: Add new features for paravirt patching")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220303112825.068773913@infradead.org

diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 95fa745e310a..96d7c27b7093 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -273,6 +273,14 @@ int module_finalize(const Elf_Ehdr *hdr,
 			retpolines = s;
 	}
 
+	/*
+	 * See alternative_instructions() for the ordering rules between the
+	 * various patching types.
+	 */
+	if (para) {
+		void *pseg = (void *)para->sh_addr;
+		apply_paravirt(pseg, pseg + para->sh_size);
+	}
 	if (retpolines) {
 		void *rseg = (void *)retpolines->sh_addr;
 		apply_retpolines(rseg, rseg + retpolines->sh_size);
@@ -290,11 +298,6 @@ int module_finalize(const Elf_Ehdr *hdr,
 					    tseg, tseg + text->sh_size);
 	}
 
-	if (para) {
-		void *pseg = (void *)para->sh_addr;
-		apply_paravirt(pseg, pseg + para->sh_size);
-	}
-
 	/* make jump label nops */
 	jump_label_apply_nops(me);
 

