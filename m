Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5851662AFC
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 17:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbjAIQRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 11:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjAIQQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 11:16:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C28EBF48;
        Mon,  9 Jan 2023 08:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BB676118C;
        Mon,  9 Jan 2023 16:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9794BC433F0;
        Mon,  9 Jan 2023 16:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673281011;
        bh=PmhN31TQlCHG66Ep9AWwrNPbC2HLA7D9FAalYlsE44E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFwraePG+womAa0oFp873AfKcQOEDOPHZj4vSUSpiL3HaHwtw5spVA82m/Ty9z5mj
         dDhFhk/hUDFEqWkUaUcb9hAewIkSDaoR9oKqDHRMFje400usY9V0wEUmPdj/v4+R8f
         KvSbZKT81FVQQ3BioFYmsqIR3xrbFRNMj5dAry8s+s1BZLC1dxwcPKXGQNnW13pNlW
         I4pBkeIMC/Gohqj4e4Q2RFW6I/MMn/hMN124bnqGwsLuBG8YzLDnQkNH7CXZ2kBiJT
         oYjda+1l+BRJGByxfHRvJcOgH/ScElSbbEL75MCnKf4whsX27rYkTFgoa99o9muX2k
         K+E2UurfUA5QQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Aaro Koskinen <aaro.koskinen@iki.fi>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Subject: [PATCH 2/3] ARM: omap1: fix !ARCH_OMAP1_ANY link failures
Date:   Mon,  9 Jan 2023 17:16:35 +0100
Message-Id: <20230109161636.512203-3-arnd@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109161636.512203-1-arnd@kernel.org>
References: <20230109161636.512203-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

While compile-testing randconfig builds for the upcoming boardfile
removal, I noticed that an earlier patch of mine was completely
broken, and the introduction of CONFIG_ARCH_OMAP1_ANY only replaced
one set of build failures with another one, now resulting in
link failures like

