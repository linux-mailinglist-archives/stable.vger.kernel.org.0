Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7616753C055
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 23:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbiFBVW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 17:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiFBVWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 17:22:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CC26587;
        Thu,  2 Jun 2022 14:22:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9E7BB82180;
        Thu,  2 Jun 2022 21:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F940C385A5;
        Thu,  2 Jun 2022 21:22:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="E0HF5nn8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654204969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dxLGBl7v8u3rcLNq9XWqGXvKeMQ71NgT/hcJ68hc2Bs=;
        b=E0HF5nn8Q4o/4PCKJOR/T2UbSHr1ys+MqXv+zrUF3ppx9pYapyKM595NthI5ZPIeiMndZS
        XpMRoLy/51DolGDKqm58VLkplQJBSsFcNtE+FEEbVWJAAmI1NpzVHZv2D8T8RyGOAItwdE
        100k8aRo2+flhQEawoDkt4YJXj/kngQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4bb1c12f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 2 Jun 2022 21:22:49 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux@armlinux.org.uk, rmk+kernel@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] ARM: initialize jump labels before setup_machine_fdt()
Date:   Thu,  2 Jun 2022 23:22:34 +0200
Message-Id: <20220602212234.344394-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stephen reported that a static key warning splat appears during early
boot on arm64 systems that credit randomness from device trees that
contain an "rng-seed" property, because setup_machine_fdt() is called
before jump_label_init() during setup_arch(), which was fixed by
73e2d827a501 ("arm64: Initialize jump labels before
setup_machine_fdt()").

Upon cursory inspection, the same basic issue appears to apply to arm32
as well. In this case, we reorder setup_arch() to do things in the same
order as is now the case on arm64.

Reported-by: Stephen Boyd <swboyd@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org
Fixes: f5bda35fba61 ("random: use static branch for crng_ready()")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/arm/kernel/setup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 1e8a50a97edf..ef40d9f5d5a7 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1097,10 +1097,15 @@ void __init setup_arch(char **cmdline_p)
 	const struct machine_desc *mdesc = NULL;
 	void *atags_vaddr = NULL;
 
+	setup_initial_init_mm(_text, _etext, _edata, _end);
+	setup_processor();
+	early_fixmap_init();
+	early_ioremap_init();
+	jump_label_init();
+
 	if (__atags_pointer)
 		atags_vaddr = FDT_VIRT_BASE(__atags_pointer);
 
-	setup_processor();
 	if (atags_vaddr) {
 		mdesc = setup_machine_fdt(atags_vaddr);
 		if (mdesc)
@@ -1125,15 +1130,10 @@ void __init setup_arch(char **cmdline_p)
 	if (mdesc->reboot_mode != REBOOT_HARD)
 		reboot_mode = mdesc->reboot_mode;
 
-	setup_initial_init_mm(_text, _etext, _edata, _end);
-
 	/* populate cmd_line too for later use, preserving boot_command_line */
 	strlcpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = cmd_line;
 
-	early_fixmap_init();
-	early_ioremap_init();
-
 	parse_early_param();
 
 #ifdef CONFIG_MMU
-- 
2.35.1

