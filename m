Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9A373CDD
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404605AbfGXT4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404219AbfGXT4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:56:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C51205C9;
        Wed, 24 Jul 2019 19:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998177;
        bh=Mf3nhtCY8W0GCW487qbs/x62W+Llqc0xdZmYO/mdXbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0hWIkBmCDh0CEPU3ZwEkbqGz0O/dzQ8WpfYPwDnfdfQVtiIrSWCOo3GGy1zATmVs
         5UTqezZxCRfYbPOfvEFb2FeHYHpbID3UvJWHXM6KzUPV0txCZnQ9peMbFYKDL7kthH
         mgLfadm4+894b24jJzzz7T+/+EchDrvzRFm7uRlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.1 273/371] iwlwifi: fix RF-Kill interrupt while FW load for gen2 devices
Date:   Wed, 24 Jul 2019 21:20:25 +0200
Message-Id: <20190724191744.884323044@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit ed3e4c6d3cd8f093a3636cb05492429fe2af228d upstream.

Newest devices have a new firmware load mechanism. This
mechanism is called the context info. It means that the
driver doesn't need to load the sections of the firmware.
The driver rather prepares a place in DRAM, with pointers
to the relevant sections of the firmware, and the firmware
loads itself.
At the end of the process, the firmware sends the ALIVE
interrupt. This is different from the previous scheme in
which the driver expected the FH_TX interrupt after each
section being transferred over the DMA.

In order to support this new flow, we enabled all the
interrupts. This broke the assumption that we have in the
code that the RF-Kill interrupt can't interrupt the firmware
load flow.

Change the context info flow to enable only the ALIVE
interrupt, and re-enable all the other interrupts only
after the firmware is alive. Then, we won't see the RF-Kill
interrupt until then. Getting the RF-Kill interrupt while
loading the firmware made us kill the firmware while it is
loading and we ended up dumping garbage instead of the firmware
state.

Re-enable the ALIVE | RX interrupts from the ISR when we
get the ALIVE interrupt to be able to get the RX interrupt
that comes immediately afterwards for the ALIVE
notification. This is needed for non MSI-X only.

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c |    2 -
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c      |    2 -
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h       |   27 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c             |    5 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c     |    9 +++++
 5 files changed, 43 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -168,7 +168,7 @@ int iwl_pcie_ctxt_info_gen3_init(struct
 
 	memcpy(iml_img, trans->iml, trans->iml_len);
 
-	iwl_enable_interrupts(trans);
+	iwl_enable_fw_load_int_ctx_info(trans);
 
 	/* kick FW self load */
 	iwl_write64(trans, CSR_CTXT_INFO_ADDR,
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -222,7 +222,7 @@ int iwl_pcie_ctxt_info_init(struct iwl_t
 
 	trans_pcie->ctxt_info = ctxt_info;
 
-	iwl_enable_interrupts(trans);
+	iwl_enable_fw_load_int_ctx_info(trans);
 
 	/* Configure debug, if exists */
 	if (iwl_pcie_dbg_on(trans))
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -894,6 +894,33 @@ static inline void iwl_enable_fw_load_in
 	}
 }
 
+static inline void iwl_enable_fw_load_int_ctx_info(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	IWL_DEBUG_ISR(trans, "Enabling ALIVE interrupt only\n");
+
+	if (!trans_pcie->msix_enabled) {
+		/*
+		 * When we'll receive the ALIVE interrupt, the ISR will call
+		 * iwl_enable_fw_load_int_ctx_info again to set the ALIVE
+		 * interrupt (which is not really needed anymore) but also the
+		 * RX interrupt which will allow us to receive the ALIVE
+		 * notification (which is Rx) and continue the flow.
+		 */
+		trans_pcie->inta_mask =  CSR_INT_BIT_ALIVE | CSR_INT_BIT_FH_RX;
+		iwl_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
+	} else {
+		iwl_enable_hw_int_msk_msix(trans,
+					   MSIX_HW_INT_CAUSES_REG_ALIVE);
+		/*
+		 * Leave all the FH causes enabled to get the ALIVE
+		 * notification.
+		 */
+		iwl_enable_fh_int_msk_msix(trans, trans_pcie->fh_init_mask);
+	}
+}
+
 static inline u16 iwl_pcie_get_cmd_index(const struct iwl_txq *q, u32 index)
 {
 	return index & (q->n_window - 1);
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1850,6 +1850,8 @@ irqreturn_t iwl_pcie_irq_handler(int irq
 			 */
 			iwl_pcie_rxmq_restock(trans, trans_pcie->rxq);
 		}
+
+		handled |= CSR_INT_BIT_ALIVE;
 	}
 
 	/* Safely ignore these bits for debug checks below */
@@ -1968,6 +1970,9 @@ irqreturn_t iwl_pcie_irq_handler(int irq
 	/* Re-enable RF_KILL if it occurred */
 	else if (handled & CSR_INT_BIT_RF_KILL)
 		iwl_enable_rfkill_int(trans);
+	/* Re-enable the ALIVE / Rx interrupt if it occurred */
+	else if (handled & (CSR_INT_BIT_ALIVE | CSR_INT_BIT_FH_RX))
+		iwl_enable_fw_load_int_ctx_info(trans);
 	spin_unlock(&trans_pcie->irq_lock);
 
 out:
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -272,6 +272,15 @@ void iwl_trans_pcie_gen2_fw_alive(struct
 	 * paging memory cannot be freed included since FW will still use it
 	 */
 	iwl_pcie_ctxt_info_free(trans);
+
+	/*
+	 * Re-enable all the interrupts, including the RF-Kill one, now that
+	 * the firmware is alive.
+	 */
+	iwl_enable_interrupts(trans);
+	mutex_lock(&trans_pcie->mutex);
+	iwl_pcie_check_hw_rf_kill(trans);
+	mutex_unlock(&trans_pcie->mutex);
 }
 
 int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,


