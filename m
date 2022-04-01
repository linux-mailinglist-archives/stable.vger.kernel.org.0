Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448174EF381
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348167AbiDAOyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351270AbiDAOsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:48:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D9926A945;
        Fri,  1 Apr 2022 07:39:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F19A8CE2585;
        Fri,  1 Apr 2022 14:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C12C340EE;
        Fri,  1 Apr 2022 14:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823926;
        bh=Vb9jK5l2dL7OUkRHwt1xmUNIYgFrzM1D1PHHrhDfYeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECSoWF4rgFaQHV36NsXEvXhvA5r3UEjtVUsYwHda6UFMAcdie733W/lp/4OHVnNBW
         aTAJEcx1c4txpt+nWX9u0t84Dda3eXXoLVQGl08k3vXyT/HREf6RG30WyXg22YluSf
         IQaOZEIPR3vHWqsjGhLROCwnBH6pZLgiHL4/4/HfWk91F8RSre7LKgZQLfEH9zXayZ
         pza73XZB5rhIKLhm7I5FAgNN97gVLIIQP7zIn7SKI448EcpI/+bX7TabMpbQXHyuAK
         PiImuKMo0fjRaq3vBDehjjqge71hwi6EJkSEz5yOQfRJmYa3eGbnBosW4Q/C/nnJVP
         022jPNpo6azbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Boger <boger@wirenboard.com>, Chen-Yu Tsai <wens@csie.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 22/98] power: supply: axp20x_battery: properly report current when discharging
Date:   Fri,  1 Apr 2022 10:36:26 -0400
Message-Id: <20220401143742.1952163-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Boger <boger@wirenboard.com>

[ Upstream commit d4f408cdcd26921c1268cb8dcbe8ffb6faf837f3 ]

As stated in [1], negative current values are used for discharging
batteries.

AXP PMICs internally have two different ADC channels for shunt current
measurement: one used during charging and one during discharging.
The values reported by these ADCs are unsigned.
While the driver properly selects ADC channel to get the data from,
it doesn't apply negative sign when reporting discharging current.

[1] Documentation/ABI/testing/sysfs-class-power

Signed-off-by: Evgeny Boger <boger@wirenboard.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp20x_battery.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/power/supply/axp20x_battery.c b/drivers/power/supply/axp20x_battery.c
index 18a9db0df4b1..335e12cc5e2f 100644
--- a/drivers/power/supply/axp20x_battery.c
+++ b/drivers/power/supply/axp20x_battery.c
@@ -186,7 +186,6 @@ static int axp20x_battery_get_prop(struct power_supply *psy,
 				   union power_supply_propval *val)
 {
 	struct axp20x_batt_ps *axp20x_batt = power_supply_get_drvdata(psy);
-	struct iio_channel *chan;
 	int ret = 0, reg, val1;
 
 	switch (psp) {
@@ -266,12 +265,12 @@ static int axp20x_battery_get_prop(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		if (reg & AXP20X_PWR_STATUS_BAT_CHARGING)
-			chan = axp20x_batt->batt_chrg_i;
-		else
-			chan = axp20x_batt->batt_dischrg_i;
-
-		ret = iio_read_channel_processed(chan, &val->intval);
+		if (reg & AXP20X_PWR_STATUS_BAT_CHARGING) {
+			ret = iio_read_channel_processed(axp20x_batt->batt_chrg_i, &val->intval);
+		} else {
+			ret = iio_read_channel_processed(axp20x_batt->batt_dischrg_i, &val1);
+			val->intval = -val1;
+		}
 		if (ret)
 			return ret;
 
-- 
2.34.1

