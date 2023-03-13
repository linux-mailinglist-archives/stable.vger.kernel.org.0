Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D798E6B7354
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 10:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjCMJ6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 05:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCMJ6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 05:58:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F025B5BDAD;
        Mon, 13 Mar 2023 02:57:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FC4B611B0;
        Mon, 13 Mar 2023 09:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65512C43443;
        Mon, 13 Mar 2023 09:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678701470;
        bh=hcCUGWSNuMner27IljuJPoGie1OqStjApvbWUf/Mvx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUlu/pfq7w6Uv77wnspQOc8xTbfrC0DwgpNV5ADRVihpJi1OBQ74lFCNyqPSp+nG1
         odG9aYhETLe5YYKAPc2YryqHcvIhskNPnhXvQ34RDGjW1o46/FQ+DWaC1O305Jr34W
         P8R5GtC/LrXM4tUQSROGBAnt56WF8cmGnAeUQzz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.1.19
Date:   Mon, 13 Mar 2023 10:57:42 +0100
Message-Id: <1678701462113147@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167870146234120@kroah.com>
References: <167870146234120@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index a825361f7162..ea18c4c20738 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 1
-SUBLEVEL = 18
+SUBLEVEL = 19
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 783d65fc71f0..409682d06309 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -507,6 +507,63 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
 	return 0;
 }
 
+/*
+ * Some AMD fTPM versions may cause stutter
+ * https://www.amd.com/en/support/kb/faq/pa-410
+ *
+ * Fixes are available in two series of fTPM firmware:
+ * 6.x.y.z series: 6.0.18.6 +
+ * 3.x.y.z series: 3.57.y.5 +
+ */
+static bool tpm_amd_is_rng_defective(struct tpm_chip *chip)
+{
+	u32 val1, val2;
+	u64 version;
+	int ret;
+
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+		return false;
+
+	ret = tpm_request_locality(chip);
+	if (ret)
+		return false;
+
+	ret = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, &val1, NULL);
+	if (ret)
+		goto release;
+	if (val1 != 0x414D4400U /* AMD */) {
+		ret = -ENODEV;
+		goto release;
+	}
+	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_1, &val1, NULL);
+	if (ret)
+		goto release;
+	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_2, &val2, NULL);
+
+release:
+	tpm_relinquish_locality(chip);
+
+	if (ret)
+		return false;
+
+	version = ((u64)val1 << 32) | val2;
+	if ((version >> 48) == 6) {
+		if (version >= 0x0006000000180006ULL)
+			return false;
+	} else if ((version >> 48) == 3) {
+		if (version >= 0x0003005700000005ULL)
+			return false;
+	} else {
+		return false;
+	}
+
+	dev_warn(&chip->dev,
+		 "AMD fTPM version 0x%llx causes system stutter; hwrng disabled\n",
+		 version);
+
+	return true;
+}
+
 static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
 	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
