Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541C428B7D4
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389747AbgJLNp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389740AbgJLNpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 313B721D81;
        Mon, 12 Oct 2020 13:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510298;
        bh=uC3giKAFbHJhzRpIE+h2om7HMtZKYSTAXTfLvmML54E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBKlfngMMgiuVZWxHRN1no+0E/AP2SkGkvuBT+gk4DFx2cQ8U+j96Qf2O99XY+v9W
         vA3UogAnZwGYDJljOk6FupdHfGGL7+dhCFtYPrR+9OCtTI1rK0H9of0UeS5Pv373oy
         iG9qqxqBAQL2l0q1kCbWkn+O1cuP569qsB/CmBw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Belin <nbelin@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.8 039/124] i2c: meson: fixup rate calculation with filter delay
Date:   Mon, 12 Oct 2020 15:30:43 +0200
Message-Id: <20201012133148.745261511@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Belin <nbelin@baylibre.com>

commit 1334d3b4e49e35d8912a7c37ffca4c5afb9a0516 upstream.

Apparently, 15 cycles of the peripheral clock are used by the controller
for sampling and filtering. Because this was not known before, the rate
calculation is slightly off.

Clean up and fix the calculation taking this filtering delay into account.

Fixes: 30021e3707a7 ("i2c: add support for Amlogic Meson I2C controller")
Signed-off-by: Nicolas Belin <nbelin@baylibre.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-meson.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/i2c/busses/i2c-meson.c
+++ b/drivers/i2c/busses/i2c-meson.c
@@ -34,10 +34,8 @@
 #define REG_CTRL_ACK_IGNORE	BIT(1)
 #define REG_CTRL_STATUS		BIT(2)
 #define REG_CTRL_ERROR		BIT(3)
-#define REG_CTRL_CLKDIV_SHIFT	12
-#define REG_CTRL_CLKDIV_MASK	GENMASK(21, 12)
-#define REG_CTRL_CLKDIVEXT_SHIFT 28
-#define REG_CTRL_CLKDIVEXT_MASK	GENMASK(29, 28)
+#define REG_CTRL_CLKDIV		GENMASK(21, 12)
+#define REG_CTRL_CLKDIVEXT	GENMASK(29, 28)
 
 #define REG_SLV_ADDR		GENMASK(7, 0)
 #define REG_SLV_SDA_FILTER	GENMASK(10, 8)
@@ -46,6 +44,7 @@
 #define REG_SLV_SCL_LOW_EN	BIT(28)
 
 #define I2C_TIMEOUT_MS		500
+#define FILTER_DELAY		15
 
 enum {
 	TOKEN_END = 0,
@@ -140,19 +139,21 @@ static void meson_i2c_set_clk_div(struct
 	unsigned long clk_rate = clk_get_rate(i2c->clk);
 	unsigned int div;
 
-	div = DIV_ROUND_UP(clk_rate, freq * i2c->data->div_factor);
+	div = DIV_ROUND_UP(clk_rate, freq);
+	div -= FILTER_DELAY;
+	div = DIV_ROUND_UP(div, i2c->data->div_factor);
 
 	/* clock divider has 12 bits */
-	if (div >= (1 << 12)) {
+	if (div > GENMASK(11, 0)) {
 		dev_err(i2c->dev, "requested bus frequency too low\n");
-		div = (1 << 12) - 1;
+		div = GENMASK(11, 0);
 	}
 
-	meson_i2c_set_mask(i2c, REG_CTRL, REG_CTRL_CLKDIV_MASK,
-			   (div & GENMASK(9, 0)) << REG_CTRL_CLKDIV_SHIFT);
+	meson_i2c_set_mask(i2c, REG_CTRL, REG_CTRL_CLKDIV,
+			   FIELD_PREP(REG_CTRL_CLKDIV, div & GENMASK(9, 0)));
 
-	meson_i2c_set_mask(i2c, REG_CTRL, REG_CTRL_CLKDIVEXT_MASK,
-			   (div >> 10) << REG_CTRL_CLKDIVEXT_SHIFT);
+	meson_i2c_set_mask(i2c, REG_CTRL, REG_CTRL_CLKDIVEXT,
+			   FIELD_PREP(REG_CTRL_CLKDIVEXT, div >> 10));
 
 	/* Disable HIGH/LOW mode */
 	meson_i2c_set_mask(i2c, REG_SLAVE_ADDR, REG_SLV_SCL_LOW_EN, 0);


