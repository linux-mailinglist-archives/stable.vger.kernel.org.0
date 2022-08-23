Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF7759D5C9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347457AbiHWJCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242749AbiHWJCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:02:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D835FF7;
        Tue, 23 Aug 2022 01:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCA90B81C50;
        Tue, 23 Aug 2022 08:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154B2C433D6;
        Tue, 23 Aug 2022 08:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243304;
        bh=AIm+iPxsLuS8cHO7rgsgO4mYB1yWFzEMV0ofdqrskFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=suxCqeebq+ztD9oz17tzvUF4emlPuXIQ6TqZ6fbIGjE19x/FruN4WAK2qX33/DX2c
         1a4SzNlb2WXuFSergfmp4EScXOMNYru33CU+PxoWdzk0vchubwVk2s29dyCcLhTHBm
         hOFmcGiz9G7QWlcW6PxFGn6LE9qjjiLGo60vXX50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Da Xue <da@libre.computer>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.19 204/365] spi: meson-spicc: add local pow2 clock ops to preserve rate between messages
Date:   Tue, 23 Aug 2022 10:01:45 +0200
Message-Id: <20220823080126.748489089@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Neil Armstrong <narmstrong@baylibre.com>

commit 09992025dacd258c823f50e82db09d7ef06cdac4 upstream.

At the end of a message, the HW gets a reset in meson_spicc_unprepare_transfer(),
this resets the SPICC_CONREG register and notably the value set by the
Common Clock Framework.

This is problematic because:
- the register value CCF can be different from the corresponding CCF cached rate
- CCF is allowed to change the clock rate whenever the HW state

This introduces:
- local pow2 clock ops checking the HW state before allowing a clock operation
- separation of legacy pow2 clock patch and new enhanced clock path
- SPICC_CONREG datarate value is now value kepts across messages

It has been checked that:
- SPICC_CONREG datarate value is kept across messages
- CCF is only allowed to change the SPICC_CONREG datarate value when busy
- SPICC_CONREG datarate value is correct for each transfer

This didn't appear before commit 3e0cf4d3fc29 ("spi: meson-spicc: add a linear clock divider support")
because we recalculated and wrote the rate for each xfer.

Fixes: 3e0cf4d3fc29 ("spi: meson-spicc: add a linear clock divider support")
Reported-by: Da Xue <da@libre.computer>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20220811134445.678446-1-narmstrong@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-meson-spicc.c |  129 ++++++++++++++++++++++++++++++++----------
 1 file changed, 101 insertions(+), 28 deletions(-)

