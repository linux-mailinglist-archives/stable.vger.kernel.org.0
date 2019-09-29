Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23DDEC186A
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbfI2RnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbfI2Rbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:31:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6208221D71;
        Sun, 29 Sep 2019 17:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778303;
        bh=IMFn1tzxwb26dMf9wGqGPU6excEbDGy+Ynd8rhWb8Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQBCfKWWfKLDeFRBW58iECTh2eMdyjKU0NpYkBFRQ5t5M9CIOP4eINrWF1NxRb/wu
         H67JCkHIGjdw3SAwaN60QlBUftz+IomCETtBIKrrv4Ty4y8J+Qed9Wsoub8Uxj8wWw
         ga3igSLJG4eCbCmWz/gr91gNCh9DPqpiSjHGDeQQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Romain Izard <romain.izard.pro@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 23/49] power: supply: register HWMON devices with valid names
Date:   Sun, 29 Sep 2019 13:30:23 -0400
Message-Id: <20190929173053.8400-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173053.8400-1-sashal@kernel.org>
References: <20190929173053.8400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Romain Izard <romain.izard.pro@gmail.com>

[ Upstream commit f1b937cc86bedf94dbc3478c2c0dc79471081fff ]

With the introduction of the HWMON compatibility layer to the power
supply framework in Linux 5.3, all power supply devices' names can be
used directly to create HWMON devices with the same names.

But HWMON has rules on allowable names that are different from those
used in the power supply framework. The dash character is forbidden, as
it is used by the libsensors library in userspace as a separator,
whereas this character is used in the device names in more than half of
the existing power supply drivers. This last case is consistent with the
typical naming usage with MFD and Device Tree.

This leads to warnings in the kernel log, with the format:

power_supply gpio-charger: hwmon: \
	'gpio-charger' is not a valid name attribute, please fix

Add a protection to power_supply_add_hwmon_sysfs() that replaces any
dash in the device name with an underscore when registering with the
HWMON framework. Other forbidden characters (star, slash, space, tab,
newline) are not replaced, as they are not in common use.

Fixes: e67d4dfc9ff1 ("power: supply: Add HWMON compatibility layer")
Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_hwmon.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/power_supply_hwmon.c b/drivers/power/supply/power_supply_hwmon.c
index 51fe60440d125..75cf861ba492d 100644
--- a/drivers/power/supply/power_supply_hwmon.c
+++ b/drivers/power/supply/power_supply_hwmon.c
@@ -284,6 +284,7 @@ int power_supply_add_hwmon_sysfs(struct power_supply *psy)
 	struct device *dev = &psy->dev;
 	struct device *hwmon;
 	int ret, i;
+	const char *name;
 
 	if (!devres_open_group(dev, power_supply_add_hwmon_sysfs,
 			       GFP_KERNEL))
@@ -334,7 +335,19 @@ int power_supply_add_hwmon_sysfs(struct power_supply *psy)
 		}
 	}
 
-	hwmon = devm_hwmon_device_register_with_info(dev, psy->desc->name,
+	name = psy->desc->name;
+	if (strchr(name, '-')) {
+		char *new_name;
+
+		new_name = devm_kstrdup(dev, name, GFP_KERNEL);
+		if (!new_name) {
+			ret = -ENOMEM;
+			goto error;
+		}
+		strreplace(new_name, '-', '_');
+		name = new_name;
+	}
+	hwmon = devm_hwmon_device_register_with_info(dev, name,
 						psyhw,
 						&power_supply_hwmon_chip_info,
 						NULL);
-- 
2.20.1

