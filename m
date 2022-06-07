Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9346A540C15
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351491AbiFGSdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352491AbiFGSbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E408B1451CE;
        Tue,  7 Jun 2022 10:56:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5AADECE242A;
        Tue,  7 Jun 2022 17:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38A2C3411C;
        Tue,  7 Jun 2022 17:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624571;
        bh=PD9e8Q2ln03IrdWmHwh9Oq+TnF2LvQdLrZsDfZ77aVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIrwbPlkhf7fGuf82dX7nQH+eoon/Lvq04+hjzM191nTPcqOFL2yPFufTwI0EhCv6
         IdwOBQRERqPapRKwE2osnY94l+T5zG3+loQWNGAR7Flk1ZIvtZSPULvoqGAH2erT5A
         LwmT6c4uyyThE8sRZudGWL6O63Y3SEZEP4XXQCvpOCEaU8Lazous1ghQ8f16aECBQ8
         mIFXDq9OL+hcclU94er4x0tK8gMHJdHH/kZUsnNgcZ/IMNgDW1kinMOcbU87MY16cq
         dpNJO6U4YVs5/WZb6wObrmLVuXVDNMHUg6I1VzDGhpjXbo5+GU4WKgJiGHRKamlBB4
         at3EmwJTGZp+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Denis Ciocca <denis.ciocca@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        lars@metafoo.de, aardelean@deviqon.com, cai.huoqing@linux.dev,
        andy.shevchenko@gmail.com, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/51] iio: st_sensors: Add a local lock for protecting odr
Date:   Tue,  7 Jun 2022 13:55:02 -0400
Message-Id: <20220607175552.479948-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175552.479948-1-sashal@kernel.org>
References: <20220607175552.479948-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 474010127e2505fc463236470908e1ff5ddb3578 ]

Right now the (framework) mlock lock is (ab)used for multiple purposes:
1- protecting concurrent accesses over the odr local cache
2- avoid changing samplig frequency whilst buffer is running

Let's start by handling situation #1 with a local lock.

Suggested-by: Jonathan Cameron <jic23@kernel.org>
Cc: Denis Ciocca <denis.ciocca@st.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20220207143840.707510-7-miquel.raynal@bootlin.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../iio/common/st_sensors/st_sensors_core.c   | 24 ++++++++++++++-----
 include/linux/iio/common/st_sensors.h         |  3 +++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
index 0bbb090b108c..aff981551617 100644
--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -71,16 +71,18 @@ static int st_sensors_match_odr(struct st_sensor_settings *sensor_settings,
 
 int st_sensors_set_odr(struct iio_dev *indio_dev, unsigned int odr)
 {
-	int err;
+	int err = 0;
 	struct st_sensor_odr_avl odr_out = {0, 0};
 	struct st_sensor_data *sdata = iio_priv(indio_dev);
 
+	mutex_lock(&sdata->odr_lock);
+
 	if (!sdata->sensor_settings->odr.mask)
-		return 0;
+		goto unlock_mutex;
 
 	err = st_sensors_match_odr(sdata->sensor_settings, odr, &odr_out);
 	if (err < 0)
-		goto st_sensors_match_odr_error;
+		goto unlock_mutex;
 
 	if ((sdata->sensor_settings->odr.addr ==
 					sdata->sensor_settings->pw.addr) &&
@@ -103,7 +105,9 @@ int st_sensors_set_odr(struct iio_dev *indio_dev, unsigned int odr)
 	if (err >= 0)
 		sdata->odr = odr_out.hz;
 
-st_sensors_match_odr_error:
+unlock_mutex:
+	mutex_unlock(&sdata->odr_lock);
+
 	return err;
 }
 EXPORT_SYMBOL(st_sensors_set_odr);
@@ -365,6 +369,8 @@ int st_sensors_init_sensor(struct iio_dev *indio_dev,
 	struct st_sensors_platform_data *of_pdata;
 	int err = 0;
 
+	mutex_init(&sdata->odr_lock);
+
 	/* If OF/DT pdata exists, it will take precedence of anything else */
 	of_pdata = st_sensors_dev_probe(indio_dev->dev.parent, pdata);
 	if (IS_ERR(of_pdata))
@@ -558,18 +564,24 @@ int st_sensors_read_info_raw(struct iio_dev *indio_dev,
 		err = -EBUSY;
 		goto out;
 	} else {
+		mutex_lock(&sdata->odr_lock);
 		err = st_sensors_set_enable(indio_dev, true);
-		if (err < 0)
+		if (err < 0) {
+			mutex_unlock(&sdata->odr_lock);
 			goto out;
+		}
 
 		msleep((sdata->sensor_settings->bootime * 1000) / sdata->odr);
 		err = st_sensors_read_axis_data(indio_dev, ch, val);
-		if (err < 0)
+		if (err < 0) {
+			mutex_unlock(&sdata->odr_lock);
 			goto out;
+		}
 
 		*val = *val >> ch->scan_type.shift;
 
 		err = st_sensors_set_enable(indio_dev, false);
+		mutex_unlock(&sdata->odr_lock);
 	}
 out:
 	mutex_unlock(&indio_dev->mlock);
diff --git a/include/linux/iio/common/st_sensors.h b/include/linux/iio/common/st_sensors.h
index 8bdbaf3f3796..69f4a1f6b536 100644
--- a/include/linux/iio/common/st_sensors.h
+++ b/include/linux/iio/common/st_sensors.h
@@ -238,6 +238,7 @@ struct st_sensor_settings {
  * @hw_irq_trigger: if we're using the hardware interrupt on the sensor.
  * @hw_timestamp: Latest timestamp from the interrupt handler, when in use.
  * @buffer_data: Data used by buffer part.
+ * @odr_lock: Local lock for preventing concurrent ODR accesses/changes
  */
 struct st_sensor_data {
 	struct device *dev;
@@ -263,6 +264,8 @@ struct st_sensor_data {
 	s64 hw_timestamp;
 
 	char buffer_data[ST_SENSORS_MAX_BUFFER_SIZE] ____cacheline_aligned;
+
+	struct mutex odr_lock;
 };
 
 #ifdef CONFIG_IIO_BUFFER
-- 
2.35.1

