Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D629A33B893
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhCOODz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233028AbhCOOAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B8AE64F4B;
        Mon, 15 Mar 2021 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816813;
        bh=cVqynOJDFRJZW692g2gKwamZGseGvNVXmtaIOGX8ERg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjWiQBbKje6iITl5ZEwuywf46tlBQaZPi241V/YFGQLYZVTngOA6fo/AExhYJ95U7
         89knkxM9fTW32/xhxjDc6l6SzNvyqqHaHycodm/yqtUOzlUaj0tP0i83+eE7DY9hBa
         aNfxoTKhqxfOYirCersu0q9BLM/VSctA+rMqiLCs=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ritesh Singh <ritesi@codeaurora.org>,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/290] ath11k: peer delete synchronization with firmware
Date:   Mon, 15 Mar 2021 14:53:41 +0100
Message-Id: <20210315135546.236777857@linuxfoundation.org>
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

From: Ritesh Singh <ritesi@codeaurora.org>

[ Upstream commit 690ace20ff790f443c3cbaf12e1769e4eb0072db ]

Peer creation in firmware fails, if last peer deletion
is still in progress.
Hence, add wait for the event after deleting every peer
from host driver to synchronize with firmware.

Signed-off-by: Ritesh Singh <ritesi@codeaurora.org>
Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1605514143-17652-3-git-send-email-mkenna@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c |  1 +
 drivers/net/wireless/ath/ath11k/core.h |  1 +
 drivers/net/wireless/ath/ath11k/mac.c  | 17 +++++++++-
 drivers/net/wireless/ath/ath11k/peer.c | 44 ++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath11k/peer.h |  2 ++
 drivers/net/wireless/ath/ath11k/wmi.c  | 17 ++++++++--
 6 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index ebd6886a8c18..a68fe3a45a74 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -774,6 +774,7 @@ static void ath11k_core_restart(struct work_struct *work)
 		complete(&ar->scan.started);
 		complete(&ar->scan.completed);
 		complete(&ar->peer_assoc_done);
+		complete(&ar->peer_delete_done);
 		complete(&ar->install_key_done);
 		complete(&ar->vdev_setup_done);
 		complete(&ar->bss_survey_done);
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index 5a7915f75e1e..c8e36251068c 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -502,6 +502,7 @@ struct ath11k {
 	u8 lmac_id;
 
 	struct completion peer_assoc_done;
+	struct completion peer_delete_done;
 
 	int install_key_status;
 	struct completion install_key_done;
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index b5bd9b06da89..c8f1b786e746 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4589,8 +4589,22 @@ static int ath11k_mac_op_add_interface(struct ieee80211_hw *hw,
 
 err_peer_del:
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
+		reinit_completion(&ar->peer_delete_done);
+
+		ret = ath11k_wmi_send_peer_delete_cmd(ar, vif->addr,
+						      arvif->vdev_id);
+		if (ret) {
+			ath11k_warn(ar->ab, "failed to delete peer vdev_id %d addr %pM\n",
+				    arvif->vdev_id, vif->addr);
+			return ret;
+		}
+
+		ret = ath11k_wait_for_peer_delete_done(ar, arvif->vdev_id,
+						       vif->addr);
+		if (ret)
+			return ret;
+
 		ar->num_peers--;
-		ath11k_wmi_send_peer_delete_cmd(ar, vif->addr, arvif->vdev_id);
 	}
 
 err_vdev_del:
@@ -6413,6 +6427,7 @@ int ath11k_mac_allocate(struct ath11k_base *ab)
 		mutex_init(&ar->conf_mutex);
 		init_completion(&ar->vdev_setup_done);
 		init_completion(&ar->peer_assoc_done);
+		init_completion(&ar->peer_delete_done);
 		init_completion(&ar->install_key_done);
 		init_completion(&ar->bss_survey_done);
 		init_completion(&ar->scan.started);
diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
index 61ad9300eafb..1866d82678fa 100644
--- a/drivers/net/wireless/ath/ath11k/peer.c
+++ b/drivers/net/wireless/ath/ath11k/peer.c
@@ -177,12 +177,36 @@ static int ath11k_wait_for_peer_deleted(struct ath11k *ar, int vdev_id, const u8
 	return ath11k_wait_for_peer_common(ar->ab, vdev_id, addr, false);
 }
 
+int ath11k_wait_for_peer_delete_done(struct ath11k *ar, u32 vdev_id,
+				     const u8 *addr)
+{
+	int ret;
+	unsigned long time_left;
+
+	ret = ath11k_wait_for_peer_deleted(ar, vdev_id, addr);
+	if (ret) {
+		ath11k_warn(ar->ab, "failed wait for peer deleted");
+		return ret;
+	}
+
+	time_left = wait_for_completion_timeout(&ar->peer_delete_done,
+						3 * HZ);
+	if (time_left == 0) {
+		ath11k_warn(ar->ab, "Timeout in receiving peer delete response\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
 int ath11k_peer_delete(struct ath11k *ar, u32 vdev_id, u8 *addr)
 {
 	int ret;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	reinit_completion(&ar->peer_delete_done);
+
 	ret = ath11k_wmi_send_peer_delete_cmd(ar, addr, vdev_id);
 	if (ret) {
 		ath11k_warn(ar->ab,
@@ -191,7 +215,7 @@ int ath11k_peer_delete(struct ath11k *ar, u32 vdev_id, u8 *addr)
 		return ret;
 	}
 
-	ret = ath11k_wait_for_peer_deleted(ar, vdev_id, addr);
+	ret = ath11k_wait_for_peer_delete_done(ar, vdev_id, addr);
 	if (ret)
 		return ret;
 
@@ -247,8 +271,22 @@ int ath11k_peer_create(struct ath11k *ar, struct ath11k_vif *arvif,
 		spin_unlock_bh(&ar->ab->base_lock);
 		ath11k_warn(ar->ab, "failed to find peer %pM on vdev %i after creation\n",
 			    param->peer_addr, param->vdev_id);
-		ath11k_wmi_send_peer_delete_cmd(ar, param->peer_addr,
-						param->vdev_id);
+
+		reinit_completion(&ar->peer_delete_done);
+
+		ret = ath11k_wmi_send_peer_delete_cmd(ar, param->peer_addr,
+						      param->vdev_id);
+		if (ret) {
+			ath11k_warn(ar->ab, "failed to delete peer vdev_id %d addr %pM\n",
+				    param->vdev_id, param->peer_addr);
+			return ret;
+		}
+
+		ret = ath11k_wait_for_peer_delete_done(ar, param->vdev_id,
+						       param->peer_addr);
+		if (ret)
+			return ret;
+
 		return -ENOENT;
 	}
 
diff --git a/drivers/net/wireless/ath/ath11k/peer.h b/drivers/net/wireless/ath/ath11k/peer.h
index 5d125ce8984e..bba2e00b6944 100644
--- a/drivers/net/wireless/ath/ath11k/peer.h
+++ b/drivers/net/wireless/ath/ath11k/peer.h
@@ -41,5 +41,7 @@ void ath11k_peer_cleanup(struct ath11k *ar, u32 vdev_id);
 int ath11k_peer_delete(struct ath11k *ar, u32 vdev_id, u8 *addr);
 int ath11k_peer_create(struct ath11k *ar, struct ath11k_vif *arvif,
 		       struct ieee80211_sta *sta, struct peer_create_params *param);
+int ath11k_wait_for_peer_delete_done(struct ath11k *ar, u32 vdev_id,
+				     const u8 *addr);
 
 #endif /* _PEER_H_ */
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 04b8b002edfe..173ab6ceed1f 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5532,15 +5532,26 @@ static int ath11k_ready_event(struct ath11k_base *ab, struct sk_buff *skb)
 static void ath11k_peer_delete_resp_event(struct ath11k_base *ab, struct sk_buff *skb)
 {
 	struct wmi_peer_delete_resp_event peer_del_resp;
+	struct ath11k *ar;
 
 	if (ath11k_pull_peer_del_resp_ev(ab, skb, &peer_del_resp) != 0) {
 		ath11k_warn(ab, "failed to extract peer delete resp");
 		return;
 	}
 
-	/* TODO: Do we need to validate whether ath11k_peer_find() return NULL
-	 *	 Why this is needed when there is HTT event for peer delete
-	 */
+	rcu_read_lock();
+	ar = ath11k_mac_get_ar_by_vdev_id(ab, peer_del_resp.vdev_id);
+	if (!ar) {
+		ath11k_warn(ab, "invalid vdev id in peer delete resp ev %d",
+			    peer_del_resp.vdev_id);
+		rcu_read_unlock();
+		return;
+	}
+
+	complete(&ar->peer_delete_done);
+	rcu_read_unlock();
+	ath11k_dbg(ab, ATH11K_DBG_WMI, "peer delete resp for vdev id %d addr %pM\n",
+		   peer_del_resp.vdev_id, peer_del_resp.peer_macaddr.addr);
 }
 
 static inline const char *ath11k_wmi_vdev_resp_print(u32 vdev_resp_status)
-- 
2.30.1



