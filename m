Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838D7157709
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgBJM5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:57:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730015AbgBJMld (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:33 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E01B7208C3;
        Mon, 10 Feb 2020 12:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338493;
        bh=c8goGARwlj2NHOIqJVsSN1MB+B+hQCBbGJ2drc+zI+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jk2EIccJTfVBRq7pNoYg98rEANJAXvO3Aj5RfWM4aWvuQ15FxVJVd1dthGzOmXjjL
         oECUL+fOSASb8SGU8b0ZWxlgbonYwXsZq7q3wmWd+otw+7i7GV6jNov+24rd3WwJC3
         QNYO+VKz1bqMgLzVFyH1Uj5fm5bU9SzlotVUccA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alden DSouza <aldend@google.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 279/367] ASoC: meson: axg-fifo: fix fifo threshold setup
Date:   Mon, 10 Feb 2020 04:33:12 -0800
Message-Id: <20200210122449.837877741@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

commit 864cee90d4bd870e5d5e5a0b1a6f055f4f951350 upstream.

On TODDR sm1, the fifo threshold register field is slightly different
compared to the other SoCs. This leads to the fifo A being flushed to
memory every 8kB. If the period is smaller than that, several periods
are pushed to memory and notified at once. This is not ideal.

Fix the register field update. With this, the fifos are flushed every
128B. We could still do better, like adapt the threshold depending on
the period size, but at least it consistent across the different
SoC/fifos

Fixes: 5ac825c3d85e ("ASoC: meson: axg-toddr: add sm1 support")
Reported-by: Alden DSouza <aldend@google.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20191218172420.1199117-2-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/meson/axg-fifo.c  |   27 +++++++++++++++++++++++++--
 sound/soc/meson/axg-fifo.h  |    6 ++++--
 sound/soc/meson/axg-frddr.c |   24 ++++++++++++------------
 sound/soc/meson/axg-toddr.c |   21 +++++++++------------
 4 files changed, 50 insertions(+), 28 deletions(-)

