Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE14150CD8
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbgBCQhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731286AbgBCQhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:37:09 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B33F2082E;
        Mon,  3 Feb 2020 16:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747827;
        bh=8oTS5n9CLDVGSryj173Q2ci7xCTiqwQ0QEBrWInXmek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cn9U5XMwPH9vNS0THB0KxdmbyKIJGDKOpZ/o0aTQjFbV/xm4hVffe+Vs5is3ghR+/
         tnVlk3E9fQvwJkyv35Ic8M2j2vLcSeyhz1REgK7e0W8rVofPPaT0M6yNiwCZ7uHNGg
         HT3qERNuNENWTwQwbPfDgFN3XEX3tq9/fsojyreM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 60/90] iwlwifi: pcie: allocate smaller dev_cmd for TX headers
Date:   Mon,  3 Feb 2020 16:20:03 +0000
Message-Id: <20200203161924.922125996@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a89c72ffd07369f5ccc74f0332d2785a7077241d ]

As noted in the previous commit, due to the way we allocate the
dev_cmd headers with 324 byte size, and 4/8 byte alignment, the
part we use of them (bytes 20..40-68) could still cross a page
and thus 2^32 boundary.

Address this by using alignment to ensure that the allocation
cannot cross a page boundary, on hardware that's affected. To
make that not cause more memory consumption, reduce the size of
the allocations to the necessary size - we go from 324 bytes in
each allocation to 60/68 on gen2 depending on family, and ~120
or so on gen1 (so on gen1 it's a pure reduction in size, since
we don't need alignment there).

To avoid size and clearing issues, add a new structure that's
just the header, and use kmem_cache_zalloc().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c   |  3 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    | 10 +++---
 .../net/wireless/intel/iwlwifi/iwl-trans.h    | 26 +++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 15 +++------
 .../wireless/intel/iwlwifi/pcie/internal.h    |  6 ++--
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 32 ++++++++++++++-----
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 21 ++++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 20 ++++++------
 8 files changed, 84 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
index 3029e3f6de63b..621cd7206b7c7 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -267,7 +267,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_station_priv *sta_priv = NULL;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwl_device_cmd *dev_cmd;
+	struct iwl_device_tx_cmd *dev_cmd;
 	struct iwl_tx_cmd *tx_cmd;
 	__le16 fc;
 	u8 hdr_len;
@@ -348,7 +348,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 	if (unlikely(!dev_cmd))
 		goto drop_unlock_priv;
 
-	memset(dev_cmd, 0, sizeof(*dev_cmd));
 	dev_cmd->hdr.cmd = REPLY_TX;
 	tx_cmd = (struct iwl_tx_cmd *) dev_cmd->payload;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 28bdc9a9617eb..f91197e4ae402 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -66,7 +66,9 @@
 
 struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 				  struct device *dev,
-				  const struct iwl_trans_ops *ops)
+				  const struct iwl_trans_ops *ops,
+				  unsigned int cmd_pool_size,
+				  unsigned int cmd_pool_align)
 {
 	struct iwl_trans *trans;
 #ifdef CONFIG_LOCKDEP
@@ -90,10 +92,8 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 		 "iwl_cmd_pool:%s", dev_name(trans->dev));
 	trans->dev_cmd_pool =
 		kmem_cache_create(trans->dev_cmd_pool_name,
-				  sizeof(struct iwl_device_cmd),
-				  sizeof(void *),
-				  SLAB_HWCACHE_ALIGN,
-				  NULL);
+				  cmd_pool_size, cmd_pool_align,
+				  SLAB_HWCACHE_ALIGN, NULL);
 	if (!trans->dev_cmd_pool)
 		return NULL;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index a31408188ed05..1e85d59b91613 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -193,6 +193,18 @@ struct iwl_device_cmd {
 	};
 } __packed;
 
