Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4106AF48B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbjCGTRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbjCGTQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFD1E3AC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:00:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E94AB8117B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AEBC4339C;
        Tue,  7 Mar 2023 19:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215634;
        bh=aqRuBkwAdgtoAz8b/bpG/fOfY+rLWRdBiQ0551uqbTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsubyP2P/e6oZgmmIbBeuKt2Gu4CJmbUjus6Vo2MyOJlz7hBCsYzdzehWyfEb/XPs
         tqwoe1OFr4RV0027kiH8GA3ZpwTZet4my8RBSnXIJ1PmGJdD5qeO7kT+cU2D1ENtbJ
         3DUYNrLkdmmYvRqxQfVYowo3q4g4dIo4rDwDdbXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andreas Kemnade <andreas@kemnade.info>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 323/567] power: supply: remove faulty cooling logic
Date:   Tue,  7 Mar 2023 18:00:59 +0100
Message-Id: <20230307165919.888082350@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
 drivers/power/supply/power_supply_core.c | 97 ------------------------
 1 file changed, 97 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 3f9c60c5b250b..8161fad081a96 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -1014,87 +1014,6 @@ static void psy_unregister_thermal(struct power_supply *psy)
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
-	int i;
-
-	/* Register for cooling device if psy can control charging */
-	for (i = 0; i < psy->desc->num_properties; i++) {
-		if (psy->desc->properties[i] ==
-				POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT) {
-			psy->tcd = thermal_cooling_device_register(
-							(char *)psy->desc->name,
-							psy, &psy_tcd_ops);
-			return PTR_ERR_OR_ZERO(psy->tcd);
-		}
-	}
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
@@ -1104,15 +1023,6 @@ static int psy_register_thermal(struct power_supply *psy)
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
@@ -1188,10 +1098,6 @@ __power_supply_register(struct device *parent,
 	if (rc)
 		goto register_thermal_failed;
 
-	rc = psy_register_cooler(psy);
-	if (rc)
-		goto register_cooler_failed;
-
 	rc = power_supply_create_triggers(psy);
 	if (rc)
 		goto create_triggers_failed;
@@ -1221,8 +1127,6 @@ __power_supply_register(struct device *parent,
 add_hwmon_sysfs_failed:
 	power_supply_remove_triggers(psy);
 create_triggers_failed:
-	psy_unregister_cooler(psy);
-register_cooler_failed:
 	psy_unregister_thermal(psy);
 register_thermal_failed:
 wakeup_init_failed:
@@ -1374,7 +1278,6 @@ void power_supply_unregister(struct power_supply *psy)
 	sysfs_remove_link(&psy->dev.kobj, "powers");
 	power_supply_remove_hwmon_sysfs(psy);
 	power_supply_remove_triggers(psy);
-	psy_unregister_cooler(psy);
 	psy_unregister_thermal(psy);
 	device_init_wakeup(&psy->dev, false);
 	device_unregister(&psy->dev);
-- 
2.39.2



