Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FDF4EF431
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349374AbiDAPGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349846AbiDAO6I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:58:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6379B163E3A;
        Fri,  1 Apr 2022 07:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F24E460C9B;
        Fri,  1 Apr 2022 14:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823B5C34111;
        Fri,  1 Apr 2022 14:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824309;
        bh=CdT67UIb3gW6Ey5zJJcP49xxe4aOfAQ2gK2EWJliYUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxT8qdiqxmtkm0l1oFFSC/19+NKgJvqJm0olTFo06/WEQtmQgzhDP2SrgXE9Ef87E
         SFdfRGhdw5GnuIv34Jxdl2GaXRgRKRUlH/4nt+eD25d2n9eTE6g5+czaZBxpppk3dd
         j5ix46CjUe8F/VxaSu2lGFRbWxb62vpQhIxWi0RZeY5oWKsTSVKRYFYCrQVMz7VIgc
         K7b9beiEpJgco5noh4GTeyVQAZ6rUGqsAoXy/x2ef1CFKBNYpbUKIsD4MLPRjiBEqJ
         m9YsrhQA/0Mcs1exUGh8YmwiZSKlWcK4n9gtnfs0CVIfqDEfWLFxVJGumXA0n/M4Ac
         nS9IZH8grQASw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Boger <boger@wirenboard.com>, Chen-Yu Tsai <wens@csie.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/37] power: supply: axp20x_battery: properly report current when discharging
Date:   Fri,  1 Apr 2022 10:44:18 -0400
Message-Id: <20220401144446.1954694-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144446.1954694-1-sashal@kernel.org>
References: <20220401144446.1954694-1-sashal@kernel.org>
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
2.34.1

