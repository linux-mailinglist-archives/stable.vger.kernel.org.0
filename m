Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5532E412F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439748AbgL1OMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:12:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439728AbgL1OMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82801207B7;
        Mon, 28 Dec 2020 14:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164679;
        bh=WlKXHPw2P3sDA/vXpx6wksKP9ovGFhoBM8z+BDlOdcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+DGDgfKnhU9Pqv2QP9PdVoQJfd6XW4WJ1I3y0B6zrH7bqti20U101QQdev4Jq0dw
         X7eZ++4HHWKKQxNdBqz5FbU33P2uxkK+fUhJc0/jQ1WYR/frvGHty4nWYy5M2AXOeq
         gg32Kshe+C9bd589Vs2JyNuUuUT0yuxdGfiLEsVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 260/717] ath11k: Dont cast ath11k_skb_cb to ieee80211_tx_info.control
Date:   Mon, 28 Dec 2020 13:44:18 +0100
Message-Id: <20201228125033.455513792@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit f4d291b43f809b74c66b21f5190cd578af43070b ]

The driver_data area of ieee80211_tx_info is used in ath11k for
ath11k_skb_cb. The first function in the TX patch which rewrites it to
ath11k_skb_cb is already ath11k_mac_op_tx. No one else in the code path
must use it for something else before it reinitializes it. Otherwise the
data has to be considered uninitialized or corrupt.

But the ieee80211_tx_info.control shares exactly the same area as
ieee80211_tx_info.driver_data and ath11k is still using it. This results in
best case in a

  ath11k c000000.wifi1: no vif found for mgmt frame, flags 0x0

or (slightly worse) in a kernel oops.

Instead, the interesting data must be moved first into the ath11k_skb_cb
and ieee80211_tx_info.control must then not be used anymore.

Tested-on: IPQ8074 hw2.0 WLAN.HK.2.4.0.1.r1-00026-QCAHKSWPL_SILICONZ-2

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201119154235.263250-1-sven@narfation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.h  |  2 ++
 drivers/net/wireless/ath/ath11k/dp_tx.c |  5 ++---
 drivers/net/wireless/ath/ath11k/mac.c   | 26 ++++++++++++++++---------
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index 18b97420f0d8a..5a7915f75e1e2 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -75,12 +75,14 @@ static inline enum wme_ac ath11k_tid_to_ac(u32 tid)
 
 enum ath11k_skb_flags {
 	ATH11K_SKB_HW_80211_ENCAP = BIT(0),
+	ATH11K_SKB_CIPHER_SET = BIT(1),
 };
 
 struct ath11k_skb_cb {
 	dma_addr_t paddr;
 	u8 eid;
 	u8 flags;
+	u32 cipher;
 	struct ath11k *ar;
 	struct ieee80211_vif *vif;
 } __packed;
diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index 3d962eee4d61d..21dfd08d3debb 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -84,7 +84,6 @@ int ath11k_dp_tx(struct ath11k *ar, struct ath11k_vif *arvif,
 	struct ath11k_dp *dp = &ab->dp;
 	struct hal_tx_info ti = {0};
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_key_conf *key = info->control.hw_key;
 	struct ath11k_skb_cb *skb_cb = ATH11K_SKB_CB(skb);
 	struct hal_srng *tcl_ring;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
@@ -149,9 +148,9 @@ tcl_ring_sel:
 	ti.meta_data_flags = arvif->tcl_metadata;
 
 	if (ti.encap_type == HAL_TCL_ENCAP_TYPE_RAW) {
-		if (key) {
+		if (skb_cb->flags & ATH11K_SKB_CIPHER_SET) {
 			ti.encrypt_type =
-				ath11k_dp_tx_get_encrypt_type(key->cipher);
+				ath11k_dp_tx_get_encrypt_type(skb_cb->cipher);
 
 			if (ieee80211_has_protected(hdr->frame_control))
 				skb_put(skb, IEEE80211_CCMP_MIC_LEN);
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index f5e49e1c11ed7..6b7f00e0086f5 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3977,21 +3977,20 @@ static void ath11k_mgmt_over_wmi_tx_purge(struct ath11k *ar)
 static void ath11k_mgmt_over_wmi_tx_work(struct work_struct *work)
 {
 	struct ath11k *ar = container_of(work, struct ath11k, wmi_mgmt_tx_work);
-	struct ieee80211_tx_info *info;
+	struct ath11k_skb_cb *skb_cb;
 	struct ath11k_vif *arvif;
 	struct sk_buff *skb;
 	int ret;
 
 	while ((skb = skb_dequeue(&ar->wmi_mgmt_tx_queue)) != NULL) {
-		info = IEEE80211_SKB_CB(skb);
-		if (!info->control.vif) {
-			ath11k_warn(ar->ab, "no vif found for mgmt frame, flags 0x%x\n",
-				    info->control.flags);
+		skb_cb = ATH11K_SKB_CB(skb);
+		if (!skb_cb->vif) {
+			ath11k_warn(ar->ab, "no vif found for mgmt frame\n");
 			ieee80211_free_txskb(ar->hw, skb);
 			continue;
 		}
 
-		arvif = ath11k_vif_to_arvif(info->control.vif);
+		arvif = ath11k_vif_to_arvif(skb_cb->vif);
 		if (ar->allocated_vdev_map & (1LL << arvif->vdev_id) &&
 		    arvif->is_started) {
 			ret = ath11k_mac_mgmt_tx_wmi(ar, arvif, skb);
@@ -4004,8 +4003,8 @@ static void ath11k_mgmt_over_wmi_tx_work(struct work_struct *work)
 			}
 		} else {
 			ath11k_warn(ar->ab,
-				    "dropping mgmt frame for vdev %d, flags 0x%x is_started %d\n",
-				    arvif->vdev_id, info->control.flags,
+				    "dropping mgmt frame for vdev %d, is_started %d\n",
+				    arvif->vdev_id,
 				    arvif->is_started);
 			ieee80211_free_txskb(ar->hw, skb);
 		}
@@ -4053,10 +4052,19 @@ static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_key_conf *key = info->control.hw_key;
+	u32 info_flags = info->flags;
 	bool is_prb_rsp;
 	int ret;
 
-	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) {
+	skb_cb->vif = vif;
+
+	if (key) {
+		skb_cb->cipher = key->cipher;
+		skb_cb->flags |= ATH11K_SKB_CIPHER_SET;
+	}
+
+	if (info_flags & IEEE80211_TX_CTL_HW_80211_ENCAP) {
 		skb_cb->flags |= ATH11K_SKB_HW_80211_ENCAP;
 	} else if (ieee80211_is_mgmt(hdr->frame_control)) {
 		is_prb_rsp = ieee80211_is_probe_resp(hdr->frame_control);
-- 
2.27.0



