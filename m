Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5756AF4B2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbjCGTSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbjCGTSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:18:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF10623675
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:02:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0074B819C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FBEC433D2;
        Tue,  7 Mar 2023 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215735;
        bh=x2w2yqC2YRL9UpNQc4UXBbyVy8gKpsfQ2Y4fVPXSunY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lm5gNUhf1Jdj1NeBy8KV0/buXwCPsMDsthIW/LooxFbkVbsvcdJ7WJRHXrqufztVt
         zxZGhQJz0EFZoKLAp+c8utq/V5SRsPAdoaUXfKiszTpcqYMwQfLANN/qZDb21aNpEG
         TcPemFRa+91DHKJz8wn+yiHArEREivCW51QJI1oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jai Luthra <j-luthra@ti.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 356/567] media: i2c: imx219: Fix binning for RAW8 capture
Date:   Tue,  7 Mar 2023 18:01:32 +0100
Message-Id: <20230307165921.314734475@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit ef86447e775fb1f2ced00d4c7fff2c0a1c63f165 ]

2x2 binning works fine for RAW10 capture, but for RAW8 1232p mode it
leads to corrupted frames [1][2].

Using the special 2x2 analog binning mode fixes the issue, but causes
artefacts for RAW10 1232p capture. So here we choose the binning mode
depending upon the frame format selected.

As both binning modes work fine for 480p RAW8 and RAW10 capture, it can
share the same code path as 1232p for selecting binning mode.

[1] https://forums.raspberrypi.com/viewtopic.php?t=332103
[2] https://github.com/raspberrypi/libcamera-apps/issues/281

Fixes: 22da1d56e982 ("media: i2c: imx219: Add support for RAW8 bit bayer format")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 57 ++++++++++++++++++++++++++++++++------
 1 file changed, 49 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index faa5dab3c2ec8..de1f0aa6fff4a 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -89,6 +89,12 @@
 
 #define IMX219_REG_ORIENTATION		0x0172
 
+/* Binning  Mode */
+#define IMX219_REG_BINNING_MODE		0x0174
+#define IMX219_BINNING_NONE		0x0000
+#define IMX219_BINNING_2X2		0x0101
+#define IMX219_BINNING_2X2_ANALOG	0x0303
+
 /* Test Pattern Control */
 #define IMX219_REG_TEST_PATTERN		0x0600
 #define IMX219_TEST_PATTERN_DISABLE	0
@@ -143,6 +149,9 @@ struct imx219_mode {
 
 	/* Default register values */
 	struct imx219_reg_list reg_list;
+
+	/* 2x2 binning is used */
+	bool binning;
 };
 
 static const struct imx219_reg imx219_common_regs[] = {
@@ -212,8 +221,6 @@ static const struct imx219_reg mode_3280x2464_regs[] = {
 	{0x016d, 0xd0},
 	{0x016e, 0x09},
 	{0x016f, 0xa0},
-	{0x0174, 0x00},	/* No-Binning */
-	{0x0175, 0x00},
 	{0x0624, 0x0c},
 	{0x0625, 0xd0},
 	{0x0626, 0x09},
@@ -233,8 +240,6 @@ static const struct imx219_reg mode_1920_1080_regs[] = {
 	{0x016d, 0x80},
 	{0x016e, 0x04},
 	{0x016f, 0x38},
-	{0x0174, 0x00},	/* No-Binning */
-	{0x0175, 0x00},
 	{0x0624, 0x07},
 	{0x0625, 0x80},
 	{0x0626, 0x04},
@@ -254,8 +259,6 @@ static const struct imx219_reg mode_1640_1232_regs[] = {
 	{0x016d, 0x68},
 	{0x016e, 0x04},
 	{0x016f, 0xd0},
-	{0x0174, 0x01},	/* x2-Binning */
-	{0x0175, 0x01},
 	{0x0624, 0x06},
 	{0x0625, 0x68},
 	{0x0626, 0x04},
@@ -275,8 +278,6 @@ static const struct imx219_reg mode_640_480_regs[] = {
 	{0x016d, 0x80},
 	{0x016e, 0x01},
 	{0x016f, 0xe0},
-	{0x0174, 0x03},	/* x2-analog binning */
-	{0x0175, 0x03},
 	{0x0624, 0x06},
 	{0x0625, 0x68},
 	{0x0626, 0x04},
@@ -390,6 +391,7 @@ static const struct imx219_mode supported_modes[] = {
 			.num_of_regs = ARRAY_SIZE(mode_3280x2464_regs),
 			.regs = mode_3280x2464_regs,
 		},
+		.binning = false,
 	},
 	{
 		/* 1080P 30fps cropped */
@@ -406,6 +408,7 @@ static const struct imx219_mode supported_modes[] = {
 			.num_of_regs = ARRAY_SIZE(mode_1920_1080_regs),
 			.regs = mode_1920_1080_regs,
 		},
+		.binning = false,
 	},
 	{
 		/* 2x2 binned 30fps mode */
@@ -422,6 +425,7 @@ static const struct imx219_mode supported_modes[] = {
 			.num_of_regs = ARRAY_SIZE(mode_1640_1232_regs),
 			.regs = mode_1640_1232_regs,
 		},
+		.binning = true,
 	},
 	{
 		/* 640x480 30fps mode */
@@ -438,6 +442,7 @@ static const struct imx219_mode supported_modes[] = {
 			.num_of_regs = ARRAY_SIZE(mode_640_480_regs),
 			.regs = mode_640_480_regs,
 		},
+		.binning = true,
 	},
 };
 
@@ -884,6 +889,35 @@ static int imx219_set_framefmt(struct imx219 *imx219)
 	return -EINVAL;
 }
 
+static int imx219_set_binning(struct imx219 *imx219)
+{
+	if (!imx219->mode->binning) {
+		return imx219_write_reg(imx219, IMX219_REG_BINNING_MODE,
+					IMX219_REG_VALUE_16BIT,
+					IMX219_BINNING_NONE);
+	}
+
+	switch (imx219->fmt.code) {
+	case MEDIA_BUS_FMT_SRGGB8_1X8:
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_SGBRG8_1X8:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+		return imx219_write_reg(imx219, IMX219_REG_BINNING_MODE,
+					IMX219_REG_VALUE_16BIT,
+					IMX219_BINNING_2X2_ANALOG);
+
+	case MEDIA_BUS_FMT_SRGGB10_1X10:
+	case MEDIA_BUS_FMT_SGRBG10_1X10:
+	case MEDIA_BUS_FMT_SGBRG10_1X10:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
+		return imx219_write_reg(imx219, IMX219_REG_BINNING_MODE,
+					IMX219_REG_VALUE_16BIT,
+					IMX219_BINNING_2X2);
+	}
+
+	return -EINVAL;
+}
+
 static const struct v4l2_rect *
 __imx219_get_pad_crop(struct imx219 *imx219,
 		      struct v4l2_subdev_state *sd_state,
@@ -968,6 +1002,13 @@ static int imx219_start_streaming(struct imx219 *imx219)
 		goto err_rpm_put;
 	}
 
+	ret = imx219_set_binning(imx219);
+	if (ret) {
+		dev_err(&client->dev, "%s failed to set binning: %d\n",
+			__func__, ret);
+		goto err_rpm_put;
+	}
+
 	/* Apply customized values from user */
 	ret =  __v4l2_ctrl_handler_setup(imx219->sd.ctrl_handler);
 	if (ret)
-- 
2.39.2



