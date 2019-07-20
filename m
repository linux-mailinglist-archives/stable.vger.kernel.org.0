Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61EB6EF06
	for <lists+stable@lfdr.de>; Sat, 20 Jul 2019 12:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfGTK0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jul 2019 06:26:03 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59440 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727852AbfGTK0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jul 2019 06:26:02 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1homYu-0000Hj-EK; Sat, 20 Jul 2019 13:25:59 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>, stable@vger.kernel.org
Date:   Sat, 20 Jul 2019 13:25:30 +0300
Message-Id: <20190720102545.5952-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190720102545.5952-1-luca@coelho.fi>
References: <20190720102545.5952-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.2
Subject: [PATCH 01/16] iwlwifi: mvm: don't send GEO_TX_POWER_LIMIT on version < 41
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Firmware versions before 41 don't support the GEO_TX_POWER_LIMIT
command, and sending it to the firmware will cause a firmware crash.
We allow this via debugfs, so we need to return an error value in case
it's not supported.

This had already been fixed during init, when we send the command if
the ACPI WGDS table is present.  Fix it also for the other,
userspace-triggered case.

Cc: stable@vger.kernel.org
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 22 ++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 1d608e9e9101..a837cf40afde 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -880,6 +880,17 @@ int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
 	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
 }
 
+static bool iwl_mvm_sar_geo_support(struct iwl_mvm *mvm)
+{
+	/*
+	 * The GEO_TX_POWER_LIMIT command is not supported on earlier
+	 * firmware versions.  Unfortunately, we don't have a TLV API
+	 * flag to rely on, so rely on the major version which is in
+	 * the first byte of ucode_ver.
+	 */
+	return IWL_UCODE_SERIAL(mvm->fw->ucode_ver) >= 41;
+}
+
 int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
 {
 	struct iwl_geo_tx_power_profiles_resp *resp;
@@ -909,6 +920,9 @@ int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
 		.data = { data },
 	};
 
+	if (!iwl_mvm_sar_geo_support(mvm))
+		return -EOPNOTSUPP;
+
 	ret = iwl_mvm_send_cmd(mvm, &cmd);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to get geographic profile info %d\n", ret);
@@ -934,13 +948,7 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 	int ret, i, j;
 	u16 cmd_wide_id =  WIDE_ID(PHY_OPS_GROUP, GEO_TX_POWER_LIMIT);
 
-	/*
-	 * This command is not supported on earlier firmware versions.
-	 * Unfortunately, we don't have a TLV API flag to rely on, so
-	 * rely on the major version which is in the first byte of
-	 * ucode_ver.
-	 */
-	if (IWL_UCODE_SERIAL(mvm->fw->ucode_ver) < 41)
+	if (!iwl_mvm_sar_geo_support(mvm))
 		return 0;
 
 	ret = iwl_mvm_sar_get_wgds_table(mvm);
-- 
2.20.1