--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -156,6 +156,7 @@ struct meson_spicc_device {
 	void __iomem			*base;
 	struct clk			*core;
 	struct clk			*pclk;
+	struct clk_divider		pow2_div;
 	struct clk			*clk;
 	struct spi_message		*message;
 	struct spi_transfer		*xfer;
@@ -168,6 +169,8 @@ struct meson_spicc_device {
 	unsigned long			xfer_remain;
 };
 
+#define pow2_clk_to_spicc(_div) container_of(_div, struct meson_spicc_device, pow2_div)
+
 static void meson_spicc_oen_enable(struct meson_spicc_device *spicc)
 {
 	u32 conf;
@@ -421,7 +424,7 @@ static int meson_spicc_prepare_message(s
 {
 	struct meson_spicc_device *spicc = spi_master_get_devdata(master);
 	struct spi_device *spi = message->spi;
-	u32 conf = 0;
+	u32 conf = readl_relaxed(spicc->base + SPICC_CONREG) & SPICC_DATARATE_MASK;
 
 	/* Store current message */
 	spicc->message = message;
@@ -458,8 +461,6 @@ static int meson_spicc_prepare_message(s
 	/* Select CS */
 	conf |= FIELD_PREP(SPICC_CS_MASK, spi->chip_select);
 
-	/* Default Clock rate core/4 */
-
 	/* Default 8bit word */
 	conf |= FIELD_PREP(SPICC_BITLENGTH_MASK, 8 - 1);
 
@@ -476,12 +477,16 @@ static int meson_spicc_prepare_message(s
 static int meson_spicc_unprepare_transfer(struct spi_master *master)
 {
 	struct meson_spicc_device *spicc = spi_master_get_devdata(master);
+	u32 conf = readl_relaxed(spicc->base + SPICC_CONREG) & SPICC_DATARATE_MASK;
 
 	/* Disable all IRQs */
 	writel(0, spicc->base + SPICC_INTREG);
 
 	device_reset_optional(&spicc->pdev->dev);
 
+	/* Set default configuration, keeping datarate field */
+	writel_relaxed(conf, spicc->base + SPICC_CONREG);
+
 	return 0;
 }
 
@@ -518,14 +523,60 @@ static void meson_spicc_cleanup(struct s
  * Clk path for G12A series:
  *    pclk -> pow2 fixed div -> pow2 div -> mux -> out
  *    pclk -> enh fixed div -> enh div -> mux -> out
+ *
+ * The pow2 divider is tied to the controller HW state, and the
+ * divider is only valid when the controller is initialized.
+ *
+ * A set of clock ops is added to make sure we don't read/set this
+ * clock rate while the controller is in an unknown state.
  */
 
-static int meson_spicc_clk_init(struct meson_spicc_device *spicc)
+static unsigned long meson_spicc_pow2_recalc_rate(struct clk_hw *hw,
+						  unsigned long parent_rate)
+{
+	struct clk_divider *divider = to_clk_divider(hw);
+	struct meson_spicc_device *spicc = pow2_clk_to_spicc(divider);
+
+	if (!spicc->master->cur_msg || !spicc->master->busy)
+		return 0;
+
+	return clk_divider_ops.recalc_rate(hw, parent_rate);
+}
+
+static int meson_spicc_pow2_determine_rate(struct clk_hw *hw,
+					   struct clk_rate_request *req)
+{
+	struct clk_divider *divider = to_clk_divider(hw);
+	struct meson_spicc_device *spicc = pow2_clk_to_spicc(divider);
+
+	if (!spicc->master->cur_msg || !spicc->master->busy)
+		return -EINVAL;
+
+	return clk_divider_ops.determine_rate(hw, req);
+}
+
+static int meson_spicc_pow2_set_rate(struct clk_hw *hw, unsigned long rate,
+				     unsigned long parent_rate)
+{
+	struct clk_divider *divider = to_clk_divider(hw);
+	struct meson_spicc_device *spicc = pow2_clk_to_spicc(divider);
+
+	if (!spicc->master->cur_msg || !spicc->master->busy)
+		return -EINVAL;
+
+	return clk_divider_ops.set_rate(hw, rate, parent_rate);
+}
+
+const struct clk_ops meson_spicc_pow2_clk_ops = {
+	.recalc_rate = meson_spicc_pow2_recalc_rate,
+	.determine_rate = meson_spicc_pow2_determine_rate,
+	.set_rate = meson_spicc_pow2_set_rate,
+};
+
+static int meson_spicc_pow2_clk_init(struct meson_spicc_device *spicc)
 {
 	struct device *dev = &spicc->pdev->dev;
-	struct clk_fixed_factor *pow2_fixed_div, *enh_fixed_div;
-	struct clk_divider *pow2_div, *enh_div;
-	struct clk_mux *mux;
+	struct clk_fixed_factor *pow2_fixed_div;
 	struct clk_init_data init;
 	struct clk *clk;
 	struct clk_parent_data parent_data[2];
@@ -560,31 +611,45 @@ static int meson_spicc_clk_init(struct m
 	if (WARN_ON(IS_ERR(clk)))
 		return PTR_ERR(clk);
 
-	pow2_div = devm_kzalloc(dev, sizeof(*pow2_div), GFP_KERNEL);
-	if (!pow2_div)
-		return -ENOMEM;
-
 	snprintf(name, sizeof(name), "%s#pow2_div", dev_name(dev));
 	init.name = name;
-	init.ops = &clk_divider_ops;
-	init.flags = CLK_SET_RATE_PARENT;
+	init.ops = &meson_spicc_pow2_clk_ops;
+	/*
+	 * Set NOCACHE here to make sure we read the actual HW value
+	 * since we reset the HW after each transfer.
+	 */
+	init.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE;
 	parent_data[0].hw = &pow2_fixed_div->hw;
 	init.num_parents = 1;
 
-	pow2_div->shift = 16,
-	pow2_div->width = 3,
-	pow2_div->flags = CLK_DIVIDER_POWER_OF_TWO,
-	pow2_div->reg = spicc->base + SPICC_CONREG;
-	pow2_div->hw.init = &init;
+	spicc->pow2_div.shift = 16,
+	spicc->pow2_div.width = 3,
+	spicc->pow2_div.flags = CLK_DIVIDER_POWER_OF_TWO,
+	spicc->pow2_div.reg = spicc->base + SPICC_CONREG;
+	spicc->pow2_div.hw.init = &init;
 
-	clk = devm_clk_register(dev, &pow2_div->hw);
-	if (WARN_ON(IS_ERR(clk)))
-		return PTR_ERR(clk);
+	spicc->clk = devm_clk_register(dev, &spicc->pow2_div.hw);
+	if (WARN_ON(IS_ERR(spicc->clk)))
+		return PTR_ERR(spicc->clk);
 
-	if (!spicc->data->has_enhance_clk_div) {
-		spicc->clk = clk;
-		return 0;
-	}
+	return 0;
+}
+
+static int meson_spicc_enh_clk_init(struct meson_spicc_device *spicc)
+{
+	struct device *dev = &spicc->pdev->dev;
+	struct clk_fixed_factor *enh_fixed_div;
+	struct clk_divider *enh_div;
+	struct clk_mux *mux;
+	struct clk_init_data init;
+	struct clk *clk;
+	struct clk_parent_data parent_data[2];
+	char name[64];
+
+	memset(&init, 0, sizeof(init));
+	memset(&parent_data, 0, sizeof(parent_data));
+
+	init.parent_data = parent_data;
 
 	/* algorithm for enh div: rate = freq / 2 / (N + 1) */
 
@@ -637,7 +702,7 @@ static int meson_spicc_clk_init(struct m
 	snprintf(name, sizeof(name), "%s#sel", dev_name(dev));
 	init.name = name;
 	init.ops = &clk_mux_ops;
-	parent_data[0].hw = &pow2_div->hw;
+	parent_data[0].hw = &spicc->pow2_div.hw;
 	parent_data[1].hw = &enh_div->hw;
 	init.num_parents = 2;
 	init.flags = CLK_SET_RATE_PARENT;
@@ -754,12 +819,20 @@ static int meson_spicc_probe(struct plat
 
 	meson_spicc_oen_enable(spicc);
 
-	ret = meson_spicc_clk_init(spicc);
+	ret = meson_spicc_pow2_clk_init(spicc);
 	if (ret) {
-		dev_err(&pdev->dev, "clock registration failed\n");
+		dev_err(&pdev->dev, "pow2 clock registration failed\n");
 		goto out_clk;
 	}
 
+	if (spicc->data->has_enhance_clk_div) {
+		ret = meson_spicc_enh_clk_init(spicc);
+		if (ret) {
+			dev_err(&pdev->dev, "clock registration failed\n");
+			goto out_clk;
+		}
+	}
+
 	ret = devm_spi_register_master(&pdev->dev, master);
 	if (ret) {
 		dev_err(&pdev->dev, "spi master registration failed\n");


