Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3985711B01C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731364AbfLKPTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:19:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732235AbfLKPTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0032022527;
        Wed, 11 Dec 2019 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077574;
        bh=bbylV87ISiyzUqa66aTLnN5hnkrRKN68Zlx6JHsytXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hw97IeEfsyc5C5B6Uv3UzYr2fSo4BcXIMlH8uRNiwQMzpjnu8Pf0kYtE2DGFA9QgR
         mc37pHzWsEygZHml7y/ksZZVoe72vMee5PknktlOOFPPO08r9Qv+bZc6drwn2wuOqn
         SbAkpi4xQSdsWJU7DBY1nef3hdjzcgjRY9W6EMzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 090/243] iwlwifi: fix cfg structs for 22000 with different RF modules
Date:   Wed, 11 Dec 2019 16:04:12 +0100
Message-Id: <20191211150345.191327127@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit b1bbc1a636505ebdd6336ff781e417123226d4f7 ]

We have to choose different configuration and different firmwares
depending on the external RF module that is installed.  Since the
external module is not represented in the PCI IDs, we need to change
the configuration at runtime, after checking the RF ID of the module
installed.  We have a bit of a mess in the code that does this,
because it applies cfg's according to the RF ID only, ignoring the
integrated module that is in use.

Fix that for some devices by adding correct configurations for them
and not ignoring the integrated module's type when making the
decision.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  1 -
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 22 +++++++++++++++++--
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index a0de61aa0feff..d7335fabd9294 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -321,7 +321,6 @@ MODULE_FIRMWARE(IWL_22000_HR_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_JF_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_B_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL_22000_QU_B_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_JF_B0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 0982bd99b1c3c..844a1009484f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -888,7 +888,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x34F0, 0x0040, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0078, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl22000_2ac_cfg_jf)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0000, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0010, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40c0, 0x0090, iwl22560_2ax_cfg_su_cdb)},
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index f89d43bc7d4bd..4f5571123f70a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3415,8 +3415,26 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 #if IS_ENABLED(CONFIG_IWLMVM)
 	trans->hw_rf_id = iwl_read32(trans, CSR_HW_RF_ID);
 
-	if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
-	    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
+	if (cfg == &iwl22000_2ax_cfg_hr) {
+		if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
+			trans->cfg = &iwl22000_2ax_cfg_hr;
+		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+			   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_JF)) {
+			trans->cfg = &iwl22000_2ax_cfg_jf;
+		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+			   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HRCDB)) {
+			IWL_ERR(trans, "RF ID HRCDB is not supported\n");
+			ret = -EINVAL;
+			goto out_no_pci;
+		} else {
+			IWL_ERR(trans, "Unrecognized RF ID 0x%08x\n",
+				CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id));
+			ret = -EINVAL;
+			goto out_no_pci;
+		}
+	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
 		u32 hw_status;
 
 		hw_status = iwl_read_prph(trans, UMAG_GEN_HW_STATUS);
-- 
2.20.1



