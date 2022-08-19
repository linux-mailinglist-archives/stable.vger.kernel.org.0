Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2725359A166
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351375AbiHSQHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351443AbiHSQFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:05:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825DF107759;
        Fri, 19 Aug 2022 08:55:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC16661746;
        Fri, 19 Aug 2022 15:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1403C433B5;
        Fri, 19 Aug 2022 15:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924512;
        bh=3N5IinqdtomHzi8xE0PdUGVJ86Iqwoa99/7IblT3vVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjbF/HwmdnBTTNR5z+MoO7cgeVo6xJoVP9gBccqUDPJJqixN0/BpK0EX+AVQ9Tgnt
         s0uzO+FjKdgQ93StyDjfkFRZvk7T/knAC3xyacQAoTPM5n97BqEPdi6BxrkSxedxDq
         AnwXwyX9NHjCgPE44ICogK1VEee980wzw+5tev88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/545] drm/vc4: dsi: Introduce a variant structure
Date:   Fri, 19 Aug 2022 17:39:25 +0200
Message-Id: <20220819153838.095675179@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit d1d195ce26a14ec0a87816c09ae514e1c40e97f7 ]

Most of the differences between DSI0 and DSI1 are handled through the
ID. However, the BCM2711 DSI is going to introduce one more variable to
the mix and will break some expectations of the earlier, simpler, test.

Let's add a variant structure that will address most of the differences
between those three controllers.

Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20201203132543.861591-5-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dsi.c | 63 ++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index 80cd2599c57b..2cedf1cf6758 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -493,6 +493,18 @@
  */
 #define DSI1_ID			0x8c
 
