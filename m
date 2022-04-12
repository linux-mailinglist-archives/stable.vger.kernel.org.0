Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0DC4FCFB3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349349AbiDLGg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349359AbiDLGgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:36:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293F035DEB;
        Mon, 11 Apr 2022 23:33:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A857D618D7;
        Tue, 12 Apr 2022 06:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0E7C385A1;
        Tue, 12 Apr 2022 06:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745222;
        bh=dvPcYCzevFs+1/jJSvQNJgim5I2zaaED6vtbihtMvF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJtn6kBxBiXse8aFfPrx61y9xU6Ite4aAo/rj8WwKiHFqKAtdoTMTzpdJO93Czx8D
         2j7+MpAA/pDq7LkC+D1ovJOSD+A0GXrEcbRWzyeGhD7lup3QMpUc1PO3/rmoSiPoLB
         vqtmh7vLS7m2rSWXwsx4f7k7roPR4inRvz5wfpcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Boger <boger@wirenboard.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/171] power: supply: axp20x_battery: properly report current when discharging
Date:   Tue, 12 Apr 2022 08:28:32 +0200
Message-Id: <20220412062928.497619703@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e84b6e4da14a..9fda98b950ba 100644
--- a/drivers/power/supply/axp20x_battery.c
+++ b/drivers/power/supply/axp20x_battery.c
@@ -185,7 +185,6 @@ static int axp20x_battery_get_prop(struct power_supply *psy,
 				   union power_supply_propval *val)
 {
 	struct axp20x_batt_ps *axp20x_batt = power_supply_get_drvdata(psy);
-	struct iio_channel *chan;
 	int ret = 0, reg, val1;
 
 	switch (psp) {
@@ -265,12 +264,12 @@ static int axp20x_battery_get_prop(struct power_supply *psy,
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
2.35.1



