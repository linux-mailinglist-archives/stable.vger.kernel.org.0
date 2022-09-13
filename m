Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699825B70AE
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbiIMOaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiIMO3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:29:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB17A696FF;
        Tue, 13 Sep 2022 07:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C7EB6149A;
        Tue, 13 Sep 2022 14:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73206C433D7;
        Tue, 13 Sep 2022 14:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078592;
        bh=ENouexZvMZz2LWeBSlXkzrdEVXOoJSTcJNW2ZxjBsjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJT8Pg3Vpv3VQFaYtOeS9k6ND4vUdHWqEpD+UKe5EQsCzZWcmjUpOwPkm9JerkpLm
         aGHugAqdKkbdjfAM3E1yPlWkWJ39GMdC68LxOWvUe4yrNXuw4NaZks1J7d0qUsal5Y
         UqTCrT7woH40U9duABxp/kS3MuxxyetGlG+WgqOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugene Shalygin <eugene.shalygin@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 186/192] hwmon: (asus-ec-sensors) autoload module via DMI data
Date:   Tue, 13 Sep 2022 16:04:52 +0200
Message-Id: <20220913140419.327640102@linuxfoundation.org>
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

From: Eugene Shalygin <eugene.shalygin@gmail.com>

[ Upstream commit 88700d1396bae72d9a4c23a48bbd98c1c2f53f3d ]

Replace autoloading data based on the ACPI EC device with the DMI
records for motherboards models. The ACPI method created a bug that when
this driver returns error from the probe function because of the
unsupported motherboard model, the ACPI subsystem concludes
that the EC device does not work properly.

