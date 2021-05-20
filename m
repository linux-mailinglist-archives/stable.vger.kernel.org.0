Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1778138A5D5
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbhETKUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236292AbhETKST (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC1996145A;
        Thu, 20 May 2021 09:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504003;
        bh=60simQmftetfoxjIzV6u5ksLLVJJ11YGwYpyidAI518=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cju1TIbgVmME/2hPMxQpDILfd/R28IccXVQjFL9ofmBqmJzqZLHLtyBlYjFEMrLym
         bcgW8uUYrfMZ5REeVaG15LgWZX4GIVESedmkhnDYn23K8LRaz/FasqFAp3LeKAxTNy
         ouossBhW8h61FFvjjDf+uctVnq5AeojxEcg8uRLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 049/323] power: supply: bq27xxx: fix power_avg for newer ICs
Date:   Thu, 20 May 2021 11:19:01 +0200
Message-Id: <20210520092121.789311003@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit c4d57c22ac65bd503716062a06fad55a01569cac ]

On all newer bq27xxx ICs, the AveragePower register contains a signed
value; in addition to handling the raw value as unsigned, the driver
code also didn't convert it to µW as expected.

At least for the BQ28Z610, the reference manual incorrectly states that
the value is in units of 1mW and not 10mW. I have no way of knowing
whether the manuals of other supported ICs contain the same error, or if
there are models that actually use 1mW. At least, the new code shouldn't
be *less* correct than the old version for any device.

power_avg is removed from the cache structure, se we don't have to
extend it to store both a signed value and an error code. Always getting
an up-to-date value may be desirable anyways, as it avoids inconsistent
current and power readings when switching between charging and
discharging.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 51 ++++++++++++++------------
 include/linux/power/bq27xxx_battery.h  |  1 -
 2 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index a7d8cadf172c..3e8466064bb2 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1445,27 +1445,6 @@ static int bq27xxx_battery_read_time(struct bq27xxx_device_info *di, u8 reg)
 	return tval * 60;
 }
 
-/*
- * Read an average power register.
- * Return < 0 if something fails.
- */
-static int bq27xxx_battery_read_pwr_avg(struct bq27xxx_device_info *di)
-{
-	int tval;
-
-	tval = bq27xxx_read(di, BQ27XXX_REG_AP, false);
-	if (tval < 0) {
-		dev_err(di->dev, "error reading average power register  %02x: %d\n",
-			BQ27XXX_REG_AP, tval);
-		return tval;
-	}
-
-	if (di->opts & BQ27XXX_O_ZERO)
-		return (tval * BQ27XXX_POWER_CONSTANT) / BQ27XXX_RS;
-	else
-		return tval;
-}
-
 /*
  * Returns true if a battery over temperature condition is detected
  */
@@ -1562,8 +1541,6 @@ void bq27xxx_battery_update(struct bq27xxx_device_info *di)
 		}
 		if (di->regs[BQ27XXX_REG_CYCT] != INVALID_REG_ADDR)
 			cache.cycle_count = bq27xxx_battery_read_cyct(di);
-		if (di->regs[BQ27XXX_REG_AP] != INVALID_REG_ADDR)
-			cache.power_avg = bq27xxx_battery_read_pwr_avg(di);
 
 		/* We only have to read charge design full once */
 		if (di->charge_design_full <= 0)
@@ -1625,6 +1602,32 @@ static int bq27xxx_battery_current(struct bq27xxx_device_info *di,
 	return 0;
 }
 
+/*
+ * Get the average power in µW
+ * Return < 0 if something fails.
+ */
+static int bq27xxx_battery_pwr_avg(struct bq27xxx_device_info *di,
+				   union power_supply_propval *val)
+{
+	int power;
+
+	power = bq27xxx_read(di, BQ27XXX_REG_AP, false);
+	if (power < 0) {
+		dev_err(di->dev,
+			"error reading average power register %02x: %d\n",
+			BQ27XXX_REG_AP, power);
+		return power;
+	}
+
+	if (di->opts & BQ27XXX_O_ZERO)
+		val->intval = (power * BQ27XXX_POWER_CONSTANT) / BQ27XXX_RS;
+	else
+		/* Other gauges return a signed value in units of 10mW */
+		val->intval = (int)((s16)power) * 10000;
+
+	return 0;
+}
+
 static int bq27xxx_battery_status(struct bq27xxx_device_info *di,
 				  union power_supply_propval *val)
 {
@@ -1790,7 +1793,7 @@ static int bq27xxx_battery_get_property(struct power_supply *psy,
 		ret = bq27xxx_simple_value(di->cache.energy, val);
 		break;
 	case POWER_SUPPLY_PROP_POWER_AVG:
-		ret = bq27xxx_simple_value(di->cache.power_avg, val);
+		ret = bq27xxx_battery_pwr_avg(di, val);
 		break;
 	case POWER_SUPPLY_PROP_HEALTH:
 		ret = bq27xxx_simple_value(di->cache.health, val);
diff --git a/include/linux/power/bq27xxx_battery.h b/include/linux/power/bq27xxx_battery.h
index e6187f524f2c..534a8080c6a3 100644
--- a/include/linux/power/bq27xxx_battery.h
+++ b/include/linux/power/bq27xxx_battery.h
@@ -47,7 +47,6 @@ struct bq27xxx_reg_cache {
 	int capacity;
 	int energy;
 	int flags;
-	int power_avg;
 	int health;
 };
 
-- 
2.30.2



