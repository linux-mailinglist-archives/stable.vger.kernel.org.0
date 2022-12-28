Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD60657F5F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiL1QEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbiL1QEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:04:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C649E19027
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:04:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6037A60D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F74C433EF;
        Wed, 28 Dec 2022 16:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243445;
        bh=Mt7l8+L5QgrPjlxFpDR+rjN5Kt/xAd1P+D68Wtizxw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XT7LZrfPHQhdV4PTgYN4oESKJFKzGtcQxc0jIdagSefZjTFIcqfXwLbcddaj4NlU4
         t1I7FRWyoSWF4y+bUBPqavYj4SPvTmgjuI6iNDUL1tSYZbfonkO1SX5Vk2lEWsFLqA
         Q5IW9k/vO+vkQC7bNsi+YKffCcyNiGtntIhHRN9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xingjiang Qiao <nanpuyue@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0493/1146] hwmon: (emc2305) fix unable to probe emc2301/2/3
Date:   Wed, 28 Dec 2022 15:33:52 +0100
Message-Id: <20221228144343.573518348@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xingjiang Qiao <nanpuyue@gmail.com>

[ Upstream commit 4d50591ebf60ccf79380fff3a4c23659c61c482f ]

The definitions of 'EMC2305_REG_PRODUCT_ID' and 'EMC2305_REG_DEVICE' are
both '0xfd', they actually return the same value, but the values returned
by emc2301/2/3/5 are different, so probe emc2301/2/3 will fail, This patch
fixes that.

Signed-off-by: Xingjiang Qiao <nanpuyue@gmail.com>
Link: https://lore.kernel.org/r/20221206055331.170459-1-nanpuyue@gmail.com
Fixes: 0d8400c5a2ce1 ("hwmon: (emc2305) add support for EMC2301/2/3/5 RPM-based PWM Fan Speed Controller.")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/emc2305.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/hwmon/emc2305.c b/drivers/hwmon/emc2305.c
index aa1f25add0b6..9a78ca22541e 100644
--- a/drivers/hwmon/emc2305.c
+++ b/drivers/hwmon/emc2305.c
@@ -16,7 +16,6 @@ static const unsigned short
 emc2305_normal_i2c[] = { 0x27, 0x2c, 0x2d, 0x2e, 0x2f, 0x4c, 0x4d, I2C_CLIENT_END };
 
 #define EMC2305_REG_DRIVE_FAIL_STATUS	0x27
-#define EMC2305_REG_DEVICE		0xfd
 #define EMC2305_REG_VENDOR		0xfe
 #define EMC2305_FAN_MAX			0xff
 #define EMC2305_FAN_MIN			0x00
@@ -524,7 +523,7 @@ static int emc2305_probe(struct i2c_client *client, const struct i2c_device_id *
 	struct device *dev = &client->dev;
 	struct emc2305_data *data;
 	struct emc2305_platform_data *pdata;
-	int vendor, device;
+	int vendor;
 	int ret;
 	int i;
 
@@ -535,10 +534,6 @@ static int emc2305_probe(struct i2c_client *client, const struct i2c_device_id *
 	if (vendor != EMC2305_VENDOR)
 		return -ENODEV;
 
-	device = i2c_smbus_read_byte_data(client, EMC2305_REG_DEVICE);
-	if (device != EMC2305_DEVICE)
-		return -ENODEV;
-
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-- 
2.35.1



