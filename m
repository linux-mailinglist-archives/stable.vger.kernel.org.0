Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1428C201554
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390680AbgFSQVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390332AbgFSPAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:00:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F98421582;
        Fri, 19 Jun 2020 15:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578853;
        bh=kG9t7AnTnL9Y93YN+7mvClU3moEy9xDxPacmFdvK0/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEG/HqgimmwUGs9+3NjZbqh91EDGLUSXQ6fABEPC+QLCMEkvQCH2cJ+R+PR203Wvq
         GnGuj1WFgdVXPfxJMKh2nKVFNKd2MpuGplf6bM1oJdiAvImvZiuzT0UKNcJJvQH0BB
         RKBfUphMnc9UAcnrg8X7wRE/ryqUuPb5aIR8AO6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 154/267] ath10k: Remove msdu from idr when management pkt send fails
Date:   Fri, 19 Jun 2020 16:32:19 +0200
Message-Id: <20200619141656.212900201@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit c730c477176ad4af86d9aae4d360a7ad840b073a ]

Currently when the sending of any management pkt
via wmi command fails, the packet is being unmapped
freed in the error handling. But the idr entry added,
which is used to track these packet is not getting removed.

Hence, during unload, in wmi cleanup, all the entries
in IDR are removed and the corresponding buffer is
attempted to be freed. This can cause a situation where
one packet is attempted to be freed twice.

Fix this error by rmeoving the msdu from the idr
list when the sending of a management packet over
wmi fails.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Fixes: 1807da49733e ("ath10k: wmi: add management tx by reference support over wmi")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1588667015-25490-1-git-send-email-pillair@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c     |  3 +++
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 10 ++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 15 +++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a09d7a07e90a..81af403c19c2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3852,6 +3852,9 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 			if (ret) {
 				ath10k_warn(ar, "failed to transmit management frame by ref via WMI: %d\n",
 					    ret);
+				/* remove this msdu from idr tracking */
+				ath10k_wmi_cleanup_mgmt_tx_send(ar, skb);
+
 				dma_unmap_single(ar->dev, paddr, skb->len,
 						 DMA_TO_DEVICE);
 				ieee80211_free_txskb(ar->hw, skb);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 7fd63bbf8e24..b6cd33fa79f8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -139,6 +139,7 @@ struct wmi_ops {
 	struct sk_buff *(*gen_mgmt_tx_send)(struct ath10k *ar,
 					    struct sk_buff *skb,
 					    dma_addr_t paddr);
+	int (*cleanup_mgmt_tx_send)(struct ath10k *ar, struct sk_buff *msdu);
 	struct sk_buff *(*gen_dbglog_cfg)(struct ath10k *ar, u64 module_enable,
 					  u32 log_level);
 	struct sk_buff *(*gen_pktlog_enable)(struct ath10k *ar, u32 filter);
@@ -431,6 +432,15 @@ ath10k_wmi_get_txbf_conf_scheme(struct ath10k *ar)
 	return ar->wmi.ops->get_txbf_conf_scheme(ar);
 }
 
+static inline int
+ath10k_wmi_cleanup_mgmt_tx_send(struct ath10k *ar, struct sk_buff *msdu)
+{
+	if (!ar->wmi.ops->cleanup_mgmt_tx_send)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->cleanup_mgmt_tx_send(ar, msdu);
+}
+
 static inline int
 ath10k_wmi_mgmt_tx_send(struct ath10k *ar, struct sk_buff *msdu,
 			dma_addr_t paddr)
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 248decb494c2..7f435fa29f75 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2638,6 +2638,18 @@ ath10k_wmi_tlv_op_gen_request_stats(struct ath10k *ar, u32 stats_mask)
 	return skb;
 }
 
+static int
+ath10k_wmi_tlv_op_cleanup_mgmt_tx_send(struct ath10k *ar,
+				       struct sk_buff *msdu)
+{
+	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(msdu);
+	struct ath10k_wmi *wmi = &ar->wmi;
+
+	idr_remove(&wmi->mgmt_pending_tx, cb->msdu_id);
+
+	return 0;
+}
+
 static int
 ath10k_wmi_mgmt_tx_alloc_msdu_id(struct ath10k *ar, struct sk_buff *skb,
 				 dma_addr_t paddr)
@@ -2710,6 +2722,8 @@ ath10k_wmi_tlv_op_gen_mgmt_tx_send(struct ath10k *ar, struct sk_buff *msdu,
 	if (desc_id < 0)
 		goto err_free_skb;
 
+	cb->msdu_id = desc_id;
+
 	ptr = (void *)skb->data;
 	tlv = ptr;
 	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_MGMT_TX_CMD);
@@ -3949,6 +3963,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_force_fw_hang = ath10k_wmi_tlv_op_gen_force_fw_hang,
 	/* .gen_mgmt_tx = not implemented; HTT is used */
 	.gen_mgmt_tx_send = ath10k_wmi_tlv_op_gen_mgmt_tx_send,
+	.cleanup_mgmt_tx_send = ath10k_wmi_tlv_op_cleanup_mgmt_tx_send,
 	.gen_dbglog_cfg = ath10k_wmi_tlv_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_tlv_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_tlv_op_gen_pktlog_disable,
-- 
2.25.1



