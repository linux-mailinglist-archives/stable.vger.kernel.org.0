Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43192353FBD
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbhDEJOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239619AbhDEJOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:14:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 335EF61002;
        Mon,  5 Apr 2021 09:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614034;
        bh=76KbTauXO6X1afzhOV3OOSUH7oq90LI9nsGXxuINuXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcaLATE2Ce1TlKP9ASWXlGO4AAn/M2dtmaTIUXenF5P/MzHCRQwmtfs4gh+wd+atu
         z9LGmpEtSBRM40B+ldScsxuGxxUZpSrSxLd3fAMbwe8tpDR944sbEsBAsLKzZDzzbb
         vP4slZrvOiEuUECJWY6S9QjjYV3XUUZ+tTbDIqEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 058/152] iwlwifi: pcie: dont disable interrupts for reg_lock
Date:   Mon,  5 Apr 2021 10:53:27 +0200
Message-Id: <20210405085036.163576489@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 874020f8adce535cd318af1768ffe744251b6593 ]

The only thing we do touching the device in hard interrupt context
is, at most, writing an interrupt ACK register, which isn't racing
in with anything protected by the reg_lock.

Thus, avoid disabling interrupts here for potentially long periods
of time, particularly long periods have been observed with dumping
of firmware memory (leading to lockup warnings on some devices.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210210135352.da916ab91298.I064c3e7823b616647293ed97da98edefb9ce9435@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 11 +++++-----
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  5 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 22 ++++++++-----------
 3 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ab93a848a466..e71bc97cb40e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1972,7 +1972,7 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans,
 	int ret;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	spin_lock_irqsave(&trans_pcie->reg_lock, *flags);
+	spin_lock_bh(&trans_pcie->reg_lock);
 
 	if (trans_pcie->cmd_hold_nic_awake)
 		goto out;
@@ -2057,7 +2057,7 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans,
 		}
 
 err:
-		spin_unlock_irqrestore(&trans_pcie->reg_lock, *flags);
+		spin_unlock_bh(&trans_pcie->reg_lock);
 		return false;
 	}
 
@@ -2095,7 +2095,7 @@ static void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans,
 	 * scheduled on different CPUs (after we drop reg_lock).
 	 */
 out:
-	spin_unlock_irqrestore(&trans_pcie->reg_lock, *flags);
+	spin_unlock_bh(&trans_pcie->reg_lock);
 }
 
 static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
@@ -2296,11 +2296,10 @@ static void iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans, u32 reg,
 					 u32 mask, u32 value)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 
-	spin_lock_irqsave(&trans_pcie->reg_lock, flags);
+	spin_lock_bh(&trans_pcie->reg_lock);
 	__iwl_trans_pcie_set_bits_mask(trans, reg, mask, value);
-	spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
+	spin_unlock_bh(&trans_pcie->reg_lock);
 }
 
 static const char *get_csr_string(int cmd)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 8757246a90d5..b9afd9b04042 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -31,7 +31,6 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	struct iwl_txq *txq = trans->txqs.txq[trans->txqs.cmd.q_id];
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
-	unsigned long flags;
 	void *dup_buf = NULL;
 	dma_addr_t phys_addr;
 	int i, cmd_pos, idx;
@@ -244,11 +243,11 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	if (txq->read_ptr == txq->write_ptr && txq->wd_timeout)
 		mod_timer(&txq->stuck_timer, jiffies + txq->wd_timeout);
 
-	spin_lock_irqsave(&trans_pcie->reg_lock, flags);
+	spin_lock(&trans_pcie->reg_lock);
 	/* Increment and update queue's write index */
 	txq->write_ptr = iwl_txq_inc_wrap(trans, txq->write_ptr);
 	iwl_txq_inc_wr_ptr(trans, txq);
-	spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
+	spin_unlock(&trans_pcie->reg_lock);
 
 out:
 	spin_unlock_bh(&txq->lock);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 83f4964f3cb2..689f51968049 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -223,12 +223,10 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 		txq->read_ptr = iwl_txq_inc_wrap(trans, txq->read_ptr);
 
 		if (txq->read_ptr == txq->write_ptr) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&trans_pcie->reg_lock, flags);
+			spin_lock(&trans_pcie->reg_lock);
 			if (txq_id == trans->txqs.cmd.q_id)
 				iwl_pcie_clear_cmd_in_flight(trans);
-			spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
+			spin_unlock(&trans_pcie->reg_lock);
 		}
 	}
 
@@ -679,7 +677,6 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = trans->txqs.txq[txq_id];
-	unsigned long flags;
 	int nfreed = 0;
 	u16 r;
 
@@ -710,9 +707,10 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 	}
 
 	if (txq->read_ptr == txq->write_ptr) {
-		spin_lock_irqsave(&trans_pcie->reg_lock, flags);
+		/* BHs are also disabled due to txq->lock */
+		spin_lock(&trans_pcie->reg_lock);
 		iwl_pcie_clear_cmd_in_flight(trans);
-		spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
+		spin_unlock(&trans_pcie->reg_lock);
 	}
 
 	iwl_txq_progress(txq);
@@ -921,7 +919,6 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	struct iwl_txq *txq = trans->txqs.txq[trans->txqs.cmd.q_id];
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
-	unsigned long flags;
 	void *dup_buf = NULL;
 	dma_addr_t phys_addr;
 	int idx;
@@ -1164,20 +1161,19 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	if (txq->read_ptr == txq->write_ptr && txq->wd_timeout)
 		mod_timer(&txq->stuck_timer, jiffies + txq->wd_timeout);
 
-	spin_lock_irqsave(&trans_pcie->reg_lock, flags);
+	spin_lock(&trans_pcie->reg_lock);
 	ret = iwl_pcie_set_cmd_in_flight(trans, cmd);
 	if (ret < 0) {
 		idx = ret;
-		spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
-		goto out;
+		goto unlock_reg;
 	}
 
 	/* Increment and update queue's write index */
 	txq->write_ptr = iwl_txq_inc_wrap(trans, txq->write_ptr);
 	iwl_pcie_txq_inc_wr_ptr(trans, txq);
 
-	spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
-
+ unlock_reg:
+	spin_unlock(&trans_pcie->reg_lock);
  out:
 	spin_unlock_bh(&txq->lock);
  free_dup_buf:
-- 
2.30.1