+/**
+ * struct iwl_device_tx_cmd - buffer for TX command
+ * @hdr: the header
+ * @payload: the payload placeholder
+ *
+ * The actual structure is sized dynamically according to need.
+ */
+struct iwl_device_tx_cmd {
+	struct iwl_cmd_header hdr;
+	u8 payload[];
+} __packed;
+
 #define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_device_cmd))
 
 /*
@@ -544,7 +556,7 @@ struct iwl_trans_ops {
 	int (*send_cmd)(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 
 	int (*tx)(struct iwl_trans *trans, struct sk_buff *skb,
-		  struct iwl_device_cmd *dev_cmd, int queue);
+		  struct iwl_device_tx_cmd *dev_cmd, int queue);
 	void (*reclaim)(struct iwl_trans *trans, int queue, int ssn,
 			struct sk_buff_head *skbs);
 
@@ -921,22 +933,22 @@ iwl_trans_dump_data(struct iwl_trans *trans, u32 dump_mask)
 	return trans->ops->dump_data(trans, dump_mask);
 }
 
-static inline struct iwl_device_cmd *
+static inline struct iwl_device_tx_cmd *
 iwl_trans_alloc_tx_cmd(struct iwl_trans *trans)
 {
-	return kmem_cache_alloc(trans->dev_cmd_pool, GFP_ATOMIC);
+	return kmem_cache_zalloc(trans->dev_cmd_pool, GFP_ATOMIC);
 }
 
 int iwl_trans_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 
 static inline void iwl_trans_free_tx_cmd(struct iwl_trans *trans,
-					 struct iwl_device_cmd *dev_cmd)
+					 struct iwl_device_tx_cmd *dev_cmd)
 {
 	kmem_cache_free(trans->dev_cmd_pool, dev_cmd);
 }
 
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
-			       struct iwl_device_cmd *dev_cmd, int queue)
+			       struct iwl_device_tx_cmd *dev_cmd, int queue)
 {
 	if (unlikely(test_bit(STATUS_FW_ERROR, &trans->status)))
 		return -EIO;
@@ -1239,7 +1251,9 @@ static inline bool iwl_trans_dbg_ini_valid(struct iwl_trans *trans)
  *****************************************************/
 struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 				  struct device *dev,
-				  const struct iwl_trans_ops *ops);
+				  const struct iwl_trans_ops *ops,
+				  unsigned int cmd_pool_size,
+				  unsigned int cmd_pool_align);
 void iwl_trans_free(struct iwl_trans *trans);
 
 /*****************************************************
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index d9d82f6b5e875..2b92980a49e68 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -487,13 +487,13 @@ static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
 /*
  * Allocates and sets the Tx cmd the driver data pointers in the skb
  */
-static struct iwl_device_cmd *
+static struct iwl_device_tx_cmd *
 iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 		      struct ieee80211_tx_info *info, int hdrlen,
 		      struct ieee80211_sta *sta, u8 sta_id)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct iwl_device_cmd *dev_cmd;
+	struct iwl_device_tx_cmd *dev_cmd;
 	struct iwl_tx_cmd *tx_cmd;
 
 	dev_cmd = iwl_trans_alloc_tx_cmd(mvm->trans);
@@ -501,11 +501,6 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (unlikely(!dev_cmd))
 		return NULL;
 
