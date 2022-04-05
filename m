Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269CC4F260D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiDEHyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiDEHyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:54:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF8C1EEE0;
        Tue,  5 Apr 2022 00:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 570E36172C;
        Tue,  5 Apr 2022 07:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A490C3410F;
        Tue,  5 Apr 2022 07:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144956;
        bh=GDkhXDUtppKjqDANeL6Q/shPJCjo5cy4GQ0T5NVoiQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiQSFYd+IXl1StVuSwWIFPUMu7oOFET535aV2+4TGmCY0d9inuGtKtu1pKvbjXuPo
         CZ0mu3f1o9C95FVHUswWu1DhbdIwXyfjIl0Qqor4vZ/icBIUDH/wmzA8vhiFZUpjNu
         QEuxw16s28oSWZpP6BBktrL3UnIbKP3VuqZpofz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Patrick Rudolph <patrick.rudolph@9elements.com>,
        Marcello Sylvester Bauer <sylv@sylv.io>,
        Alan Tull <atull@opensource.altera.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0233/1126] hwmon: (pmbus) Add mutex to regulator ops
Date:   Tue,  5 Apr 2022 09:16:20 +0200
Message-Id: <20220405070414.447564063@linuxfoundation.org>
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

From: Patrick Rudolph <patrick.rudolph@9elements.com>

[ Upstream commit 686d303ee6301261b422ea51e64833d7909a2c36 ]

On PMBUS devices with multiple pages, the regulator ops need to be
protected with the update mutex. This prevents accidentally changing
the page in a separate thread while operating on the PMBUS_OPERATION
register.

Tested on Infineon xdpe11280 while a separate thread polls for sensor
data.

Signed-off-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Signed-off-by: Marcello Sylvester Bauer <sylv@sylv.io>
Link: https://lore.kernel.org/r/b991506bcbf665f7af185945f70bf9d5cf04637c.1645804976.git.sylv@sylv.io
Fixes: ddbb4db4ced1b ("hwmon: (pmbus) Add regulator support")
Cc: Alan Tull <atull@opensource.altera.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index ac2fbee1ba9c..b1386a4df4cc 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -2391,10 +2391,14 @@ static int pmbus_regulator_is_enabled(struct regulator_dev *rdev)
 {
 	struct device *dev = rdev_get_dev(rdev);
 	struct i2c_client *client = to_i2c_client(dev->parent);
+	struct pmbus_data *data = i2c_get_clientdata(client);
 	u8 page = rdev_get_id(rdev);
 	int ret;
 
+	mutex_lock(&data->update_lock);
 	ret = pmbus_read_byte_data(client, page, PMBUS_OPERATION);
+	mutex_unlock(&data->update_lock);
+
 	if (ret < 0)
 		return ret;
 
@@ -2405,11 +2409,17 @@ static int _pmbus_regulator_on_off(struct regulator_dev *rdev, bool enable)
 {
 	struct device *dev = rdev_get_dev(rdev);
 	struct i2c_client *client = to_i2c_client(dev->parent);
+	struct pmbus_data *data = i2c_get_clientdata(client);
 	u8 page = rdev_get_id(rdev);
+	int ret;
 
-	return pmbus_update_byte_data(client, page, PMBUS_OPERATION,
-				      PB_OPERATION_CONTROL_ON,
-				      enable ? PB_OPERATION_CONTROL_ON : 0);
+	mutex_lock(&data->update_lock);
+	ret = pmbus_update_byte_data(client, page, PMBUS_OPERATION,
+				     PB_OPERATION_CONTROL_ON,
+				     enable ? PB_OPERATION_CONTROL_ON : 0);
+	mutex_unlock(&data->update_lock);
+
+	return ret;
 }
 
 static int pmbus_regulator_enable(struct regulator_dev *rdev)
-- 
2.34.1



