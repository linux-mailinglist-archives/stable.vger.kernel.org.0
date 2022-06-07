Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA86540C07
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351707AbiFGScj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351764AbiFGSaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DD22CE30;
        Tue,  7 Jun 2022 10:55:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8D4E617A8;
        Tue,  7 Jun 2022 17:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16ECC385A5;
        Tue,  7 Jun 2022 17:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624546;
        bh=d6PRW2L/i7S3njKFXoCdPxI1YSkETLyxZT/LUdwxwUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NztU1rKEA1+Fzknha7UaNrDPu08B6TayKEYgZwPy6IDszezkXnknDnBah/KOfz3rX
         cicHDFN0ZPmOhZrmab9eCrBZofXsjIG/K8xToxRhTU80utl0eT1vu+AVP+mlnD/c7N
         N83o4xT2bUVD6v1ko/jcgRMd8yGgHTYAR6dX8wIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Wujek <dev_public@wujek.eu>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 367/667] hwmon: (pmbus) Check PEC support before reading other registers
Date:   Tue,  7 Jun 2022 19:00:32 +0200
Message-Id: <20220607164945.758697261@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Adam Wujek <dev_public@wujek.eu>

[ Upstream commit d1baf7a3a3177d46a7149858beddb88a9eca7a54 ]

Make sure that the support of PEC is determined before the read of other
registers. Otherwise the validation of PEC can trigger an error on the read
of STATUS_BYTE or STATUS_WORD registers.

The problematic scenario is the following. A device with enabled PEC
support is up and running and a kernel driver is loaded.
Then the driver is unloaded (or device unbound), the HW device
is reconfigured externally (e.g. by i2cset) to advertise itself as not
supporting PEC. Without the move of the code, at the second load of
the driver (or bind) the STATUS_BYTE or STATUS_WORD register is always
read with PEC enabled, which is likely to cause a read error resulting
with fail of a driver load (or bind).

Signed-off-by: Adam Wujek <dev_public@wujek.eu>
Link: https://lore.kernel.org/r/20220519233334.438621-1-dev_public@wujek.eu
Fixes: 75d2b2b06bd84 ("hwmon: (pmbus) disable PEC if not enabled")
Fixes: 4e5418f787ec5 ("hwmon: (pmbus_core) Check adapter PEC support")
[groeck: Added Fixes: tags, dropped continuation line]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 5f8f824d997f..63b616ce3a6e 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -2308,6 +2308,21 @@ static int pmbus_init_common(struct i2c_client *client, struct pmbus_data *data,
 	struct device *dev = &client->dev;
 	int page, ret;
 
+	/*
+	 * Figure out if PEC is enabled before accessing any other register.
+	 * Make sure PEC is disabled, will be enabled later if needed.
+	 */
+	client->flags &= ~I2C_CLIENT_PEC;
+
+	/* Enable PEC if the controller and bus supports it */
+	if (!(data->flags & PMBUS_NO_CAPABILITY)) {
+		ret = i2c_smbus_read_byte_data(client, PMBUS_CAPABILITY);
+		if (ret >= 0 && (ret & PB_CAPABILITY_ERROR_CHECK)) {
+			if (i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_PEC))
+				client->flags |= I2C_CLIENT_PEC;
+		}
+	}
+
 	/*
 	 * Some PMBus chips don't support PMBUS_STATUS_WORD, so try
 	 * to use PMBUS_STATUS_BYTE instead if that is the case.
@@ -2326,19 +2341,6 @@ static int pmbus_init_common(struct i2c_client *client, struct pmbus_data *data,
 		data->has_status_word = true;
 	}
 
-	/* Make sure PEC is disabled, will be enabled later if needed */
-	client->flags &= ~I2C_CLIENT_PEC;
-
-	/* Enable PEC if the controller and bus supports it */
-	if (!(data->flags & PMBUS_NO_CAPABILITY)) {
-		ret = i2c_smbus_read_byte_data(client, PMBUS_CAPABILITY);
-		if (ret >= 0 && (ret & PB_CAPABILITY_ERROR_CHECK)) {
-			if (i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_PEC)) {
-				client->flags |= I2C_CLIENT_PEC;
-			}
-		}
-	}
-
 	/*
 	 * Check if the chip is write protected. If it is, we can not clear
 	 * faults, and we should not try it. Also, in that case, writes into
-- 
2.35.1