-	/* Make sure we zero enough of dev_cmd */
-	BUILD_BUG_ON(sizeof(struct iwl_tx_cmd_gen2) > sizeof(*tx_cmd));
-	BUILD_BUG_ON(sizeof(struct iwl_tx_cmd_gen3) > sizeof(*tx_cmd));
-
-	memset(dev_cmd, 0, sizeof(dev_cmd->hdr) + sizeof(*tx_cmd));
 	dev_cmd->hdr.cmd = TX_CMD;
 
 	if (iwl_mvm_has_new_tx_api(mvm)) {
@@ -594,7 +589,7 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 }
 
 static void iwl_mvm_skb_prepare_status(struct sk_buff *skb,
-				       struct iwl_device_cmd *cmd)
+				       struct iwl_device_tx_cmd *cmd)
 {
 	struct ieee80211_tx_info *skb_info = IEEE80211_SKB_CB(skb);
 
@@ -713,7 +708,7 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info info;
-	struct iwl_device_cmd *dev_cmd;
+	struct iwl_device_tx_cmd *dev_cmd;
 	u8 sta_id;
 	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	__le16 fc = hdr->frame_control;
@@ -1075,7 +1070,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct iwl_mvm_sta *mvmsta;
-	struct iwl_device_cmd *dev_cmd;
+	struct iwl_device_tx_cmd *dev_cmd;
 	__le16 fc;
 	u16 seq_number = 0;
 	u8 tid = IWL_MAX_TID_COUNT;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 1047d48beaa5d..9b5b96e34456f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -305,7 +305,7 @@ struct iwl_cmd_meta {
 #define IWL_FIRST_TB_SIZE_ALIGN ALIGN(IWL_FIRST_TB_SIZE, 64)
 
 struct iwl_pcie_txq_entry {
-	struct iwl_device_cmd *cmd;
+	void *cmd;
 	struct sk_buff *skb;
 	/* buffer to free after command completes */
 	const void *free_buf;
@@ -690,7 +690,7 @@ void iwl_trans_pcie_txq_set_shared_mode(struct iwl_trans *trans, u32 txq_id,
 void iwl_trans_pcie_log_scd_error(struct iwl_trans *trans,
 				  struct iwl_txq *txq);
 int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
-		      struct iwl_device_cmd *dev_cmd, int txq_id);
+		      struct iwl_device_tx_cmd *dev_cmd, int txq_id);
 void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans);
 int iwl_trans_pcie_send_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx);
@@ -1111,7 +1111,7 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 				 unsigned int timeout);
 void iwl_trans_pcie_dyn_txq_free(struct iwl_trans *trans, int queue);
 int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
-			   struct iwl_device_cmd *dev_cmd, int txq_id);
+			   struct iwl_device_tx_cmd *dev_cmd, int txq_id);
 int iwl_trans_pcie_gen2_send_hcmd(struct iwl_trans *trans,
 				  struct iwl_host_cmd *cmd);
 void iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index d3db38c3095be..c76d26708e659 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -79,6 +79,7 @@
 #include "iwl-agn-hw.h"
 #include "fw/error-dump.h"
 #include "fw/dbg.h"
+#include "fw/api/tx.h"
 #include "internal.h"
 #include "iwl-fh.h"
 