@@ -516,7 +573,8 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 
 static int tpm_add_hwrng(struct tpm_chip *chip)
 {
-	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip))
+	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip) ||
+	    tpm_amd_is_rng_defective(chip))
 		return 0;
 
 	snprintf(chip->hwrng_name, sizeof(chip->hwrng_name),
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 24ee4e1cc452..830014a26609 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -150,6 +150,79 @@ enum tpm_sub_capabilities {
 	TPM_CAP_PROP_TIS_DURATION = 0x120,
 };
 
+enum tpm2_pt_props {
+	TPM2_PT_NONE = 0x00000000,
+	TPM2_PT_GROUP = 0x00000100,
+	TPM2_PT_FIXED = TPM2_PT_GROUP * 1,
+	TPM2_PT_FAMILY_INDICATOR = TPM2_PT_FIXED + 0,
+	TPM2_PT_LEVEL = TPM2_PT_FIXED + 1,
+	TPM2_PT_REVISION = TPM2_PT_FIXED + 2,
+	TPM2_PT_DAY_OF_YEAR = TPM2_PT_FIXED + 3,
+	TPM2_PT_YEAR = TPM2_PT_FIXED + 4,
+	TPM2_PT_MANUFACTURER = TPM2_PT_FIXED + 5,
+	TPM2_PT_VENDOR_STRING_1 = TPM2_PT_FIXED + 6,
+	TPM2_PT_VENDOR_STRING_2 = TPM2_PT_FIXED + 7,
+	TPM2_PT_VENDOR_STRING_3 = TPM2_PT_FIXED + 8,
+	TPM2_PT_VENDOR_STRING_4 = TPM2_PT_FIXED + 9,
+	TPM2_PT_VENDOR_TPM_TYPE = TPM2_PT_FIXED + 10,
+	TPM2_PT_FIRMWARE_VERSION_1 = TPM2_PT_FIXED + 11,
+	TPM2_PT_FIRMWARE_VERSION_2 = TPM2_PT_FIXED + 12,
+	TPM2_PT_INPUT_BUFFER = TPM2_PT_FIXED + 13,
+	TPM2_PT_HR_TRANSIENT_MIN = TPM2_PT_FIXED + 14,
+	TPM2_PT_HR_PERSISTENT_MIN = TPM2_PT_FIXED + 15,
+	TPM2_PT_HR_LOADED_MIN = TPM2_PT_FIXED + 16,
+	TPM2_PT_ACTIVE_SESSIONS_MAX = TPM2_PT_FIXED + 17,
+	TPM2_PT_PCR_COUNT = TPM2_PT_FIXED + 18,
+	TPM2_PT_PCR_SELECT_MIN = TPM2_PT_FIXED + 19,
+	TPM2_PT_CONTEXT_GAP_MAX = TPM2_PT_FIXED + 20,
+	TPM2_PT_NV_COUNTERS_MAX = TPM2_PT_FIXED + 22,
+	TPM2_PT_NV_INDEX_MAX = TPM2_PT_FIXED + 23,
+	TPM2_PT_MEMORY = TPM2_PT_FIXED + 24,
+	TPM2_PT_CLOCK_UPDATE = TPM2_PT_FIXED + 25,
+	TPM2_PT_CONTEXT_HASH = TPM2_PT_FIXED + 26,
+	TPM2_PT_CONTEXT_SYM = TPM2_PT_FIXED + 27,
+	TPM2_PT_CONTEXT_SYM_SIZE = TPM2_PT_FIXED + 28,
+	TPM2_PT_ORDERLY_COUNT = TPM2_PT_FIXED + 29,
+	TPM2_PT_MAX_COMMAND_SIZE = TPM2_PT_FIXED + 30,
+	TPM2_PT_MAX_RESPONSE_SIZE = TPM2_PT_FIXED + 31,
+	TPM2_PT_MAX_DIGEST = TPM2_PT_FIXED + 32,
+	TPM2_PT_MAX_OBJECT_CONTEXT = TPM2_PT_FIXED + 33,
+	TPM2_PT_MAX_SESSION_CONTEXT = TPM2_PT_FIXED + 34,
+	TPM2_PT_PS_FAMILY_INDICATOR = TPM2_PT_FIXED + 35,
+	TPM2_PT_PS_LEVEL = TPM2_PT_FIXED + 36,
+	TPM2_PT_PS_REVISION = TPM2_PT_FIXED + 37,
+	TPM2_PT_PS_DAY_OF_YEAR = TPM2_PT_FIXED + 38,
+	TPM2_PT_PS_YEAR = TPM2_PT_FIXED + 39,
+	TPM2_PT_SPLIT_MAX = TPM2_PT_FIXED + 40,
+	TPM2_PT_TOTAL_COMMANDS = TPM2_PT_FIXED + 41,
+	TPM2_PT_LIBRARY_COMMANDS = TPM2_PT_FIXED + 42,
+	TPM2_PT_VENDOR_COMMANDS = TPM2_PT_FIXED + 43,
+	TPM2_PT_NV_BUFFER_MAX = TPM2_PT_FIXED + 44,
+	TPM2_PT_MODES = TPM2_PT_FIXED + 45,
+	TPM2_PT_MAX_CAP_BUFFER = TPM2_PT_FIXED + 46,
+	TPM2_PT_VAR = TPM2_PT_GROUP * 2,
+	TPM2_PT_PERMANENT = TPM2_PT_VAR + 0,
+	TPM2_PT_STARTUP_CLEAR = TPM2_PT_VAR + 1,
+	TPM2_PT_HR_NV_INDEX = TPM2_PT_VAR + 2,
+	TPM2_PT_HR_LOADED = TPM2_PT_VAR + 3,
+	TPM2_PT_HR_LOADED_AVAIL = TPM2_PT_VAR + 4,
+	TPM2_PT_HR_ACTIVE = TPM2_PT_VAR + 5,
+	TPM2_PT_HR_ACTIVE_AVAIL = TPM2_PT_VAR + 6,
+	TPM2_PT_HR_TRANSIENT_AVAIL = TPM2_PT_VAR + 7,
+	TPM2_PT_HR_PERSISTENT = TPM2_PT_VAR + 8,
+	TPM2_PT_HR_PERSISTENT_AVAIL = TPM2_PT_VAR + 9,
+	TPM2_PT_NV_COUNTERS = TPM2_PT_VAR + 10,
+	TPM2_PT_NV_COUNTERS_AVAIL = TPM2_PT_VAR + 11,
+	TPM2_PT_ALGORITHM_SET = TPM2_PT_VAR + 12,
+	TPM2_PT_LOADED_CURVES = TPM2_PT_VAR + 13,
+	TPM2_PT_LOCKOUT_COUNTER = TPM2_PT_VAR + 14,
+	TPM2_PT_MAX_AUTH_FAIL = TPM2_PT_VAR + 15,
+	TPM2_PT_LOCKOUT_INTERVAL = TPM2_PT_VAR + 16,
+	TPM2_PT_LOCKOUT_RECOVERY = TPM2_PT_VAR + 17,
+	TPM2_PT_NV_WRITE_RECOVERY = TPM2_PT_VAR + 18,
+	TPM2_PT_AUDIT_COUNTER_0 = TPM2_PT_VAR + 19,
+	TPM2_PT_AUDIT_COUNTER_1 = TPM2_PT_VAR + 20,
+};
 
 /* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
  * bytes, but 128 is still a relatively large number of random bytes and
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
index 702551056227..f660f947ab63 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -185,7 +185,6 @@ static void _rtl92e_dm_init_fsync(struct net_device *dev);
 static void _rtl92e_dm_deinit_fsync(struct net_device *dev);
 
 static	void _rtl92e_dm_check_txrateandretrycount(struct net_device *dev);
-static  void _rtl92e_dm_check_ac_dc_power(struct net_device *dev);
 static void _rtl92e_dm_check_fsync(struct net_device *dev);
 static void _rtl92e_dm_check_rf_ctrl_gpio(void *data);
 static void _rtl92e_dm_fsync_timer_callback(struct timer_list *t);
@@ -238,8 +237,6 @@ void rtl92e_dm_watchdog(struct net_device *dev)
 	if (priv->being_init_adapter)
 		return;
 
-	_rtl92e_dm_check_ac_dc_power(dev);
-
 	_rtl92e_dm_check_txrateandretrycount(dev);
 	_rtl92e_dm_check_edca_turbo(dev);
 
@@ -257,28 +254,6 @@ void rtl92e_dm_watchdog(struct net_device *dev)
 	_rtl92e_dm_cts_to_self(dev);
 }
 
-static void _rtl92e_dm_check_ac_dc_power(struct net_device *dev)
-{
-	struct r8192_priv *priv = rtllib_priv(dev);
-	static const char ac_dc_script[] = "/etc/acpi/wireless-rtl-ac-dc-power.sh";
-	char *argv[] = {(char *)ac_dc_script, DRV_NAME, NULL};
-	static char *envp[] = {"HOME=/",
-			"TERM=linux",
-			"PATH=/usr/bin:/bin",
-			 NULL};
-
-	if (priv->ResetProgress == RESET_TYPE_SILENT) {
-		return;
-	}
-
-	if (priv->rtllib->state != RTLLIB_LINKED)
-		return;
-	call_usermodehelper(ac_dc_script, argv, envp, UMH_WAIT_PROC);
-
-	return;
-};
-
-
 void rtl92e_init_adaptive_rate(struct net_device *dev)
 {
 
@@ -1667,10 +1642,6 @@ static void _rtl92e_dm_check_rf_ctrl_gpio(void *data)
 	u8 tmp1byte;
 	enum rt_rf_power_state rf_power_state_to_set;
 	bool bActuallySet = false;
-	char *argv[3];
-	static const char RadioPowerPath[] = "/etc/acpi/events/RadioPower.sh";
-	static char *envp[] = {"HOME=/", "TERM=linux", "PATH=/usr/bin:/bin",
-			       NULL};
 
 	bActuallySet = false;
 
@@ -1700,14 +1671,6 @@ static void _rtl92e_dm_check_rf_ctrl_gpio(void *data)
 		mdelay(1000);
 		priv->bHwRfOffAction = 1;
 		rtl92e_set_rf_state(dev, rf_power_state_to_set, RF_CHANGE_BY_HW);
-		if (priv->hw_radio_off)
-			argv[1] = "RFOFF";
-		else
-			argv[1] = "RFON";
-
-		argv[0] = (char *)RadioPowerPath;
-		argv[2] = NULL;
-		call_usermodehelper(RadioPowerPath, argv, envp, UMH_WAIT_PROC);
 	}
 }
 
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 89fc5683ed26..6e87d2cd8345 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1486,8 +1486,6 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 		connect->key = NULL;
 		connect->key_len = 0;
 		connect->key_idx = 0;
-		connect->crypto.cipher_group = 0;
-		connect->crypto.n_ciphers_pairwise = 0;
 	}
 
 	wdev->connect_keys = connkeys;
