Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAEE212C8F5
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387576AbfL2R6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732810AbfL2R6j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 735E6206DB;
        Sun, 29 Dec 2019 17:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642318;
        bh=7srSCgN1L+BObUBtfu2DAI5KwztU1BXGD/OqxpN/Oo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zd6Pc271Ds62v0PWVHGcPA9ZotHK4jEsgvRHaGf06meQKqGQ5unHHCOfEIVQ5nnjQ
         dsUSHCkJ4FgTozlx1hVa+dYLp2zQhECFJ0l7kkrb00YZXrV8liWh86dqea64HxYiv0
         jNR5/zjn1MjmfU9vOVjFI8QC3Jt38cPiif4C0FIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Kaseorg <andersk@mit.edu>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>, stable@ver.kernel.org
Subject: [PATCH 5.4 434/434] iwlwifi: pcie: move power gating workaround earlier in the flow
Date:   Sun, 29 Dec 2019 18:28:07 +0100
Message-Id: <20191229172732.257750274@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

commit 0df36b90c47d93295b7e393da2d961b2f3b6cde4 upstream.

We need to reset the NIC after setting the bits to enable power
gating and that cannot be done too late in the flow otherwise it
cleans other registers and things that were already configured,
causing initialization to fail.

In order to fix this, move the function to the common code in trans.c
so it can be called directly from there at an earlier point, just
after the reset we already do during initialization.

Fixes: 9a47cb988338 ("iwlwifi: pcie: add workaround for power gating in integrated 22000")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=205719
Cc: stable@ver.kernel.org # 5.4+
Reported-by: Anders Kaseorg <andersk@mit.edu>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c |   25 ---------------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |   30 +++++++++++++++++++
 2 files changed, 30 insertions(+), 25 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -57,24 +57,6 @@
 #include "internal.h"
 #include "fw/dbg.h"
 
-static int iwl_pcie_gen2_force_power_gating(struct iwl_trans *trans)
-{
-	iwl_set_bits_prph(trans, HPM_HIPM_GEN_CFG,
-			  HPM_HIPM_GEN_CFG_CR_FORCE_ACTIVE);
-	udelay(20);
-	iwl_set_bits_prph(trans, HPM_HIPM_GEN_CFG,
-			  HPM_HIPM_GEN_CFG_CR_PG_EN |
-			  HPM_HIPM_GEN_CFG_CR_SLP_EN);
-	udelay(20);
-	iwl_clear_bits_prph(trans, HPM_HIPM_GEN_CFG,
-			    HPM_HIPM_GEN_CFG_CR_FORCE_ACTIVE);
-
-	iwl_trans_sw_reset(trans);
-	iwl_clear_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-
-	return 0;
-}
-
 /*
  * Start up NIC's basic functionality after it has been reset
  * (e.g. after platform boot, or shutdown via iwl_pcie_apm_stop())
@@ -110,13 +92,6 @@ int iwl_pcie_gen2_apm_init(struct iwl_tr
 
 	iwl_pcie_apm_config(trans);
 
-	if (trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_22000 &&
-	    trans->cfg->integrated) {
-		ret = iwl_pcie_gen2_force_power_gating(trans);
-		if (ret)
-			return ret;
-	}
-
 	ret = iwl_finish_nic_init(trans, trans->trans_cfg);
 	if (ret)
 		return ret;
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1783,6 +1783,29 @@ static int iwl_trans_pcie_clear_persiste
 	return 0;
 }
 
+static int iwl_pcie_gen2_force_power_gating(struct iwl_trans *trans)
+{
+	int ret;
+
+	ret = iwl_finish_nic_init(trans, trans->trans_cfg);
+	if (ret < 0)
+		return ret;
+
+	iwl_set_bits_prph(trans, HPM_HIPM_GEN_CFG,
+			  HPM_HIPM_GEN_CFG_CR_FORCE_ACTIVE);
+	udelay(20);
+	iwl_set_bits_prph(trans, HPM_HIPM_GEN_CFG,
+			  HPM_HIPM_GEN_CFG_CR_PG_EN |
+			  HPM_HIPM_GEN_CFG_CR_SLP_EN);
+	udelay(20);
+	iwl_clear_bits_prph(trans, HPM_HIPM_GEN_CFG,
+			    HPM_HIPM_GEN_CFG_CR_FORCE_ACTIVE);
+
+	iwl_trans_pcie_sw_reset(trans);
+
+	return 0;
+}
+
 static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -1802,6 +1825,13 @@ static int _iwl_trans_pcie_start_hw(stru
 
 	iwl_trans_pcie_sw_reset(trans);
 
+	if (trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_22000 &&
+	    trans->cfg->integrated) {
+		err = iwl_pcie_gen2_force_power_gating(trans);
+		if (err)
+			return err;
+	}
+
 	err = iwl_pcie_apm_init(trans);
 	if (err)
 		return err;


