Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31D26AF0AC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjCGSds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjCGSd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:33:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A210EB257D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:25:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F210614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218A6C433EF;
        Tue,  7 Mar 2023 18:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213536;
        bh=02XnPdONoiDs9LXoZYGirtykNmW01n2+STxeiUy/Xw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCBwR2iCuOuZNhOYelQKPw2gEs44VKhxuPKoGu5HTVstl9PIneNsaV0mzxIzHn21f
         FQJ7PbMRAO6cSVx4Z6wLc03qsSn9ihqebAKmGEvzyFyR3RXKEm+iF7qaRZ8Sqvifh9
         Kx9OXQBGtjWW9bZSuA5ka6rp1qln0d6fJDVFzyzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adam Ford <aford173@gmail.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 508/885] media: i2c: imx219: Split common registers from mode tables
Date:   Tue,  7 Mar 2023 17:57:22 +0100
Message-Id: <20230307170024.543247508@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 8508455961d5a9e8907bcfd8dcd58f19d9b6ce47 ]

There are four modes, and each mode has a table of registers.
Some of the registers are common to all modes, so create new
tables for these common registers to reduce duplicate code.

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: ef86447e775f ("media: i2c: imx219: Fix binning for RAW8 capture")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 206 +++++++++++--------------------------
 1 file changed, 59 insertions(+), 147 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 77bd79a5954ed..7f44d62047b67 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -145,23 +145,61 @@ struct imx219_mode {
 	struct imx219_reg_list reg_list;
 };
 
