Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE1B537DAA
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbiE3Nlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237762AbiE3NiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:38:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643638BD1F;
        Mon, 30 May 2022 06:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B78DB80D89;
        Mon, 30 May 2022 13:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B67BC3411C;
        Mon, 30 May 2022 13:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917472;
        bh=jwx+vf2s8FhK15e9dVjLvjTG6LGBGKIc0EVLYugk9P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SankRzmBI3yRujlBC+OilUXWysU2PIEXgZd8MBseGL5I6CHPG9y9T0AKKBiJtP2iv
         noj/QTPSOpsFRYwI/+ol5WmN70Q58988gOlctJIscRo5cFfmsXf02AtFcmtNEt4kKA
         nEQ16JVIsbjV75jMpQD1vCIn+oqz6fgQ6DFrRGALgmeWAXopKi80rxlwlb6b4Jl+Hq
         RvKPyeeHo4Ps5sJnpy33hLHa8EFY7FeMMFXbmeDvkerys/LfuIP74iv0Pd81fQzUsu
         vBMCSacsvEv5OiB5vxbxEmjR55A0U6l7qmlfiicF6SW4FQEj3BbZ/YUQs57FCZE4t6
         fcc2qEPTP/f8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 150/159] hwmon: (pmbus) Add get_voltage/set_voltage ops
Date:   Mon, 30 May 2022 09:24:15 -0400
Message-Id: <20220530132425.1929512-150-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mårten Lindahl <marten.lindahl@axis.com>

[ Upstream commit 28bf22ef93eceb42c7583f0909bc9dedc07770e3 ]

The pmbus core does not have operations for getting or setting voltage.
Add functions get/set voltage for the dynamic regulator framework.

Signed-off-by: Mårten Lindahl <marten.lindahl@axis.com>
Link: https://lore.kernel.org/r/20220503104631.3515715-5-marten.lindahl@axis.com
[groeck: cosmetic alignment / empty line fixes]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 67 ++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index d93574d6a1fb..5a1796650f5b 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -2548,11 +2548,78 @@ static int pmbus_regulator_get_error_flags(struct regulator_dev *rdev, unsigned
 	return 0;
 }
 
+static int pmbus_regulator_get_voltage(struct regulator_dev *rdev)
+{
+	struct device *dev = rdev_get_dev(rdev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
+	struct pmbus_data *data = i2c_get_clientdata(client);
+	struct pmbus_sensor s = {
+		.page = rdev_get_id(rdev),
+		.class = PSC_VOLTAGE_OUT,
+		.convert = true,
+	};
+
+	s.data = _pmbus_read_word_data(client, s.page, 0xff, PMBUS_READ_VOUT);
+	if (s.data < 0)
+		return s.data;
+
+	return (int)pmbus_reg2data(data, &s) * 1000; /* unit is uV */
+}
+
+static int pmbus_regulator_set_voltage(struct regulator_dev *rdev, int min_uv,
+				       int max_uv, unsigned int *selector)
+{
+	struct device *dev = rdev_get_dev(rdev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
+	struct pmbus_data *data = i2c_get_clientdata(client);
+	struct pmbus_sensor s = {
+		.page = rdev_get_id(rdev),
+		.class = PSC_VOLTAGE_OUT,
+		.convert = true,
+		.data = -1,
+	};
+	int val = DIV_ROUND_CLOSEST(min_uv, 1000); /* convert to mV */
+	int low, high;
+
+	*selector = 0;
+
+	if (pmbus_check_word_register(client, s.page, PMBUS_MFR_VOUT_MIN))
+		s.data = _pmbus_read_word_data(client, s.page, 0xff, PMBUS_MFR_VOUT_MIN);
+	if (s.data < 0) {
+		s.data = _pmbus_read_word_data(client, s.page, 0xff, PMBUS_VOUT_MARGIN_LOW);
+		if (s.data < 0)
+			return s.data;
+	}
+	low = pmbus_reg2data(data, &s);
+
+	s.data = -1;
+	if (pmbus_check_word_register(client, s.page, PMBUS_MFR_VOUT_MAX))
+		s.data = _pmbus_read_word_data(client, s.page, 0xff, PMBUS_MFR_VOUT_MAX);
+	if (s.data < 0) {
+		s.data = _pmbus_read_word_data(client, s.page, 0xff, PMBUS_VOUT_MARGIN_HIGH);
+		if (s.data < 0)
+			return s.data;
+	}
+	high = pmbus_reg2data(data, &s);
+
+	/* Make sure we are within margins */
+	if (low > val)
+		val = low;
+	if (high < val)
+		val = high;
+
+	val = pmbus_data2reg(data, &s, val);
+
+	return _pmbus_write_word_data(client, s.page, PMBUS_VOUT_COMMAND, (u16)val);
+}
+
 const struct regulator_ops pmbus_regulator_ops = {
 	.enable = pmbus_regulator_enable,
 	.disable = pmbus_regulator_disable,
 	.is_enabled = pmbus_regulator_is_enabled,
 	.get_error_flags = pmbus_regulator_get_error_flags,
+	.get_voltage = pmbus_regulator_get_voltage,
+	.set_voltage = pmbus_regulator_set_voltage,
 };
 EXPORT_SYMBOL_NS_GPL(pmbus_regulator_ops, PMBUS);
 
-- 
2.35.1

