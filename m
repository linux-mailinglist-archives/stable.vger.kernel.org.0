Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B134B201D
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388990AbfIMNQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389865AbfIMNQb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:16:31 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A24920CC7;
        Fri, 13 Sep 2019 13:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380590;
        bh=L8fWCWUiAstESpIS8DEYln27AVPTs+nKw7k5sYprZqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fD23xbgkDLOYbCTVMBabMMkmZApYdGGagGi/tJfzaZ2iBPFxM6OGoO8SDndc8kHKM
         ++tAwq82wsO2Ffzgk3PqyXDUsRKtQj8Gpv6p0sCFwqJDG4PR5Kbh13dH+sQplU2qn9
         LrUvwzMWVkOluTAB0q7H8U6wpVP4h98MpAUlyuaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/190] iwlwifi: fix devices with PCI Device ID 0x34F0 and 11ac RF modules
Date:   Fri, 13 Sep 2019 14:05:48 +0100
Message-Id: <20190913130607.051325131@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ab27926d9e4ae23df4f4d98e31f067c8b486bb4f ]

The devices with PCI device ID 0x34F0 are part of the SoC and can be
combined with some different external RF modules.  The configuration
for these devices should reflect that, but are currently mixed up.  To
avoid confusion with discrete devices, add part of the firmware to be
used and the official name of the device to the cfg structs.

This is least reorganization possible (without messing things even
more) that could be done as a bugfix for this SoC.  Further
reorganization of this code will be done separately.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 65 ++++++++++++++++++-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  9 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 55 ++++++++--------
 3 files changed, 97 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 91ca77c7571ce..b4347806a59ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -77,10 +77,13 @@
 #define IWL_22000_HR_FW_PRE		"iwlwifi-Qu-a0-hr-a0-"
 #define IWL_22000_HR_CDB_FW_PRE		"iwlwifi-QuIcp-z0-hrcdb-a0-"
 #define IWL_22000_HR_A_F0_FW_PRE	"iwlwifi-QuQnj-f0-hr-a0-"
-#define IWL_22000_HR_B_FW_PRE		"iwlwifi-Qu-b0-hr-b0-"
+#define IWL_22000_HR_B_F0_FW_PRE	"iwlwifi-Qu-b0-hr-b0-"
+#define IWL_22000_QU_B_HR_B_FW_PRE	"iwlwifi-Qu-b0-hr-b0-"
+#define IWL_22000_HR_B_FW_PRE		"iwlwifi-QuQnj-b0-hr-b0-"
 #define IWL_22000_JF_B0_FW_PRE		"iwlwifi-QuQnj-a0-jf-b0-"
 #define IWL_22000_HR_A0_FW_PRE		"iwlwifi-QuQnj-a0-hr-a0-"
 #define IWL_22000_SU_Z0_FW_PRE		"iwlwifi-su-z0-"
+#define IWL_QU_B_JF_B_FW_PRE		"iwlwifi-Qu-b0-jf-b0-"
 
 #define IWL_22000_HR_MODULE_FIRMWARE(api) \
 	IWL_22000_HR_FW_PRE __stringify(api) ".ucode"
@@ -88,7 +91,11 @@
 	IWL_22000_JF_FW_PRE __stringify(api) ".ucode"
 #define IWL_22000_HR_A_F0_QNJ_MODULE_FIRMWARE(api) \
 	IWL_22000_HR_A_F0_FW_PRE __stringify(api) ".ucode"
-#define IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(api) \
+#define IWL_22000_HR_B_F0_QNJ_MODULE_FIRMWARE(api) \
+	IWL_22000_HR_B_F0_FW_PRE __stringify(api) ".ucode"
+#define IWL_22000_QU_B_HR_B_MODULE_FIRMWARE(api) \
+	IWL_22000_QU_B_HR_B_FW_PRE __stringify(api) ".ucode"
+#define IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(api)	\
 	IWL_22000_HR_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_22000_JF_B0_QNJ_MODULE_FIRMWARE(api) \
 	IWL_22000_JF_B0_FW_PRE __stringify(api) ".ucode"
@@ -96,6 +103,8 @@
 	IWL_22000_HR_A0_FW_PRE __stringify(api) ".ucode"
 #define IWL_22000_SU_Z0_MODULE_FIRMWARE(api) \
 	IWL_22000_SU_Z0_FW_PRE __stringify(api) ".ucode"
+#define IWL_QU_B_JF_B_MODULE_FIRMWARE(api) \
+	IWL_QU_B_JF_B_FW_PRE __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_22000		10
 
