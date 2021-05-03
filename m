Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7714371C7A
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhECQwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232410AbhECQuw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BAB961924;
        Mon,  3 May 2021 16:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060079;
        bh=4BCdbTYXuL/pPsVOok3idNTXuOc8zWZcALaGlnPFJ10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XecemRWCVSRrL9+pvIH4fIQskVNjRBr6/FlM1BD+TQLcdzFZj+vxtFB7Bhgf1zF9D
         W7B3BmgtiZLb6HsulSdomDC9TBxtYNta+y+ItTMtYxfV0JpXhemjkhMf8X826UIw4t
         i8QRG8vYviRVuzru1r7ZlxPJCU0d9NQlavwxp91LZDDTqJIeIo7eAk/GtPcvZMEa3T
         GVuNDlXZGWEIkxE76uU5n/J+4BdFd+7nSv4f0P0Razv6iY9/4omc2SHgncEgCS/BLc
         n9cIasCX+e34p1v+0pltdx86hMEVXOKo397XJHAdtWlPczhs/TmP2YZw/Gm9llBzYb
         qcaaD1WCQpzgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/35] power: supply: bq27xxx: fix power_avg for newer ICs
Date:   Mon,  3 May 2021 12:40:40 -0400
Message-Id: <20210503164109.2853838-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 93e3d9c747aa..b7dc88126866 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1490,27 +1490,6 @@ static int bq27xxx_battery_read_time(struct bq27xxx_device_info *di, u8 reg)
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
@@ -1607,8 +1586,6 @@ void bq27xxx_battery_update(struct bq27xxx_device_info *di)
 		}
 		if (di->regs[BQ27XXX_REG_CYCT] != INVALID_REG_ADDR)
 			cache.cycle_count = bq27xxx_battery_read_cyct(di);
-		if (di->regs[BQ27XXX_REG_AP] != INVALID_REG_ADDR)
-			cache.power_avg = bq27xxx_battery_read_pwr_avg(di);
 
 		/* We only have to read charge design full once */
 		if (di->charge_design_full <= 0)
@@ -1670,6 +1647,32 @@ static int bq27xxx_battery_current(struct bq27xxx_device_info *di,
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
@@ -1837,7 +1840,7 @@ static int bq27xxx_battery_get_property(struct power_supply *psy,
 		ret = bq27xxx_simple_value(di->cache.energy, val);
 		break;
 	case POWER_SUPPLY_PROP_POWER_AVG:
-		ret = bq27xxx_simple_value(di->cache.power_avg, val);
+		ret = bq27xxx_battery_pwr_avg(di, val);
 		break;
 	case POWER_SUPPLY_PROP_HEALTH:
 		ret = bq27xxx_simple_value(di->cache.health, val);
diff --git a/include/linux/power/bq27xxx_battery.h b/include/linux/power/bq27xxx_battery.h
index d6355f49fbae..13d5dd4eb40b 100644
--- a/include/linux/power/bq27xxx_battery.h
+++ b/include/linux/power/bq27xxx_battery.h
@@ -49,7 +49,6 @@ struct bq27xxx_reg_cache {
 	int capacity;
 	int energy;
 	int flags;
-	int power_avg;
 	int health;
 };
 
-- 
2.30.2

