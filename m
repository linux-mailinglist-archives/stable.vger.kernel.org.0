Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A775B70B3
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiIMO3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiIMO2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8466D67C99;
        Tue, 13 Sep 2022 07:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50D8C614BD;
        Tue, 13 Sep 2022 14:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF12C433C1;
        Tue, 13 Sep 2022 14:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078549;
        bh=kWaJaqfSDIHyK2Hlx0qudHzqLUGwNU3CI8gNO7RTeao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhgPZgXA2+9mToZjc8t/5mVQ5gAPK4N3/du/VjvP3BFuOTacXtEjJgdRb03lAmveW
         +ILX1eAshNTHVTSyCjnKCl3ZNjaJe2njlAyIR0vFMCbQJRsfoKeq7OqhZnvSM9K3gF
         oFNHAMflvheuBe2EC1YnUEaTuz7zSmOFW/wl7aNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Carns <mike@carns.com>,
        Eugene Shalygin <eugene.shalygin@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 183/192] hwmon: (asus-ec-sensors) add support for Maximus XI Hero
Date:   Tue, 13 Sep 2022 16:04:49 +0200
Message-Id: <20220913140419.174531488@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michael Carns <mike@carns.com>

[ Upstream commit 8f9eb10ff71d8e3beeee3f8d19050223600faf85 ]

Add definitions for ROG MAXIMUS XI HERO and ROG MAXIMUS XI HERO (WI-FI)
boards.

Signed-off-by: Michael Carns <mike@carns.com>
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20220627225437.87462-1-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 88700d1396ba ("hwmon: (asus-ec-sensors) autoload module via DMI data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/asus_ec_sensors.rst |  2 ++
 drivers/hwmon/asus-ec-sensors.c         | 36 +++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/Documentation/hwmon/asus_ec_sensors.rst b/Documentation/hwmon/asus_ec_sensors.rst
index 00d8c46ef9e04..1e40c123db777 100644
--- a/Documentation/hwmon/asus_ec_sensors.rst
+++ b/Documentation/hwmon/asus_ec_sensors.rst
@@ -13,6 +13,8 @@ Supported boards:
  * ROG CROSSHAIR VIII FORMULA
  * ROG CROSSHAIR VIII HERO
  * ROG CROSSHAIR VIII IMPACT
+ * ROG MAXIMUS XI HERO
+ * ROG MAXIMUS XI HERO (WI-FI)
  * ROG STRIX B550-E GAMING
  * ROG STRIX B550-I GAMING
  * ROG STRIX X570-E GAMING
diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 19d3ca71b3609..625c2baa35ec6 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -141,6 +141,7 @@ enum board_family {
 	family_unknown,
 	family_amd_400_series,
 	family_amd_500_series,
+	family_intel_300_series,
 	family_intel_600_series
 };
 
@@ -200,6 +201,26 @@ static const struct ec_sensor_info sensors_family_amd_500[] = {
 		EC_SENSOR("Water_Out", hwmon_temp, 1, 0x01, 0x01),
 };
 
+static const struct ec_sensor_info sensors_family_intel_300[] = {
+	[ec_sensor_temp_chipset] =
+		EC_SENSOR("Chipset", hwmon_temp, 1, 0x00, 0x3a),
+	[ec_sensor_temp_cpu] = EC_SENSOR("CPU", hwmon_temp, 1, 0x00, 0x3b),
+	[ec_sensor_temp_mb] =
+		EC_SENSOR("Motherboard", hwmon_temp, 1, 0x00, 0x3c),
+	[ec_sensor_temp_t_sensor] =
+		EC_SENSOR("T_Sensor", hwmon_temp, 1, 0x00, 0x3d),
+	[ec_sensor_temp_vrm] = EC_SENSOR("VRM", hwmon_temp, 1, 0x00, 0x3e),
+	[ec_sensor_fan_cpu_opt] =
+		EC_SENSOR("CPU_Opt", hwmon_fan, 2, 0x00, 0xb0),
+	[ec_sensor_fan_vrm_hs] = EC_SENSOR("VRM HS", hwmon_fan, 2, 0x00, 0xb2),
+	[ec_sensor_fan_water_flow] =
+		EC_SENSOR("Water_Flow", hwmon_fan, 2, 0x00, 0xbc),
+	[ec_sensor_temp_water_in] =
+		EC_SENSOR("Water_In", hwmon_temp, 1, 0x01, 0x00),
+	[ec_sensor_temp_water_out] =
+		EC_SENSOR("Water_Out", hwmon_temp, 1, 0x01, 0x01),
+};
+
 static const struct ec_sensor_info sensors_family_intel_600[] = {
 	[ec_sensor_temp_t_sensor] =
 		EC_SENSOR("T_Sensor", hwmon_temp, 1, 0x00, 0x3d),
@@ -281,6 +302,18 @@ static const struct ec_board_info board_info[] = {
 		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
 		.family = family_amd_500_series,
 	},
+	{
+		.board_names = {
+			"ROG MAXIMUS XI HERO",
+			"ROG MAXIMUS XI HERO (WI-FI)",
+		},
+		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
+			SENSOR_TEMP_T_SENSOR |
+			SENSOR_TEMP_VRM | SENSOR_SET_TEMP_WATER |
+			SENSOR_FAN_CPU_OPT | SENSOR_FAN_WATER_FLOW,
+		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+		.family = family_intel_300_series,
+	},
 	{
 		.board_names = {"ROG CROSSHAIR VIII IMPACT"},
 		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
@@ -814,6 +847,9 @@ static int __init asus_ec_probe(struct platform_device *pdev)
 	case family_amd_500_series:
 		ec_data->sensors_info = sensors_family_amd_500;
 		break;
+	case family_intel_300_series:
+		ec_data->sensors_info = sensors_family_intel_300;
+		break;
 	case family_intel_600_series:
 		ec_data->sensors_info = sensors_family_intel_600;
 		break;
-- 
2.35.1



