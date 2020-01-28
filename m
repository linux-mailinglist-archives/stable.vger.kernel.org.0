Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D4414BC05
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgA1Oum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgA1N6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 08:58:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A61AD2173E;
        Tue, 28 Jan 2020 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580219931;
        bh=SFR2d31pGBWYC5sDAQbVOFXbyWhqJ2hBoTVTx7MidMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3eXcurjfp7sYcj0xwaUDV5P4Ey4Zk4cHVTjwYEB5/q/4rsmiNNlw5/T20bet2FWw
         mRMnNZ8t9p1fb25dUXz/BxKulI0sqOlzjfkwLnB6KGilJSG3rv9SKrY/zPEy0AC7TO
         wBDLjVe8UzPUH9v1u2YT5ZCbhgC2MV0ZFzbfGXy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 18/46] hwmon: Deal with errors from the thermal subsystem
Date:   Tue, 28 Jan 2020 14:57:52 +0100
Message-Id: <20200128135752.300771628@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135749.822297911@linuxfoundation.org>
References: <20200128135749.822297911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 47c332deb8e89f6c59b0bb2615945c6e7fad1a60 upstream.

If the thermal subsystem returne -EPROBE_DEFER or any other error
when hwmon calls devm_thermal_zone_of_sensor_register(), this is
silently ignored.

I ran into this with an incorrectly defined thermal zone, making
it non-existing and thus this call failed with -EPROBE_DEFER
assuming it would appear later. The sensor was still added
which is incorrect: sensors must strictly be added after the
thermal zones, so deferred probe must be respected.

Fixes: d560168b5d0f ("hwmon: (core) New hwmon registration API")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/hwmon.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -143,6 +143,7 @@ static int hwmon_thermal_add_sensor(stru
 				    struct hwmon_device *hwdev, int index)
 {
 	struct hwmon_thermal_data *tdata;
+	struct thermal_zone_device *tzd;
 
 	tdata = devm_kzalloc(dev, sizeof(*tdata), GFP_KERNEL);
 	if (!tdata)
@@ -151,8 +152,14 @@ static int hwmon_thermal_add_sensor(stru
 	tdata->hwdev = hwdev;
 	tdata->index = index;
 
-	devm_thermal_zone_of_sensor_register(&hwdev->dev, index, tdata,
-					     &hwmon_thermal_ops);
+	tzd = devm_thermal_zone_of_sensor_register(&hwdev->dev, index, tdata,
+						   &hwmon_thermal_ops);
+	/*
+	 * If CONFIG_THERMAL_OF is disabled, this returns -ENODEV,
+	 * so ignore that error but forward any other error.
+	 */
+	if (IS_ERR(tzd) && (PTR_ERR(tzd) != -ENODEV))
+		return PTR_ERR(tzd);
 
 	return 0;
 }
@@ -621,14 +628,20 @@ __hwmon_device_register(struct device *d
 				if (!chip->ops->is_visible(drvdata, hwmon_temp,
 							   hwmon_temp_input, j))
 					continue;
-				if (info[i]->config[j] & HWMON_T_INPUT)
-					hwmon_thermal_add_sensor(dev, hwdev, j);
+				if (info[i]->config[j] & HWMON_T_INPUT) {
+					err = hwmon_thermal_add_sensor(dev,
+								hwdev, j);
+					if (err)
+						goto free_device;
+				}
 			}
 		}
 	}
 
 	return hdev;
 
+free_device:
+	device_unregister(hdev);
 free_hwmon:
 	kfree(hwdev);
 ida_remove:


