Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B2433B88F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhCOODw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231866AbhCOOAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 172C064FAB;
        Mon, 15 Mar 2021 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816815;
        bh=hO6yZG1cain8SdkXCW05F7WCHrRiE8TmoVhXnPyDdSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYHXyD32JDMyhG7rcyqKqqUtfmc/fRo1So2PPgXOFrBczw5jt9mU/oY5Y2c3Hg5eB
         QyhnEXuxMGaKoLvh5s35uPXVtKXgAXotWnk9bN2bgeW2THrFAui+cZcKATJSWDuDi2
         33YQGHoXNQUpii6H0/QyaO7zE8Lru7n0GA11KyQo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Huang <cjhuang@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/290] ath11k: start vdev if a bss peer is already created
Date:   Mon, 15 Mar 2021 14:53:42 +0100
Message-Id: <20210315135546.266491278@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Carl Huang <cjhuang@codeaurora.org>

[ Upstream commit aa44b2f3ecd41f90b7e477158036648a49d21a32 ]

For QCA6390, bss peer must be created before vdev is to start. This
change is to start vdev if a bss peer is created. Otherwise, ath11k
delays to start vdev.

This fixes an issue in a case where HT/VHT/HE settings change between
authentication and association, e.g., due to the user space request
to disable HT.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201211051358.9191-1-cjhuang@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c  |  8 ++++++--
 drivers/net/wireless/ath/ath11k/peer.c | 17 +++++++++++++++++
 drivers/net/wireless/ath/ath11k/peer.h |  2 ++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index c8f1b786e746..f3c5023f8a45 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2986,6 +2986,7 @@ static int ath11k_mac_station_add(struct ath11k *ar,
 	}
 
 	if (ab->hw_params.vdev_start_delay &&
+	    !arvif->is_started &&
 	    arvif->vdev_type != WMI_VDEV_TYPE_AP) {
 		ret = ath11k_start_vdev_delay(ar->hw, vif);
 		if (ret) {
@@ -5248,7 +5249,8 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	/* for QCA6390 bss peer must be created before vdev_start */
 	if (ab->hw_params.vdev_start_delay &&
 	    arvif->vdev_type != WMI_VDEV_TYPE_AP &&
-	    arvif->vdev_type != WMI_VDEV_TYPE_MONITOR) {
+	    arvif->vdev_type != WMI_VDEV_TYPE_MONITOR &&
+	    !ath11k_peer_find_by_vdev_id(ab, arvif->vdev_id)) {
 		memcpy(&arvif->chanctx, ctx, sizeof(*ctx));
 		ret = 0;
 		goto out;
@@ -5259,7 +5261,9 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	if (ab->hw_params.vdev_start_delay) {
+	if (ab->hw_params.vdev_start_delay &&
+	    (arvif->vdev_type == WMI_VDEV_TYPE_AP ||
+	    arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)) {
 		param.vdev_id = arvif->vdev_id;
 		param.peer_type = WMI_PEER_TYPE_DEFAULT;
 		param.peer_addr = ar->mac_addr;
diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
index 1866d82678fa..b69e7ebfa930 100644
--- a/drivers/net/wireless/ath/ath11k/peer.c
+++ b/drivers/net/wireless/ath/ath11k/peer.c
@@ -76,6 +76,23 @@ struct ath11k_peer *ath11k_peer_find_by_id(struct ath11k_base *ab,
 	return NULL;
 }
 
+struct ath11k_peer *ath11k_peer_find_by_vdev_id(struct ath11k_base *ab,
+						int vdev_id)
+{
+	struct ath11k_peer *peer;
+
+	spin_lock_bh(&ab->base_lock);
+
+	list_for_each_entry(peer, &ab->peers, list) {
+		if (vdev_id == peer->vdev_id) {
+			spin_unlock_bh(&ab->base_lock);
+			return peer;
+		}
+	}
+	spin_unlock_bh(&ab->base_lock);
+	return NULL;
+}
+
 void ath11k_peer_unmap_event(struct ath11k_base *ab, u16 peer_id)
 {
 	struct ath11k_peer *peer;
diff --git a/drivers/net/wireless/ath/ath11k/peer.h b/drivers/net/wireless/ath/ath11k/peer.h
index bba2e00b6944..8553ed061aea 100644
--- a/drivers/net/wireless/ath/ath11k/peer.h
+++ b/drivers/net/wireless/ath/ath11k/peer.h
@@ -43,5 +43,7 @@ int ath11k_peer_create(struct ath11k *ar, struct ath11k_vif *arvif,
 		       struct ieee80211_sta *sta, struct peer_create_params *param);
 int ath11k_wait_for_peer_delete_done(struct ath11k *ar, u32 vdev_id,
 				     const u8 *addr);
+struct ath11k_peer *ath11k_peer_find_by_vdev_id(struct ath11k_base *ab,
+						int vdev_id);
 
 #endif /* _PEER_H_ */
-- 
2.30.1