-/*
- * Register sets lifted off the i2C interface from the Raspberry Pi firmware
- * driver.
- * 3280x2464 = mode 2, 1920x1080 = mode 1, 1640x1232 = mode 4, 640x480 = mode 7.
- */
-static const struct imx219_reg mode_3280x2464_regs[] = {
-	{0x0100, 0x00},
+static const struct imx219_reg imx219_common_regs[] = {
+	{0x0100, 0x00},	/* Mode Select */
+
+	/* To Access Addresses 3000-5fff, send the following commands */
 	{0x30eb, 0x0c},
 	{0x30eb, 0x05},
 	{0x300a, 0xff},
 	{0x300b, 0xff},
 	{0x30eb, 0x05},
 	{0x30eb, 0x09},
-	{0x0114, 0x01},
-	{0x0128, 0x00},
-	{0x012a, 0x18},
+
+	/* PLL Clock Table */
+	{0x0301, 0x05},	/* VTPXCK_DIV */
+	{0x0303, 0x01},	/* VTSYSCK_DIV */
+	{0x0304, 0x03},	/* PREPLLCK_VT_DIV 0x03 = AUTO set */
+	{0x0305, 0x03}, /* PREPLLCK_OP_DIV 0x03 = AUTO set */
+	{0x0306, 0x00},	/* PLL_VT_MPY */
+	{0x0307, 0x39},
+	{0x030b, 0x01},	/* OP_SYS_CLK_DIV */
+	{0x030c, 0x00},	/* PLL_OP_MPY */
+	{0x030d, 0x72},
+
+	/* Undocumented registers */
+	{0x455e, 0x00},
+	{0x471e, 0x4b},
+	{0x4767, 0x0f},
+	{0x4750, 0x14},
+	{0x4540, 0x00},
+	{0x47b4, 0x14},
+	{0x4713, 0x30},
+	{0x478b, 0x10},
+	{0x478f, 0x10},
+	{0x4793, 0x10},
+	{0x4797, 0x0e},
+	{0x479b, 0x0e},
+
+	/* Frame Bank Register Group "A" */
+	{0x0162, 0x0d},	/* Line_Length_A */
+	{0x0163, 0x78},
+	{0x0170, 0x01}, /* X_ODD_INC_A */
+	{0x0171, 0x01}, /* Y_ODD_INC_A */
+
+	/* Output setup registers */
+	{0x0114, 0x01},	/* CSI 2-Lane Mode */
+	{0x0128, 0x00},	/* DPHY Auto Mode */
+	{0x012a, 0x18},	/* EXCK_Freq */
 	{0x012b, 0x00},
+};
+
+/*
+ * Register sets lifted off the i2C interface from the Raspberry Pi firmware
+ * driver.
+ * 3280x2464 = mode 2, 1920x1080 = mode 1, 1640x1232 = mode 4, 640x480 = mode 7.
+ */
+static const struct imx219_reg mode_3280x2464_regs[] = {
 	{0x0164, 0x00},
 	{0x0165, 0x00},
 	{0x0166, 0x0c},
@@ -174,53 +212,15 @@ static const struct imx219_reg mode_3280x2464_regs[] = {
 	{0x016d, 0xd0},
 	{0x016e, 0x09},
 	{0x016f, 0xa0},
-	{0x0170, 0x01},
-	{0x0171, 0x01},
-	{0x0174, 0x00},
+	{0x0174, 0x00},	/* No-Binning */
 	{0x0175, 0x00},
-	{0x0301, 0x05},
-	{0x0303, 0x01},
-	{0x0304, 0x03},
-	{0x0305, 0x03},
-	{0x0306, 0x00},
-	{0x0307, 0x39},
-	{0x030b, 0x01},
-	{0x030c, 0x00},
-	{0x030d, 0x72},
 	{0x0624, 0x0c},
 	{0x0625, 0xd0},
 	{0x0626, 0x09},
 	{0x0627, 0xa0},
-	{0x455e, 0x00},
-	{0x471e, 0x4b},
-	{0x4767, 0x0f},
-	{0x4750, 0x14},
-	{0x4540, 0x00},
-	{0x47b4, 0x14},
-	{0x4713, 0x30},
-	{0x478b, 0x10},
-	{0x478f, 0x10},
-	{0x4793, 0x10},
-	{0x4797, 0x0e},
-	{0x479b, 0x0e},
-	{0x0162, 0x0d},
-	{0x0163, 0x78},
 };
 
 static const struct imx219_reg mode_1920_1080_regs[] = {
-	{0x0100, 0x00},
-	{0x30eb, 0x05},
-	{0x30eb, 0x0c},
-	{0x300a, 0xff},
-	{0x300b, 0xff},
-	{0x30eb, 0x05},
-	{0x30eb, 0x09},
-	{0x0114, 0x01},
-	{0x0128, 0x00},
-	{0x012a, 0x18},
-	{0x012b, 0x00},
-	{0x0162, 0x0d},
-	{0x0163, 0x78},
 	{0x0164, 0x02},
 	{0x0165, 0xa8},
 	{0x0166, 0x0a},
@@ -233,49 +233,15 @@ static const struct imx219_reg mode_1920_1080_regs[] = {
 	{0x016d, 0x80},
 	{0x016e, 0x04},
 	{0x016f, 0x38},
-	{0x0170, 0x01},
-	{0x0171, 0x01},
-	{0x0174, 0x00},
+	{0x0174, 0x00},	/* No-Binning */
 	{0x0175, 0x00},
-	{0x0301, 0x05},
-	{0x0303, 0x01},
-	{0x0304, 0x03},
-	{0x0305, 0x03},
-	{0x0306, 0x00},
-	{0x0307, 0x39},
-	{0x030b, 0x01},
-	{0x030c, 0x00},
-	{0x030d, 0x72},
 	{0x0624, 0x07},
 	{0x0625, 0x80},
 	{0x0626, 0x04},
 	{0x0627, 0x38},
-	{0x455e, 0x00},
-	{0x471e, 0x4b},
-	{0x4767, 0x0f},
-	{0x4750, 0x14},
-	{0x4540, 0x00},
-	{0x47b4, 0x14},
-	{0x4713, 0x30},
-	{0x478b, 0x10},
-	{0x478f, 0x10},
-	{0x4793, 0x10},
-	{0x4797, 0x0e},
-	{0x479b, 0x0e},
 };
 
 static const struct imx219_reg mode_1640_1232_regs[] = {
-	{0x0100, 0x00},
-	{0x30eb, 0x0c},
-	{0x30eb, 0x05},
-	{0x300a, 0xff},
-	{0x300b, 0xff},
-	{0x30eb, 0x05},
-	{0x30eb, 0x09},
-	{0x0114, 0x01},
-	{0x0128, 0x00},
-	{0x012a, 0x18},
-	{0x012b, 0x00},
 	{0x0164, 0x00},
 	{0x0165, 0x00},
 	{0x0166, 0x0c},
@@ -288,53 +254,15 @@ static const struct imx219_reg mode_1640_1232_regs[] = {
 	{0x016d, 0x68},
 	{0x016e, 0x04},
 	{0x016f, 0xd0},
-	{0x0170, 0x01},
-	{0x0171, 0x01},
-	{0x0174, 0x01},
+	{0x0174, 0x01},	/* x2-Binning */
 	{0x0175, 0x01},
-	{0x0301, 0x05},
-	{0x0303, 0x01},
-	{0x0304, 0x03},
-	{0x0305, 0x03},
-	{0x0306, 0x00},
-	{0x0307, 0x39},
-	{0x030b, 0x01},
-	{0x030c, 0x00},
-	{0x030d, 0x72},
 	{0x0624, 0x06},
 	{0x0625, 0x68},
 	{0x0626, 0x04},
 	{0x0627, 0xd0},
-	{0x455e, 0x00},
-	{0x471e, 0x4b},
-	{0x4767, 0x0f},
-	{0x4750, 0x14},
-	{0x4540, 0x00},
-	{0x47b4, 0x14},
-	{0x4713, 0x30},
-	{0x478b, 0x10},
-	{0x478f, 0x10},
-	{0x4793, 0x10},
-	{0x4797, 0x0e},
-	{0x479b, 0x0e},
-	{0x0162, 0x0d},
-	{0x0163, 0x78},
 };
 
 static const struct imx219_reg mode_640_480_regs[] = {
-	{0x0100, 0x00},
-	{0x30eb, 0x05},
-	{0x30eb, 0x0c},
-	{0x300a, 0xff},
-	{0x300b, 0xff},
-	{0x30eb, 0x05},
-	{0x30eb, 0x09},
-	{0x0114, 0x01},
-	{0x0128, 0x00},
-	{0x012a, 0x18},
-	{0x012b, 0x00},
-	{0x0162, 0x0d},
-	{0x0163, 0x78},
 	{0x0164, 0x03},
 	{0x0165, 0xe8},
 	{0x0166, 0x08},
@@ -347,35 +275,12 @@ static const struct imx219_reg mode_640_480_regs[] = {
 	{0x016d, 0x80},
 	{0x016e, 0x01},
 	{0x016f, 0xe0},
-	{0x0170, 0x01},
-	{0x0171, 0x01},
-	{0x0174, 0x03},
+	{0x0174, 0x03},	/* x2-analog binning */
 	{0x0175, 0x03},
-	{0x0301, 0x05},
-	{0x0303, 0x01},
-	{0x0304, 0x03},
-	{0x0305, 0x03},
-	{0x0306, 0x00},
-	{0x0307, 0x39},
-	{0x030b, 0x01},
-	{0x030c, 0x00},
-	{0x030d, 0x72},
 	{0x0624, 0x06},
 	{0x0625, 0x68},
 	{0x0626, 0x04},
 	{0x0627, 0xd0},
-	{0x455e, 0x00},
-	{0x471e, 0x4b},
-	{0x4767, 0x0f},
-	{0x4750, 0x14},
-	{0x4540, 0x00},
-	{0x47b4, 0x14},
-	{0x4713, 0x30},
-	{0x478b, 0x10},
-	{0x478f, 0x10},
-	{0x4793, 0x10},
-	{0x4797, 0x0e},
-	{0x479b, 0x0e},
 };
 
 static const struct imx219_reg raw8_framefmt_regs[] = {
@@ -1041,6 +946,13 @@ static int imx219_start_streaming(struct imx219 *imx219)
 	if (ret < 0)
 		return ret;
 
+	/* Send all registers that are common to all modes */
+	ret = imx219_write_regs(imx219, imx219_common_regs, ARRAY_SIZE(imx219_common_regs));
+	if (ret) {
+		dev_err(&client->dev, "%s failed to send mfg header\n", __func__);
+		goto err_rpm_put;
+	}
+
 	/* Apply default values of current mode */
 	reg_list = &imx219->mode->reg_list;
 	ret = imx219_write_regs(imx219, reg_list->regs, reg_list->num_of_regs);
-- 
2.39.2



