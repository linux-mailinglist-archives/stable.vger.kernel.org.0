Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76157463C
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388270AbfGYFne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:43:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391048AbfGYFne (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:43:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7FFF21880;
        Thu, 25 Jul 2019 05:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033413;
        bh=Lhr6BkMgExe9yw7qvcMi+kaWoADSpYt0EYo8B7SuNaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYhri+8jGGuJloCuPA0zQ6Xc0Wkogf2BjpKx96yqQ1R3eGWmoE8MeKoMwRT2ZUGrR
         rTRGdRzgaBj8/oI/p665LNrpn9zBjP+S18GZn10LyPpXibWHW1a25DtEJIIxQBJdws
         Y4jtI0+t1/8n3soYK/7xW7Z6RdBhTupqwWyy0/Zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 4.19 198/271] iwlwifi: fix RF-Kill interrupt while FW load for gen2 devices
Date:   Wed, 24 Jul 2019 21:21:07 +0200
Message-Id: <20190724191712.070382445@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
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
@@ -164,7 +164,7 @@ int iwl_pcie_ctxt_info_gen3_init(struct
 
 	memcpy(iml_img, trans->iml, trans->iml_len);
 
-	iwl_enable_interrupts(trans);
+	iwl_enable_fw_load_int_ctx_info(trans);
 
 	/* kick FW self load */
 	iwl_write64(trans, CSR_CTXT_INFO_ADDR,
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -206,7 +206,7 @@ int iwl_pcie_ctxt_info_init(struct iwl_t
 
 	trans_pcie->ctxt_info = ctxt_info;
 
-	iwl_enable_interrupts(trans);
+	iwl_enable_fw_load_int_ctx_info(trans);
 
 	/* Configure debug, if exists */
 	if (trans->dbg_dest_tlv)
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -896,6 +896,33 @@ static inline void iwl_enable_fw_load_in
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
@@ -1796,6 +1796,8 @@ irqreturn_t iwl_pcie_irq_handler(int irq
 			 */
 			iwl_pcie_rxmq_restock(trans, trans_pcie->rxq);
 		}
+
+		handled |= CSR_INT_BIT_ALIVE;
 	}
 
 	/* Safely ignore these bits for debug checks below */
@@ -1914,6 +1916,9 @@ irqreturn_t iwl_pcie_irq_handler(int irq
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
@@ -289,6 +289,15 @@ void iwl_trans_pcie_gen2_fw_alive(struct
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


