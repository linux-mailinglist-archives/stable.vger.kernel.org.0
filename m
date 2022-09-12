Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FB55B59A0
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 13:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiILLtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 07:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiILLtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 07:49:18 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D071A3A5
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 04:49:15 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id q21so12346992edc.9
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 04:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=hj86q0yiyKgVZIjt3FYH/HtBcZiAlF6D/10dXTGLExU=;
        b=Yc8pyCxgyw7c9s4HF3KIVuCQi6Ev9j0ZQ+nBaW+jGaClwAPIOkiz3zuRqWMk0IfwJ3
         VTHQK7jkIaVU4CWz32n8GviL2SpQSr8kFAx8Nmhw44WN2cDK8sPGVYlFVutea+ScuSXW
         glCZaMDQtqqMJbcfe8RNdDG6nC7lpVzstTHqWoAGIkVd4B90NqLyoIhCDgJXaeRt6Ld7
         HzaLoKM/8aGYulf2MVft9khGTeIpwlnIUj7utn7myABNILPOcS3PXN5CQ7IDuvrzppOs
         cquWUIgIxOd+SwWFNWrl/6IlqWouw5VhGdlUsx52LKhMi7qbPegOpk5aVfa9nZcq8K4E
         P5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=hj86q0yiyKgVZIjt3FYH/HtBcZiAlF6D/10dXTGLExU=;
        b=YoEEJlLi7i/LGtafnoimkBnT33eMXh5fEKCitYu6FeVswP4NIfA+ZbLPY0KKUmaCs/
         OnxknFCJYu+eslTRngz93dX8mXAJqBm7zHsXSyqjT2UmvL1z/UNLrA/8ieD0hMaQ6CNH
         USnpH2Df0ekRWXXCBe5HY6vGhOPkd9Z87goAALUx+dA0AlePOQV+/RsuYsb8M5jHMJNc
         Dw9YduMQkU3OM5euUG0Zbhh4rxNQNBcbgau0o3Cqx+73a74yElhxjMkidBCsIHj23ixr
         iUobF9zLFGGGHOKAgq/RBeOtrm9GPm5mGDT3CUnWUqB56i/c6KkEwGQmaS3Rs5ZRPeSx
         de8A==
X-Gm-Message-State: ACgBeo3b6oAPMeaaspwKxexalFptBI5IqfP1k8ARz+Q0uga4rghhCjPj
        PkFGWy31sjnxigB7Vow8AXkxS6BvgRE=
X-Google-Smtp-Source: AA6agR6dPdeKm9VIms0in+C1LxpaAfjBqTIJtBbB9oPfvwHEHVfkyRXUZB3vMDAw8pSizqnSpPUEfw==
X-Received: by 2002:aa7:cd14:0:b0:44e:2335:fb90 with SMTP id b20-20020aa7cd14000000b0044e2335fb90mr21178708edw.152.1662983353196;
        Mon, 12 Sep 2022 04:49:13 -0700 (PDT)
Received: from caracal.museclub.art (erm103.goemobile.de. [134.76.0.103])
        by smtp.googlemail.com with ESMTPSA id p1-20020a17090653c100b0077f5e96129fsm436135ejo.158.2022.09.12.04.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 04:49:12 -0700 (PDT)
From:   Eugene Shalygin <eugene.shalygin@gmail.com>
To:     stable@vger.kernel.org
Cc:     Eugene Shalygin <eugene.shalygin@gmail.com>
Subject: [PATCH 1/1] hwmon: (asus-ec-sensors) autoload module via DMI data
Date:   Mon, 12 Sep 2022 13:48:42 +0200
Message-Id: <20220912114842.762355-2-eugene.shalygin@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220912114842.762355-1-eugene.shalygin@gmail.com>
References: <20220912114842.762355-1-eugene.shalygin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Replace autoloading data based on the ACPI EC device with the DMI
records for motherboards models. The ACPI method created a bug that when
this driver returns error from the probe function because of the
unsupported motherboard model, the ACPI subsystem concludes
that the EC device does not work properly.

Fixes: 5cd29012028d
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=216412
Bug: https://bugzilla.redhat.com/show_bug.cgi?id=2121844
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
---
 drivers/hwmon/asus-ec-sensors.c | 341 +++++++++++++++++---------------
 1 file changed, 187 insertions(+), 154 deletions(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 3633ab691662..13c8aa84a4a4 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -203,7 +203,6 @@ static const struct ec_sensor_info sensors_family_amd_500[] = {
 #define SENSOR_SET_TEMP_WATER (SENSOR_TEMP_WATER_IN | SENSOR_TEMP_WATER_OUT)
 
 struct ec_board_info {
-	const char *board_names[MAX_IDENTICAL_BOARD_VARIATIONS];
 	unsigned long sensors;
 	/*
 	 * Defines which mutex to use for guarding access to the state and the
@@ -216,121 +215,159 @@ struct ec_board_info {
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
-		.sensors = SENSOR_TEMP_T_SENSOR | SENSOR_FAN_VRM_HS |
-			SENSOR_FAN_CHIPSET | SENSOR_CURR_CPU |
-			SENSOR_IN_CPU_CORE,
-		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
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
+#define DMI_EXACT_MATCH_ASUS_BOARD_NAME(name, board_info)                      \
+	{                                                                      \
+		.matches = {                                                   \
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR,                      \
+					"ASUSTeK COMPUTER INC."),              \
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, name),                 \
+		},                                                             \
+		.driver_data = (void *)board_info,                             \
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
+	{},
 };
 
 struct ec_sensor {
@@ -441,12 +478,12 @@ static int find_ec_sensor_index(const struct ec_sensors_data *ec,
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
@@ -478,7 +515,7 @@ static void __init setup_sensor_data(struct ec_sensors_data *ec)
 	sort(ec->banks, ec->nr_banks, 1, bank_compare, NULL);
 }
 
-static void __init fill_ec_registers(struct ec_sensors_data *ec)
+static void fill_ec_registers(struct ec_sensors_data *ec)
 {
 	const struct ec_sensor_info *si;
 	unsigned int i, j, register_idx = 0;
@@ -493,7 +530,7 @@ static void __init fill_ec_registers(struct ec_sensors_data *ec)
 	}
 }
 
-static int __init setup_lock_data(struct device *dev)
+static int setup_lock_data(struct device *dev)
 {
 	const char *mutex_path;
 	int status;
@@ -716,7 +753,7 @@ static umode_t asus_ec_hwmon_is_visible(const void *drvdata,
 	return find_ec_sensor_index(state, type, channel) >= 0 ? S_IRUGO : 0;
 }
 
-static int __init
+static int
 asus_ec_hwmon_add_chan_info(struct hwmon_channel_info *asus_ec_hwmon_chan,
 			     struct device *dev, int num,
 			     enum hwmon_sensor_types type, u32 config)
@@ -745,27 +782,15 @@ static struct hwmon_chip_info asus_ec_chip_info = {
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
@@ -868,29 +893,37 @@ static int __init asus_ec_probe(struct platform_device *pdev)
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
2.37.3

