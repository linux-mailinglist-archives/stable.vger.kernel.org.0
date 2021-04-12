Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A00735BF60
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237970AbhDLJGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238399AbhDLJCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:02:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D05F861207;
        Mon, 12 Apr 2021 09:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218041;
        bh=gLUIuEpYwlpOlFUPuzXAFx6I7OuCt8QpiuA7uwQG5Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDt3LiWgj1YwnJk9T2XeNKjfj1B8H1essnWQ6i6xVAjgB8hk4X6b162nk4heQS+SK
         rO6uL7wRZ+kbE0cwObzArtd0eku4nGuIsVfhzXI0jTgQ1hVfPuBzBaAF4bDjU3Z4iW
         t5V0T/NJuSxCbbHkKWU9soum6CHuiHIGzdgeX9R8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.11 048/210] iwlwifi: pcie: properly set LTR workarounds on 22000 devices
Date:   Mon, 12 Apr 2021 10:39:13 +0200
Message-Id: <20210412084017.611304212@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 25628bc08d4526d3673ca7d039eb636aa9006076 upstream.

As the context info gen3 code is only called for >=AX210 devices
(from iwl_trans_pcie_gen2_start_fw()) the code there to set LTR
on 22000 devices cannot actually do anything (22000 < AX210).

Fix this by moving the LTR code to iwl_trans_pcie_gen2_start_fw()
where it can handle both devices. This then requires that we kick
the firmware only after that rather than doing it from the context
info code.

Note that this again had a dead branch in gen3 code, which I've
removed here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: ed0022da8bd9 ("iwlwifi: pcie: set LTR on more devices")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210326125611.675486178ed1.Ib61463aba6920645059e366dcdca4c4c77f0ff58@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c |   31 -------------
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c      |    3 -
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c     |   35 +++++++++++++++
 3 files changed, 37 insertions(+), 32 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 #include "iwl-trans.h"
 #include "iwl-fh.h"
@@ -75,15 +75,6 @@ int iwl_pcie_ctxt_info_gen3_init(struct
 				 const struct fw_img *fw)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u32 ltr_val = CSR_LTR_LONG_VAL_AD_NO_SNOOP_REQ |
-		      u32_encode_bits(CSR_LTR_LONG_VAL_AD_SCALE_USEC,
-				      CSR_LTR_LONG_VAL_AD_NO_SNOOP_SCALE) |
-		      u32_encode_bits(250,
-				      CSR_LTR_LONG_VAL_AD_NO_SNOOP_VAL) |
-		      CSR_LTR_LONG_VAL_AD_SNOOP_REQ |
-		      u32_encode_bits(CSR_LTR_LONG_VAL_AD_SCALE_USEC,
-				      CSR_LTR_LONG_VAL_AD_SNOOP_SCALE) |
-		      u32_encode_bits(250, CSR_LTR_LONG_VAL_AD_SNOOP_VAL);
 	struct iwl_context_info_gen3 *ctxt_info_gen3;
 	struct iwl_prph_scratch *prph_scratch;
 	struct iwl_prph_scratch_ctrl_cfg *prph_sc_ctrl;
@@ -217,26 +208,6 @@ int iwl_pcie_ctxt_info_gen3_init(struct
 	iwl_set_bit(trans, CSR_CTXT_INFO_BOOT_CTRL,
 		    CSR_AUTO_FUNC_BOOT_ENA);
 
-	/*
-	 * To workaround hardware latency issues during the boot process,
-	 * initialize the LTR to ~250 usec (see ltr_val above).
-	 * The firmware initializes this again later (to a smaller value).
-	 */
-	if ((trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_AX210 ||
-	     trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_22000) &&
-	    !trans->trans_cfg->integrated) {
-		iwl_write32(trans, CSR_LTR_LONG_VAL_AD, ltr_val);
-	} else if (trans->trans_cfg->integrated &&
-		   trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_22000) {
-		iwl_write_prph(trans, HPM_MAC_LTR_CSR, HPM_MAC_LRT_ENABLE_ALL);
-		iwl_write_prph(trans, HPM_UMAC_LTR, ltr_val);
-	}
-
-	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210)
-		iwl_write_umac_prph(trans, UREG_CPU_INIT_RUN, 1);
-	else
-		iwl_set_bit(trans, CSR_GP_CNTRL, CSR_AUTO_FUNC_INIT);
-
 	return 0;
 
 err_free_ctxt_info:
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 #include "iwl-trans.h"
 #include "iwl-fh.h"
@@ -240,7 +240,6 @@ int iwl_pcie_ctxt_info_init(struct iwl_t
 
 	/* kick FW self load */
 	iwl_write64(trans, CSR_CTXT_INFO_BA, trans_pcie->ctxt_info_dma_addr);
-	iwl_write_prph(trans, UREG_CPU_INIT_RUN, 1);
 
 	/* Context info will be released upon alive or failure to get one */
 
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -260,6 +260,34 @@ void iwl_trans_pcie_gen2_fw_alive(struct
 	mutex_unlock(&trans_pcie->mutex);
 }
 
+static void iwl_pcie_set_ltr(struct iwl_trans *trans)
+{
+	u32 ltr_val = CSR_LTR_LONG_VAL_AD_NO_SNOOP_REQ |
+		      u32_encode_bits(CSR_LTR_LONG_VAL_AD_SCALE_USEC,
+				      CSR_LTR_LONG_VAL_AD_NO_SNOOP_SCALE) |
+		      u32_encode_bits(250,
+				      CSR_LTR_LONG_VAL_AD_NO_SNOOP_VAL) |
+		      CSR_LTR_LONG_VAL_AD_SNOOP_REQ |
+		      u32_encode_bits(CSR_LTR_LONG_VAL_AD_SCALE_USEC,
+				      CSR_LTR_LONG_VAL_AD_SNOOP_SCALE) |
+		      u32_encode_bits(250, CSR_LTR_LONG_VAL_AD_SNOOP_VAL);
+
+	/*
+	 * To workaround hardware latency issues during the boot process,
+	 * initialize the LTR to ~250 usec (see ltr_val above).
+	 * The firmware initializes this again later (to a smaller value).
+	 */
+	if ((trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_AX210 ||
+	     trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_22000) &&
+	    !trans->trans_cfg->integrated) {
+		iwl_write32(trans, CSR_LTR_LONG_VAL_AD, ltr_val);
+	} else if (trans->trans_cfg->integrated &&
+		   trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_22000) {
+		iwl_write_prph(trans, HPM_MAC_LTR_CSR, HPM_MAC_LRT_ENABLE_ALL);
+		iwl_write_prph(trans, HPM_UMAC_LTR, ltr_val);
+	}
+}
+
 int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 				 const struct fw_img *fw, bool run_in_rfkill)
 {
@@ -326,6 +354,13 @@ int iwl_trans_pcie_gen2_start_fw(struct
 	if (ret)
 		goto out;
 
+	iwl_pcie_set_ltr(trans);
+
+	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210)
+		iwl_write_umac_prph(trans, UREG_CPU_INIT_RUN, 1);
+	else
+		iwl_write_prph(trans, UREG_CPU_INIT_RUN, 1);
+
 	/* re-check RF-Kill state since we may have missed the interrupt */
 	hw_rfkill = iwl_pcie_check_hw_rf_kill(trans);
 	if (hw_rfkill && !run_in_rfkill)


