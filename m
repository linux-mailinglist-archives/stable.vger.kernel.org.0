Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A2E9601F
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbfHTNdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:33:00 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:37366 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728993AbfHTNdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 09:33:00 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1i04Ft-00007G-2H
        for stable@vger.kernel.org; Tue, 20 Aug 2019 16:32:57 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     stable@vger.kernel.org
Date:   Tue, 20 Aug 2019 16:32:51 +0300
Message-Id: <20190820133251.9555-1-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Subject: [PATCH 5.2] iwlwifi: Add support for SAR South Korea limitation
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

commit 0c3d7282233c7b02c74400b49981d6fff1d683a8 upstream.

South Korea is adding a more strict SAR limit called "Limb SAR".
Currently, WGDS SAR offset group 3 is not used (not mapped to any country).
In order to be able to comply with South Korea new restriction:
- OEM will use WGDS SAR offset group 3 to South Korea limitation.
- OEM will change WGDS revision to 1 (currently latest revision is 0)
	to notify that Korea Limb SAR applied.
- Driver will read the WGDS table and pass the values to FW (as usual)
- Driver will pass to FW an indication that Korea Limb SAR is applied
	in case table revision is 1.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---

This is needed in v5.2, because the FW API has changed and this patch
is needed to support this new version.  The new version was backported
to our FW version 46, which we didn't predict at the time when the
patch was committed to the mainline, but it needs to be taken now in
order to avoid a regression.

drivers/net/wireless/intel/iwlwifi/fw/acpi.c  | 28 ++++++----
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  5 +-
 .../net/wireless/intel/iwlwifi/fw/api/power.h | 12 ++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 55 ++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  1 +
 6 files changed, 76 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 405038ce98d6..7573af2d88ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -97,7 +97,7 @@ IWL_EXPORT_SYMBOL(iwl_acpi_get_object);
 
 union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
 					 union acpi_object *data,
