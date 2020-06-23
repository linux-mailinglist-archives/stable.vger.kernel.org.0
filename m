Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741A9205D76
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389103AbgFWUNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388585AbgFWUNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:13:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7216820707;
        Tue, 23 Jun 2020 20:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943214;
        bh=kmCuUneOgrsaCjQY4XoQyOFfFUkVDN8JazHn6sETeRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RI9hFy+sdKk2USHnBwOrGP08MMYhYzF3otUEtlrdNDdPHXN/tbAUNNPJdKELn070Z
         nNdAZKC/eLd7FxpZ/4jjwvk5SKYbv076yG8RDFTwrffl3y9UnfNNdjsPWMkcn0hG6X
         DRgH7AEQuFa7cB2LbhzUH7Z16kAMcQsvL4eDFLWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 274/477] powerpc/8xx: Drop CONFIG_8xx_COPYBACK option
Date:   Tue, 23 Jun 2020 21:54:31 +0200
Message-Id: <20200623195420.516308029@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit d3efcd38c0b99162d889e36a30425345a18edb33 ]

CONFIG_8xx_COPYBACK was there to help disabling copyback cache mode
for debuging hardware. But nobody will design new boards with 8xx now.

All 8xx platforms select it, so make it the default and remove
the option.

Also remove the Mx_RESETVAL values which are pretty useless and hide
the real value while reading code.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/bcc968cda075516eb76e2f25e09821f582c566b4.1589866984.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/configs/adder875_defconfig      |  1 -
 arch/powerpc/configs/ep88xc_defconfig        |  1 -
 arch/powerpc/configs/mpc866_ads_defconfig    |  1 -
 arch/powerpc/configs/mpc885_ads_defconfig    |  1 -
 arch/powerpc/configs/tqm8xx_defconfig        |  1 -
 arch/powerpc/include/asm/nohash/32/mmu-8xx.h |  2 --
 arch/powerpc/kernel/head_8xx.S               | 15 +--------------
 arch/powerpc/platforms/8xx/Kconfig           |  9 ---------
 8 files changed, 1 insertion(+), 30 deletions(-)

diff --git a/arch/powerpc/configs/adder875_defconfig b/arch/powerpc/configs/adder875_defconfig
index f55e23cb176cc..5326bc7392790 100644
--- a/arch/powerpc/configs/adder875_defconfig
+++ b/arch/powerpc/configs/adder875_defconfig
@@ -10,7 +10,6 @@ CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_PPC_ADDER875=y
-CONFIG_8xx_COPYBACK=y
 CONFIG_GEN_RTC=y
 CONFIG_HZ_1000=y
 # CONFIG_SECCOMP is not set
diff --git a/arch/powerpc/configs/ep88xc_defconfig b/arch/powerpc/configs/ep88xc_defconfig
index 0e2e5e81a3595..f5c3e72da7196 100644
--- a/arch/powerpc/configs/ep88xc_defconfig
+++ b/arch/powerpc/configs/ep88xc_defconfig
@@ -12,7 +12,6 @@ CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_PPC_EP88XC=y
-CONFIG_8xx_COPYBACK=y
 CONFIG_GEN_RTC=y
 CONFIG_HZ_100=y
 # CONFIG_SECCOMP is not set
diff --git a/arch/powerpc/configs/mpc866_ads_defconfig b/arch/powerpc/configs/mpc866_ads_defconfig
index 5320735395e7f..5c56d36cdfc5c 100644
--- a/arch/powerpc/configs/mpc866_ads_defconfig
+++ b/arch/powerpc/configs/mpc866_ads_defconfig
@@ -12,7 +12,6 @@ CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_MPC86XADS=y
-CONFIG_8xx_COPYBACK=y
 CONFIG_GEN_RTC=y
 CONFIG_HZ_1000=y
 CONFIG_MATH_EMULATION=y
diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
index 82a008c04eaec..949ff9ccda5e7 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -11,7 +11,6 @@ CONFIG_EXPERT=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_PARTITION_ADVANCED=y
-CONFIG_8xx_COPYBACK=y
 CONFIG_GEN_RTC=y
 CONFIG_HZ_100=y
 # CONFIG_SECCOMP is not set