ld: drivers/video/fbdev/omap/omapfb_main.o: in function `omapfb_do_probe':
drivers/video/fbdev/omap/omapfb_main.c:1703: undefined reference to `omap_set_dma_priority'
ld: drivers/dma/ti/omap-dma.o: in function `omap_dma_free_chan_resources':
drivers/dma/ti/omap-dma.c:777: undefined reference to `omap_free_dma'
drivers/dma/ti/omap-dma.c:1685: undefined reference to `omap_get_plat_info'
ld: drivers/usb/gadget/udc/omap_udc.o: in function `next_in_dma':
drivers/usb/gadget/udc/omap_udc.c:820: undefined reference to `omap_get_dma_active_status'

I tried reworking it, but the resulting patch ended up much bigger than
simply avoiding the original problem of unused-function warnings like

arch/arm/mach-omap1/mcbsp.c:76:30: error: unused variable 'omap1_mcbsp_ops' [-Werror,-Wunused-variable]

As a result, revert the previous fix, and rearrange the code that
produces warnings to hide them. For mcbsp, the #ifdef check can
simply be removed as the cpu_is_omapxxx() checks already achieve
the same result, while in the io.c the easiest solution appears to
be to merge the common map bits into each soc specific portion.
This gets cleaned in a nicer way after omap7xx support gets dropped,
as the remaining SoCs all have the exact same I/O map.

Fixes: 615dce5bf736 ("ARM: omap1: fix build with no SoC selected")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap1/Kconfig     |  5 +----
 arch/arm/mach-omap1/Makefile    |  4 ----
 arch/arm/mach-omap1/io.c        | 32 +++++++++++++++-----------------
 arch/arm/mach-omap1/mcbsp.c     | 21 ---------------------
 arch/arm/mach-omap1/pm.h        |  7 -------
 include/linux/soc/ti/omap1-io.h |  4 ++--
 6 files changed, 18 insertions(+), 55 deletions(-)

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 538a960257cc..7ec7ada287e0 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -4,6 +4,7 @@ menuconfig ARCH_OMAP1
 	depends on ARCH_MULTI_V4T || ARCH_MULTI_V5
 	depends on CPU_LITTLE_ENDIAN
 	depends on ATAGS
+	select ARCH_OMAP
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_OMAP
 	select CLKSRC_MMIO
@@ -45,10 +46,6 @@ config ARCH_OMAP16XX
 	select CPU_ARM926T
 	select OMAP_DM_TIMER
 
-config ARCH_OMAP1_ANY
-	select ARCH_OMAP
-	def_bool ARCH_OMAP730 || ARCH_OMAP850 || ARCH_OMAP15XX || ARCH_OMAP16XX
-
 config ARCH_OMAP
 	bool
 
diff --git a/arch/arm/mach-omap1/Makefile b/arch/arm/mach-omap1/Makefile
index 506074b86333..0615cb0ba580 100644
--- a/arch/arm/mach-omap1/Makefile
+++ b/arch/arm/mach-omap1/Makefile
@@ -3,8 +3,6 @@
 # Makefile for the linux kernel.
 #
 
-ifdef CONFIG_ARCH_OMAP1_ANY
-
 # Common support
 obj-y := io.o id.o sram-init.o sram.o time.o irq.o mux.o flash.o \
 	 serial.o devices.o dma.o omap-dma.o fb.o
@@ -59,5 +57,3 @@ obj-$(CONFIG_ARCH_OMAP730)		+= gpio7xx.o
 obj-$(CONFIG_ARCH_OMAP850)		+= gpio7xx.o
 obj-$(CONFIG_ARCH_OMAP15XX)		+= gpio15xx.o
 obj-$(CONFIG_ARCH_OMAP16XX)		+= gpio16xx.o
-
-endif
diff --git a/arch/arm/mach-omap1/io.c b/arch/arm/mach-omap1/io.c
index d2db9b8aed3f..0074b011a05a 100644
--- a/arch/arm/mach-omap1/io.c
+++ b/arch/arm/mach-omap1/io.c
@@ -22,17 +22,14 @@
  * The machine specific code may provide the extra mapping besides the
  * default mapping provided here.
  */
-static struct map_desc omap_io_desc[] __initdata = {
+#if defined (CONFIG_ARCH_OMAP730) || defined (CONFIG_ARCH_OMAP850)
+static struct map_desc omap7xx_io_desc[] __initdata = {
 	{
 		.virtual	= OMAP1_IO_VIRT,
 		.pfn		= __phys_to_pfn(OMAP1_IO_PHYS),
 		.length		= OMAP1_IO_SIZE,
 		.type		= MT_DEVICE
-	}
-};
-
-#if defined (CONFIG_ARCH_OMAP730) || defined (CONFIG_ARCH_OMAP850)
-static struct map_desc omap7xx_io_desc[] __initdata = {
+	},
 	{
 		.virtual	= OMAP7XX_DSP_BASE,
 		.pfn		= __phys_to_pfn(OMAP7XX_DSP_START),
@@ -49,6 +46,12 @@ static struct map_desc omap7xx_io_desc[] __initdata = {
 
 #ifdef CONFIG_ARCH_OMAP15XX
 static struct map_desc omap1510_io_desc[] __initdata = {
+	{
+		.virtual	= OMAP1_IO_VIRT,
+		.pfn		= __phys_to_pfn(OMAP1_IO_PHYS),
+		.length		= OMAP1_IO_SIZE,
+		.type		= MT_DEVICE
+	},
 	{
 		.virtual	= OMAP1510_DSP_BASE,
 		.pfn		= __phys_to_pfn(OMAP1510_DSP_START),
@@ -65,6 +68,12 @@ static struct map_desc omap1510_io_desc[] __initdata = {
 
 #if defined(CONFIG_ARCH_OMAP16XX)
 static struct map_desc omap16xx_io_desc[] __initdata = {
+	{
+		.virtual	= OMAP1_IO_VIRT,
+		.pfn		= __phys_to_pfn(OMAP1_IO_PHYS),
+		.length		= OMAP1_IO_SIZE,
+		.type		= MT_DEVICE
+	},
 	{
 		.virtual	= OMAP16XX_DSP_BASE,
 		.pfn		= __phys_to_pfn(OMAP16XX_DSP_START),
@@ -79,18 +88,9 @@ static struct map_desc omap16xx_io_desc[] __initdata = {
 };
 #endif
 
-/*
- * Maps common IO regions for omap1
- */
-static void __init omap1_map_common_io(void)
-{
-	iotable_init(omap_io_desc, ARRAY_SIZE(omap_io_desc));
-}
-
 #if defined (CONFIG_ARCH_OMAP730) || defined (CONFIG_ARCH_OMAP850)
 void __init omap7xx_map_io(void)
 {
-	omap1_map_common_io();
 	iotable_init(omap7xx_io_desc, ARRAY_SIZE(omap7xx_io_desc));
 }
 #endif
@@ -98,7 +98,6 @@ void __init omap7xx_map_io(void)
 #ifdef CONFIG_ARCH_OMAP15XX
 void __init omap15xx_map_io(void)
 {
-	omap1_map_common_io();
 	iotable_init(omap1510_io_desc, ARRAY_SIZE(omap1510_io_desc));
 }
 #endif
@@ -106,7 +105,6 @@ void __init omap15xx_map_io(void)
 #if defined(CONFIG_ARCH_OMAP16XX)
 void __init omap16xx_map_io(void)
 {
-	omap1_map_common_io();
 	iotable_init(omap16xx_io_desc, ARRAY_SIZE(omap16xx_io_desc));
 }
 #endif
diff --git a/arch/arm/mach-omap1/mcbsp.c b/arch/arm/mach-omap1/mcbsp.c
index 05c25c432449..b1632cbe37e6 100644
--- a/arch/arm/mach-omap1/mcbsp.c
+++ b/arch/arm/mach-omap1/mcbsp.c
@@ -89,7 +89,6 @@ static struct omap_mcbsp_ops omap1_mcbsp_ops = {
 #define OMAP1610_MCBSP2_BASE	0xfffb1000
 #define OMAP1610_MCBSP3_BASE	0xe1017000
 
-#if defined(CONFIG_ARCH_OMAP730) || defined(CONFIG_ARCH_OMAP850)
 struct resource omap7xx_mcbsp_res[][6] = {
 	{
 		{
@@ -159,14 +158,7 @@ static struct omap_mcbsp_platform_data omap7xx_mcbsp_pdata[] = {
 };
 #define OMAP7XX_MCBSP_RES_SZ		ARRAY_SIZE(omap7xx_mcbsp_res[1])
 #define OMAP7XX_MCBSP_COUNT		ARRAY_SIZE(omap7xx_mcbsp_res)
-#else
-#define omap7xx_mcbsp_res_0		NULL
-#define omap7xx_mcbsp_pdata		NULL
-#define OMAP7XX_MCBSP_RES_SZ		0
-#define OMAP7XX_MCBSP_COUNT		0
-#endif
 
-#ifdef CONFIG_ARCH_OMAP15XX
 struct resource omap15xx_mcbsp_res[][6] = {
 	{
 		{
@@ -266,14 +258,7 @@ static struct omap_mcbsp_platform_data omap15xx_mcbsp_pdata[] = {
 };
 #define OMAP15XX_MCBSP_RES_SZ		ARRAY_SIZE(omap15xx_mcbsp_res[1])
 #define OMAP15XX_MCBSP_COUNT		ARRAY_SIZE(omap15xx_mcbsp_res)
-#else
-#define omap15xx_mcbsp_res_0		NULL
-#define omap15xx_mcbsp_pdata		NULL
-#define OMAP15XX_MCBSP_RES_SZ		0
-#define OMAP15XX_MCBSP_COUNT		0
-#endif
 
-#ifdef CONFIG_ARCH_OMAP16XX
 struct resource omap16xx_mcbsp_res[][6] = {
 	{
 		{
@@ -373,12 +358,6 @@ static struct omap_mcbsp_platform_data omap16xx_mcbsp_pdata[] = {
 };
 #define OMAP16XX_MCBSP_RES_SZ		ARRAY_SIZE(omap16xx_mcbsp_res[1])
 #define OMAP16XX_MCBSP_COUNT		ARRAY_SIZE(omap16xx_mcbsp_res)
-#else
-#define omap16xx_mcbsp_res_0		NULL
-#define omap16xx_mcbsp_pdata		NULL
-#define OMAP16XX_MCBSP_RES_SZ		0
-#define OMAP16XX_MCBSP_COUNT		0
-#endif
 
 static void omap_mcbsp_register_board_cfg(struct resource *res, int res_count,
 			struct omap_mcbsp_platform_data *config, int size)
diff --git a/arch/arm/mach-omap1/pm.h b/arch/arm/mach-omap1/pm.h
index d9165709c532..0d1f092821ff 100644
--- a/arch/arm/mach-omap1/pm.h
+++ b/arch/arm/mach-omap1/pm.h
@@ -106,13 +106,6 @@
 #define OMAP7XX_IDLECT3		0xfffece24
 #define OMAP7XX_IDLE_LOOP_REQUEST	0x0C00
 
-#if     !defined(CONFIG_ARCH_OMAP730) && \
-	!defined(CONFIG_ARCH_OMAP850) && \
-	!defined(CONFIG_ARCH_OMAP15XX) && \
-	!defined(CONFIG_ARCH_OMAP16XX)
-#warning "Power management for this processor not implemented yet"
-#endif
-
 #ifndef __ASSEMBLER__
 
 #include <linux/clk.h>
diff --git a/include/linux/soc/ti/omap1-io.h b/include/linux/soc/ti/omap1-io.h
index f7f12728d4a6..9a60f45899d3 100644
--- a/include/linux/soc/ti/omap1-io.h
+++ b/include/linux/soc/ti/omap1-io.h
@@ -5,7 +5,7 @@
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
 
-#ifdef CONFIG_ARCH_OMAP1_ANY
+#ifdef CONFIG_ARCH_OMAP1
 /*
  * NOTE: Please use ioremap + __raw_read/write where possible instead of these
  */
@@ -15,7 +15,7 @@ extern u32 omap_readl(u32 pa);
 extern void omap_writeb(u8 v, u32 pa);
 extern void omap_writew(u16 v, u32 pa);
 extern void omap_writel(u32 v, u32 pa);
-#else
+#elif defined(CONFIG_COMPILE_TEST)
 static inline u8 omap_readb(u32 pa)  { return 0; }
 static inline u16 omap_readw(u32 pa) { return 0; }
 static inline u32 omap_readl(u32 pa) { return 0; }
-- 
2.39.0

