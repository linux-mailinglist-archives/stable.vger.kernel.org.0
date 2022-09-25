Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EC65E915C
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 09:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiIYHPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 03:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiIYHP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 03:15:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB02B22B23
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 00:15:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 576A060AD7
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 07:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7F7C433C1;
        Sun, 25 Sep 2022 07:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664090127;
        bh=ZeO3UxzfPPvReJDrqFLEyZY3gfLm3XRjUENejRQlPRw=;
        h=Subject:To:From:Date:From;
        b=gfSOgDFrSUaDxW74QI2S4MFBy0u/HjIuZjfIvuhaeEhfVh6461Fx5P7SSAdhOqSYi
         ZyoZ2ZKz2Rhd4IMzmAay9gf17WgQQ1HyRa/FH/rEKRMIOVyHyeasTLqcyx+z+0EMTc
         gx3ZiWs00K8/GZ1etleDHVSXRiwKx1fsW6/hbeDI=
Subject: patch "iio: pressure: dps310: Refactor startup procedure" added to char-misc-next
To:     eajames@linux.ibm.com, Jonathan.Cameron@huawei.com,
        andy.shevchenko@gmail.com, joel@jms.id.au, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 25 Sep 2022 09:10:58 +0200
Message-ID: <166408985810955@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: pressure: dps310: Refactor startup procedure

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From c2329717bdd3fa62f8a2f3d8d85ad0bee4556bd7 Mon Sep 17 00:00:00 2001
From: Eddie James <eajames@linux.ibm.com>
Date: Thu, 15 Sep 2022 14:57:18 -0500
Subject: iio: pressure: dps310: Refactor startup procedure

Move the startup procedure into a function, and correct a missing
check on the return code for writing the PRS_CFG register.

Cc: <stable@vger.kernel.org>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220915195719.136812-2-eajames@linux.ibm.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/pressure/dps310.c | 188 ++++++++++++++++++----------------
 1 file changed, 99 insertions(+), 89 deletions(-)

diff --git a/drivers/iio/pressure/dps310.c b/drivers/iio/pressure/dps310.c
index 36fb7ae0d0a9..c706a8b423b5 100644
--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -159,6 +159,102 @@ static int dps310_get_coefs(struct dps310_data *data)
 	return 0;
 }
 
