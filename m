Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421906B419D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbjCJNyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjCJNyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:54:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0595F10FB95
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:54:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADC01B822B7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5C5C4339E;
        Fri, 10 Mar 2023 13:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456482;
        bh=XAuJ/h1GVB4Czg9NFM4xX7yxATTwkKwsl8BuDxxv/Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUv9CnyEyJZk0KQXrnotVwBUXP480dvxU5WHiBioLv+j6QwJL697z9QMoOTK/vTKs
         wbr8UfXQ4syf46sQXRv6xwrE0B1fdErO8TmO/TKchF87JQGxhBoiuhOl/rW5OpXyH9
         H2gK3lRKxlPXS4aXQjLMKjBjnlaK1UMuadS5VAVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 010/211] memory: renesas-rpc-if: Split-off private data from struct rpcif
Date:   Fri, 10 Mar 2023 14:36:30 +0100
Message-Id: <20230310133719.040095444@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 51de3fc9a84d8e99dd3f02536a623f9fb95d0c0a ]

The rpcif structure is used as a common data structure, shared by the
RPC-IF core driver and by the HyperBus and SPI child drivers.
This poses several problems:
  - Most structure members describe private core driver state, which
    should not be accessible by the child drivers,
  - The structure's lifetime is controlled by the child drivers,
    complicating use by the core driver.

Fix this by moving the private core driver state to its own structure,
managed by the RPC-IF core driver, and store it in the core driver's
private data field.  This requires absorbing the child's platform
device, as that was stored in the driver's private data field before.