--- a/sound/soc/meson/axg-fifo.c
+++ b/sound/soc/meson/axg-fifo.c
@@ -113,10 +113,12 @@ int axg_fifo_pcm_hw_params(struct snd_so
 {
 	struct snd_pcm_runtime *runtime = ss->runtime;
 	struct axg_fifo *fifo = axg_fifo_data(ss);
+	unsigned int burst_num, period, threshold;
 	dma_addr_t end_ptr;
-	unsigned int burst_num;
 	int ret;
 
+	period = params_period_bytes(params);
+
 	ret = snd_pcm_lib_malloc_pages(ss, params_buffer_bytes(params));
 	if (ret < 0)
 		return ret;
@@ -127,9 +129,25 @@ int axg_fifo_pcm_hw_params(struct snd_so
 	regmap_write(fifo->map, FIFO_FINISH_ADDR, end_ptr);
 
 	/* Setup interrupt periodicity */
-	burst_num = params_period_bytes(params) / AXG_FIFO_BURST;
+	burst_num = period / AXG_FIFO_BURST;
 	regmap_write(fifo->map, FIFO_INT_ADDR, burst_num);
 
+	/*
+	 * Start the fifo request on the smallest of the following:
+	 * - Half the fifo size
+	 * - Half the period size
+	 */
+	threshold = min(period / 2,
+			(unsigned int)AXG_FIFO_MIN_DEPTH / 2);
+
+	/*
+	 * With the threshold in bytes, register value is:
+	 * V = (threshold / burst) - 1
+	 */
+	threshold /= AXG_FIFO_BURST;
+	regmap_field_write(fifo->field_threshold,
+			   threshold ? threshold - 1 : 0);
+
 	/* Enable block count irq */
 	regmap_update_bits(fifo->map, FIFO_CTRL0,
 			   CTRL0_INT_EN(FIFO_INT_COUNT_REPEAT),
@@ -352,6 +370,11 @@ int axg_fifo_probe(struct platform_devic
 		return fifo->irq;
 	}
 
+	fifo->field_threshold =
+		devm_regmap_field_alloc(dev, fifo->map, data->field_threshold);
+	if (IS_ERR(fifo->field_threshold))
+		return PTR_ERR(fifo->field_threshold);
+
 	return devm_snd_soc_register_component(dev, data->component_drv,
 					       data->dai_drv, 1);
 }
--- a/sound/soc/meson/axg-fifo.h
+++ b/sound/soc/meson/axg-fifo.h
@@ -9,7 +9,9 @@
 
 struct clk;
 struct platform_device;
+struct reg_field;
 struct regmap;
+struct regmap_field;
 struct reset_control;
 
 struct snd_soc_component_driver;
@@ -50,8 +52,6 @@ struct snd_soc_pcm_runtime;
 #define  CTRL1_STATUS2_SEL_MASK		GENMASK(11, 8)
 #define  CTRL1_STATUS2_SEL(x)		((x) << 8)
 #define   STATUS2_SEL_DDR_READ		0
-#define  CTRL1_THRESHOLD_MASK		GENMASK(23, 16)
-#define  CTRL1_THRESHOLD(x)		((x) << 16)
 #define  CTRL1_FRDDR_DEPTH_MASK		GENMASK(31, 24)
 #define  CTRL1_FRDDR_DEPTH(x)		((x) << 24)
 #define FIFO_START_ADDR			0x08
@@ -67,12 +67,14 @@ struct axg_fifo {
 	struct regmap *map;
 	struct clk *pclk;
 	struct reset_control *arb;
+	struct regmap_field *field_threshold;
 	int irq;
 };
 
 struct axg_fifo_match_data {
 	const struct snd_soc_component_driver *component_drv;
 	struct snd_soc_dai_driver *dai_drv;
+	struct reg_field field_threshold;
 };
 
 int axg_fifo_pcm_open(struct snd_soc_component *component,
--- a/sound/soc/meson/axg-frddr.c
+++ b/sound/soc/meson/axg-frddr.c
@@ -50,7 +50,7 @@ static int axg_frddr_dai_startup(struct
 				 struct snd_soc_dai *dai)
 {
 	struct axg_fifo *fifo = snd_soc_dai_get_drvdata(dai);
-	unsigned int fifo_depth, fifo_threshold;
+	unsigned int fifo_depth;
 	int ret;
 
 	/* Enable pclk to access registers and clock the fifo ip */
@@ -68,11 +68,8 @@ static int axg_frddr_dai_startup(struct
 	 * Depth and threshold are zero based.
 	 */
 	fifo_depth = AXG_FIFO_MIN_CNT - 1;
-	fifo_threshold = (AXG_FIFO_MIN_CNT / 2) - 1;
-	regmap_update_bits(fifo->map, FIFO_CTRL1,
-			   CTRL1_FRDDR_DEPTH_MASK | CTRL1_THRESHOLD_MASK,
-			   CTRL1_FRDDR_DEPTH(fifo_depth) |
-			   CTRL1_THRESHOLD(fifo_threshold));
+	regmap_update_bits(fifo->map, FIFO_CTRL1, CTRL1_FRDDR_DEPTH_MASK,
+			   CTRL1_FRDDR_DEPTH(fifo_depth));
 
 	return 0;
 }
@@ -159,8 +156,9 @@ static const struct snd_soc_component_dr
 };
 
 static const struct axg_fifo_match_data axg_frddr_match_data = {
-	.component_drv	= &axg_frddr_component_drv,
-	.dai_drv	= &axg_frddr_dai_drv
+	.field_threshold	= REG_FIELD(FIFO_CTRL1, 16, 23),
+	.component_drv		= &axg_frddr_component_drv,
+	.dai_drv		= &axg_frddr_dai_drv
 };
 
 static const struct snd_soc_dai_ops g12a_frddr_ops = {
@@ -283,8 +281,9 @@ static const struct snd_soc_component_dr
 };
 
 static const struct axg_fifo_match_data g12a_frddr_match_data = {
-	.component_drv	= &g12a_frddr_component_drv,
-	.dai_drv	= &g12a_frddr_dai_drv
+	.field_threshold	= REG_FIELD(FIFO_CTRL1, 16, 23),
+	.component_drv		= &g12a_frddr_component_drv,
+	.dai_drv		= &g12a_frddr_dai_drv
 };
 
 /* On SM1, the output selection in on CTRL2 */
@@ -353,8 +352,9 @@ static const struct snd_soc_component_dr
 };
 
 static const struct axg_fifo_match_data sm1_frddr_match_data = {
-	.component_drv	= &sm1_frddr_component_drv,
-	.dai_drv	= &g12a_frddr_dai_drv
+	.field_threshold	= REG_FIELD(FIFO_CTRL1, 16, 23),
+	.component_drv		= &sm1_frddr_component_drv,
+	.dai_drv		= &g12a_frddr_dai_drv
 };
 
 static const struct of_device_id axg_frddr_of_match[] = {
--- a/sound/soc/meson/axg-toddr.c
+++ b/sound/soc/meson/axg-toddr.c
@@ -89,7 +89,6 @@ static int axg_toddr_dai_startup(struct
 				 struct snd_soc_dai *dai)
 {
 	struct axg_fifo *fifo = snd_soc_dai_get_drvdata(dai);
-	unsigned int fifo_threshold;
 	int ret;
 
 	/* Enable pclk to access registers and clock the fifo ip */
@@ -107,11 +106,6 @@ static int axg_toddr_dai_startup(struct
 	/* Apply single buffer mode to the interface */
 	regmap_update_bits(fifo->map, FIFO_CTRL0, CTRL0_TODDR_PP_MODE, 0);
 
-	/* TODDR does not have a configurable fifo depth */
-	fifo_threshold = AXG_FIFO_MIN_CNT - 1;
-	regmap_update_bits(fifo->map, FIFO_CTRL1, CTRL1_THRESHOLD_MASK,
-			   CTRL1_THRESHOLD(fifo_threshold));
-
 	return 0;
 }
 
@@ -191,8 +185,9 @@ static const struct snd_soc_component_dr
 };
 
 static const struct axg_fifo_match_data axg_toddr_match_data = {
-	.component_drv	= &axg_toddr_component_drv,
-	.dai_drv	= &axg_toddr_dai_drv
+	.field_threshold	= REG_FIELD(FIFO_CTRL1, 16, 23),
+	.component_drv		= &axg_toddr_component_drv,
+	.dai_drv		= &axg_toddr_dai_drv
 };
 
 static const struct snd_soc_dai_ops g12a_toddr_ops = {
@@ -230,8 +225,9 @@ static const struct snd_soc_component_dr
 };
 
 static const struct axg_fifo_match_data g12a_toddr_match_data = {
-	.component_drv	= &g12a_toddr_component_drv,
-	.dai_drv	= &g12a_toddr_dai_drv
+	.field_threshold	= REG_FIELD(FIFO_CTRL1, 16, 23),
+	.component_drv		= &g12a_toddr_component_drv,
+	.dai_drv		= &g12a_toddr_dai_drv
 };
 
 static const char * const sm1_toddr_sel_texts[] = {
@@ -300,8 +296,9 @@ static const struct snd_soc_component_dr
 };
 
 static const struct axg_fifo_match_data sm1_toddr_match_data = {
-	.component_drv	= &sm1_toddr_component_drv,
-	.dai_drv	= &g12a_toddr_dai_drv
+	.field_threshold	= REG_FIELD(FIFO_CTRL1, 12, 23),
+	.component_drv		= &sm1_toddr_component_drv,
+	.dai_drv		= &g12a_toddr_dai_drv
 };
 
 static const struct of_device_id axg_toddr_of_match[] = {


