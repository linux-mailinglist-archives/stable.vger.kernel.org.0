Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1513C545F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348461AbhGLH5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348161AbhGLHzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:55:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F359761220;
        Mon, 12 Jul 2021 07:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076314;
        bh=OCif2ZsNIOhHAWJltQSZzdH7Ucun+7oFwwXTFZNaHWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oMDFHcMPoo4wlx14SedsWPkxHhhql/U1ChETUHhRUcb2FqPTQmyu2JpYjYbof+lVO
         kUf2D7YTKtqmS4sFxbRsq0+pQPTpAhNNEYkTdTTzETSqQbEYsNMNghMnD9/aD6D/b3
         ZAvv/v/k+xTtYp2CguKentoJtVuCMhMSKiqUBT9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 590/800] clk: si5341: Wait for DEVICE_READY on startup
Date:   Mon, 12 Jul 2021 08:10:13 +0200
Message-Id: <20210712061030.061914999@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 6e7d2de1e000d36990923ed80d2e78dfcb545cee ]

The Si5341 datasheet warns that before accessing any other registers,
including the PAGE register, we need to wait for the DEVICE_READY register
to indicate the device is ready, or the process of the device loading its
state from NVM can be corrupted. Wait for DEVICE_READY on startup before
continuing initialization. This is done using a raw I2C register read
prior to setting up regmap to avoid any potential unwanted automatic PAGE
register accesses from regmap at this stage.

Fixes: 3044a860fd ("clk: Add Si5341/Si5340 driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20210325192643.2190069-3-robert.hancock@calian.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si5341.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/clk/clk-si5341.c b/drivers/clk/clk-si5341.c
index e0446e66fa64..b8a960e927bc 100644
--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -94,6 +94,7 @@ struct clk_si5341_output_config {
 #define SI5341_STATUS		0x000C
 #define SI5341_SOFT_RST		0x001C
 #define SI5341_IN_SEL		0x0021
+#define SI5341_DEVICE_READY	0x00FE
 #define SI5341_XAXB_CFG		0x090E
 #define SI5341_IN_EN		0x0949
 #define SI5341_INX_TO_PFD_EN	0x094A
@@ -1189,6 +1190,32 @@ static const struct regmap_range_cfg si5341_regmap_ranges[] = {
 	},
 };
 
+static int si5341_wait_device_ready(struct i2c_client *client)
+{
+	int count;
+
+	/* Datasheet warns: Any attempt to read or write any register other
+	 * than DEVICE_READY before DEVICE_READY reads as 0x0F may corrupt the
+	 * NVM programming and may corrupt the register contents, as they are
+	 * read from NVM. Note that this includes accesses to the PAGE register.
+	 * Also: DEVICE_READY is available on every register page, so no page
+	 * change is needed to read it.
+	 * Do this outside regmap to avoid automatic PAGE register access.
+	 * May take up to 300ms to complete.
+	 */
+	for (count = 0; count < 15; ++count) {
+		s32 result = i2c_smbus_read_byte_data(client,
+						      SI5341_DEVICE_READY);
+		if (result < 0)
+			return result;
+		if (result == 0x0F)
+			return 0;
+		msleep(20);
+	}
+	dev_err(&client->dev, "timeout waiting for DEVICE_READY\n");
+	return -EIO;
+}
+
 static const struct regmap_config si5341_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -1385,6 +1412,11 @@ static int si5341_probe(struct i2c_client *client,
 
 	data->i2c_client = client;
 
+	/* Must be done before otherwise touching hardware */
+	err = si5341_wait_device_ready(client);
+	if (err)
+		return err;
+
 	for (i = 0; i < SI5341_NUM_INPUTS; ++i) {
 		input = devm_clk_get(&client->dev, si5341_input_clock_names[i]);
 		if (IS_ERR(input)) {
-- 
2.30.2



