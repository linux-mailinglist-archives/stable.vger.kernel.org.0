Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96320353EC8
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhDEJIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237386AbhDEJHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:07:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88BAD613A4;
        Mon,  5 Apr 2021 09:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613661;
        bh=l91+oOfn9miaMHMEuYNcd+ONhbwh/a503oVQiotvaCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLWXFunkfgJLk/duqouOv6+nYhnl4+EwcqGTEXHFPq3+kGmSstdPrZfd15t1EEMlh
         CmAm5mAqRNq6Adxr9DbMSNZ2vJnWF/0Et923L6M5gKQ0Mkl0gK/d+KT8VV6SlGyaw0
         kq4QAAMzKVEtypOICewZS0hucs6s5uYoXf4ZJn3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/126] iwlwifi: pcie: dont disable interrupts for reg_lock
Date:   Mon,  5 Apr 2021 10:53:28 +0200
Message-Id: <20210405085032.567164693@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
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
index 1a222469b5b4..bb990be7c870 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2026,7 +2026,7 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans,
 	int ret;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	spin_lock_irqsave(&trans_pcie->reg_lock, *flags);
+	spin_lock_bh(&trans_pcie->reg_lock);
 
 	if (trans_pcie->cmd_hold_nic_awake)
 		goto out;
@@ -2111,7 +2111,7 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans,
 		}
 
 err:
-		spin_unlock_irqrestore(&trans_pcie->reg_lock, *flags);
+		spin_unlock_bh(&trans_pcie->reg_lock);
 		return false;
 	}
 
@@ -2149,7 +2149,7 @@ static void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans,
 	 * scheduled on different CPUs (after we drop reg_lock).
 	 */
 out:
-	spin_unlock_irqrestore(&trans_pcie->reg_lock, *flags);
+	spin_unlock_bh(&trans_pcie->reg_lock);
 }
 
 static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
@@ -2403,11 +2403,10 @@ static void iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans, u32 reg,
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
index baa83a0b8593..8c7138247869 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -78,7 +78,6 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	struct iwl_txq *txq = trans->txqs.txq[trans->txqs.cmd.q_id];
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
-	unsigned long flags;
 	void *dup_buf = NULL;
 	dma_addr_t phys_addr;
 	int i, cmd_pos, idx;
@@ -291,11 +290,11 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
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
index ed54d04e4396..50133c09a780 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -321,12 +321,10 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
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
 
@@ -931,7 +929,6 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = trans->txqs.txq[txq_id];
-	unsigned long flags;
 	int nfreed = 0;
 	u16 r;
 
@@ -962,9 +959,10 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 	}
 
 	if (txq->read_ptr == txq->write_ptr) {
-		spin_lock_irqsave(&trans_pcie->reg_lock, flags);
+		/* BHs are also disabled due to txq->lock */
+		spin_lock(&trans_pcie->reg_lock);
 		iwl_pcie_clear_cmd_in_flight(trans);
-		spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
+		spin_unlock(&trans_pcie->reg_lock);
 	}
 
 	iwl_pcie_txq_progress(txq);
@@ -1173,7 +1171,6 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	struct iwl_txq *txq = trans->txqs.txq[trans->txqs.cmd.q_id];
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
-	unsigned long flags;
 	void *dup_buf = NULL;
 	dma_addr_t phys_addr;
 	int idx;
@@ -1416,20 +1413,19 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
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



