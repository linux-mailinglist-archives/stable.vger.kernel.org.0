Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FA766EA5
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfGLMkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728322AbfGLMZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:25:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 132182084B;
        Fri, 12 Jul 2019 12:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934347;
        bh=GyHefXivisLVR/eF9qxTNRPybD7EwF9fKQxmdjLmPJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlJeWEBN3Aqsr3/zJoiW5uYAaSk6gikO2tln5uWuiXC3bSsgIWYvS+RyPzjYe5qse
         4aePAfT3dFnH7pb25XM/EpAHWhqG7eq6J/4DB2U1w02IY6M5IwZFdeRBtlnPIZbhHJ
         hrsQuTTJBrhAy4o0Vz0nV3fwsBhyxyTCMuROJESI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 025/138] iwlwifi: clear persistence bit according to device family
Date:   Fri, 12 Jul 2019 14:18:09 +0200
Message-Id: <20190712121629.670987476@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 44f61b5c832c4085fcf476484efeaeef96dcfb8b ]

The driver attempts to clear persistence bit on any device familiy even
though only 9000 and 22000 families require it. Clear the bit only on
the relevant device families.

Each HW has different address to the write protection register. Use the
right register for each HW

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: 8954e1eb2270 ("iwlwifi: trans: Clear persistence bit when starting the FW")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |  7 ++-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 46 +++++++++++++------
 2 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 1af9f9e1ecd4..0c0799d13e15 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -402,7 +402,12 @@ enum aux_misc_master1_en {
 #define AUX_MISC_MASTER1_SMPHR_STATUS	0xA20800
 #define RSA_ENABLE			0xA24B08
 #define PREG_AUX_BUS_WPROT_0		0xA04CC0
-#define PREG_PRPH_WPROT_0		0xA04CE0
+
+/* device family 9000 WPROT register */
+#define PREG_PRPH_WPROT_9000		0xA04CE0
+/* device family 22000 WPROT register */
+#define PREG_PRPH_WPROT_22000		0xA04D00
+
 #define SB_CPU_1_STATUS			0xA01E30
 #define SB_CPU_2_STATUS			0xA01E34
 #define UMAG_SB_CPU_1_STATUS		0xA038C0
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index c4375b868901..2a03d34afa3b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1696,26 +1696,26 @@ static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 	return 0;
 }
 
-static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
+static int iwl_trans_pcie_clear_persistence_bit(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u32 hpm;
-	int err;
-
-	lockdep_assert_held(&trans_pcie->mutex);
+	u32 hpm, wprot;
 
-	err = iwl_pcie_prepare_card_hw(trans);
-	if (err) {
-		IWL_ERR(trans, "Error while preparing HW: %d\n", err);
-		return err;
+	switch (trans->cfg->device_family) {
+	case IWL_DEVICE_FAMILY_9000:
+		wprot = PREG_PRPH_WPROT_9000;
+		break;
+	case IWL_DEVICE_FAMILY_22000:
+		wprot = PREG_PRPH_WPROT_22000;
+		break;
+	default:
+		return 0;
 	}
 
 	hpm = iwl_read_umac_prph_no_grab(trans, HPM_DEBUG);
 	if (hpm != 0xa5a5a5a0 && (hpm & PERSISTENCE_BIT)) {
-		int wfpm_val = iwl_read_umac_prph_no_grab(trans,
-							  PREG_PRPH_WPROT_0);
+		u32 wprot_val = iwl_read_umac_prph_no_grab(trans, wprot);
 
-		if (wfpm_val & PREG_WFPM_ACCESS) {
+		if (wprot_val & PREG_WFPM_ACCESS) {
 			IWL_ERR(trans,
 				"Error, can not clear persistence bit\n");
 			return -EPERM;
@@ -1724,6 +1724,26 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 					    hpm & ~PERSISTENCE_BIT);
 	}
 
+	return 0;
+}
+
+static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int err;
+
+	lockdep_assert_held(&trans_pcie->mutex);
+
+	err = iwl_pcie_prepare_card_hw(trans);
+	if (err) {
+		IWL_ERR(trans, "Error while preparing HW: %d\n", err);
+		return err;
+	}
+
+	err = iwl_trans_pcie_clear_persistence_bit(trans);
+	if (err)
+		return err;
+
 	iwl_trans_pcie_sw_reset(trans);
 
 	err = iwl_pcie_apm_init(trans);
-- 
2.20.1



