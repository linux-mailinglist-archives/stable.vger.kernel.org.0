Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F4146541983
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378827AbiFGVWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380699AbiFGVQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FFC14AF5D;
        Tue,  7 Jun 2022 11:56:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F05A061578;
        Tue,  7 Jun 2022 18:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0E2C385A2;
        Tue,  7 Jun 2022 18:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628180;
        bh=jwx+vf2s8FhK15e9dVjLvjTG6LGBGKIc0EVLYugk9P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVKxFZwR5G7ZziiK8D9dmWTdVFZYGLcPlCHom5dGzEq2At8yzcmbcG6pxxtix/wis
         a/pPGD/owkwOPCYrZDMbSVcOMw62qEj0nC+CCa4zXDuLbkQgBlGzQAKBZ9pfrQGVqH
         AcRNaUXH134BTbcr5QO+jWdzNEWUmgwG0WtkTaRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 198/879] hwmon: (pmbus) Add get_voltage/set_voltage ops
Date:   Tue,  7 Jun 2022 18:55:16 +0200
Message-Id: <20220607165008.592697266@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