diff --git a/arch/powerpc/configs/tqm8xx_defconfig b/arch/powerpc/configs/tqm8xx_defconfig
index eda8bfb2d0a3a..77857d5130223 100644
--- a/arch/powerpc/configs/tqm8xx_defconfig
+++ b/arch/powerpc/configs/tqm8xx_defconfig
@@ -15,7 +15,6 @@ CONFIG_MODULE_SRCVERSION_ALL=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_TQM8XX=y
-CONFIG_8xx_COPYBACK=y
 # CONFIG_8xx_CPU15 is not set
 CONFIG_GEN_RTC=y
 CONFIG_HZ_100=y
diff --git a/arch/powerpc/include/asm/nohash/32/mmu-8xx.h b/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
index 76af5b0cb16ec..26b7cee34dfe5 100644
--- a/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
@@ -19,7 +19,6 @@
 #define MI_RSV4I	0x08000000	/* Reserve 4 TLB entries */
 #define MI_PPCS		0x02000000	/* Use MI_RPN prob/priv state */
 #define MI_IDXMASK	0x00001f00	/* TLB index to be loaded */
-#define MI_RESETVAL	0x00000000	/* Value of register at reset */
 
 /* These are the Ks and Kp from the PowerPC books.  For proper operation,
  * Ks = 0, Kp = 1.
@@ -95,7 +94,6 @@
 #define MD_TWAM		0x04000000	/* Use 4K page hardware assist */
 #define MD_PPCS		0x02000000	/* Use MI_RPN prob/priv state */
 #define MD_IDXMASK	0x00001f00	/* TLB index to be loaded */
-#define MD_RESETVAL	0x04000000	/* Value of register at reset */
 
 #define SPRN_M_CASID	793	/* Address space ID (context) to match */
 #define MC_ASIDMASK	0x0000000f	/* Bits used for ASID value */
diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 073a651787df8..905205c79a25e 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -779,10 +779,7 @@ start_here:
 initial_mmu:
 	li	r8, 0
 	mtspr	SPRN_MI_CTR, r8		/* remove PINNED ITLB entries */
-	lis	r10, MD_RESETVAL@h
-#ifndef CONFIG_8xx_COPYBACK
-	oris	r10, r10, MD_WTDEF@h
-#endif
+	lis	r10, MD_TWAM@h
 	mtspr	SPRN_MD_CTR, r10	/* remove PINNED DTLB entries */
 
 	tlbia			/* Invalidate all TLB entries */
@@ -857,17 +854,7 @@ initial_mmu:
 	mtspr	SPRN_DC_CST, r8
 	lis	r8, IDC_ENABLE@h
 	mtspr	SPRN_IC_CST, r8
-#ifdef CONFIG_8xx_COPYBACK
-	mtspr	SPRN_DC_CST, r8
-#else
-	/* For a debug option, I left this here to easily enable
-	 * the write through cache mode
-	 */
-	lis	r8, DC_SFWT@h
 	mtspr	SPRN_DC_CST, r8
-	lis	r8, IDC_ENABLE@h
-	mtspr	SPRN_DC_CST, r8
-#endif
 	/* Disable debug mode entry on breakpoints */
 	mfspr	r8, SPRN_DER
 #ifdef CONFIG_PERF_EVENTS
diff --git a/arch/powerpc/platforms/8xx/Kconfig b/arch/powerpc/platforms/8xx/Kconfig
index e0fe670f06f60..b37de62d7e7f7 100644
--- a/arch/powerpc/platforms/8xx/Kconfig
+++ b/arch/powerpc/platforms/8xx/Kconfig
@@ -98,15 +98,6 @@ menu "MPC8xx CPM Options"
 # 8xx specific questions.
 comment "Generic MPC8xx Options"
 
-config 8xx_COPYBACK
-	bool "Copy-Back Data Cache (else Writethrough)"
-	help
-	  Saying Y here will cause the cache on an MPC8xx processor to be used
-	  in Copy-Back mode.  If you say N here, it is used in Writethrough
-	  mode.
-
-	  If in doubt, say Y here.
-
 config 8xx_GPIO
 	bool "GPIO API Support"
 	select GPIOLIB
-- 
2.25.1



