Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EF4541C20
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349654AbiFGV40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382649AbiFGVvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39F923D5D4;
        Tue,  7 Jun 2022 12:09:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6C906188D;
        Tue,  7 Jun 2022 19:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AEDC385A2;
        Tue,  7 Jun 2022 19:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628948;
        bh=cNOrBeipYs4+o24KDc75FBnvoDRrZfjh1pCMj8Jy9TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK24aMgqOPccQErEIgfbvid26hd1GbU1RciCC6o4YSYJhAXs9Me95Gg/jlSOGYw+z
         XuEnx4lmklZojWT/pn1Iy0zHMqr93AfkFqw6eA/ONFQIgDJqZvcR8Ob5DMlGNEb1Su
         kusQU8TSnR5MlgpfMjBAPPkLzNEyl6Zv7l3f5CB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Wujek <dev_public@wujek.eu>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 515/879] hwmon: (pmbus) Check PEC support before reading other registers
Date:   Tue,  7 Jun 2022 19:00:33 +0200
Message-Id: <20220607165017.825232303@linuxfoundation.org>
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
index 5a1796650f5b..86429bfa4847 100644
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



