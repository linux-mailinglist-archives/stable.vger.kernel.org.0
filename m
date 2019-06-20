Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B234CA76
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 11:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfFTJQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 05:16:08 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54574 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725953AbfFTJQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 05:16:08 -0400
X-Greylist: delayed 1779 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jun 2019 05:16:07 EDT
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hdsiA-0003KB-OJ; Thu, 20 Jun 2019 11:46:26 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Oren Givon <oren.givon@intel.com>,
        stable@vger.kernel.org, Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH] iwlwifi: add support for hr1 RF ID
Date:   Thu, 20 Jun 2019 11:46:23 +0300
Message-Id: <20190620084623.12014-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oren Givon <oren.givon@intel.com>

The 22000 series FW that was meant to be used with hr is
also the FW that is used for hr1 and has a different RF ID.
Add support to load the hr FW when hr1 RF ID is detected.

Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h    | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index 553554846009..93da96a7247c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -336,6 +336,7 @@ enum {
 /* RF_ID value */
 #define CSR_HW_RF_ID_TYPE_JF		(0x00105100)
 #define CSR_HW_RF_ID_TYPE_HR		(0x0010A000)
+#define CSR_HW_RF_ID_TYPE_HR1		(0x0010c100)
 #define CSR_HW_RF_ID_TYPE_HRCDB		(0x00109F00)
 #define CSR_HW_RF_ID_TYPE_GF		(0x0010D000)
 #define CSR_HW_RF_ID_TYPE_GF4		(0x0010E000)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index b93753233223..38ab24d96244 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3575,9 +3575,11 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 			trans->cfg = &iwlax411_2ax_cfg_so_gf4_a0;
 		}
 	} else if (cfg == &iwl_ax101_cfg_qu_hr) {
-		if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
-		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
-		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0) {
+		if ((CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+		     CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
+		     trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0) ||
+		    (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+		     CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR1))) {
 			trans->cfg = &iwl22000_2ax_cfg_qnj_hr_b0;
 		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
-- 
2.20.1

