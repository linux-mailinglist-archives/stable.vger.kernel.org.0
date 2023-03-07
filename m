Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1B86AEAEB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbjCGRim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbjCGRiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:38:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356729384B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:34:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D12AD6150D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF3EC433EF;
        Tue,  7 Mar 2023 17:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210446;
        bh=g9QSuZ+8Y6IfhM51GN+41xFOHUoR7jR8N2hZQOUwEwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oeNt5QnWpi4koppQDVNdey5z3zc83wyxCbRTQXT5us8BX6X0efXhvs6kpnGU6WPwA
         /3yDKO5MJrkQG7nC09JBWFndNV5e4cJS05A59cbBMu8aU32uSX1uoLtOVXk0ATALwq
         YBzRw6hjg1t9O+3b+UqXMYag4H/8X6OxqjmNbtuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andreas Kemnade <andreas@kemnade.info>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0543/1001] power: supply: remove faulty cooling logic
Date:   Tue,  7 Mar 2023 17:55:15 +0100
Message-Id: <20230307170045.023091579@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit c85c191694cb1cf290b11059b3d2de8a2732ffd0 ]

The rn5t618 power driver fails to register
a cooling device because POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX
is missing but availability is not checked before registering
cooling device. After improved error checking in the thermal
code, the registration of the power supply fails entirely.

Checking for availability of _MAX before registering cooling device
fixes the rn5t618 problem. But the whole logic feels questionable.

First, the logic is inverted here:
the code tells: max_current = max_cooling but
0 = max_cooling, so there needs to be some inversion
in the code which cannot be found. Comparing with other
cooling devices, it can be found that value for fan speed is not
inverted, value for cpufreq cooling is inverted (similar situation
as here lowest frequency = max cooling)

Second, analyzing usage of _MAX: it is seems that maximum capabilities
of charging controller are specified and not of the battery. Probably
there is not too much mismatch in the drivers actually implementing
that. So nothing has exploded yet.  So there is no easy and safe way
to specifify a max cooling value now.

Conclusion for now (as a regression fix) just remove the cooling device
registration and do it properly later on.

Fixes: e49a1e1ee078 ("thermal/core: fix error code in __thermal_cooling_device_register()")
Fixes: 952aeeb3ee28 ("power_supply: Register power supply for thermal cooling device")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 93 ------------------------
 1 file changed, 93 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 7c790c41e2fe3..cc5b2e22b42ac 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -1186,83 +1186,6 @@ static void psy_unregister_thermal(struct power_supply *psy)
 	thermal_zone_device_unregister(psy->tzd);
 }
 
-/* thermal cooling device callbacks */
-static int ps_get_max_charge_cntl_limit(struct thermal_cooling_device *tcd,
-					unsigned long *state)
-{
-	struct power_supply *psy;
-	union power_supply_propval val;
-	int ret;
-
-	psy = tcd->devdata;
-	ret = power_supply_get_property(psy,
-			POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX, &val);
-	if (ret)
-		return ret;
-
-	*state = val.intval;
-
-	return ret;
-}
-
-static int ps_get_cur_charge_cntl_limit(struct thermal_cooling_device *tcd,
-					unsigned long *state)
-{
-	struct power_supply *psy;
-	union power_supply_propval val;
-	int ret;
-
-	psy = tcd->devdata;
-	ret = power_supply_get_property(psy,
-			POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT, &val);
-	if (ret)
-		return ret;
-
-	*state = val.intval;
-
-	return ret;
-}
-
-static int ps_set_cur_charge_cntl_limit(struct thermal_cooling_device *tcd,
-					unsigned long state)
-{
-	struct power_supply *psy;
-	union power_supply_propval val;
-	int ret;
-
-	psy = tcd->devdata;
-	val.intval = state;
-	ret = psy->desc->set_property(psy,
-		POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT, &val);
-
-	return ret;
-}
-
-static const struct thermal_cooling_device_ops psy_tcd_ops = {
-	.get_max_state = ps_get_max_charge_cntl_limit,
-	.get_cur_state = ps_get_cur_charge_cntl_limit,
-	.set_cur_state = ps_set_cur_charge_cntl_limit,
-};
-
-static int psy_register_cooler(struct power_supply *psy)
-{
-	/* Register for cooling device if psy can control charging */
-	if (psy_has_property(psy->desc, POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT)) {
-		psy->tcd = thermal_cooling_device_register(
-			(char *)psy->desc->name,
-			psy, &psy_tcd_ops);
-		return PTR_ERR_OR_ZERO(psy->tcd);
-	}
-
-	return 0;
-}
-
-static void psy_unregister_cooler(struct power_supply *psy)
-{
-	if (IS_ERR_OR_NULL(psy->tcd))
-		return;
-	thermal_cooling_device_unregister(psy->tcd);
-}
 #else
 static int psy_register_thermal(struct power_supply *psy)
 {
@@ -1272,15 +1195,6 @@ static int psy_register_thermal(struct power_supply *psy)
 static void psy_unregister_thermal(struct power_supply *psy)
 {
 }
-
-static int psy_register_cooler(struct power_supply *psy)
-{
-	return 0;
-}
-
-static void psy_unregister_cooler(struct power_supply *psy)
-{
-}
 #endif
 
 static struct power_supply *__must_check
@@ -1354,10 +1268,6 @@ __power_supply_register(struct device *parent,
 	if (rc)
 		goto register_thermal_failed;
 
-	rc = psy_register_cooler(psy);
-	if (rc)
-		goto register_cooler_failed;
-
 	rc = power_supply_create_triggers(psy);
 	if (rc)
 		goto create_triggers_failed;
@@ -1387,8 +1297,6 @@ __power_supply_register(struct device *parent,
 add_hwmon_sysfs_failed:
 	power_supply_remove_triggers(psy);
 create_triggers_failed:
-	psy_unregister_cooler(psy);
-register_cooler_failed:
 	psy_unregister_thermal(psy);
 register_thermal_failed:
 wakeup_init_failed:
@@ -1540,7 +1448,6 @@ void power_supply_unregister(struct power_supply *psy)
 	sysfs_remove_link(&psy->dev.kobj, "powers");
 	power_supply_remove_hwmon_sysfs(psy);
 	power_supply_remove_triggers(psy);
-	psy_unregister_cooler(psy);
 	psy_unregister_thermal(psy);
 	device_init_wakeup(&psy->dev, false);
 	device_unregister(&psy->dev);
-- 
2.39.2



