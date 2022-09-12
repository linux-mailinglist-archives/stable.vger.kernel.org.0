Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B485B62B6
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 23:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiILV2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 17:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiILV2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 17:28:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94014A81B;
        Mon, 12 Sep 2022 14:28:02 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CKujRt000764;
        Mon, 12 Sep 2022 21:27:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EMcv0u1/xQzPEzEA83QhzXj8VXm/t6Z9feb8R2hGNSY=;
 b=fxHaOBXJB0YI0GpTOKJ0iYOi+r6vE+EcvVzaOpcNBGzXGvMmNvLggNh5dKREFRNuurSP
 RNftn6RCOr6tG4zIjXjmA1tzV0TNRSqBhO9Y7i+t3G2Ktx8G//7M+pyaf8uRWYuIwoCZ
 aWBO2bYi89kouZQax6Yhh8EdZCgYMBhYUojwUsw1W1Zr/TykhJBfcVFephpmFo2EFoWR
 gX6QMw2h3KriNV3kBMd0FCjz6zSaet9Xmjbz1PlCk00dS2AHcsj5XeE3H99LvF+3UtPB
 6ZDhAlxEJ9LiAJqfX9/y/s65UlnrgUkpgQwe5r3LD/wPfsI3rqXj6pG+Y0NTCY1ckRkc +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjc8k0un2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 21:27:47 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28CLBS9n008860;
        Mon, 12 Sep 2022 21:27:47 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjc8k0umm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 21:27:47 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28CLKCn7021625;
        Mon, 12 Sep 2022 21:27:46 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 3jgj797yt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 21:27:46 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28CLRjar2163328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 21:27:45 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A73E2AE05C;
        Mon, 12 Sep 2022 21:27:45 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E563AE064;
        Mon, 12 Sep 2022 21:27:45 +0000 (GMT)
Received: from slate16.aus.stglabs.ibm.com (unknown [9.77.129.206])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 12 Sep 2022 21:27:44 +0000 (GMT)
From:   Eddie James <eajames@linux.ibm.com>
To:     jic23@kernel.org
Cc:     lars@metafoo.de, linux-iio@vger.kernel.org, joel@jms.id.au,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        stable@vger.kernel.org, eajames@linux.ibm.com
Subject: [PATCH v7 2/2] iio: pressure: dps310: Reset chip after timeout
Date:   Mon, 12 Sep 2022 16:27:43 -0500
Message-Id: <20220912212743.37365-3-eajames@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220912212743.37365-1-eajames@linux.ibm.com>
References: <20220912212743.37365-1-eajames@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CCL-j9RrVxCGbCZZv1M2lLpTidwn0qR0
X-Proofpoint-GUID: 62_Wql-NLvAgcqvhR66jv0vy_1h__2PY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_14,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The DPS310 chip has been observed to get "stuck" such that pressure
and temperature measurements are never indicated as "ready" in the
MEAS_CFG register. The only solution is to reset the device and try
again. In order to avoid continual failures, use a boolean flag to
only try the reset after timeout once if errors persist.

Fixes: ba6ec48e76bc ("iio: Add driver for Infineon DPS310")
Cc: <stable@vger.kernel.org> # iio: pressure: dps310: Refactor startup procedure
Cc: <stable@vger.kernel.org>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
---
 drivers/iio/pressure/dps310.c | 78 ++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/pressure/dps310.c b/drivers/iio/pressure/dps310.c
index c706a8b423b5..82c9a05123e2 100644
--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -89,6 +89,7 @@ struct dps310_data {
 	s32 c00, c10, c20, c30, c01, c11, c21;
 	s32 pressure_raw;
 	s32 temp_raw;
+	bool timeout_recovery_failed;
 };
 
 static const struct iio_chan_spec dps310_channels[] = {
@@ -393,11 +394,73 @@ static int dps310_get_temp_k(struct dps310_data *data)
 	return scale_factors[ilog2(rc)];
 }
 
+static int dps310_reset_wait(struct dps310_data *data)
+{
+	int rc;
+
+	rc = regmap_write(data->regmap, DPS310_RESET, DPS310_RESET_MAGIC);
+	if (rc)
+		return rc;
+
+	/* Wait for device chip access: 2.5ms in specification */
+	usleep_range(2500, 12000);
+	return 0;
+}
+
+static int dps310_reset_reinit(struct dps310_data *data)
+{
+	int rc;
+
+	rc = dps310_reset_wait(data);
+	if (rc)
+		return rc;
+
+	return dps310_startup(data);
+}
+
+static int dps310_ready_status(struct dps310_data *data, int ready_bit, int timeout)
+{
+	int ready;
+	int sleep = DPS310_POLL_SLEEP_US(timeout);
+
+	return regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready, ready & ready_bit,
+					sleep, timeout);
+}
+
+static int dps310_ready(struct dps310_data *data, int ready_bit, int timeout)
+{
+	int rc;
+
+	rc = dps310_ready_status(data, ready_bit, timeout);
+	if (rc) {
+		if (rc == -ETIMEDOUT && !data->timeout_recovery_failed) {
+			int rc2;
+
+			/* Reset and reinitialize the chip. */
+			rc2 = dps310_reset_reinit(data);
+			if (rc2) {
+				data->timeout_recovery_failed = true;
+			} else {
+				/* Try again to get sensor ready status. */
+				rc2 = dps310_ready_status(data, ready_bit, timeout);
+				if (rc2)
+					data->timeout_recovery_failed = true;
+				else
+					return 0;
+			}
+		}
+
+		return rc;
+	}
+
+	data->timeout_recovery_failed = false;
+	return 0;
+}
+
 static int dps310_read_pres_raw(struct dps310_data *data)
 {
 	int rc;
 	int rate;
-	int ready;
 	int timeout;
 	s32 raw;
 	u8 val[3];
@@ -409,9 +472,7 @@ static int dps310_read_pres_raw(struct dps310_data *data)
 	timeout = DPS310_POLL_TIMEOUT_US(rate);
 
 	/* Poll for sensor readiness; base the timeout upon the sample rate. */
-	rc = regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready,
-				      ready & DPS310_PRS_RDY,
-				      DPS310_POLL_SLEEP_US(timeout), timeout);
+	rc = dps310_ready(data, DPS310_PRS_RDY, timeout);
 	if (rc)
 		goto done;
 
@@ -448,7 +509,6 @@ static int dps310_read_temp_raw(struct dps310_data *data)
 {
 	int rc;
 	int rate;
-	int ready;
 	int timeout;
 
 	if (mutex_lock_interruptible(&data->lock))
@@ -458,10 +518,8 @@ static int dps310_read_temp_raw(struct dps310_data *data)
 	timeout = DPS310_POLL_TIMEOUT_US(rate);
 
 	/* Poll for sensor readiness; base the timeout upon the sample rate. */
-	rc = regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready,
-				      ready & DPS310_TMP_RDY,
-				      DPS310_POLL_SLEEP_US(timeout), timeout);
-	if (rc < 0)
+	rc = dps310_ready(data, DPS310_TMP_RDY, timeout);
+	if (rc)
 		goto done;
 
 	rc = dps310_read_temp_ready(data);
@@ -756,7 +814,7 @@ static void dps310_reset(void *action_data)
 {
 	struct dps310_data *data = action_data;
 
-	regmap_write(data->regmap, DPS310_RESET, DPS310_RESET_MAGIC);
+	dps310_reset_wait(data);
 }
 
 static const struct regmap_config dps310_regmap_config = {
-- 
2.31.1

