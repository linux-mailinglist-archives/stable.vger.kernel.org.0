Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718DD4CE6B3
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 21:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiCEUJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 15:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiCEUJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 15:09:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8969340D8
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 12:08:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41A5F60B65
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 20:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E80AC004E1;
        Sat,  5 Mar 2022 20:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646510895;
        bh=Au8pUWpl3Balf2Tapbf0VyzsuqfcaXZaUXi3oYL9J6w=;
        h=Subject:To:Cc:From:Date:From;
        b=OzzsW7ZdJds/gHpgFh5Lw6M0dhAnqMaxlyZz2ZsZ3dTQZMhafMukxNKm/GFTEajx0
         3jMV5gTOgTPyIIVgZC1aJ2a9nlNtpeE0mjXzPJJjHO1E+tJ5sZ7ch9wdxpPV1jcKIC
         4qxy6OHKXhyxSV5N9J/rMpzGPOLyOX9SjwG1elc0=
Subject: FAILED: patch "[PATCH] ARM: Fix kgdb breakpoint for Thumb2" failed to apply to 4.9-stable tree
To:     rmk+kernel@armlinux.org.uk, js@sig21.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Mar 2022 21:08:10 +0100
Message-ID: <1646510890182251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d920eaa4c4559f59be7b4c2d26fa0a2e1aaa3da9 Mon Sep 17 00:00:00 2001
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Date: Wed, 16 Feb 2022 15:37:38 +0000
Subject: [PATCH] ARM: Fix kgdb breakpoint for Thumb2

The kgdb code needs to register an undef hook for the Thumb UDF
instruction that will fault in order to be functional on Thumb2
platforms.

Reported-by: Johannes Stezenbach <js@sig21.net>
Tested-by: Johannes Stezenbach <js@sig21.net>
Fixes: 5cbad0ebf45c ("kgdb: support for ARCH=arm")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index 7bd30c0a4280..22f937e6f3ff 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -154,22 +154,38 @@ static int kgdb_compiled_brk_fn(struct pt_regs *regs, unsigned int instr)
 	return 0;
 }
 
-static struct undef_hook kgdb_brkpt_hook = {
+static struct undef_hook kgdb_brkpt_arm_hook = {
 	.instr_mask		= 0xffffffff,
 	.instr_val		= KGDB_BREAKINST,
-	.cpsr_mask		= MODE_MASK,
+	.cpsr_mask		= PSR_T_BIT | MODE_MASK,
 	.cpsr_val		= SVC_MODE,
 	.fn			= kgdb_brk_fn
 };
 
-static struct undef_hook kgdb_compiled_brkpt_hook = {
+static struct undef_hook kgdb_brkpt_thumb_hook = {
+	.instr_mask		= 0xffff,
+	.instr_val		= KGDB_BREAKINST & 0xffff,
+	.cpsr_mask		= PSR_T_BIT | MODE_MASK,
+	.cpsr_val		= PSR_T_BIT | SVC_MODE,
+	.fn			= kgdb_brk_fn
+};
+
+static struct undef_hook kgdb_compiled_brkpt_arm_hook = {
 	.instr_mask		= 0xffffffff,
 	.instr_val		= KGDB_COMPILED_BREAK,
-	.cpsr_mask		= MODE_MASK,
+	.cpsr_mask		= PSR_T_BIT | MODE_MASK,
 	.cpsr_val		= SVC_MODE,
 	.fn			= kgdb_compiled_brk_fn
 };
 
+static struct undef_hook kgdb_compiled_brkpt_thumb_hook = {
+	.instr_mask		= 0xffff,
+	.instr_val		= KGDB_COMPILED_BREAK & 0xffff,
+	.cpsr_mask		= PSR_T_BIT | MODE_MASK,
+	.cpsr_val		= PSR_T_BIT | SVC_MODE,
+	.fn			= kgdb_compiled_brk_fn
+};
+
 static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 {
 	struct pt_regs *regs = args->regs;
@@ -210,8 +226,10 @@ int kgdb_arch_init(void)
 	if (ret != 0)
 		return ret;
 
-	register_undef_hook(&kgdb_brkpt_hook);
-	register_undef_hook(&kgdb_compiled_brkpt_hook);
+	register_undef_hook(&kgdb_brkpt_arm_hook);
+	register_undef_hook(&kgdb_brkpt_thumb_hook);
+	register_undef_hook(&kgdb_compiled_brkpt_arm_hook);
+	register_undef_hook(&kgdb_compiled_brkpt_thumb_hook);
 
 	return 0;
 }
@@ -224,8 +242,10 @@ int kgdb_arch_init(void)
  */
 void kgdb_arch_exit(void)
 {
-	unregister_undef_hook(&kgdb_brkpt_hook);
-	unregister_undef_hook(&kgdb_compiled_brkpt_hook);
+	unregister_undef_hook(&kgdb_brkpt_arm_hook);
+	unregister_undef_hook(&kgdb_brkpt_thumb_hook);
+	unregister_undef_hook(&kgdb_compiled_brkpt_arm_hook);
+	unregister_undef_hook(&kgdb_compiled_brkpt_thumb_hook);
 	unregister_die_notifier(&kgdb_notifier);
 }
 

