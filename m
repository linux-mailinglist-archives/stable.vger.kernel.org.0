Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1CF3C4F12
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244837AbhGLHXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343682AbhGLHUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D1BC60FF1;
        Mon, 12 Jul 2021 07:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074231;
        bh=G8YL6T1iBH1nBWOx2yCzGcu378wr6uJX+MtL00NrUdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lAX8FkaExV1CVaMPyWDgeMwi6hFW7DIOmafsUOFBsU1E9g5/1Bq9drpuL+thy58JA
         p5DxZmVs6afQduuxrlbAoRuhtVVaae0TskPLBct5yhooA/mAxylHIDCbyCf5dY/1PL
         bvO+1EwN+t6A8na4+CfiOgT60Ppy/I6xYZ6o/Ddo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 509/700] clk: si5341: Check for input clock presence and PLL lock on startup
Date:   Mon, 12 Jul 2021 08:09:52 +0200
Message-Id: <20210712061030.681349825@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 71dcc4d1f7d2ad97ff7ab831281bc6893ff713a2 ]

After initializing the device, wait for it to report that the input
clock is present and the PLL has locked before declaring success.

Fixes: 3044a860fd ("clk: Add Si5341/Si5340 driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20210325192643.2190069-5-robert.hancock@calian.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si5341.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/clk/clk-si5341.c b/drivers/clk/clk-si5341.c
index ac1ccec2b681..da40b90c2aa8 100644
--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -92,6 +92,9 @@ struct clk_si5341_output_config {
 #define SI5341_PN_BASE		0x0002
 #define SI5341_DEVICE_REV	0x0005
 #define SI5341_STATUS		0x000C
+#define SI5341_LOS		0x000D
+#define SI5341_STATUS_STICKY	0x0011
+#define SI5341_LOS_STICKY	0x0012
 #define SI5341_SOFT_RST		0x001C
 #define SI5341_IN_SEL		0x0021
 #define SI5341_DEVICE_READY	0x00FE
@@ -99,6 +102,12 @@ struct clk_si5341_output_config {
 #define SI5341_IN_EN		0x0949
 #define SI5341_INX_TO_PFD_EN	0x094A
 
+/* Status bits */
+#define SI5341_STATUS_SYSINCAL	BIT(0)
+#define SI5341_STATUS_LOSXAXB	BIT(1)
+#define SI5341_STATUS_LOSREF	BIT(2)
+#define SI5341_STATUS_LOL	BIT(3)
+
 /* Input selection */
 #define SI5341_IN_SEL_MASK	0x06
 #define SI5341_IN_SEL_SHIFT	1
@@ -1416,6 +1425,7 @@ static int si5341_probe(struct i2c_client *client,
 	unsigned int i;
 	struct clk_si5341_output_config config[SI5341_MAX_NUM_OUTPUTS];
 	bool initialization_required;
+	u32 status;
 
 	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -1583,6 +1593,22 @@ static int si5341_probe(struct i2c_client *client,
 			return err;
 	}
 
+	/* wait for device to report input clock present and PLL lock */
+	err = regmap_read_poll_timeout(data->regmap, SI5341_STATUS, status,
+		!(status & (SI5341_STATUS_LOSREF | SI5341_STATUS_LOL)),
+	       10000, 250000);
+	if (err) {
+		dev_err(&client->dev, "Error waiting for input clock or PLL lock\n");
+		return err;
+	}
+
+	/* clear sticky alarm bits from initialization */
+	err = regmap_write(data->regmap, SI5341_STATUS_STICKY, 0);
+	if (err) {
+		dev_err(&client->dev, "unable to clear sticky status\n");
+		return err;
+	}
+
 	/* Free the names, clk framework makes copies */
 	for (i = 0; i < data->num_synth; ++i)
 		 devm_kfree(&client->dev, (void *)synth_clock_names[i]);
-- 
2.30.2