-					 int data_size)
+					 int data_size, int *tbl_rev)
 {
 	int i;
 	union acpi_object *wifi_pkg;
@@ -113,16 +113,19 @@ union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
 	/*
 	 * We need at least two packages, one for the revision and one
 	 * for the data itself.  Also check that the revision is valid
-	 * (i.e. it is an integer set to 0).
+	 * (i.e. it is an integer smaller than 2, as we currently support only
+	 * 2 revisions).
 	 */
 	if (data->type != ACPI_TYPE_PACKAGE ||
 	    data->package.count < 2 ||
 	    data->package.elements[0].type != ACPI_TYPE_INTEGER ||
-	    data->package.elements[0].integer.value != 0) {
+	    data->package.elements[0].integer.value > 1) {
 		IWL_DEBUG_DEV_RADIO(dev, "Unsupported packages structure\n");
 		return ERR_PTR(-EINVAL);
 	}
 
+	*tbl_rev = data->package.elements[0].integer.value;
+
 	/* loop through all the packages to find the one for WiFi */
 	for (i = 1; i < data->package.count; i++) {
 		union acpi_object *domain;
@@ -151,14 +154,15 @@ int iwl_acpi_get_mcc(struct device *dev, char *mcc)
 {
 	union acpi_object *wifi_pkg, *data;
 	u32 mcc_val;
-	int ret;
+	int ret, tbl_rev;
 
 	data = iwl_acpi_get_object(dev, ACPI_WRDD_METHOD);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	wifi_pkg = iwl_acpi_get_wifi_pkg(dev, data, ACPI_WRDD_WIFI_DATA_SIZE);
-	if (IS_ERR(wifi_pkg)) {
+	wifi_pkg = iwl_acpi_get_wifi_pkg(dev, data, ACPI_WRDD_WIFI_DATA_SIZE,
+					 &tbl_rev);
+	if (IS_ERR(wifi_pkg) || tbl_rev != 0) {
 		ret = PTR_ERR(wifi_pkg);
 		goto out_free;
 	}
@@ -185,6 +189,7 @@ u64 iwl_acpi_get_pwr_limit(struct device *dev)
 {
 	union acpi_object *data, *wifi_pkg;
 	u64 dflt_pwr_limit;
+	int tbl_rev;
 
 	data = iwl_acpi_get_object(dev, ACPI_SPLC_METHOD);
 	if (IS_ERR(data)) {
@@ -193,8 +198,8 @@ u64 iwl_acpi_get_pwr_limit(struct device *dev)
 	}
 
 	wifi_pkg = iwl_acpi_get_wifi_pkg(dev, data,
-					 ACPI_SPLC_WIFI_DATA_SIZE);
-	if (IS_ERR(wifi_pkg) ||
+					 ACPI_SPLC_WIFI_DATA_SIZE, &tbl_rev);
+	if (IS_ERR(wifi_pkg) || tbl_rev != 0 ||
 	    wifi_pkg->package.elements[1].integer.value != ACPI_TYPE_INTEGER) {
 		dflt_pwr_limit = 0;
 		goto out_free;
@@ -211,14 +216,15 @@ IWL_EXPORT_SYMBOL(iwl_acpi_get_pwr_limit);
 int iwl_acpi_get_eckv(struct device *dev, u32 *extl_clk)
 {
 	union acpi_object *wifi_pkg, *data;
-	int ret;
+	int ret, tbl_rev;
 
 	data = iwl_acpi_get_object(dev, ACPI_ECKV_METHOD);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	wifi_pkg = iwl_acpi_get_wifi_pkg(dev, data, ACPI_ECKV_WIFI_DATA_SIZE);
-	if (IS_ERR(wifi_pkg)) {
+	wifi_pkg = iwl_acpi_get_wifi_pkg(dev, data, ACPI_ECKV_WIFI_DATA_SIZE,
+					 &tbl_rev);
+	if (IS_ERR(wifi_pkg) || tbl_rev != 0) {
 		ret = PTR_ERR(wifi_pkg);
 		goto out_free;
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index f5704e16643f..991a23450999 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -97,7 +97,7 @@
 void *iwl_acpi_get_object(struct device *dev, acpi_string method);
 union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
 					 union acpi_object *data,
-					 int data_size);
+					 int data_size, int *tbl_rev);
 
 /**
  * iwl_acpi_get_mcc - read MCC from ACPI, if available
@@ -131,7 +131,8 @@ static inline void *iwl_acpi_get_object(struct device *dev, acpi_string method)
 
 static inline union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
 						       union acpi_object *data,
-						       int data_size)
+						       int data_size,
+						       int *tbl_rev)
 {
 	return ERR_PTR(-ENOENT);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
index 01f003c6cff9..f195db398bed 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
@@ -419,14 +419,26 @@ struct iwl_per_chain_offset_group {
 	struct iwl_per_chain_offset hb;
 } __packed; /* PER_CHAIN_LIMIT_OFFSET_GROUP_S_VER_1 */
 
+/**
+ * struct iwl_geo_tx_power_profile_cmd_v1 - struct for GEO_TX_POWER_LIMIT cmd.
+ * @ops: operations, value from &enum iwl_geo_per_chain_offset_operation
+ * @table: offset profile per band.
+ */
+struct iwl_geo_tx_power_profiles_cmd_v1 {
+	__le32 ops;
+	struct iwl_per_chain_offset_group table[IWL_NUM_GEO_PROFILES];
+} __packed; /* GEO_TX_POWER_LIMIT_VER_1 */
+
 /**
  * struct iwl_geo_tx_power_profile_cmd - struct for GEO_TX_POWER_LIMIT cmd.
  * @ops: operations, value from &enum iwl_geo_per_chain_offset_operation
  * @table: offset profile per band.
+ * @table_revision: BIOS table revision.
  */
 struct iwl_geo_tx_power_profiles_cmd {
 	__le32 ops;
 	struct iwl_per_chain_offset_group table[IWL_NUM_GEO_PROFILES];
+	__le32 table_revision;
 } __packed; /* GEO_TX_POWER_LIMIT */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index de9243d30135..a74f34a8dffb 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -286,6 +286,8 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  *	SCAN_OFFLOAD_PROFILES_QUERY_RSP_S.
  * @IWL_UCODE_TLV_API_MBSSID_HE: This ucode supports v2 of
  *	STA_CONTEXT_DOT11AX_API_S
+ * @IWL_UCODE_TLV_CAPA_SAR_TABLE_VER: This ucode supports different sar
+ *	version tables.
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -318,6 +320,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_MBSSID_HE		= (__force iwl_ucode_tlv_api_t)52,
 	IWL_UCODE_TLV_API_WOWLAN_TCP_SYN_WAKE	= (__force iwl_ucode_tlv_api_t)53,
 	IWL_UCODE_TLV_API_FTM_RTT_ACCURACY      = (__force iwl_ucode_tlv_api_t)54,
+	IWL_UCODE_TLV_API_SAR_TABLE_VER         = (__force iwl_ucode_tlv_api_t)55,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 5af9959d05e5..8892707050d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -682,15 +682,15 @@ static int iwl_mvm_sar_get_wrds_table(struct iwl_mvm *mvm)
 {
 	union acpi_object *wifi_pkg, *table, *data;
 	bool enabled;
-	int ret;
+	int ret, tbl_rev;
 
 	data = iwl_acpi_get_object(mvm->dev, ACPI_WRDS_METHOD);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
 	wifi_pkg = iwl_acpi_get_wifi_pkg(mvm->dev, data,
-					 ACPI_WRDS_WIFI_DATA_SIZE);
-	if (IS_ERR(wifi_pkg)) {
+					 ACPI_WRDS_WIFI_DATA_SIZE, &tbl_rev);
+	if (IS_ERR(wifi_pkg) || tbl_rev != 0) {
 		ret = PTR_ERR(wifi_pkg);
 		goto out_free;
 	}
@@ -719,15 +719,15 @@ static int iwl_mvm_sar_get_ewrd_table(struct iwl_mvm *mvm)
 {
 	union acpi_object *wifi_pkg, *data;
 	bool enabled;
-	int i, n_profiles, ret;
+	int i, n_profiles, ret, tbl_rev;
 
 	data = iwl_acpi_get_object(mvm->dev, ACPI_EWRD_METHOD);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
 	wifi_pkg = iwl_acpi_get_wifi_pkg(mvm->dev, data,
-					 ACPI_EWRD_WIFI_DATA_SIZE);
-	if (IS_ERR(wifi_pkg)) {
+					 ACPI_EWRD_WIFI_DATA_SIZE, &tbl_rev);
+	if (IS_ERR(wifi_pkg) || tbl_rev != 0) {
 		ret = PTR_ERR(wifi_pkg);
 		goto out_free;
 	}
@@ -778,7 +778,7 @@ static int iwl_mvm_sar_get_ewrd_table(struct iwl_mvm *mvm)
 static int iwl_mvm_sar_get_wgds_table(struct iwl_mvm *mvm)
 {
 	union acpi_object *wifi_pkg, *data;
-	int i, j, ret;
+	int i, j, ret, tbl_rev;
 	int idx = 1;
 
 	data = iwl_acpi_get_object(mvm->dev, ACPI_WGDS_METHOD);
@@ -786,12 +786,13 @@ static int iwl_mvm_sar_get_wgds_table(struct iwl_mvm *mvm)
 		return PTR_ERR(data);
 
 	wifi_pkg = iwl_acpi_get_wifi_pkg(mvm->dev, data,
-					 ACPI_WGDS_WIFI_DATA_SIZE);
-	if (IS_ERR(wifi_pkg)) {
+					 ACPI_WGDS_WIFI_DATA_SIZE, &tbl_rev);
+	if (IS_ERR(wifi_pkg) || tbl_rev > 1) {
 		ret = PTR_ERR(wifi_pkg);
 		goto out_free;
 	}
 
+	mvm->geo_rev = tbl_rev;
 	for (i = 0; i < ACPI_NUM_GEO_PROFILES; i++) {
 		for (j = 0; j < ACPI_GEO_TABLE_SIZE; j++) {
 			union acpi_object *entry;
@@ -894,15 +895,29 @@ int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
 {
 	struct iwl_geo_tx_power_profiles_resp *resp;
 	int ret;
+	u16 len;
+	void *data;
+	struct iwl_geo_tx_power_profiles_cmd geo_cmd;
+	struct iwl_geo_tx_power_profiles_cmd_v1 geo_cmd_v1;
+	struct iwl_host_cmd cmd;
+
+	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_SAR_TABLE_VER)) {
+		geo_cmd.ops =
+			cpu_to_le32(IWL_PER_CHAIN_OFFSET_GET_CURRENT_TABLE);
+		len = sizeof(geo_cmd);
+		data = &geo_cmd;
+	} else {
+		geo_cmd_v1.ops =
+			cpu_to_le32(IWL_PER_CHAIN_OFFSET_GET_CURRENT_TABLE);
+		len = sizeof(geo_cmd_v1);
+		data = &geo_cmd_v1;
+	}
 
-	struct iwl_geo_tx_power_profiles_cmd geo_cmd = {
-		.ops = cpu_to_le32(IWL_PER_CHAIN_OFFSET_GET_CURRENT_TABLE),
-	};
-	struct iwl_host_cmd cmd = {
+	cmd = (struct iwl_host_cmd){
 		.id =  WIDE_ID(PHY_OPS_GROUP, GEO_TX_POWER_LIMIT),
-		.len = { sizeof(geo_cmd), },
+		.len = { len, },
 		.flags = CMD_WANT_SKB,
-		.data = { &geo_cmd },
+		.data = { data },
 	};
 
 	if (!iwl_mvm_sar_geo_support(mvm))
@@ -969,6 +984,16 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 					i, j, value[1], value[2], value[0]);
 		}
 	}
+
+	cmd.table_revision = cpu_to_le32(mvm->geo_rev);
+
+	if (!fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_SAR_TABLE_VER)) {
+		return iwl_mvm_send_cmd_pdu(mvm, cmd_wide_id, 0,
+				sizeof(struct iwl_geo_tx_power_profiles_cmd_v1),
+				&cmd);
+	}
+
 	return iwl_mvm_send_cmd_pdu(mvm, cmd_wide_id, 0, sizeof(cmd), &cmd);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 88af1f0ba3f0..ed8fc9a9204c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1184,6 +1184,7 @@ struct iwl_mvm {
 #ifdef CONFIG_ACPI
 	struct iwl_mvm_sar_profile sar_profiles[ACPI_SAR_PROFILE_NUM];
 	struct iwl_mvm_geo_profile geo_profiles[ACPI_NUM_GEO_PROFILES];
+	u32 geo_rev;
 #endif
 };
 
-- 
2.23.0.rc1

