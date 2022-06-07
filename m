Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA22540D12
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353540AbiFGSou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353447AbiFGSmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:42:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB716540A;
        Tue,  7 Jun 2022 10:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0CBDCCE2428;
        Tue,  7 Jun 2022 17:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0989FC34115;
        Tue,  7 Jun 2022 17:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624735;
        bh=QjdCu1aptZA0HMTYSO5wIg0K7eKoSRF/GSpxcxLlggo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIc7eHT1hzsasZvSWi/Uk13nW6Prlwf/gdnRtfyCRbirNY3O2SPz9od6pdAy51bx4
         vmr9Vgdp2F5akze6yFFOIGCPwgQHiakhnbVpP05QhSzqQ+pWh95MNM7OQ8Gt5ZK7ss
         TskBlowZfASlm3vppHyW1UCkUAmzvl+gldcU3MgbXZSYmLMDQCsBDwJR/WjWzINGYW
         CNJjW18itybUG/u+l5rKHx2FhJ0cJVYZ43j0+tlRxIgmN9IQTrrNNP+KeI7LeOyBkJ
         2AJSnekdyCKMzNe3p6Op0ca4npEduui1ftOr0azqOpSf+EJZLdLvojG4GTibNRjkEh
         kyZbtSj920poQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Denis Ciocca <denis.ciocca@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        cai.huoqing@linux.dev, andy.shevchenko@gmail.com,
        aardelean@deviqon.com, lars@metafoo.de, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/38] iio: st_sensors: Add a local lock for protecting odr
Date:   Tue,  7 Jun 2022 13:57:58 -0400
Message-Id: <20220607175835.480735-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175835.480735-1-sashal@kernel.org>
References: <20220607175835.480735-1-sashal@kernel.org>
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
index 7a69c1be7393..56206fdbceb9 100644
--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -70,16 +70,18 @@ static int st_sensors_match_odr(struct st_sensor_settings *sensor_settings,
 
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
@@ -102,7 +104,9 @@ int st_sensors_set_odr(struct iio_dev *indio_dev, unsigned int odr)
 	if (err >= 0)
 		sdata->odr = odr_out.hz;
 
-st_sensors_match_odr_error:
+unlock_mutex:
+	mutex_unlock(&sdata->odr_lock);
+
 	return err;
 }
 EXPORT_SYMBOL(st_sensors_set_odr);
@@ -364,6 +368,8 @@ int st_sensors_init_sensor(struct iio_dev *indio_dev,
 	struct st_sensors_platform_data *of_pdata;
 	int err = 0;
 
+	mutex_init(&sdata->odr_lock);
+
 	/* If OF/DT pdata exists, it will take precedence of anything else */
 	of_pdata = st_sensors_dev_probe(indio_dev->dev.parent, pdata);
 	if (IS_ERR(of_pdata))
@@ -557,18 +563,24 @@ int st_sensors_read_info_raw(struct iio_dev *indio_dev,
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
index 33e939977444..c16a9dda3ad5 100644
--- a/include/linux/iio/common/st_sensors.h
+++ b/include/linux/iio/common/st_sensors.h
@@ -228,6 +228,7 @@ struct st_sensor_settings {
  * @hw_irq_trigger: if we're using the hardware interrupt on the sensor.
  * @hw_timestamp: Latest timestamp from the interrupt handler, when in use.
  * @buffer_data: Data used by buffer part.
+ * @odr_lock: Local lock for preventing concurrent ODR accesses/changes
  */
 struct st_sensor_data {
 	struct device *dev;
@@ -253,6 +254,8 @@ struct st_sensor_data {
 	s64 hw_timestamp;
 
 	char buffer_data[ST_SENSORS_MAX_BUFFER_SIZE] ____cacheline_aligned;
+
+	struct mutex odr_lock;
 };
 
 #ifdef CONFIG_IIO_BUFFER
-- 
2.35.1