@@ -3462,19 +3463,34 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 {
 	struct iwl_trans_pcie *trans_pcie;
 	struct iwl_trans *trans;
-	int ret, addr_size;
+	int ret, addr_size, txcmd_size, txcmd_align;
+	const struct iwl_trans_ops *ops = &trans_ops_pcie_gen2;
+
+	if (!cfg_trans->gen2) {
+		ops = &trans_ops_pcie;
+		txcmd_size = sizeof(struct iwl_tx_cmd);
+		txcmd_align = sizeof(void *);
+	} else if (cfg_trans->device_family < IWL_DEVICE_FAMILY_AX210) {
+		txcmd_size = sizeof(struct iwl_tx_cmd_gen2);
+		txcmd_align = 64;
+	} else {
+		txcmd_size = sizeof(struct iwl_tx_cmd_gen3);
+		txcmd_align = 128;
+	}
+
+	txcmd_size += sizeof(struct iwl_cmd_header);
+	txcmd_size += 36; /* biggest possible 802.11 header */
+
+	/* Ensure device TX cmd cannot reach/cross a page boundary in gen2 */
+	if (WARN_ON(cfg_trans->gen2 && txcmd_size >= txcmd_align))
+		return ERR_PTR(-EINVAL);
 
 	ret = pcim_enable_device(pdev);
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (cfg_trans->gen2)
-		trans = iwl_trans_alloc(sizeof(struct iwl_trans_pcie),
-					&pdev->dev, &trans_ops_pcie_gen2);
-	else
-		trans = iwl_trans_alloc(sizeof(struct iwl_trans_pcie),
-					&pdev->dev, &trans_ops_pcie);
-
+	trans = iwl_trans_alloc(sizeof(struct iwl_trans_pcie), &pdev->dev, ops,
+				txcmd_size, txcmd_align);
 	if (!trans)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 97cb3a8d505cd..ff4c34d7b74f7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -243,7 +243,8 @@ static int iwl_pcie_gen2_set_tb(struct iwl_trans *trans,
 static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 				     struct sk_buff *skb,
 				     struct iwl_tfh_tfd *tfd, int start_len,
-				     u8 hdr_len, struct iwl_device_cmd *dev_cmd)
+				     u8 hdr_len,
+				     struct iwl_device_tx_cmd *dev_cmd)
 {
 #ifdef CONFIG_INET
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -371,7 +372,7 @@ static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 static struct
 iwl_tfh_tfd *iwl_pcie_gen2_build_tx_amsdu(struct iwl_trans *trans,
 					  struct iwl_txq *txq,
-					  struct iwl_device_cmd *dev_cmd,
+					  struct iwl_device_tx_cmd *dev_cmd,
 					  struct sk_buff *skb,
 					  struct iwl_cmd_meta *out_meta,
 					  int hdr_len,
@@ -403,6 +404,10 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx_amsdu(struct iwl_trans *trans,
 	tb_phys = dma_map_single(trans->dev, tb1_addr, len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
 		goto out_err;
+	/*
+	 * No need for _with_wa(), we ensure (via alignment) that the data
+	 * here can never cross or end at a page boundary.
+	 */
 	iwl_pcie_gen2_set_tb(trans, tfd, tb_phys, len);
 
 	if (iwl_pcie_gen2_build_amsdu(trans, skb, tfd,
@@ -456,7 +461,7 @@ static int iwl_pcie_gen2_tx_add_frags(struct iwl_trans *trans,
 static struct
 iwl_tfh_tfd *iwl_pcie_gen2_build_tx(struct iwl_trans *trans,
 				    struct iwl_txq *txq,
-				    struct iwl_device_cmd *dev_cmd,
+				    struct iwl_device_tx_cmd *dev_cmd,
 				    struct sk_buff *skb,
 				    struct iwl_cmd_meta *out_meta,
 				    int hdr_len,
@@ -496,6 +501,10 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx(struct iwl_trans *trans,
 	tb_phys = dma_map_single(trans->dev, tb1_addr, tb1_len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
 		goto out_err;
+	/*
+	 * No need for _with_wa(), we ensure (via alignment) that the data
+	 * here can never cross or end at a page boundary.
+	 */
 	iwl_pcie_gen2_set_tb(trans, tfd, tb_phys, tb1_len);
 	trace_iwlwifi_dev_tx(trans->dev, skb, tfd, sizeof(*tfd), &dev_cmd->hdr,
 			     IWL_FIRST_TB_SIZE + tb1_len, hdr_len);
@@ -540,7 +549,7 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx(struct iwl_trans *trans,
 static
 struct iwl_tfh_tfd *iwl_pcie_gen2_build_tfd(struct iwl_trans *trans,
 					    struct iwl_txq *txq,
-					    struct iwl_device_cmd *dev_cmd,
+					    struct iwl_device_tx_cmd *dev_cmd,
 					    struct sk_buff *skb,
 					    struct iwl_cmd_meta *out_meta)
 {
@@ -580,7 +589,7 @@ struct iwl_tfh_tfd *iwl_pcie_gen2_build_tfd(struct iwl_trans *trans,
 }
 
 int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
-			   struct iwl_device_cmd *dev_cmd, int txq_id)
+			   struct iwl_device_tx_cmd *dev_cmd, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_cmd_meta *out_meta;
@@ -605,7 +614,7 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 		/* don't put the packet on the ring, if there is no room */
 		if (unlikely(iwl_queue_space(trans, txq) < 3)) {
-			struct iwl_device_cmd **dev_cmd_ptr;
+			struct iwl_device_tx_cmd **dev_cmd_ptr;
 
 			dev_cmd_ptr = (void *)((u8 *)skb->cb +
 					       trans_pcie->dev_cmd_offs);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 4806a04cec8c4..d3b58334e13ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -213,8 +213,8 @@ static void iwl_pcie_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 	u8 sec_ctl = 0;
 	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 	__le16 bc_ent;
-	struct iwl_tx_cmd *tx_cmd =
-		(void *)txq->entries[txq->write_ptr].cmd->payload;
+	struct iwl_device_tx_cmd *dev_cmd = txq->entries[txq->write_ptr].cmd;
+	struct iwl_tx_cmd *tx_cmd = (void *)dev_cmd->payload;
 	u8 sta_id = tx_cmd->sta_id;
 
 	scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
@@ -257,8 +257,8 @@ static void iwl_pcie_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
 	int read_ptr = txq->read_ptr;
 	u8 sta_id = 0;
 	__le16 bc_ent;
-	struct iwl_tx_cmd *tx_cmd =
-		(void *)txq->entries[read_ptr].cmd->payload;
+	struct iwl_device_tx_cmd *dev_cmd = txq->entries[read_ptr].cmd;
+	struct iwl_tx_cmd *tx_cmd = (void *)dev_cmd->payload;
 
 	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
 
@@ -1196,7 +1196,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 		while (!skb_queue_empty(&overflow_skbs)) {
 			struct sk_buff *skb = __skb_dequeue(&overflow_skbs);
-			struct iwl_device_cmd *dev_cmd_ptr;
+			struct iwl_device_tx_cmd *dev_cmd_ptr;
 
 			dev_cmd_ptr = *(void **)((u8 *)skb->cb +
 						 trans_pcie->dev_cmd_offs);
@@ -2099,7 +2099,8 @@ static void iwl_compute_pseudo_hdr_csum(void *iph, struct tcphdr *tcph,
 static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 				   struct iwl_txq *txq, u8 hdr_len,
 				   struct iwl_cmd_meta *out_meta,
-				   struct iwl_device_cmd *dev_cmd, u16 tb1_len)
+				   struct iwl_device_tx_cmd *dev_cmd,
+				   u16 tb1_len)
 {
 	struct iwl_tx_cmd *tx_cmd = (void *)dev_cmd->payload;
 	struct iwl_trans_pcie *trans_pcie = txq->trans_pcie;
@@ -2281,7 +2282,8 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 				   struct iwl_txq *txq, u8 hdr_len,
 				   struct iwl_cmd_meta *out_meta,
-				   struct iwl_device_cmd *dev_cmd, u16 tb1_len)
+				   struct iwl_device_tx_cmd *dev_cmd,
+				   u16 tb1_len)
 {
 	/* No A-MSDU without CONFIG_INET */
 	WARN_ON(1);
@@ -2291,7 +2293,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 #endif /* CONFIG_INET */
 
 int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
-		      struct iwl_device_cmd *dev_cmd, int txq_id)
+		      struct iwl_device_tx_cmd *dev_cmd, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct ieee80211_hdr *hdr;
@@ -2348,7 +2350,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 		/* don't put the packet on the ring, if there is no room */
 		if (unlikely(iwl_queue_space(trans, txq) < 3)) {
-			struct iwl_device_cmd **dev_cmd_ptr;
+			struct iwl_device_tx_cmd **dev_cmd_ptr;
 
 			dev_cmd_ptr = (void *)((u8 *)skb->cb +
 					       trans_pcie->dev_cmd_offs);
-- 
2.20.1



