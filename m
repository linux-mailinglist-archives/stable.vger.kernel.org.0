Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB85540B62
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351199AbiFGS2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350961AbiFGSPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:15:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAB215C880;
        Tue,  7 Jun 2022 10:49:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94541B82343;
        Tue,  7 Jun 2022 17:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE484C385A5;
        Tue,  7 Jun 2022 17:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624157;
        bh=dWtkSMzKDscygiG+tJ3tu1ikyvw0VFXcLcT5fAOsbOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEn1Ki84bYIjnvcaDYJAZU6v0Ro86rBx88p4mTUqS80obkBstkQxew2BVyxVuJ1en
         GR3y10Il8cn0T0YZqBrKf311HRwzE2km9UGuiSpwzoANmXSua94QZ7seF8E5P3RY0Q
         ru7vX1nQCXFwo5/fCtqRiq/+ld/gUi6StPYBsFVrRcU87GF9mCTG5y5p21/q3RvwE6
         NkjGezXp1SS9ej7JVyQoVXvP94dNpDsfwSA9hKNZuyHnKor3H/bRaL/k6uZmDxoKpI
         ujF1iLpmfrH0vAbhucAGls/eXzA2in0kpwX/ek8rW7B2SHd44A8NrXOXt1T9kAajXg
         FZU3qnG75XK0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Denis Ciocca <denis.ciocca@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        lars@metafoo.de, andy.shevchenko@gmail.com, aardelean@deviqon.com,
        cai.huoqing@linux.dev, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 03/68] iio: st_sensors: Add a local lock for protecting odr
Date:   Tue,  7 Jun 2022 13:47:29 -0400
Message-Id: <20220607174846.477972-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
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
index fa9bcdf0d190..b92de90a125c 100644
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
 EXPORT_SYMBOL_NS(st_sensors_set_odr, IIO_ST_SENSORS);
@@ -361,6 +365,8 @@ int st_sensors_init_sensor(struct iio_dev *indio_dev,
 	struct st_sensors_platform_data *of_pdata;
 	int err = 0;
 
+	mutex_init(&sdata->odr_lock);
+
 	/* If OF/DT pdata exists, it will take precedence of anything else */
 	of_pdata = st_sensors_dev_probe(indio_dev->dev.parent, pdata);
 	if (IS_ERR(of_pdata))
@@ -554,18 +560,24 @@ int st_sensors_read_info_raw(struct iio_dev *indio_dev,
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
index 22f67845cdd3..db4a1b260348 100644
--- a/include/linux/iio/common/st_sensors.h
+++ b/include/linux/iio/common/st_sensors.h
@@ -237,6 +237,7 @@ struct st_sensor_settings {
  * @hw_irq_trigger: if we're using the hardware interrupt on the sensor.
  * @hw_timestamp: Latest timestamp from the interrupt handler, when in use.
  * @buffer_data: Data used by buffer part.
+ * @odr_lock: Local lock for preventing concurrent ODR accesses/changes
  */
 struct st_sensor_data {
 	struct iio_trigger *trig;
@@ -261,6 +262,8 @@ struct st_sensor_data {
 	s64 hw_timestamp;
 
 	char buffer_data[ST_SENSORS_MAX_BUFFER_SIZE] ____cacheline_aligned;
+
+	struct mutex odr_lock;
 };
 
 #ifdef CONFIG_IIO_BUFFER
-- 
2.35.1

