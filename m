Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEC032B0DB
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbhCCAju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:39:50 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:47552 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1447895AbhCBPd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 10:33:26 -0500
X-Greylist: delayed 1690 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Mar 2021 10:33:25 EST
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1lH6RP-004O82-0G; Tue, 02 Mar 2021 16:56:04 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Date:   Tue,  2 Mar 2021 16:56:00 +0200
Message-Id: <20210302145600.47207-1-luca@coelho.fi>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP autolearn=ham autolearn_force=no version=3.4.4
Subject: [PATCH 5.11] iwlwifi: add new cards for So and Qu family
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ihab Zhaika <ihab.zhaika@intel.com>

commit 410f758529bc227b186ba0846bcc75ac0700ffb2 upstream.

add few PCI ID'S for So with Hr and Qu with Hr in AX family.

Cc: stable@vger.kernel.org
Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210206130110.6f0c1849f7dc.I647b4d22f9468c2f34b777a4bfa445912c6f04f0@changeid
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 18 +++++++++++++
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  3 +++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 26 +++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 8280092066e7..503d0feb6bbc 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -635,6 +635,24 @@ const struct iwl_cfg iwl_cfg_snj_a0_mr_a0 = {
 	.num_rbds = IWL_NUM_RBDS_AX210_HE,
 };
 
+const struct iwl_cfg iwl_cfg_so_a0_hr_a0 = {
+	.fw_name_pre = IWL_SO_A_HR_B_FW_PRE,
+	IWL_DEVICE_AX210,
+	.num_rbds = IWL_NUM_RBDS_AX210_HE,
+};
+
+const struct iwl_cfg iwl_cfg_quz_a0_hr_b0 = {
+	.fw_name_pre = IWL_QUZ_A_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+	.num_rbds = IWL_NUM_RBDS_22000_HE,
+};
+
 MODULE_FIRMWARE(IWL_QU_B_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QNJ_B_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_C_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 86e1d57df65e..c72d23d54d90 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -418,6 +418,7 @@ struct iwl_cfg {
 #define IWL_CFG_MAC_TYPE_QU		0x33
 #define IWL_CFG_MAC_TYPE_QUZ		0x35
 #define IWL_CFG_MAC_TYPE_QNJ		0x36
+#define IWL_CFG_MAC_TYPE_SO		0x37
 #define IWL_CFG_MAC_TYPE_SNJ		0x42
 #define IWL_CFG_MAC_TYPE_MA		0x44
 
@@ -604,6 +605,8 @@ extern const struct iwl_cfg iwlax201_cfg_snj_hr_b0;
 extern const struct iwl_cfg iwl_cfg_ma_a0_gf_a0;
 extern const struct iwl_cfg iwl_cfg_ma_a0_mr_a0;
 extern const struct iwl_cfg iwl_cfg_snj_a0_mr_a0;
+extern const struct iwl_cfg iwl_cfg_so_a0_hr_a0;
+extern const struct iwl_cfg iwl_cfg_quz_a0_hr_b0;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index ed3f5b7aa71e..c55faa388948 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -934,6 +934,11 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_RF_TYPE_HR1, IWL_CFG_ANY,
 		      IWL_CFG_ANY, IWL_CFG_ANY,
 		      iwl_quz_a0_hr1_b0, iwl_ax101_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_QUZ, SILICON_B_STEP,
+		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY,
+		      IWL_CFG_NO_160, IWL_CFG_ANY,
+		      iwl_cfg_quz_a0_hr_b0, iwl_ax203_name),
 
 /* Ma */
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
@@ -952,6 +957,27 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_ANY, IWL_CFG_ANY,
 		      iwl_cfg_snj_a0_mr_a0, iwl_ma_name),
 
+/* So with Hr */
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY,
+		      IWL_CFG_NO_160, IWL_CFG_ANY,
+		      iwl_cfg_so_a0_hr_a0, iwl_ax203_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY,
+		      IWL_CFG_NO_160, IWL_CFG_ANY,
+		      iwl_cfg_so_a0_hr_a0, iwl_ax203_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_HR1, IWL_CFG_ANY,
+		      IWL_CFG_160, IWL_CFG_ANY,
+		      iwl_cfg_so_a0_hr_a0, iwl_ax101_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY,
+		      IWL_CFG_160, IWL_CFG_ANY,
+		      iwl_cfg_so_a0_hr_a0, iwl_ax201_name)
 
 #endif /* CONFIG_IWLMVM */
 };
-- 
2.30.1

