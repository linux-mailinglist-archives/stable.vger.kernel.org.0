Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728535EBA65
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 08:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiI0GPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 02:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiI0GPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 02:15:12 -0400
Received: from comms.puri.sm (comms.puri.sm [159.203.221.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1649B7DA;
        Mon, 26 Sep 2022 23:15:09 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 9D9EFDFB07;
        Mon, 26 Sep 2022 23:15:08 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id S77rVG9D9b_h; Mon, 26 Sep 2022 23:15:07 -0700 (PDT)
From:   Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=puri.sm; s=comms;
        t=1664259307; bh=q0lLN8fy8Pt559Gj7K8t+/crEZ4o049mXfWGL1MvNZo=;
        h=From:To:Cc:Subject:Date:From;
        b=FpoCWRm8MeuqaeGBu27oCW7n7vVue8Ms6zVCOLlH8DbB13uj+CvElpZtjoGLSXWO2
         jDU0uPUKF5HUaTC5nKRZekFg7P53py3vLwtZjb2SMDDJUD266+cJvMy66v3r5L8924
         Cd/qD92oEdaRfwAJPPg4tIUyLAcQlFxegfIk7Kje4GEu3bFanKDuXSI/hFm4q5+xMn
         Pc4AUps2Uc/jKnnqHsRZdDqUm4BNjb0htrKLIGoJVvWEo4JMobndyrFtXpJp7dCw+Z
         hxiIY4BrCAlG5t94QM63faMgzzP0sjk9Tl9HHMsM3tnOAUYh+VVm75mpHqWv/EO7aP
         S5TddHAU1OrWQ==
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org
Cc:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        linux-kernel@vger.kernel.org, kernel@puri.sm,
        stable@vger.kernel.org
Subject: [PATCH v3 RESEND] thermal: qoriq: Only enable sites that actually exist
Date:   Tue, 27 Sep 2022 08:15:01 +0200
Message-ID: <7115709.31r3eYUQgx@pliszka>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On i.MX8MQ, enabling monitoring sites that aren't connected to anything
can cause unwanted side effects on some units. This seems to happen
once some of these sites report out-of-range readings and results in
sensor misbehavior, such as thermal zone readings getting stuck or even
suddenly reporting an impossibly high value, triggering emergency
shutdowns.

The datasheet lists all non-existent sites as "reserved" and doesn't
make any guarantees about being able to enable them at all, so let's
not do that. Instead, iterate over sensor DT nodes and only enable
monitoring sites that are specified there prior to registering their
thermal zones. This still fixes the issue with bogus data being
reported on the first reading, but doesn't introduce problems that
come with reading from non-existent sites.

Fixes: 45038e03d633 ("thermal: qoriq: Enable all sensors before registering them")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
---
Resent <20220321170852.654094-1-sebastian.krzyszkowiak@puri.sm>
v3: add cc: stable
v2: augment the commit message with details on what the patch is doing
---
 drivers/thermal/qoriq_thermal.c | 63 ++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 20 deletions(-)

diff --git a/drivers/thermal/qoriq_thermal.c b/drivers/thermal/qoriq_thermal.c
index 73049f9bea25..ef0848849ee2 100644
--- a/drivers/thermal/qoriq_thermal.c
+++ b/drivers/thermal/qoriq_thermal.c
@@ -32,7 +32,6 @@
 #define TMR_DISABLE	0x0
 #define TMR_ME		0x80000000
 #define TMR_ALPF	0x0c000000
-#define TMR_MSITE_ALL	GENMASK(15, 0)
 
 #define REGS_TMTMIR	0x008	/* Temperature measurement interval Register */
 #define TMTMIR_DEFAULT	0x0000000f
@@ -129,33 +128,51 @@ static const struct thermal_zone_of_device_ops tmu_tz_ops = {
 static int qoriq_tmu_register_tmu_zone(struct device *dev,
 				       struct qoriq_tmu_data *qdata)
 {
-	int id;
+	int ret = 0;
+	struct device_node *np, *child, *sensor_np;
 
-	if (qdata->ver == TMU_VER1) {
-		regmap_write(qdata->regmap, REGS_TMR,
-			     TMR_MSITE_ALL | TMR_ME | TMR_ALPF);
-	} else {
-		regmap_write(qdata->regmap, REGS_V2_TMSR, TMR_MSITE_ALL);
-		regmap_write(qdata->regmap, REGS_TMR, TMR_ME | TMR_ALPF_V2);
-	}
+	np = of_find_node_by_name(NULL, "thermal-zones");
+	if (!np)
+		return -ENODEV;
+
+	sensor_np = of_node_get(dev->of_node);
 
-	for (id = 0; id < SITES_MAX; id++) {
+	for_each_available_child_of_node(np, child) {
 		struct thermal_zone_device *tzd;
-		struct qoriq_sensor *sensor = &qdata->sensor[id];
-		int ret;
+		struct qoriq_sensor *sensor;
+		int id, site;
+
+		ret = thermal_zone_of_get_sensor_id(child, sensor_np, &id);
+
+		if (ret < 0) {
+			dev_err(dev, "failed to get valid sensor id: %d\n", ret);
+			of_node_put(child);
+			break;
+		}
 
+		sensor = &qdata->sensor[id];
 		sensor->id = id;
 
+		/* Enable monitoring */
+		if (qdata->ver == TMU_VER1) {
+			site = 0x1 << (15 - id);
+			regmap_update_bits(qdata->regmap, REGS_TMR,
+					   site | TMR_ME | TMR_ALPF,
+					   site | TMR_ME | TMR_ALPF);
+		} else {
+			site = 0x1 << id;
+			regmap_update_bits(qdata->regmap, REGS_V2_TMSR, site, site);
+			regmap_write(qdata->regmap, REGS_TMR, TMR_ME | TMR_ALPF_V2);
+		}
+
 		tzd = devm_thermal_zone_of_sensor_register(dev, id,
 							   sensor,
 							   &tmu_tz_ops);
-		ret = PTR_ERR_OR_ZERO(tzd);
-		if (ret) {
-			if (ret == -ENODEV)
-				continue;
-
-			regmap_write(qdata->regmap, REGS_TMR, TMR_DISABLE);
-			return ret;
+		if (IS_ERR(tzd)) {
+			ret = PTR_ERR(tzd);
+			dev_err(dev, "failed to register thermal zone: %d\n", ret);
+			of_node_put(child);
+			break;
 		}
 
 		if (devm_thermal_add_hwmon_sysfs(tzd))
@@ -164,7 +181,13 @@ static int qoriq_tmu_register_tmu_zone(struct device *dev,
 
 	}
 
-	return 0;
+	of_node_put(sensor_np);
+	of_node_put(np);
+
+	if (ret)
+		regmap_write(qdata->regmap, REGS_TMR, TMR_DISABLE);
+
+	return ret;
 }
 
 static int qoriq_tmu_calibration(struct device *dev,
-- 
2.35.1