Fixes: 5cd29012028d ("hwmon: (asus-ec-sensors) introduce ec_board_info struct for board data")
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=216412
Bug: https://bugzilla.redhat.com/show_bug.cgi?id=2121844
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20220909155654.123398-2-eugene.shalygin@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 408 +++++++++++++++++---------------
 1 file changed, 222 insertions(+), 186 deletions(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 61a4684fc020e..81e688975c6a7 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -266,9 +266,7 @@ static const struct ec_sensor_info sensors_family_intel_600[] = {
 #define SENSOR_SET_WATER_BLOCK                                                 \
 	(SENSOR_TEMP_WATER_BLOCK_IN | SENSOR_TEMP_WATER_BLOCK_OUT)
 
-
 struct ec_board_info {
-	const char *board_names[MAX_IDENTICAL_BOARD_VARIATIONS];
 	unsigned long sensors;
 	/*
 	 * Defines which mutex to use for guarding access to the state and the
@@ -281,152 +279,194 @@ struct ec_board_info {
 	enum board_family family;
 };
 
-static const struct ec_board_info board_info[] = {
-	{
-		.board_names = {"PRIME X470-PRO"},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-			SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
-			SENSOR_FAN_CPU_OPT |
-			SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
-		.mutex_path = ACPI_GLOBAL_LOCK_PSEUDO_PATH,
-		.family = family_amd_400_series,
-	},
-	{
-		.board_names = {"PRIME X570-PRO"},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB | SENSOR_TEMP_VRM |
-			SENSOR_TEMP_T_SENSOR | SENSOR_FAN_CHIPSET,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-		.family = family_amd_500_series,
-	},
-	{
-		.board_names = {"ProArt X570-CREATOR WIFI"},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB | SENSOR_TEMP_VRM |
-			SENSOR_TEMP_T_SENSOR | SENSOR_FAN_CPU_OPT |
-			SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
-	},
-	{
-		.board_names = {"Pro WS X570-ACE"},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB | SENSOR_TEMP_VRM |
-			SENSOR_TEMP_T_SENSOR | SENSOR_FAN_CHIPSET |
-			SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-		.family = family_amd_500_series,
-	},
-	{
-		.board_names = {"ROG CROSSHAIR VIII DARK HERO"},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-			SENSOR_TEMP_T_SENSOR |
-			SENSOR_TEMP_VRM | SENSOR_SET_TEMP_WATER |
-			SENSOR_FAN_CPU_OPT | SENSOR_FAN_WATER_FLOW |
-			SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-		.family = family_amd_500_series,
-	},
-	{
-		.board_names = {
-			"ROG CROSSHAIR VIII FORMULA",
-			"ROG CROSSHAIR VIII HERO",
-			"ROG CROSSHAIR VIII HERO (WI-FI)",
-		},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-			SENSOR_TEMP_T_SENSOR |
-			SENSOR_TEMP_VRM | SENSOR_SET_TEMP_WATER |
-			SENSOR_FAN_CPU_OPT | SENSOR_FAN_CHIPSET |
-			SENSOR_FAN_WATER_FLOW | SENSOR_CURR_CPU |
-			SENSOR_IN_CPU_CORE,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-		.family = family_amd_500_series,
-	},
-	{
-		.board_names = {
-			"ROG MAXIMUS XI HERO",
-			"ROG MAXIMUS XI HERO (WI-FI)",
-		},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-			SENSOR_TEMP_T_SENSOR |
-			SENSOR_TEMP_VRM | SENSOR_SET_TEMP_WATER |
-			SENSOR_FAN_CPU_OPT | SENSOR_FAN_WATER_FLOW,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-		.family = family_intel_300_series,
-	},
-	{
-		.board_names = {"ROG CROSSHAIR VIII IMPACT"},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-			SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
-			SENSOR_FAN_CHIPSET | SENSOR_CURR_CPU |
-			SENSOR_IN_CPU_CORE,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-		.family = family_amd_500_series,
-	},
-	{
-		.board_names = {"ROG STRIX B550-E GAMING"},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-			SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
-			SENSOR_FAN_CPU_OPT,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-		.family = family_amd_500_series,
-	},
-	{
-		.board_names = {"ROG STRIX B550-I GAMING"},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-			SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
-			SENSOR_FAN_VRM_HS | SENSOR_CURR_CPU |
-			SENSOR_IN_CPU_CORE,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-		.family = family_amd_500_series,
-	},
-	{
-		.board_names = {"ROG STRIX X570-E GAMING"},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-			SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
-			SENSOR_FAN_CHIPSET | SENSOR_CURR_CPU |
-			SENSOR_IN_CPU_CORE,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-		.family = family_amd_500_series,
-	},
-	{
-		.board_names = {"ROG STRIX X570-E GAMING WIFI II"},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-			SENSOR_TEMP_T_SENSOR | SENSOR_CURR_CPU |
-			SENSOR_IN_CPU_CORE,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-		.family = family_amd_500_series,
-	},
-	{
-		.board_names = {"ROG STRIX X570-F GAMING"},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
-			SENSOR_TEMP_T_SENSOR | SENSOR_FAN_CHIPSET,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-		.family = family_amd_500_series,
-	},
-	{
-		.board_names = {"ROG STRIX X570-I GAMING"},
-		.sensors = SENSOR_TEMP_CHIPSET | SENSOR_TEMP_VRM |
-			SENSOR_TEMP_T_SENSOR |
-			SENSOR_FAN_VRM_HS | SENSOR_FAN_CHIPSET |
-			SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
-		.family = family_amd_500_series,
-	},
-	{
-		.board_names = {"ROG STRIX Z690-A GAMING WIFI D4"},
-		.sensors = SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_RMTW_ASMX,
-		.family = family_intel_600_series,
-	},
-	{
-		.board_names = {"ROG ZENITH II EXTREME"},
-		.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB | SENSOR_TEMP_T_SENSOR |
-			SENSOR_TEMP_VRM | SENSOR_SET_TEMP_WATER |
-			SENSOR_FAN_CPU_OPT | SENSOR_FAN_CHIPSET | SENSOR_FAN_VRM_HS |
-			SENSOR_FAN_WATER_FLOW | SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE |
-			SENSOR_SET_WATER_BLOCK |
-			SENSOR_TEMP_T_SENSOR_2 | SENSOR_TEMP_SENSOR_EXTRA_1 |
-			SENSOR_TEMP_SENSOR_EXTRA_2 | SENSOR_TEMP_SENSOR_EXTRA_3,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0,
-		.family = family_amd_500_series,
-	},
-	{}
+static const struct ec_board_info board_info_prime_x470_pro = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
+		SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
+		SENSOR_FAN_CPU_OPT |
+		SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
+	.mutex_path = ACPI_GLOBAL_LOCK_PSEUDO_PATH,
+	.family = family_amd_400_series,
+};
+
+static const struct ec_board_info board_info_prime_x570_pro = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB | SENSOR_TEMP_VRM |
+		SENSOR_TEMP_T_SENSOR | SENSOR_FAN_CHIPSET,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+	.family = family_amd_500_series,
+};
+
+static const struct ec_board_info board_info_pro_art_x570_creator_wifi = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB | SENSOR_TEMP_VRM |
+		SENSOR_TEMP_T_SENSOR | SENSOR_FAN_CPU_OPT |
+		SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
+	.family = family_amd_500_series,
+};
+
+static const struct ec_board_info board_info_pro_ws_x570_ace = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB | SENSOR_TEMP_VRM |
+		SENSOR_TEMP_T_SENSOR | SENSOR_FAN_CHIPSET |
+		SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+	.family = family_amd_500_series,
+};
+
+static const struct ec_board_info board_info_crosshair_viii_dark_hero = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
+		SENSOR_TEMP_T_SENSOR |
+		SENSOR_TEMP_VRM | SENSOR_SET_TEMP_WATER |
+		SENSOR_FAN_CPU_OPT | SENSOR_FAN_WATER_FLOW |
+		SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+	.family = family_amd_500_series,
+};
+
+static const struct ec_board_info board_info_crosshair_viii_hero = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
+		SENSOR_TEMP_T_SENSOR |
+		SENSOR_TEMP_VRM | SENSOR_SET_TEMP_WATER |
+		SENSOR_FAN_CPU_OPT | SENSOR_FAN_CHIPSET |
+		SENSOR_FAN_WATER_FLOW | SENSOR_CURR_CPU |
+		SENSOR_IN_CPU_CORE,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+	.family = family_amd_500_series,
+};
+
+static const struct ec_board_info board_info_maximus_xi_hero = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
+		SENSOR_TEMP_T_SENSOR |
+		SENSOR_TEMP_VRM | SENSOR_SET_TEMP_WATER |
+		SENSOR_FAN_CPU_OPT | SENSOR_FAN_WATER_FLOW,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+	.family = family_intel_300_series,
+};
+
+static const struct ec_board_info board_info_crosshair_viii_impact = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
+		SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
+		SENSOR_FAN_CHIPSET | SENSOR_CURR_CPU |
+		SENSOR_IN_CPU_CORE,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+	.family = family_amd_500_series,
+};
+
+static const struct ec_board_info board_info_strix_b550_e_gaming = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
+		SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
+		SENSOR_FAN_CPU_OPT,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+	.family = family_amd_500_series,
+};
+
+static const struct ec_board_info board_info_strix_b550_i_gaming = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
+		SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
+		SENSOR_FAN_VRM_HS | SENSOR_CURR_CPU |
+		SENSOR_IN_CPU_CORE,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+	.family = family_amd_500_series,
+};
+
+static const struct ec_board_info board_info_strix_x570_e_gaming = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
+		SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM |
+		SENSOR_FAN_CHIPSET | SENSOR_CURR_CPU |
+		SENSOR_IN_CPU_CORE,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+	.family = family_amd_500_series,
+};
+
+static const struct ec_board_info board_info_strix_x570_e_gaming_wifi_ii = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
+		SENSOR_TEMP_T_SENSOR | SENSOR_CURR_CPU |
+		SENSOR_IN_CPU_CORE,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+	.family = family_amd_500_series,
+};
+
+static const struct ec_board_info board_info_strix_x570_f_gaming = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB |
+		SENSOR_TEMP_T_SENSOR | SENSOR_FAN_CHIPSET,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+	.family = family_amd_500_series,
+};
+
+static const struct ec_board_info board_info_strix_x570_i_gaming = {
+	.sensors = SENSOR_TEMP_CHIPSET | SENSOR_TEMP_VRM |
+		SENSOR_TEMP_T_SENSOR |
+		SENSOR_FAN_VRM_HS | SENSOR_FAN_CHIPSET |
+		SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
+	.family = family_amd_500_series,
+};
+
+static const struct ec_board_info board_info_strix_z690_a_gaming_wifi_d4 = {
+	.sensors = SENSOR_TEMP_T_SENSOR | SENSOR_TEMP_VRM,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_RMTW_ASMX,
+	.family = family_intel_600_series,
+};
+
+static const struct ec_board_info board_info_zenith_ii_extreme = {
+	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB | SENSOR_TEMP_T_SENSOR |
+		SENSOR_TEMP_VRM | SENSOR_SET_TEMP_WATER |
+		SENSOR_FAN_CPU_OPT | SENSOR_FAN_CHIPSET | SENSOR_FAN_VRM_HS |
+		SENSOR_FAN_WATER_FLOW | SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE |
+		SENSOR_SET_WATER_BLOCK |
+		SENSOR_TEMP_T_SENSOR_2 | SENSOR_TEMP_SENSOR_EXTRA_1 |
+		SENSOR_TEMP_SENSOR_EXTRA_2 | SENSOR_TEMP_SENSOR_EXTRA_3,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0,
+	.family = family_amd_500_series,
+};
+
+#define DMI_EXACT_MATCH_ASUS_BOARD_NAME(name, board_info)                      \
+	{                                                                      \
+		.matches = {                                                   \
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR,                      \
+					"ASUSTeK COMPUTER INC."),              \
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, name),                 \
+		},                                                             \
+		.driver_data = (void *)board_info,                              \
+	}
+
+static const struct dmi_system_id dmi_table[] = {
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("PRIME X470-PRO",
+					&board_info_prime_x470_pro),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("PRIME X570-PRO",
+					&board_info_prime_x570_pro),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ProArt X570-CREATOR WIFI",
+					&board_info_pro_art_x570_creator_wifi),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("Pro WS X570-ACE",
+					&board_info_pro_ws_x570_ace),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VIII DARK HERO",
+					&board_info_crosshair_viii_dark_hero),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VIII FORMULA",
+					&board_info_crosshair_viii_hero),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VIII HERO",
+					&board_info_crosshair_viii_hero),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VIII HERO (WI-FI)",
+					&board_info_crosshair_viii_hero),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG MAXIMUS XI HERO",
+					&board_info_maximus_xi_hero),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG MAXIMUS XI HERO (WI-FI)",
+					&board_info_maximus_xi_hero),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG CROSSHAIR VIII IMPACT",
+					&board_info_crosshair_viii_impact),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX B550-E GAMING",
+					&board_info_strix_b550_e_gaming),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX B550-I GAMING",
+					&board_info_strix_b550_i_gaming),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX X570-E GAMING",
+					&board_info_strix_x570_e_gaming),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX X570-E GAMING WIFI II",
+					&board_info_strix_x570_e_gaming_wifi_ii),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX X570-F GAMING",
+					&board_info_strix_x570_f_gaming),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX X570-I GAMING",
+					&board_info_strix_x570_i_gaming),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG STRIX Z690-A GAMING WIFI D4",
+					&board_info_strix_z690_a_gaming_wifi_d4),
+	DMI_EXACT_MATCH_ASUS_BOARD_NAME("ROG ZENITH II EXTREME",
+					&board_info_zenith_ii_extreme),
+	{},
 };
 
 struct ec_sensor {
@@ -537,12 +577,12 @@ static int find_ec_sensor_index(const struct ec_sensors_data *ec,
 	return -ENOENT;
 }
 
-static int __init bank_compare(const void *a, const void *b)
+static int bank_compare(const void *a, const void *b)
 {
 	return *((const s8 *)a) - *((const s8 *)b);
 }
 
-static void __init setup_sensor_data(struct ec_sensors_data *ec)
+static void setup_sensor_data(struct ec_sensors_data *ec)
 {
 	struct ec_sensor *s = ec->sensors;
 	bool bank_found;
@@ -574,7 +614,7 @@ static void __init setup_sensor_data(struct ec_sensors_data *ec)
 	sort(ec->banks, ec->nr_banks, 1, bank_compare, NULL);
 }
 
-static void __init fill_ec_registers(struct ec_sensors_data *ec)
+static void fill_ec_registers(struct ec_sensors_data *ec)
 {
 	const struct ec_sensor_info *si;
 	unsigned int i, j, register_idx = 0;
@@ -589,7 +629,7 @@ static void __init fill_ec_registers(struct ec_sensors_data *ec)
 	}
 }
 
-static int __init setup_lock_data(struct device *dev)
+static int setup_lock_data(struct device *dev)
 {
 	const char *mutex_path;
 	int status;
@@ -812,7 +852,7 @@ static umode_t asus_ec_hwmon_is_visible(const void *drvdata,
 	return find_ec_sensor_index(state, type, channel) >= 0 ? S_IRUGO : 0;
 }
 
-static int __init
+static int
 asus_ec_hwmon_add_chan_info(struct hwmon_channel_info *asus_ec_hwmon_chan,
 			     struct device *dev, int num,
 			     enum hwmon_sensor_types type, u32 config)
@@ -841,27 +881,15 @@ static struct hwmon_chip_info asus_ec_chip_info = {
 	.ops = &asus_ec_hwmon_ops,
 };
 
-static const struct ec_board_info * __init get_board_info(void)
+static const struct ec_board_info *get_board_info(void)
 {
-	const char *dmi_board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
-	const char *dmi_board_name = dmi_get_system_info(DMI_BOARD_NAME);
-	const struct ec_board_info *board;
-
-	if (!dmi_board_vendor || !dmi_board_name ||
-	    strcasecmp(dmi_board_vendor, "ASUSTeK COMPUTER INC."))
-		return NULL;
-
-	for (board = board_info; board->sensors; board++) {
-		if (match_string(board->board_names,
-				 MAX_IDENTICAL_BOARD_VARIATIONS,
-				 dmi_board_name) >= 0)
-			return board;
-	}
+	const struct dmi_system_id *dmi_entry;
 
-	return NULL;
+	dmi_entry = dmi_first_match(dmi_table);
+	return dmi_entry ? dmi_entry->driver_data : NULL;
 }
 
-static int __init asus_ec_probe(struct platform_device *pdev)
+static int asus_ec_probe(struct platform_device *pdev)
 {
 	const struct hwmon_channel_info **ptr_asus_ec_ci;
 	int nr_count[hwmon_max] = { 0 }, nr_types = 0;
@@ -970,29 +998,37 @@ static int __init asus_ec_probe(struct platform_device *pdev)
 	return PTR_ERR_OR_ZERO(hwdev);
 }
 
-
-static const struct acpi_device_id acpi_ec_ids[] = {
-	/* Embedded Controller Device */
-	{ "PNP0C09", 0 },
-	{}
-};
+MODULE_DEVICE_TABLE(dmi, dmi_table);
 
 static struct platform_driver asus_ec_sensors_platform_driver = {
 	.driver = {
 		.name	= "asus-ec-sensors",
-		.acpi_match_table = acpi_ec_ids,
 	},
+	.probe = asus_ec_probe,
 };
 
-MODULE_DEVICE_TABLE(acpi, acpi_ec_ids);
-/*
- * we use module_platform_driver_probe() rather than module_platform_driver()
- * because the probe function (and its dependants) are marked with __init, which
- * means we can't put it into the .probe member of the platform_driver struct
- * above, and we can't mark the asus_ec_sensors_platform_driver object as __init
- * because the object is referenced from the module exit code.
- */
-module_platform_driver_probe(asus_ec_sensors_platform_driver, asus_ec_probe);
+static struct platform_device *asus_ec_sensors_platform_device;
+
+static int __init asus_ec_init(void)
+{
+	asus_ec_sensors_platform_device =
+		platform_create_bundle(&asus_ec_sensors_platform_driver,
+				       asus_ec_probe, NULL, 0, NULL, 0);
+
+	if (IS_ERR(asus_ec_sensors_platform_device))
+		return PTR_ERR(asus_ec_sensors_platform_device);
+
+	return 0;
+}
+
+static void __exit asus_ec_exit(void)
+{
+	platform_device_unregister(asus_ec_sensors_platform_device);
+	platform_driver_unregister(&asus_ec_sensors_platform_driver);
+}
+
+module_init(asus_ec_init);
+module_exit(asus_ec_exit);
 
 module_param_named(mutex_path, mutex_path_override, charp, 0);
 MODULE_PARM_DESC(mutex_path,
-- 
2.35.1



