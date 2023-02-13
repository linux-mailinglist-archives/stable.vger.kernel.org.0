Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2146949F3
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjBMPD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjBMPDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:03:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF6E1C30E
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:03:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C96FCB80DF1
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F6BC4339C;
        Mon, 13 Feb 2023 15:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300568;
        bh=Xt3IOYl9LSvImaehPZVqaYjoAJmamT99nIBsGcHE3nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtVrnuVPhT9FAbBIhxeZAIRuza7uA7MH0nqAzWq8EEeBR8TJftO2fR8SgcAYuIAKT
         5yIPcYXCkxRLs0xszAQng+/ksbV567/hIfpOncbvPTpHAk/r2teL/dCR9LdOrNNSjW
         tL7tjLoyyrMW0iTtdtOoppkrZkIC5h+CK9i/+1KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Carlos Song <carlos.song@nxp.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 063/139] iio: imu: fxos8700: fix ACCEL measurement range selection
Date:   Mon, 13 Feb 2023 15:50:08 +0100
Message-Id: <20230213144749.090755140@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlos Song <carlos.song@nxp.com>

commit 9d61c1820598a5ea474576ed55318a6dadee37ed upstream.

When device is in active mode, it fails to set an ACCEL full-scale
range(2g/4g/8g) in FXOS8700_XYZ_DATA_CFG. This is not align with the
datasheet, but it is a fxos8700 chip behavior.

Keep the device in standby mode before setting ACCEL full-scale range
into FXOS8700_XYZ_DATA_CFG in chip initialization phase and setting
scale phase.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20221208071911.2405922-6-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/fxos8700_core.c |   41 +++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -345,7 +345,8 @@ static int fxos8700_set_active_mode(stru
 static int fxos8700_set_scale(struct fxos8700_data *data,
 			      enum fxos8700_sensor t, int uscale)
 {
-	int i;
+	int i, ret, val;
+	bool active_mode;
 	static const int scale_num = ARRAY_SIZE(fxos8700_accel_scale);
 	struct device *dev = regmap_get_device(data->regmap);
 
@@ -354,6 +355,25 @@ static int fxos8700_set_scale(struct fxo
 		return -EINVAL;
 	}
 
+	/*
+	 * When device is in active mode, it failed to set an ACCEL
+	 * full-scale range(2g/4g/8g) in FXOS8700_XYZ_DATA_CFG.
+	 * This is not align with the datasheet, but it is a fxos8700
+	 * chip behavier. Set the device in standby mode before setting
+	 * an ACCEL full-scale range.
+	 */
+	ret = regmap_read(data->regmap, FXOS8700_CTRL_REG1, &val);
+	if (ret)
+		return ret;
+
+	active_mode = val & FXOS8700_ACTIVE;
+	if (active_mode) {
+		ret = regmap_write(data->regmap, FXOS8700_CTRL_REG1,
+				   val & ~FXOS8700_ACTIVE);
+		if (ret)
+			return ret;
+	}
+
 	for (i = 0; i < scale_num; i++)
 		if (fxos8700_accel_scale[i].uscale == uscale)
 			break;
@@ -361,8 +381,12 @@ static int fxos8700_set_scale(struct fxo
 	if (i == scale_num)
 		return -EINVAL;
 
-	return regmap_write(data->regmap, FXOS8700_XYZ_DATA_CFG,
+	ret = regmap_write(data->regmap, FXOS8700_XYZ_DATA_CFG,
 			    fxos8700_accel_scale[i].bits);
+	if (ret)
+		return ret;
+	return regmap_write(data->regmap, FXOS8700_CTRL_REG1,
+				  active_mode);
 }
 
 static int fxos8700_get_scale(struct fxos8700_data *data,
@@ -592,14 +616,17 @@ static int fxos8700_chip_init(struct fxo
 	if (ret)
 		return ret;
 
-	/* Max ODR (800Hz individual or 400Hz hybrid), active mode */
-	ret = regmap_write(data->regmap, FXOS8700_CTRL_REG1,
-			   FXOS8700_CTRL_ODR_MAX | FXOS8700_ACTIVE);
+	/*
+	 * Set max full-scale range (+/-8G) for ACCEL sensor in chip
+	 * initialization then activate the device.
+	 */
+	ret = regmap_write(data->regmap, FXOS8700_XYZ_DATA_CFG, MODE_8G);
 	if (ret)
 		return ret;
 
-	/* Set for max full-scale range (+/-8G) */
-	return regmap_write(data->regmap, FXOS8700_XYZ_DATA_CFG, MODE_8G);
+	/* Max ODR (800Hz individual or 400Hz hybrid), active mode */
+	return regmap_write(data->regmap, FXOS8700_CTRL_REG1,
+			   FXOS8700_CTRL_ODR_MAX | FXOS8700_ACTIVE);
 }
 
 static void fxos8700_chip_uninit(void *data)