+struct vc4_dsi_variant {
+	/* Whether we're on bcm2835's DSI0 or DSI1. */
+	unsigned int port;
+
+	bool broken_axi_workaround;
+
+	const char *debugfs_name;
+	const struct debugfs_reg32 *regs;
+	size_t nregs;
+
+};
+
 /* General DSI hardware state. */
 struct vc4_dsi {
 	struct platform_device *pdev;
@@ -509,8 +521,7 @@ struct vc4_dsi {
 	u32 *reg_dma_mem;
 	dma_addr_t reg_paddr;
 
-	/* Whether we're on bcm2835's DSI0 or DSI1. */
-	int port;
+	const struct vc4_dsi_variant *variant;
 
 	/* DSI channel for the panel we're connected to. */
 	u32 channel;
@@ -586,10 +597,10 @@ dsi_dma_workaround_write(struct vc4_dsi *dsi, u32 offset, u32 val)
 #define DSI_READ(offset) readl(dsi->regs + (offset))
 #define DSI_WRITE(offset, val) dsi_dma_workaround_write(dsi, offset, val)
 #define DSI_PORT_READ(offset) \
-	DSI_READ(dsi->port ? DSI1_##offset : DSI0_##offset)
+	DSI_READ(dsi->variant->port ? DSI1_##offset : DSI0_##offset)
 #define DSI_PORT_WRITE(offset, val) \
-	DSI_WRITE(dsi->port ? DSI1_##offset : DSI0_##offset, val)
-#define DSI_PORT_BIT(bit) (dsi->port ? DSI1_##bit : DSI0_##bit)
+	DSI_WRITE(dsi->variant->port ? DSI1_##offset : DSI0_##offset, val)
+#define DSI_PORT_BIT(bit) (dsi->variant->port ? DSI1_##bit : DSI0_##bit)
 
 /* VC4 DSI encoder KMS struct */
 struct vc4_dsi_encoder {
@@ -835,7 +846,7 @@ static void vc4_dsi_encoder_enable(struct drm_encoder *encoder)
 
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret) {
-		DRM_ERROR("Failed to runtime PM enable on DSI%d\n", dsi->port);
+		DRM_ERROR("Failed to runtime PM enable on DSI%d\n", dsi->variant->port);
 		return;
 	}
 
@@ -869,7 +880,7 @@ static void vc4_dsi_encoder_enable(struct drm_encoder *encoder)
 	DSI_PORT_WRITE(STAT, DSI_PORT_READ(STAT));
 
 	/* Set AFE CTR00/CTR1 to release powerdown of analog. */
-	if (dsi->port == 0) {
+	if (dsi->variant->port == 0) {
 		u32 afec0 = (VC4_SET_FIELD(7, DSI_PHY_AFEC0_PTATADJ) |
 			     VC4_SET_FIELD(7, DSI_PHY_AFEC0_CTATADJ));
 
@@ -1015,7 +1026,7 @@ static void vc4_dsi_encoder_enable(struct drm_encoder *encoder)
 		       DSI_PORT_BIT(PHYC_CLANE_ENABLE) |
 		       ((dsi->mode_flags & MIPI_DSI_CLOCK_NON_CONTINUOUS) ?
 			0 : DSI_PORT_BIT(PHYC_HS_CLK_CONTINUOUS)) |
-		       (dsi->port == 0 ?
+		       (dsi->variant->port == 0 ?
 			VC4_SET_FIELD(lpx - 1, DSI0_PHYC_ESC_CLK_LPDT) :
 			VC4_SET_FIELD(lpx - 1, DSI1_PHYC_ESC_CLK_LPDT)));
 
@@ -1041,13 +1052,13 @@ static void vc4_dsi_encoder_enable(struct drm_encoder *encoder)
 		       DSI_DISP1_ENABLE);
 
 	/* Ungate the block. */
-	if (dsi->port == 0)
+	if (dsi->variant->port == 0)
 		DSI_PORT_WRITE(CTRL, DSI_PORT_READ(CTRL) | DSI0_CTRL_CTRL0);
 	else
 		DSI_PORT_WRITE(CTRL, DSI_PORT_READ(CTRL) | DSI1_CTRL_EN);
 
 	/* Bring AFE out of reset. */
-	if (dsi->port == 0) {
+	if (dsi->variant->port == 0) {
 	} else {
 		DSI_PORT_WRITE(PHY_AFEC0,
 			       DSI_PORT_READ(PHY_AFEC0) &
@@ -1303,8 +1314,16 @@ static const struct drm_encoder_helper_funcs vc4_dsi_encoder_helper_funcs = {
 	.mode_fixup = vc4_dsi_encoder_mode_fixup,
 };
 
+static const struct vc4_dsi_variant bcm2835_dsi1_variant = {
+	.port			= 1,
+	.broken_axi_workaround	= true,
+	.debugfs_name		= "dsi1_regs",
+	.regs			= dsi1_regs,
+	.nregs			= ARRAY_SIZE(dsi1_regs),
+};
+
 static const struct of_device_id vc4_dsi_dt_match[] = {
-	{ .compatible = "brcm,bcm2835-dsi1", (void *)(uintptr_t)1 },
+	{ .compatible = "brcm,bcm2835-dsi1", &bcm2835_dsi1_variant },
 	{}
 };
 
@@ -1315,7 +1334,7 @@ static void dsi_handle_error(struct vc4_dsi *dsi,
 	if (!(stat & bit))
 		return;
 
-	DRM_ERROR("DSI%d: %s error\n", dsi->port, type);
+	DRM_ERROR("DSI%d: %s error\n", dsi->variant->port, type);
 	*ret = IRQ_HANDLED;
 }
 
@@ -1413,7 +1432,7 @@ vc4_dsi_init_phy_clocks(struct vc4_dsi *dsi)
 		int ret;
 
 		snprintf(clk_name, sizeof(clk_name),
-			 "dsi%u_%s", dsi->port, phy_clocks[i].name);
+			 "dsi%u_%s", dsi->variant->port, phy_clocks[i].name);
 
 		/* We just use core fixed factor clock ops for the PHY
 		 * clocks.  The clocks are actually gated by the
@@ -1461,7 +1480,7 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 	if (!match)
 		return -ENODEV;
 
-	dsi->port = (uintptr_t)match->data;
+	dsi->variant = match->data;
 
 	vc4_dsi_encoder = devm_kzalloc(dev, sizeof(*vc4_dsi_encoder),
 				       GFP_KERNEL);
@@ -1478,13 +1497,8 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 		return PTR_ERR(dsi->regs);
 
 	dsi->regset.base = dsi->regs;
-	if (dsi->port == 0) {
-		dsi->regset.regs = dsi0_regs;
-		dsi->regset.nregs = ARRAY_SIZE(dsi0_regs);
-	} else {
-		dsi->regset.regs = dsi1_regs;
-		dsi->regset.nregs = ARRAY_SIZE(dsi1_regs);
-	}
+	dsi->regset.regs = dsi->variant->regs;
+	dsi->regset.nregs = dsi->variant->nregs;
 
 	if (DSI_PORT_READ(ID) != DSI_ID_VALUE) {
 		dev_err(dev, "Port returned 0x%08x for ID instead of 0x%08x\n",
@@ -1496,7 +1510,7 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 	 * from the ARM.  It does handle writes from the DMA engine,
 	 * so set up a channel for talking to it.
 	 */
-	if (dsi->port == 1) {
+	if (dsi->variant->broken_axi_workaround) {
 		dsi->reg_dma_mem = dma_alloc_coherent(dev, 4,
 						      &dsi->reg_dma_paddr,
 						      GFP_KERNEL);
@@ -1617,10 +1631,7 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 	 */
 	list_splice_init(&dsi->encoder->bridge_chain, &dsi->bridge_chain);
 
-	if (dsi->port == 0)
-		vc4_debugfs_add_regset32(drm, "dsi0_regs", &dsi->regset);
-	else
-		vc4_debugfs_add_regset32(drm, "dsi1_regs", &dsi->regset);
+	vc4_debugfs_add_regset32(drm, dsi->variant->debugfs_name, &dsi->regset);
 
 	pm_runtime_enable(dev);
 
-- 
2.35.1