+/*
+ * Some versions of the chip will read temperatures in the ~60C range when
+ * it's actually ~20C. This is the manufacturer recommended workaround
+ * to correct the issue. The registers used below are undocumented.
+ */
+static int dps310_temp_workaround(struct dps310_data *data)
+{
+	int rc;
+	int reg;
+
+	rc = regmap_read(data->regmap, 0x32, &reg);
+	if (rc)
+		return rc;
+
+	/*
+	 * If bit 1 is set then the device is okay, and the workaround does not
+	 * need to be applied
+	 */
+	if (reg & BIT(1))
+		return 0;
+
+	rc = regmap_write(data->regmap, 0x0e, 0xA5);
+	if (rc)
+		return rc;
+
+	rc = regmap_write(data->regmap, 0x0f, 0x96);
+	if (rc)
+		return rc;
+
+	rc = regmap_write(data->regmap, 0x62, 0x02);
+	if (rc)
+		return rc;
+
+	rc = regmap_write(data->regmap, 0x0e, 0x00);
+	if (rc)
+		return rc;
+
+	return regmap_write(data->regmap, 0x0f, 0x00);
+}
+
+static int dps310_startup(struct dps310_data *data)
+{
+	int rc;
+	int ready;
+
+	/*
+	 * Set up pressure sensor in single sample, one measurement per second
+	 * mode
+	 */
+	rc = regmap_write(data->regmap, DPS310_PRS_CFG, 0);
+	if (rc)
+		return rc;
+
+	/*
+	 * Set up external (MEMS) temperature sensor in single sample, one
+	 * measurement per second mode
+	 */
+	rc = regmap_write(data->regmap, DPS310_TMP_CFG, DPS310_TMP_EXT);
+	if (rc)
+		return rc;
+
+	/* Temp and pressure shifts are disabled when PRC <= 8 */
+	rc = regmap_write_bits(data->regmap, DPS310_CFG_REG,
+			       DPS310_PRS_SHIFT_EN | DPS310_TMP_SHIFT_EN, 0);
+	if (rc)
+		return rc;
+
+	/* MEAS_CFG doesn't update correctly unless first written with 0 */
+	rc = regmap_write_bits(data->regmap, DPS310_MEAS_CFG,
+			       DPS310_MEAS_CTRL_BITS, 0);
+	if (rc)
+		return rc;
+
+	/* Turn on temperature and pressure measurement in the background */
+	rc = regmap_write_bits(data->regmap, DPS310_MEAS_CFG,
+			       DPS310_MEAS_CTRL_BITS, DPS310_PRS_EN |
+			       DPS310_TEMP_EN | DPS310_BACKGROUND);
+	if (rc)
+		return rc;
+
+	/*
+	 * Calibration coefficients required for reporting temperature.
+	 * They are available 40ms after the device has started
+	 */
+	rc = regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready,
+				      ready & DPS310_COEF_RDY, 10000, 40000);
+	if (rc)
+		return rc;
+
+	rc = dps310_get_coefs(data);
+	if (rc)
+		return rc;
+
+	return dps310_temp_workaround(data);
+}
+
 static int dps310_get_pres_precision(struct dps310_data *data)
 {
 	int rc;
@@ -677,52 +773,12 @@ static const struct iio_info dps310_info = {
 	.write_raw = dps310_write_raw,
 };
 
-/*
- * Some verions of chip will read temperatures in the ~60C range when
- * its actually ~20C. This is the manufacturer recommended workaround
- * to correct the issue. The registers used below are undocumented.
- */
-static int dps310_temp_workaround(struct dps310_data *data)
-{
-	int rc;
-	int reg;
-
-	rc = regmap_read(data->regmap, 0x32, &reg);
-	if (rc < 0)
-		return rc;
-
-	/*
-	 * If bit 1 is set then the device is okay, and the workaround does not
-	 * need to be applied
-	 */
-	if (reg & BIT(1))
-		return 0;
-
-	rc = regmap_write(data->regmap, 0x0e, 0xA5);
-	if (rc < 0)
-		return rc;
-
-	rc = regmap_write(data->regmap, 0x0f, 0x96);
-	if (rc < 0)
-		return rc;
-
-	rc = regmap_write(data->regmap, 0x62, 0x02);
-	if (rc < 0)
-		return rc;
-
-	rc = regmap_write(data->regmap, 0x0e, 0x00);
-	if (rc < 0)
-		return rc;
-
-	return regmap_write(data->regmap, 0x0f, 0x00);
-}
-
 static int dps310_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct dps310_data *data;
 	struct iio_dev *iio;
-	int rc, ready;
+	int rc;
 
 	iio = devm_iio_device_alloc(&client->dev,  sizeof(*data));
 	if (!iio)
@@ -747,54 +803,8 @@ static int dps310_probe(struct i2c_client *client,
 	if (rc)
 		return rc;
 
-	/*
-	 * Set up pressure sensor in single sample, one measurement per second
-	 * mode
-	 */
-	rc = regmap_write(data->regmap, DPS310_PRS_CFG, 0);
-
-	/*
-	 * Set up external (MEMS) temperature sensor in single sample, one
-	 * measurement per second mode
-	 */
-	rc = regmap_write(data->regmap, DPS310_TMP_CFG, DPS310_TMP_EXT);
-	if (rc < 0)
-		return rc;
-
-	/* Temp and pressure shifts are disabled when PRC <= 8 */
-	rc = regmap_write_bits(data->regmap, DPS310_CFG_REG,
-			       DPS310_PRS_SHIFT_EN | DPS310_TMP_SHIFT_EN, 0);
-	if (rc < 0)
-		return rc;
-
-	/* MEAS_CFG doesn't update correctly unless first written with 0 */
-	rc = regmap_write_bits(data->regmap, DPS310_MEAS_CFG,
-			       DPS310_MEAS_CTRL_BITS, 0);
-	if (rc < 0)
-		return rc;
-
-	/* Turn on temperature and pressure measurement in the background */
-	rc = regmap_write_bits(data->regmap, DPS310_MEAS_CFG,
-			       DPS310_MEAS_CTRL_BITS, DPS310_PRS_EN |
-			       DPS310_TEMP_EN | DPS310_BACKGROUND);
-	if (rc < 0)
-		return rc;
-
-	/*
-	 * Calibration coefficients required for reporting temperature.
-	 * They are available 40ms after the device has started
-	 */
-	rc = regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready,
-				      ready & DPS310_COEF_RDY, 10000, 40000);
-	if (rc < 0)
-		return rc;
-
-	rc = dps310_get_coefs(data);
-	if (rc < 0)
-		return rc;
-
-	rc = dps310_temp_workaround(data);
-	if (rc < 0)
+	rc = dps310_startup(data);
+	if (rc)
 		return rc;
 
 	rc = devm_iio_device_register(&client->dev, iio);
-- 
2.37.3


