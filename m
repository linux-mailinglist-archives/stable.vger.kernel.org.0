Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6579C5B62B8
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 23:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiILV2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 17:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiILV2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 17:28:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94AA4A820;
        Mon, 12 Sep 2022 14:28:02 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CLOlDR010615;
        Mon, 12 Sep 2022 21:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Cfu5FJZ4JG5jLdo4Iw5LJ1Ej88atCRf+rYVjWppK3As=;
 b=afqsEfXpwYYU8p0GpC236yenRtdWjtOAHGPAxd84h8TDfiiOJ1VWZhsxueco0xCnx7oO
 pXhf7Pm/huSvWFlFBhyo0+M9lCoVld4tYww0JoZEDCM8zsNBbXkGn/2FO6vtVYKBMSGV
 ZIJfjd9psOuv3+m2ubp2MW/qMo43YMXy0nYGVFV7J1t8CzkiG49cNy4AMGyYXsDZucFn
 pcvxX4CHkbiDW/kXs0ukO45v2NePUYx/Ilw67hvGm88ndkChY/T+Aa2k7GLfBJtoxRRX
 gZVdMpezuGHrR9r9FFzLHzLGw5KYV8uwjfn7wM/p4E2vWtaY4/4+0nBM05awf1TxYIz+ oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjcnn81b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 21:27:47 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28CLRkDZ021169;
        Mon, 12 Sep 2022 21:27:46 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjcnn81av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 21:27:46 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28CLLuOT023750;
        Mon, 12 Sep 2022 21:27:45 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3jgj7a3x37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 21:27:45 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28CLRj2k64029008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 21:27:45 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E53B0AE064;
        Mon, 12 Sep 2022 21:27:44 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C856AE05C;
        Mon, 12 Sep 2022 21:27:44 +0000 (GMT)
Received: from slate16.aus.stglabs.ibm.com (unknown [9.77.129.206])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 12 Sep 2022 21:27:44 +0000 (GMT)
From:   Eddie James <eajames@linux.ibm.com>
To:     jic23@kernel.org
Cc:     lars@metafoo.de, linux-iio@vger.kernel.org, joel@jms.id.au,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        stable@vger.kernel.org, eajames@linux.ibm.com
Subject: [PATCH v7 1/2] iio: pressure: dps310: Refactor startup procedure
Date:   Mon, 12 Sep 2022 16:27:42 -0500
Message-Id: <20220912212743.37365-2-eajames@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220912212743.37365-1-eajames@linux.ibm.com>
References: <20220912212743.37365-1-eajames@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FmNZql93hiWmbzHXHJCdSkO-9L2T6YTH
X-Proofpoint-ORIG-GUID: OXSUVhQARuUrLdV3-br5n0L7boDDTzEg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_14,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Move the startup procedure into a function, and correct a missing
check on the return code for writing the PRS_CFG register.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
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
2.31.1

