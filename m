Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB69C4CF9C2
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbiCGKM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242560AbiCGKLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9628AE54;
        Mon,  7 Mar 2022 01:55:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6484DB80F9F;
        Mon,  7 Mar 2022 09:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF29C340E9;
        Mon,  7 Mar 2022 09:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646922;
        bh=KjGoanFe9yX2UdN5dVRQKQaNmaQjJPnPPFDSw4zrYPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0z5CeZrhKTZ7nCK66sU/MkSQ3dat35Yy/ZmWZT439l+0qJIRDwmK756wHOgpaW80
         IZ+n3Hou05EOz5Pv7ouW5eih29CbDS3KrIUzhpHwXB6nPv2ceA6jJicjbytPm0ijwF
         urSrW6KdupBF8MklJXkED5RdhclUjSwG/3R/jRKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Stezenbach <js@sig21.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.16 108/186] ARM: Fix kgdb breakpoint for Thumb2
Date:   Mon,  7 Mar 2022 10:19:06 +0100
Message-Id: <20220307091657.098264721@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit d920eaa4c4559f59be7b4c2d26fa0a2e1aaa3da9 upstream.

The kgdb code needs to register an undef hook for the Thumb UDF
instruction that will fault in order to be functional on Thumb2
platforms.

Reported-by: Johannes Stezenbach <js@sig21.net>
Tested-by: Johannes Stezenbach <js@sig21.net>
Fixes: 5cbad0ebf45c ("kgdb: support for ARCH=arm")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/kgdb.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -154,22 +154,38 @@ static int kgdb_compiled_brk_fn(struct p
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
 


