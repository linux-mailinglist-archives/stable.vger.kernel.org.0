Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C9D5CC5A
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 11:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfGBJGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 05:06:09 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54826 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726213AbfGBJGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 05:06:09 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hiEje-0004GP-Ic; Tue, 02 Jul 2019 12:05:58 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, bjorn@mork.no,
        Luca Coelho <luciano.coelho@intel.com>, stable@vger.kernel.org
Subject: [PATCH] iwlwifi: fix support for quz firmwares
Date:   Tue,  2 Jul 2019 12:05:52 +0300
Message-Id: <20190702090552.14079-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

There was a merge damage when we added support for quz firmwares.  We
should be checking for CSR_HW_REV_TYPE_QUZ and not
CSR_HW_REV_TYPE_QNJ_B0.  Fix that.

Fixes: debec2f23910 ("iwlwifi: add support for quz firmwares")
Cc: stable@vger.kernel.org # v5.1
Reported-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 602c31b3992a..0338bf9184a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3579,8 +3579,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	} else if (cfg == &iwl_ax101_cfg_qu_hr) {
 		if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
-		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0) {
-			trans->cfg = &iwl22000_2ax_cfg_qnj_hr_b0;
+		    trans->hw_rev == CSR_HW_REV_TYPE_QUZ) {
+			trans->cfg = &iwl_ax101_cfg_quz_hr;
 		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
 			trans->cfg = &iwl_ax101_cfg_qu_hr;
-- 
2.20.1