@@ -190,7 +199,54 @@ const struct iwl_cfg iwl22000_2ac_cfg_jf = {
 
 const struct iwl_cfg iwl22000_2ax_cfg_hr = {
 	.name = "Intel(R) Dual Band Wireless AX 22000",
-	.fw_name_pre = IWL_22000_HR_FW_PRE,
+	.fw_name_pre = IWL_22000_QU_B_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
+/*
+ * All JF radio modules are part of the 9000 series, but the MAC part
+ * looks more like 22000.  That's why this device is here, but called
+ * 9560 nevertheless.
+ */
+const struct iwl_cfg iwl9461_2ac_cfg_qu_b0_jf_b0 = {
+	.name = "Intel(R) Wireless-AC 9461",
+	.fw_name_pre = IWL_QU_B_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
+const struct iwl_cfg iwl9462_2ac_cfg_qu_b0_jf_b0 = {
+	.name = "Intel(R) Wireless-AC 9462",
+	.fw_name_pre = IWL_QU_B_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
+const struct iwl_cfg iwl9560_2ac_cfg_qu_b0_jf_b0 = {
+	.name = "Intel(R) Wireless-AC 9560",
+	.fw_name_pre = IWL_QU_B_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
+const struct iwl_cfg killer1550i_2ac_cfg_qu_b0_jf_b0 = {
+	.name = "Killer (R) Wireless-AC 1550i Wireless Network Adapter (9560NGW)",
+	.fw_name_pre = IWL_QU_B_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
+const struct iwl_cfg killer1550s_2ac_cfg_qu_b0_jf_b0 = {
+	.name = "Killer (R) Wireless-AC 1550s Wireless Network Adapter (9560NGW)",
+	.fw_name_pre = IWL_QU_B_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
+const struct iwl_cfg iwl22000_2ax_cfg_jf = {
+	.name = "Intel(R) Dual Band Wireless AX 22000",
+	.fw_name_pre = IWL_QU_B_JF_B_FW_PRE,
 	IWL_DEVICE_22500,
 	/*
 	 * This device doesn't support receiving BlockAck with a large bitmap
@@ -264,7 +320,10 @@ const struct iwl_cfg iwl22560_2ax_cfg_su_cdb = {
 MODULE_FIRMWARE(IWL_22000_HR_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_JF_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_22000_HR_B_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_22000_QU_B_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_JF_B0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_SU_Z0_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_QU_B_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 12fddcf15bab3..2e9fd7a303985 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -574,11 +574,18 @@ extern const struct iwl_cfg iwl22000_2ac_cfg_hr;
 extern const struct iwl_cfg iwl22000_2ac_cfg_hr_cdb;
 extern const struct iwl_cfg iwl22000_2ac_cfg_jf;
 extern const struct iwl_cfg iwl22000_2ax_cfg_hr;
+extern const struct iwl_cfg iwl9461_2ac_cfg_qu_b0_jf_b0;
+extern const struct iwl_cfg iwl9462_2ac_cfg_qu_b0_jf_b0;
+extern const struct iwl_cfg iwl9560_2ac_cfg_qu_b0_jf_b0;
+extern const struct iwl_cfg killer1550i_2ac_cfg_qu_b0_jf_b0;
+extern const struct iwl_cfg killer1550s_2ac_cfg_qu_b0_jf_b0;
+extern const struct iwl_cfg iwl22000_2ax_cfg_jf;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0_f0;
+extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_b0_f0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_b0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_jf_b0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0;
 extern const struct iwl_cfg iwl22560_2ax_cfg_su_cdb;
-#endif /* CONFIG_IWLMVM */
+#endif /* CPTCFG_IWLMVM || CPTCFG_IWLFMAC */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 5d65500a8aa75..d3a1c13bcf6f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -696,34 +696,33 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x31DC, 0x40A4, iwl9462_2ac_cfg_shared_clk)},
 	{IWL_PCI_DEVICE(0x31DC, 0x4234, iwl9560_2ac_cfg_shared_clk)},
 	{IWL_PCI_DEVICE(0x31DC, 0x42A4, iwl9462_2ac_cfg_shared_clk)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0038, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x003C, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0060, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0064, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x00A0, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x00A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0230, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0234, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0238, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x023C, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0260, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0264, iwl9461_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x02A0, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x02A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x1010, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x34F0, 0x1030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x1210, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x34F0, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x2030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x2034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x4030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x4034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x40A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x4234, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x34F0, 0x42A4, iwl9462_2ac_cfg_soc)},
+
+	{IWL_PCI_DEVICE(0x34F0, 0x0030, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0038, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x003C, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0060, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0064, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x00A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x00A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0230, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0238, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x023C, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0260, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0264, iwl9461_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x02A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x02A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x1551, killer1550s_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x1552, killer1550i_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x2030, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x2034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x4030, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x4034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x40A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x4234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x42A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
+
 	{IWL_PCI_DEVICE(0x3DF0, 0x0030, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x3DF0, 0x0034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x3DF0, 0x0038, iwl9560_2ac_cfg_soc)},
-- 
2.20.1



