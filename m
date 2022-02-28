Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEB94C75F0
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239216AbiB1R5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239289AbiB1RzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:55:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37B45418E;
        Mon, 28 Feb 2022 09:44:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AADBB815C6;
        Mon, 28 Feb 2022 17:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA744C36AEB;
        Mon, 28 Feb 2022 17:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070278;
        bh=DYAZNilmD8cCnmy4h4SXlX7Bd/ZLe909alZgUubnF3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcvaMB6Kl2zg0I2hr2c3bewED4g78M36ZKYZbbJbWiY8uTTy6TPo47yacXNk2C5TI
         UkMkJi/bvpUxQJ4IM83cFUgDFpy216jNgDQTpIYHY8WfSj3tOrWEZcdK1yBcOgHxji
         ixIF1pFXG6MfyfKFuCdhDYbFmhPwCW00UtZhuKnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.16 049/164] hwmon: Handle failure to register sensor with thermal zone correctly
Date:   Mon, 28 Feb 2022 18:23:31 +0100
Message-Id: <20220228172404.661831798@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 1b5f517cca36292076d9e38fa6e33a257703e62e upstream.

If an attempt is made to a sensor with a thermal zone and it fails,
the call to devm_thermal_zone_of_sensor_register() may return -ENODEV.
This may result in crashes similar to the following.

Unable to handle kernel NULL pointer dereference at virtual address 00000000000003cd
...
Internal error: Oops: 96000021 [#1] PREEMPT SMP
...
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : mutex_lock+0x18/0x60
lr : thermal_zone_device_update+0x40/0x2e0
sp : ffff800014c4fc60
x29: ffff800014c4fc60 x28: ffff365ee3f6e000 x27: ffffdde218426790
x26: ffff365ee3f6e000 x25: 0000000000000000 x24: ffff365ee3f6e000
x23: ffffdde218426870 x22: ffff365ee3f6e000 x21: 00000000000003cd
x20: ffff365ee8bf3308 x19: ffffffffffffffed x18: 0000000000000000
x17: ffffdde21842689c x16: ffffdde1cb7a0b7c x15: 0000000000000040
x14: ffffdde21a4889a0 x13: 0000000000000228 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
x8 : 0000000001120000 x7 : 0000000000000001 x6 : 0000000000000000
x5 : 0068000878e20f07 x4 : 0000000000000000 x3 : 00000000000003cd
x2 : ffff365ee3f6e000 x1 : 0000000000000000 x0 : 00000000000003cd
Call trace:
 mutex_lock+0x18/0x60
 hwmon_notify_event+0xfc/0x110
 0xffffdde1cb7a0a90
 0xffffdde1cb7a0b7c
 irq_thread_fn+0x2c/0xa0
 irq_thread+0x134/0x240
 kthread+0x178/0x190
 ret_from_fork+0x10/0x20
Code: d503201f d503201f d2800001 aa0103e4 (c8e47c02)

Jon Hunter reports that the exact call sequence is:

hwmon_notify_event()
  --> hwmon_thermal_notify()
    --> thermal_zone_device_update()
      --> update_temperature()
        --> mutex_lock()

The hwmon core needs to handle all errors returned from calls
to devm_thermal_zone_of_sensor_register(). If the call fails
with -ENODEV, report that the sensor was not attached to a
thermal zone  but continue to register the hwmon device.

Reported-by: Jon Hunter <jonathanh@nvidia.com>
Cc: Dmitry Osipenko <digetx@gmail.com>
Fixes: 1597b374af222 ("hwmon: Add notification support")
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/hwmon.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -214,12 +214,14 @@ static int hwmon_thermal_add_sensor(stru
 
 	tzd = devm_thermal_zone_of_sensor_register(dev, index, tdata,
 						   &hwmon_thermal_ops);
-	/*
-	 * If CONFIG_THERMAL_OF is disabled, this returns -ENODEV,
-	 * so ignore that error but forward any other error.
-	 */
-	if (IS_ERR(tzd) && (PTR_ERR(tzd) != -ENODEV))
-		return PTR_ERR(tzd);
+	if (IS_ERR(tzd)) {
+		if (PTR_ERR(tzd) != -ENODEV)
+			return PTR_ERR(tzd);
+		dev_info(dev, "temp%d_input not attached to any thermal zone\n",
+			 index + 1);
+		devm_kfree(dev, tdata);
+		return 0;
+	}
 
 	err = devm_add_action(dev, hwmon_thermal_remove_sensor, &tdata->node);
 	if (err)


