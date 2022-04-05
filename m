Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E704F2CFA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbiDEI0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239373AbiDEIUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B0DBF961;
        Tue,  5 Apr 2022 01:12:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B6B8609AD;
        Tue,  5 Apr 2022 08:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA81C385A0;
        Tue,  5 Apr 2022 08:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146324;
        bh=rbac+8DdlPGXajy2CvCIDYMwsFJSMo+lheXCihS3ad4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3JkEK8aFT9KVeRpkg+NmbZeW901elTLBirVZB8RjRXROjZvhF5hFgUdtIFx27gzH
         pYDfgXrxQ+y367olm+ocsopGUwfezhBx5Y4+rro+zsyHdI7f558OjmRsBiM4/uTnlc
         N+3BwP9bUJ2DGdK9ZrGT7Ousu5GXjuhLuKRMjZ1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0724/1126] iio: mma8452: Fix probe failing when an i2c_device_id is used
Date:   Tue,  5 Apr 2022 09:24:31 +0200
Message-Id: <20220405070428.844319178@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a47ac019e7e8129b93a0b991e04b2a59872e053d ]

The mma8452_driver declares both of_match_table and i2c_driver.id_table
match-tables, but its probe() function only checked for of matches.

Add support for i2c_device_id matches. This fixes the driver not loading
on some x86 tablets (e.g. the Nextbook Ares 8) where the i2c_client is
instantiated by platform code using an i2c_device_id.

Drop of_match_ptr() protection to avoid unused warning.

Fixes: c3cdd6e48e35 ("iio: mma8452: refactor for seperating chip specific data")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220208124336.511884-1-hdegoede@redhat.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma8452.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 0016bb947c10..a21fdb015c6c 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -176,6 +176,7 @@ static const struct mma8452_event_regs trans_ev_regs = {
  * @enabled_events:		event flags enabled and handled by this driver
  */
 struct mma_chip_info {
+	const char *name;
 	u8 chip_id;
 	const struct iio_chan_spec *channels;
 	int num_channels;
@@ -1301,6 +1302,7 @@ enum {
 
 static const struct mma_chip_info mma_chip_info_table[] = {
 	[mma8451] = {
+		.name = "mma8451",
 		.chip_id = MMA8451_DEVICE_ID,
 		.channels = mma8451_channels,
 		.num_channels = ARRAY_SIZE(mma8451_channels),
@@ -1325,6 +1327,7 @@ static const struct mma_chip_info mma_chip_info_table[] = {
 					MMA8452_INT_FF_MT,
 	},
 	[mma8452] = {
+		.name = "mma8452",
 		.chip_id = MMA8452_DEVICE_ID,
 		.channels = mma8452_channels,
 		.num_channels = ARRAY_SIZE(mma8452_channels),
@@ -1341,6 +1344,7 @@ static const struct mma_chip_info mma_chip_info_table[] = {
 					MMA8452_INT_FF_MT,
 	},
 	[mma8453] = {
+		.name = "mma8453",
 		.chip_id = MMA8453_DEVICE_ID,
 		.channels = mma8453_channels,
 		.num_channels = ARRAY_SIZE(mma8453_channels),
@@ -1357,6 +1361,7 @@ static const struct mma_chip_info mma_chip_info_table[] = {
 					MMA8452_INT_FF_MT,
 	},
 	[mma8652] = {
+		.name = "mma8652",
 		.chip_id = MMA8652_DEVICE_ID,
 		.channels = mma8652_channels,
 		.num_channels = ARRAY_SIZE(mma8652_channels),
@@ -1366,6 +1371,7 @@ static const struct mma_chip_info mma_chip_info_table[] = {
 		.enabled_events = MMA8452_INT_FF_MT,
 	},
 	[mma8653] = {
+		.name = "mma8653",
 		.chip_id = MMA8653_DEVICE_ID,
 		.channels = mma8653_channels,
 		.num_channels = ARRAY_SIZE(mma8653_channels),
@@ -1380,6 +1386,7 @@ static const struct mma_chip_info mma_chip_info_table[] = {
 		.enabled_events = MMA8452_INT_FF_MT,
 	},
 	[fxls8471] = {
+		.name = "fxls8471",
 		.chip_id = FXLS8471_DEVICE_ID,
 		.channels = mma8451_channels,
 		.num_channels = ARRAY_SIZE(mma8451_channels),
@@ -1522,13 +1529,6 @@ static int mma8452_probe(struct i2c_client *client,
 	struct mma8452_data *data;
 	struct iio_dev *indio_dev;
 	int ret;
-	const struct of_device_id *match;
-
-	match = of_match_device(mma8452_dt_ids, &client->dev);
-	if (!match) {
-		dev_err(&client->dev, "unknown device model\n");
-		return -ENODEV;
-	}
 
 	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
 	if (!indio_dev)
@@ -1537,7 +1537,14 @@ static int mma8452_probe(struct i2c_client *client,
 	data = iio_priv(indio_dev);
 	data->client = client;
 	mutex_init(&data->lock);
-	data->chip_info = match->data;
+
+	data->chip_info = device_get_match_data(&client->dev);
+	if (!data->chip_info && id) {
+		data->chip_info = &mma_chip_info_table[id->driver_data];
+	} else {
+		dev_err(&client->dev, "unknown device model\n");
+		return -ENODEV;
+	}
 
 	data->vdd_reg = devm_regulator_get(&client->dev, "vdd");
 	if (IS_ERR(data->vdd_reg))
@@ -1581,11 +1588,11 @@ static int mma8452_probe(struct i2c_client *client,
 	}
 
 	dev_info(&client->dev, "registering %s accelerometer; ID 0x%x\n",
-		 match->compatible, data->chip_info->chip_id);
+		 data->chip_info->name, data->chip_info->chip_id);
 
 	i2c_set_clientdata(client, indio_dev);
 	indio_dev->info = &mma8452_info;
-	indio_dev->name = id->name;
+	indio_dev->name = data->chip_info->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->channels = data->chip_info->channels;
 	indio_dev->num_channels = data->chip_info->num_channels;
@@ -1810,7 +1817,7 @@ MODULE_DEVICE_TABLE(i2c, mma8452_id);
 static struct i2c_driver mma8452_driver = {
 	.driver = {
 		.name	= "mma8452",
-		.of_match_table = of_match_ptr(mma8452_dt_ids),
+		.of_match_table = mma8452_dt_ids,
 		.pm	= &mma8452_pm_ops,
 	},
 	.probe = mma8452_probe,
-- 
2.34.1



