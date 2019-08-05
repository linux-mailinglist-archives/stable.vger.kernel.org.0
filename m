Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA49781C05
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbfHENTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:19:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728991AbfHENTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:19:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95853214C6;
        Mon,  5 Aug 2019 13:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011171;
        bh=WKk7Po/DdPi+mkB6NA0NVJqtNYKUxWRUF1VhLXt1suA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olzOwIT/uj2MdgBz5NnFu7lz+6RdQEPjJrhZ2FkeXHCPghRiksB3AOssFQG1Fh1Ny
         0dlXEeOVoCHUDS4Mc5ZMcBBNCNjV2QH+Q41dAQkeL8gElOYg4fblW7sbzl2XiyI+DY
         zrJOq9cb9QpY6nFhIfShpVXjLMgsyeH84I9puvzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin LABBE <clabbe@baylibre.com>,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 4.19 70/74] ARC: enable uboot support unconditionally
Date:   Mon,  5 Aug 2019 15:03:23 +0200
Message-Id: <20190805124941.456368181@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>

commit 493a2f812446e92bcb1e69a77381b4d39808d730 upstream.

After reworking U-boot args handling code and adding paranoid
arguments check we can eliminate CONFIG_ARC_UBOOT_SUPPORT and
enable uboot support unconditionally.

For JTAG case we can assume that core registers will come up
reset value of 0 or in worst case we rely on user passing
'-on=clear_regs' to Metaware debugger.

Cc: stable@vger.kernel.org
Tested-by: Corentin LABBE <clabbe@baylibre.com>
Signed-off-by: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/Kconfig                        |   13 -------------
 arch/arc/configs/nps_defconfig          |    1 -
 arch/arc/configs/vdk_hs38_defconfig     |    1 -
 arch/arc/configs/vdk_hs38_smp_defconfig |    2 --
 arch/arc/kernel/head.S                  |    2 --
 arch/arc/kernel/setup.c                 |    2 --
 6 files changed, 21 deletions(-)

--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -199,7 +199,6 @@ config NR_CPUS
 
 config ARC_SMP_HALT_ON_RESET
 	bool "Enable Halt-on-reset boot mode"
-	default y if ARC_UBOOT_SUPPORT
 	help
 	  In SMP configuration cores can be configured as Halt-on-reset
 	  or they could all start at same time. For Halt-on-reset, non
@@ -539,18 +538,6 @@ config ARC_DBG_TLB_PARANOIA
 
 endif
 
-config ARC_UBOOT_SUPPORT
-	bool "Support uboot arg Handling"
-	default n
-	help
-	  ARC Linux by default checks for uboot provided args as pointers to
-	  external cmdline or DTB. This however breaks in absence of uboot,
-	  when booting from Metaware debugger directly, as the registers are
-	  not zeroed out on reset by mdb and/or ARCv2 based cores. The bogus
-	  registers look like uboot args to kernel which then chokes.
-	  So only enable the uboot arg checking/processing if users are sure
-	  of uboot being in play.
-
 config ARC_BUILTIN_DTB_NAME
 	string "Built in DTB"
 	help
--- a/arch/arc/configs/nps_defconfig
+++ b/arch/arc/configs/nps_defconfig
@@ -31,7 +31,6 @@ CONFIG_ARC_CACHE_LINE_SHIFT=5
 # CONFIG_ARC_HAS_LLSC is not set
 CONFIG_ARC_KVADDR_SIZE=402
 CONFIG_ARC_EMUL_UNALIGNED=y
-CONFIG_ARC_UBOOT_SUPPORT=y
 CONFIG_PREEMPT=y
 CONFIG_NET=y
 CONFIG_UNIX=y
--- a/arch/arc/configs/vdk_hs38_defconfig
+++ b/arch/arc/configs/vdk_hs38_defconfig
@@ -13,7 +13,6 @@ CONFIG_PARTITION_ADVANCED=y
 CONFIG_ARC_PLAT_AXS10X=y
 CONFIG_AXS103=y
 CONFIG_ISA_ARCV2=y
-CONFIG_ARC_UBOOT_SUPPORT=y
 CONFIG_ARC_BUILTIN_DTB_NAME="vdk_hs38"
 CONFIG_PREEMPT=y
 CONFIG_NET=y
--- a/arch/arc/configs/vdk_hs38_smp_defconfig
+++ b/arch/arc/configs/vdk_hs38_smp_defconfig
@@ -15,8 +15,6 @@ CONFIG_AXS103=y
 CONFIG_ISA_ARCV2=y
 CONFIG_SMP=y
 # CONFIG_ARC_TIMERS_64BIT is not set
-# CONFIG_ARC_SMP_HALT_ON_RESET is not set
-CONFIG_ARC_UBOOT_SUPPORT=y
 CONFIG_ARC_BUILTIN_DTB_NAME="vdk_hs38_smp"
 CONFIG_PREEMPT=y
 CONFIG_NET=y
--- a/arch/arc/kernel/head.S
+++ b/arch/arc/kernel/head.S
@@ -100,7 +100,6 @@ ENTRY(stext)
 	st.ab   0, [r5, 4]
 1:
 
-#ifdef CONFIG_ARC_UBOOT_SUPPORT
 	; Uboot - kernel ABI
 	;    r0 = [0] No uboot interaction, [1] cmdline in r2, [2] DTB in r2
 	;    r1 = magic number (always zero as of now)
@@ -109,7 +108,6 @@ ENTRY(stext)
 	st	r0, [@uboot_tag]
 	st      r1, [@uboot_magic]
 	st	r2, [@uboot_arg]
-#endif
 
 	; setup "current" tsk and optionally cache it in dedicated r25
 	mov	r9, @init_task
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -493,7 +493,6 @@ void __init handle_uboot_args(void)
 	bool use_embedded_dtb = true;
 	bool append_cmdline = false;
 
-#ifdef CONFIG_ARC_UBOOT_SUPPORT
 	/* check that we know this tag */
 	if (uboot_tag != UBOOT_TAG_NONE &&
 	    uboot_tag != UBOOT_TAG_CMDLINE &&
@@ -525,7 +524,6 @@ void __init handle_uboot_args(void)
 		append_cmdline = true;
 
 ignore_uboot_args:
-#endif
 
 	if (use_embedded_dtb) {
 		machine_desc = setup_machine_fdt(__dtb_start);