Fixes: ca7d8b980b67 ("memory: add Renesas RPC-IF driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/09fbb6fa67d5a8cd48a08808c9afa2f6a499aa42.1669213027.git.geert+renesas@glider.be
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/renesas-rpc-if.c | 75 +++++++++++++++++++++++++--------
 include/memory/renesas-rpc-if.h | 16 -------
 2 files changed, 57 insertions(+), 34 deletions(-)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 09cd4318a83d8..ded80caec1678 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -163,14 +163,36 @@ static const struct regmap_access_table rpcif_volatile_table = {
 	.n_yes_ranges	= ARRAY_SIZE(rpcif_volatile_ranges),
 };
 
+struct rpcif_priv {
+	struct device *dev;
+	void __iomem *base;
+	void __iomem *dirmap;
+	struct regmap *regmap;
+	struct reset_control *rstc;
+	struct platform_device *vdev;
+	size_t size;
+	enum rpcif_type type;
+	enum rpcif_data_dir dir;
+	u8 bus_size;
+	u8 xfer_size;
+	void *buffer;
+	u32 xferlen;
+	u32 smcr;
+	u32 smadr;
+	u32 command;		/* DRCMR or SMCMR */
+	u32 option;		/* DROPR or SMOPR */
+	u32 enable;		/* DRENR or SMENR */
+	u32 dummy;		/* DRDMCR or SMDMCR */
+	u32 ddr;		/* DRDRENR or SMDRENR */
+};
 
 /*
  * Custom accessor functions to ensure SM[RW]DR[01] are always accessed with
- * proper width.  Requires rpcif.xfer_size to be correctly set before!
+ * proper width.  Requires rpcif_priv.xfer_size to be correctly set before!
  */
 static int rpcif_reg_read(void *context, unsigned int reg, unsigned int *val)
 {
-	struct rpcif *rpc = context;
+	struct rpcif_priv *rpc = context;
 
 	switch (reg) {
 	case RPCIF_SMRDR0:
@@ -206,7 +228,7 @@ static int rpcif_reg_read(void *context, unsigned int reg, unsigned int *val)
 
 static int rpcif_reg_write(void *context, unsigned int reg, unsigned int val)
 {
-	struct rpcif *rpc = context;
+	struct rpcif_priv *rpc = context;
 
 	switch (reg) {
 	case RPCIF_SMWDR0:
@@ -253,13 +275,12 @@ static const struct regmap_config rpcif_regmap_config = {
 	.volatile_table	= &rpcif_volatile_table,
 };
 
-int rpcif_sw_init(struct rpcif *rpc, struct device *dev)
+int rpcif_sw_init(struct rpcif *rpcif, struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
+	struct rpcif_priv *rpc = dev_get_drvdata(dev);
 	struct resource *res;
 
-	rpc->dev = dev;
-
 	rpc->base = devm_platform_ioremap_resource_byname(pdev, "regs");
 	if (IS_ERR(rpc->base))
 		return PTR_ERR(rpc->base);
@@ -280,12 +301,17 @@ int rpcif_sw_init(struct rpcif *rpc, struct device *dev)
 
 	rpc->type = (uintptr_t)of_device_get_match_data(dev);
 	rpc->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
+	if (IS_ERR(rpc->rstc))
+		return PTR_ERR(rpc->rstc);
 
-	return PTR_ERR_OR_ZERO(rpc->rstc);
+	rpcif->dev = dev;
+	rpcif->dirmap = rpc->dirmap;
+	rpcif->size = rpc->size;
+	return 0;
 }
 EXPORT_SYMBOL(rpcif_sw_init);
 
-static void rpcif_rzg2l_timing_adjust_sdr(struct rpcif *rpc)
+static void rpcif_rzg2l_timing_adjust_sdr(struct rpcif_priv *rpc)
 {
 	regmap_write(rpc->regmap, RPCIF_PHYWR, 0xa5390000);
 	regmap_write(rpc->regmap, RPCIF_PHYADD, 0x80000000);
@@ -299,8 +325,9 @@ static void rpcif_rzg2l_timing_adjust_sdr(struct rpcif *rpc)
 	regmap_write(rpc->regmap, RPCIF_PHYADD, 0x80000032);
 }
 
-int rpcif_hw_init(struct rpcif *rpc, bool hyperflash)
+int rpcif_hw_init(struct rpcif *rpcif, bool hyperflash)
 {
+	struct rpcif_priv *rpc = dev_get_drvdata(rpcif->dev);
 	u32 dummy;
 
 	pm_runtime_get_sync(rpc->dev);
@@ -364,7 +391,7 @@ int rpcif_hw_init(struct rpcif *rpc, bool hyperflash)
 }
 EXPORT_SYMBOL(rpcif_hw_init);
 
-static int wait_msg_xfer_end(struct rpcif *rpc)
+static int wait_msg_xfer_end(struct rpcif_priv *rpc)
 {
 	u32 sts;
 
@@ -373,7 +400,7 @@ static int wait_msg_xfer_end(struct rpcif *rpc)
 					USEC_PER_SEC);
 }
 
-static u8 rpcif_bits_set(struct rpcif *rpc, u32 nbytes)
+static u8 rpcif_bits_set(struct rpcif_priv *rpc, u32 nbytes)
 {
 	if (rpc->bus_size == 2)
 		nbytes /= 2;
@@ -386,9 +413,11 @@ static u8 rpcif_bit_size(u8 buswidth)
 	return buswidth > 4 ? 2 : ilog2(buswidth);
 }
 
-void rpcif_prepare(struct rpcif *rpc, const struct rpcif_op *op, u64 *offs,
+void rpcif_prepare(struct rpcif *rpcif, const struct rpcif_op *op, u64 *offs,
 		   size_t *len)
 {
+	struct rpcif_priv *rpc = dev_get_drvdata(rpcif->dev);
+
 	rpc->smcr = 0;
 	rpc->smadr = 0;
 	rpc->enable = 0;
@@ -472,8 +501,9 @@ void rpcif_prepare(struct rpcif *rpc, const struct rpcif_op *op, u64 *offs,
 }
 EXPORT_SYMBOL(rpcif_prepare);
 
-int rpcif_manual_xfer(struct rpcif *rpc)
+int rpcif_manual_xfer(struct rpcif *rpcif)
 {
+	struct rpcif_priv *rpc = dev_get_drvdata(rpcif->dev);
 	u32 smenr, smcr, pos = 0, max = rpc->bus_size == 2 ? 8 : 4;
 	int ret = 0;
 
@@ -593,7 +623,7 @@ int rpcif_manual_xfer(struct rpcif *rpc)
 err_out:
 	if (reset_control_reset(rpc->rstc))
 		dev_err(rpc->dev, "Failed to reset HW\n");
-	rpcif_hw_init(rpc, rpc->bus_size == 2);
+	rpcif_hw_init(rpcif, rpc->bus_size == 2);
 	goto exit;
 }
 EXPORT_SYMBOL(rpcif_manual_xfer);
@@ -640,8 +670,9 @@ static void memcpy_fromio_readw(void *to,
 	}
 }
 
-ssize_t rpcif_dirmap_read(struct rpcif *rpc, u64 offs, size_t len, void *buf)
+ssize_t rpcif_dirmap_read(struct rpcif *rpcif, u64 offs, size_t len, void *buf)
 {
+	struct rpcif_priv *rpc = dev_get_drvdata(rpcif->dev);
 	loff_t from = offs & (rpc->size - 1);
 	size_t size = rpc->size - from;
 
@@ -676,6 +707,7 @@ static int rpcif_probe(struct platform_device *pdev)
 {
 	struct platform_device *vdev;
 	struct device_node *flash;
+	struct rpcif_priv *rpc;
 	const char *name;
 	int ret;
 
@@ -696,11 +728,18 @@ static int rpcif_probe(struct platform_device *pdev)
 	}
 	of_node_put(flash);
 
+	rpc = devm_kzalloc(&pdev->dev, sizeof(*rpc), GFP_KERNEL);
+	if (!rpc)
+		return -ENOMEM;
+
 	vdev = platform_device_alloc(name, pdev->id);
 	if (!vdev)
 		return -ENOMEM;
 	vdev->dev.parent = &pdev->dev;
-	platform_set_drvdata(pdev, vdev);
+
+	rpc->dev = &pdev->dev;
+	rpc->vdev = vdev;
+	platform_set_drvdata(pdev, rpc);
 
 	ret = platform_device_add(vdev);
 	if (ret) {
@@ -713,9 +752,9 @@ static int rpcif_probe(struct platform_device *pdev)
 
 static int rpcif_remove(struct platform_device *pdev)
 {
-	struct platform_device *vdev = platform_get_drvdata(pdev);
+	struct rpcif_priv *rpc = platform_get_drvdata(pdev);
 
-	platform_device_unregister(vdev);
+	platform_device_unregister(rpc->vdev);
 
 	return 0;
 }
diff --git a/include/memory/renesas-rpc-if.h b/include/memory/renesas-rpc-if.h
index 862eff613dc79..2dcb82df0d176 100644
--- a/include/memory/renesas-rpc-if.h
+++ b/include/memory/renesas-rpc-if.h
@@ -65,24 +65,8 @@ enum rpcif_type {
 
 struct rpcif {
 	struct device *dev;
-	void __iomem *base;
 	void __iomem *dirmap;
-	struct regmap *regmap;
-	struct reset_control *rstc;
 	size_t size;
-	enum rpcif_type type;
-	enum rpcif_data_dir dir;
-	u8 bus_size;
-	u8 xfer_size;
-	void *buffer;
-	u32 xferlen;
-	u32 smcr;
-	u32 smadr;
-	u32 command;		/* DRCMR or SMCMR */
-	u32 option;		/* DROPR or SMOPR */
-	u32 enable;		/* DRENR or SMENR */
-	u32 dummy;		/* DRDMCR or SMDMCR */
-	u32 ddr;		/* DRDRENR or SMDRENR */
 };
 
 int rpcif_sw_init(struct rpcif *rpc, struct device *dev);
-- 
2.39.2



