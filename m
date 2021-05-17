Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF84F382EF0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238666AbhEQOLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238275AbhEQOJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:09:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 751506135C;
        Mon, 17 May 2021 14:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260426;
        bh=rvik31wNCtC9gMOzvh2YCdENR358Ai1yNdp2L2ZWotY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deYepTfuRY5YAqzYN0ZObmTZDEENJT8aegIz0I4U96f7RD/m5WAFTOLppel/i/Qfr
         joKcYQCYE2nLWbcmF1PpTVndfOD/JHHq1tlR47HUdw0/57asSdaMvf1Jam7atTBYD7
         9iL7P45LKwA+is4Kwjs1pB5vUsupQYfX9UzjG2J8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 077/363] iwlwifi: queue: avoid memory leak in reset flow
Date:   Mon, 17 May 2021 15:59:03 +0200
Message-Id: <20210517140305.196019382@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit 4cf2f5904d971a461f67825434ae3c31900ff84b ]

In case the device is stopped any usage of hw queues needs to be
reallocated in fw due to fw reset after device stop, so all driver
internal queue should also be freed, and if we don't free the next usage
would leak the old memory and get in recover flows
"iwlwifi 0000:00:03.0: dma_pool_destroy iwlwifi:bc" warning.

Also warn about trying to reuse an internal allocated queue.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210411124417.c72d2f0355c4.Ia3baff633b9b9109f88ab379ef0303aa152c16bf@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  4 +--
 drivers/net/wireless/intel/iwlwifi/queue/tx.c | 30 ++++---------------
 drivers/net/wireless/intel/iwlwifi/queue/tx.h |  3 +-
 3 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 94ffc1ae484d..af9412bd697e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 #include "iwl-trans.h"
 #include "iwl-prph.h"
@@ -143,7 +143,7 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans)
 	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
 		IWL_DEBUG_INFO(trans,
 			       "DEVICE_ENABLED bit was set and is now cleared\n");
-		iwl_txq_gen2_tx_stop(trans);
+		iwl_txq_gen2_tx_free(trans);
 		iwl_pcie_rx_stop(trans);
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.c b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
index 833f43d1ca7a..810dcb3df242 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
@@ -13,30 +13,6 @@
 #include "iwl-scd.h"
 #include <linux/dmapool.h>
 
-/*
- * iwl_txq_gen2_tx_stop - Stop all Tx DMA channels
- */
-void iwl_txq_gen2_tx_stop(struct iwl_trans *trans)
-{
-	int txq_id;
-
-	/*
-	 * This function can be called before the op_mode disabled the
-	 * queues. This happens when we have an rfkill interrupt.
-	 * Since we stop Tx altogether - mark the queues as stopped.
-	 */
-	memset(trans->txqs.queue_stopped, 0,
-	       sizeof(trans->txqs.queue_stopped));
-	memset(trans->txqs.queue_used, 0, sizeof(trans->txqs.queue_used));
-
-	/* Unmap DMA from host system and free skb's */
-	for (txq_id = 0; txq_id < ARRAY_SIZE(trans->txqs.txq); txq_id++) {
-		if (!trans->txqs.txq[txq_id])
-			continue;
-		iwl_txq_gen2_unmap(trans, txq_id);
-	}
-}
-
 /*
  * iwl_txq_update_byte_tbl - Set up entry in Tx byte-count array
  */
@@ -1189,6 +1165,12 @@ static int iwl_txq_alloc_response(struct iwl_trans *trans, struct iwl_txq *txq,
 		goto error_free_resp;
 	}
 
+	if (WARN_ONCE(trans->txqs.txq[qid],
+		      "queue %d already allocated\n", qid)) {
+		ret = -EIO;
+		goto error_free_resp;
+	}
+
 	txq->id = qid;
 	trans->txqs.txq[qid] = txq;
 	wr_ptr &= (trans->trans_cfg->base_params->max_tfd_queue_size - 1);
diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.h b/drivers/net/wireless/intel/iwlwifi/queue/tx.h
index af1dbdf5617a..20efc62acf13 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2020 Intel Corporation
+ * Copyright (C) 2020-2021 Intel Corporation
  */
 #ifndef __iwl_trans_queue_tx_h__
 #define __iwl_trans_queue_tx_h__
@@ -123,7 +123,6 @@ int iwl_txq_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 void iwl_txq_dyn_free(struct iwl_trans *trans, int queue);
 void iwl_txq_gen2_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq);
 void iwl_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq);
-void iwl_txq_gen2_tx_stop(struct iwl_trans *trans);
 void iwl_txq_gen2_tx_free(struct iwl_trans *trans);
 int iwl_txq_init(struct iwl_trans *trans, struct iwl_txq *txq, int slots_num,
 		 bool cmd_queue);
-- 
2.30.2



