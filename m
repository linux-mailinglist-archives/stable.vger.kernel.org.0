Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FD237C925
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238326AbhELQPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237117AbhELQIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:08:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7601A61D1C;
        Wed, 12 May 2021 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833923;
        bh=g+Ve+Jsgli8CEVaZcP9VDknhoulY1TncyOd7deDURT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbovujqPeXBgFI1zjW2vuNYxyru2FJJ/emOrFHFNfYzTuOmcIFYohOTwoUJfM0K/I
         ReVbcOQfSMtGXKFCu1PVAho5kG90mvRsjQ9tiDlatiS1zFl5mtaa7bFPuoLjtnytEd
         0uUri2jfiIzadzXXourtihxuwK72wgWeIo9EHoCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ricardo Rivera-Matos <r-rivera-matos@ti.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 343/601] power: supply: bq25980: Move props from battery node
Date:   Wed, 12 May 2021 16:47:00 +0200
Message-Id: <20210512144839.093420743@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Rivera-Matos <r-rivera-matos@ti.com>

[ Upstream commit 04722cec1436c732d39153ce6ae2ebf71ac3ade7 ]

Currently POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT and
POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE are exposed on
the battery node and this is incorrect.

This patch exposes both of them on the charger node rather
than the battery node.

Fixes: 5069185fc18e ("power: supply: bq25980: Add support for the BQ259xx family")
Signed-off-by: Ricardo Rivera-Matos <r-rivera-matos@ti.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq25980_charger.c | 40 ++++++++------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/power/supply/bq25980_charger.c b/drivers/power/supply/bq25980_charger.c
index c936f311eb4f..b94ecf814e43 100644
--- a/drivers/power/supply/bq25980_charger.c
+++ b/drivers/power/supply/bq25980_charger.c
@@ -606,33 +606,6 @@ static int bq25980_get_state(struct bq25980_device *bq,
 	return 0;
 }
 
-static int bq25980_set_battery_property(struct power_supply *psy,
-				enum power_supply_property psp,
-				const union power_supply_propval *val)
-{
-	struct bq25980_device *bq = power_supply_get_drvdata(psy);
-	int ret = 0;
-
-	switch (psp) {
-	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
-		ret = bq25980_set_const_charge_curr(bq, val->intval);
-		if (ret)
-			return ret;
-		break;
-
-	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
-		ret = bq25980_set_const_charge_volt(bq, val->intval);
-		if (ret)
-			return ret;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	return ret;
-}
-
 static int bq25980_get_battery_property(struct power_supply *psy,
 				enum power_supply_property psp,
 				union power_supply_propval *val)
@@ -701,6 +674,18 @@ static int bq25980_set_charger_property(struct power_supply *psy,
 			return ret;
 		break;
 
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
+		ret = bq25980_set_const_charge_curr(bq, val->intval);
+		if (ret)
+			return ret;
+		break;
+
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
+		ret = bq25980_set_const_charge_volt(bq, val->intval);
+		if (ret)
+			return ret;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -922,7 +907,6 @@ static struct power_supply_desc bq25980_battery_desc = {
 	.name			= "bq25980-battery",
 	.type			= POWER_SUPPLY_TYPE_BATTERY,
 	.get_property		= bq25980_get_battery_property,
-	.set_property		= bq25980_set_battery_property,
 	.properties		= bq25980_battery_props,
 	.num_properties		= ARRAY_SIZE(bq25980_battery_props),
 	.property_is_writeable	= bq25980_property_is_writeable,
-- 
2.30.2



