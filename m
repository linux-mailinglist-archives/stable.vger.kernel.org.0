Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8A65B7049
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiIMOYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbiIMOYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:24:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392965C367;
        Tue, 13 Sep 2022 07:15:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95646B80F9C;
        Tue, 13 Sep 2022 14:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2DEC433C1;
        Tue, 13 Sep 2022 14:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078547;
        bh=VY/Ay3kKE70oNyFPjlsuRy0rDmW1jBUkn3PCjS2vUyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UU5cycGm59M2ccH6F+zTk1p1yTsFKPKckVIqnCmSHXxqEjy3FxrnxgXh5GQxvHr9k
         h+f9mts2DknGvIBH0+A7Ft9F0Q73NDYLnwRsP6Rpfpp6k8Gv0oC0RpLVC6QyaAY901
         fCjNXiwF3IKXZHSGob9xteySqFiRoSAzSGp0NOAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shady Nawara <shady.nawara@outlook.com>,
        Eugene Shalygin <eugene.shalygin@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 182/192] hwmon: (asus-ec-sensors) add support for Strix Z690-a D4
Date:   Tue, 13 Sep 2022 16:04:48 +0200
Message-Id: <20220913140419.123746705@linuxfoundation.org>
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

From: Shady Nawara <shady.nawara@outlook.com>

[ Upstream commit bae26b801f98bc902ab4a43c96947f3a0ce4f3a0 ]

adds T_Sensor and VRM Temp sensors for the Asus Strix z690-a D4 motherboard

Signed-off-by: Shady Nawara <shady.nawara@outlook.com>
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20220603122758.1561064-1-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 88700d1396ba ("hwmon: (asus-ec-sensors) autoload module via DMI data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/asus_ec_sensors.rst |  1 +
 drivers/hwmon/asus-ec-sensors.c         | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/Documentation/hwmon/asus_ec_sensors.rst b/Documentation/hwmon/asus_ec_sensors.rst
index 78ca69eda8778..00d8c46ef9e04 100644
--- a/Documentation/hwmon/asus_ec_sensors.rst
+++ b/Documentation/hwmon/asus_ec_sensors.rst
@@ -19,6 +19,7 @@ Supported boards:
  * ROG STRIX X570-E GAMING WIFI II
  * ROG STRIX X570-F GAMING
  * ROG STRIX X570-I GAMING
+ * ROG STRIX Z690-A GAMING WIFI D4
 
 Authors:
     - Eugene Shalygin <eugene.shalygin@gmail.com>
diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 3633ab691662b..19d3ca71b3609 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -54,6 +54,8 @@ static char *mutex_path_override;
 /* ACPI mutex for locking access to the EC for the firmware */
 #define ASUS_HW_ACCESS_MUTEX_ASMX	"\\AMW0.ASMX"
 
+#define ASUS_HW_ACCESS_MUTEX_RMTW_ASMX	"\\RMTW.ASMX"
+
 #define MAX_IDENTICAL_BOARD_VARIATIONS	3
 
 /* Moniker for the ACPI global lock (':' is not allowed in ASL identifiers) */
@@ -139,6 +141,7 @@ enum board_family {
 	family_unknown,
 	family_amd_400_series,
 	family_amd_500_series,
+	family_intel_600_series
 };
 
 /* All the known sensors for ASUS EC controllers */
@@ -197,6 +200,12 @@ static const struct ec_sensor_info sensors_family_amd_500[] = {
 		EC_SENSOR("Water_Out", hwmon_temp, 1, 0x01, 0x01),
 };
 
+static const struct ec_sensor_info sensors_family_intel_600[] = {
+	[ec_sensor_temp_t_sensor] =
+		EC_SENSOR("T_Sensor", hwmon_temp, 1, 0x00, 0x3d),
+	[ec_sensor_temp_vrm] = EC_SENSOR("VRM", hwmon_temp, 1, 0x00, 0x3e),
+};
+
 /* Shortcuts for common combinations */
 #define SENSOR_SET_TEMP_CHIPSET_CPU_MB                                         \
 	(SENSOR_TEMP_CHIPSET | SENSOR_TEMP_CPU | SENSOR_TEMP_MB)
@@ -330,6 +339,12 @@ static const struct ec_board_info board_info[] = {
 		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
 		.family = family_amd_500_series,
 	},
+	{
+		.board_names = {"ROG STRIX Z690-A GAMING WIFI D4"},
+		.sensors = SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM,
+		.mutex_path = ASUS_HW_ACCESS_MUTEX_RMTW_ASMX,
+		.family = family_intel_600_series,
+	},
 	{}
 };
 
@@ -799,6 +814,9 @@ static int __init asus_ec_probe(struct platform_device *pdev)
 	case family_amd_500_series:
 		ec_data->sensors_info = sensors_family_amd_500;
 		break;
+	case family_intel_600_series:
+		ec_data->sensors_info = sensors_family_intel_600;
+		break;
 	default:
 		dev_err(dev, "Unknown board family: %d",
 			ec_data->board_info->family);
-- 
2.35.1



