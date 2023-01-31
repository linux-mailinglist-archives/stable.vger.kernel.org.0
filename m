Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00560682994
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjAaJx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjAaJx1 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:53:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAEF126CD
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:53:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2519EB81AB2
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51150C433EF;
        Tue, 31 Jan 2023 09:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158790;
        bh=ke13B/HTVar8Y7dRzoFdjpCSOE1c/MuauGmqY93xEfA=;
        h=Subject:To:From:Date:From;
        b=xTIYUUz74ynAT8zkKBEVviEw6Kjx0rJevCNH7xKlnp4yZzox8jjzawaeiQ0ZTSJ9a
         gNhNKvUHahgTACbIgj3ZAy7K4QoIAGxYKpTNAaqEk/eG5FJQ4KFqNxDYqMvIvX+jX3
         Yc5VX8QCOutjadkXgckje562wR4vBvW42LrwjJoE=
Subject: patch "iio: imu: fxos8700: fix ACCEL measurement range selection" added to char-misc-linus
To:     carlos.song@nxp.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:41 +0100
Message-ID: <16751587618756@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: fxos8700: fix ACCEL measurement range selection

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9d61c1820598a5ea474576ed55318a6dadee37ed Mon Sep 17 00:00:00 2001
From: Carlos Song <carlos.song@nxp.com>
Date: Thu, 8 Dec 2022 15:19:09 +0800
Subject: iio: imu: fxos8700: fix ACCEL measurement range selection

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
---
 drivers/iio/imu/fxos8700_core.c | 41 +++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/imu/fxos8700_core.c b/drivers/iio/imu/fxos8700_core.c
index 06948a8cc315..ec622123ccac 100644
--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -345,7 +345,8 @@ static int fxos8700_set_active_mode(struct fxos8700_data *data,
 static int fxos8700_set_scale(struct fxos8700_data *data,
 			      enum fxos8700_sensor t, int uscale)
 {
-	int i;
+	int i, ret, val;
+	bool active_mode;
 	static const int scale_num = ARRAY_SIZE(fxos8700_accel_scale);
 	struct device *dev = regmap_get_device(data->regmap);
 
@@ -354,6 +355,25 @@ static int fxos8700_set_scale(struct fxos8700_data *data,
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
@@ -361,8 +381,12 @@ static int fxos8700_set_scale(struct fxos8700_data *data,
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
@@ -631,14 +655,17 @@ static int fxos8700_chip_init(struct fxos8700_data *data, bool use_spi)
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
-- 
2.39.1


