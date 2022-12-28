Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53EA657B35
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbiL1PTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbiL1PTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:19:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097441408A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:18:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 589A461551
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69230C433D2;
        Wed, 28 Dec 2022 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240737;
        bh=4/o4PVMUe4np5d+cgENpzoe7wZaJhmyjdHE73+UchXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnP97HAQ61z8cNGKZE7x2Pp6tUqPWTUyQpVOS1RmXP01Acq5V/hMVYSE4fmpxFNE5
         K06ofI8BEDTe6Vczbjr2XxLVs+wO4zFlVn2AeZ/gqAqyKXYUgIwJLx1ZKiok2R/f+0
         Abf3T7NhzFcc2SuVmY8VyawlcYI0/l8SvWTP6w6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Aditya Kumar Singh <quic_adisi@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0197/1073] wifi: ath11k: fix firmware assert during bandwidth change for peer sta
Date:   Wed, 28 Dec 2022 15:29:45 +0100
Message-Id: <20221228144333.366016713@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Kumar Singh <quic_adisi@quicinc.com>

[ Upstream commit 3ff51d7416ee1ea2d771051a0ffa1ec8be054768 ]

Currently, ath11k sends peer assoc command for each peer to
firmware when bandwidth changes. Peer assoc command is a
bulky command and if many clients are connected, this could
lead to firmware buffer getting overflowed leading to a firmware
assert.

However, during bandwidth change, only phymode and bandwidth
also can be updated by WMI set peer param command. This makes
the overall command light when compared to peer assoc and for
multi-client cases, firmware buffer overflow also does not
occur.

Remove sending peer assoc command during sta bandwidth change
and instead add sending WMI set peer param command for phymode
and bandwidth.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1

Fixes: f187fe8e3bc65 ("ath11k: fix firmware crash during channel switch")
Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221005095430.19890-1-quic_adisi@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.h |   2 +
 drivers/net/wireless/ath/ath11k/mac.c  | 122 +++++++++++++++++--------
 2 files changed, 87 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index b4aac98497cb..8edc1f4e5694 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -498,6 +498,8 @@ struct ath11k_sta {
 
 	bool use_4addr_set;
 	u16 tcl_metadata;
+
+	u32 bw_prev;
 };
 
 #define ATH11K_MIN_5G_FREQ 4150
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 7f6521314b2d..475ed20b495d 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4209,10 +4209,11 @@ static void ath11k_sta_rc_update_wk(struct work_struct *wk)
 	const u8 *ht_mcs_mask;
 	const u16 *vht_mcs_mask;
 	const u16 *he_mcs_mask;
-	u32 changed, bw, nss, smps;
+	u32 changed, bw, nss, smps, bw_prev;
 	int err, num_vht_rates, num_he_rates;
 	const struct cfg80211_bitrate_mask *mask;
 	struct peer_assoc_params peer_arg;
+	enum wmi_phy_mode peer_phymode;
 
 	arsta = container_of(wk, struct ath11k_sta, update_wk);
 	sta = container_of((void *)arsta, struct ieee80211_sta, drv_priv);
@@ -4233,6 +4234,7 @@ static void ath11k_sta_rc_update_wk(struct work_struct *wk)
 	arsta->changed = 0;
 
 	bw = arsta->bw;
+	bw_prev = arsta->bw_prev;
 	nss = arsta->nss;
 	smps = arsta->smps;
 
@@ -4246,26 +4248,57 @@ static void ath11k_sta_rc_update_wk(struct work_struct *wk)
 			   ath11k_mac_max_he_nss(he_mcs_mask)));
 
 	if (changed & IEEE80211_RC_BW_CHANGED) {
-		/* Send peer assoc command before set peer bandwidth param to
-		 * avoid the mismatch between the peer phymode and the peer
-		 * bandwidth.
-		 */
-		ath11k_peer_assoc_prepare(ar, arvif->vif, sta, &peer_arg, true);
-
-		peer_arg.is_assoc = false;
-		err = ath11k_wmi_send_peer_assoc_cmd(ar, &peer_arg);
-		if (err) {
-			ath11k_warn(ar->ab, "failed to send peer assoc for STA %pM vdev %i: %d\n",
-				    sta->addr, arvif->vdev_id, err);
-		} else if (wait_for_completion_timeout(&ar->peer_assoc_done, 1 * HZ)) {
+		/* Get the peer phymode */
+		ath11k_peer_assoc_h_phymode(ar, arvif->vif, sta, &peer_arg);
+		peer_phymode = peer_arg.peer_phymode;
+
+		ath11k_dbg(ar->ab, ATH11K_DBG_MAC, "mac update sta %pM peer bw %d phymode %d\n",
+			   sta->addr, bw, peer_phymode);
+
+		if (bw > bw_prev) {
+			/* BW is upgraded. In this case we send WMI_PEER_PHYMODE
+			 * followed by WMI_PEER_CHWIDTH
+			 */
+			ath11k_dbg(ar->ab, ATH11K_DBG_MAC, "mac BW upgrade for sta %pM new BW %d, old BW %d\n",
+				   sta->addr, bw, bw_prev);
+
+			err = ath11k_wmi_set_peer_param(ar, sta->addr, arvif->vdev_id,
+							WMI_PEER_PHYMODE, peer_phymode);
+
+			if (err) {
+				ath11k_warn(ar->ab, "failed to update STA %pM peer phymode %d: %d\n",
+					    sta->addr, peer_phymode, err);
+				goto err_rc_bw_changed;
+			}
+
 			err = ath11k_wmi_set_peer_param(ar, sta->addr, arvif->vdev_id,
 							WMI_PEER_CHWIDTH, bw);
+
 			if (err)
 				ath11k_warn(ar->ab, "failed to update STA %pM peer bw %d: %d\n",
 					    sta->addr, bw, err);
 		} else {
-			ath11k_warn(ar->ab, "failed to get peer assoc conf event for %pM vdev %i\n",
-				    sta->addr, arvif->vdev_id);
+			/* BW is downgraded. In this case we send WMI_PEER_CHWIDTH
+			 * followed by WMI_PEER_PHYMODE
+			 */
+			ath11k_dbg(ar->ab, ATH11K_DBG_MAC, "mac BW downgrade for sta %pM new BW %d,old BW %d\n",
+				   sta->addr, bw, bw_prev);
+
+			err = ath11k_wmi_set_peer_param(ar, sta->addr, arvif->vdev_id,
+							WMI_PEER_CHWIDTH, bw);
+
+			if (err) {
+				ath11k_warn(ar->ab, "failed to update STA %pM peer bw %d: %d\n",
+					    sta->addr, bw, err);
+				goto err_rc_bw_changed;
+			}
+
+			err = ath11k_wmi_set_peer_param(ar, sta->addr, arvif->vdev_id,
+							WMI_PEER_PHYMODE, peer_phymode);
+
+			if (err)
+				ath11k_warn(ar->ab, "failed to update STA %pM peer phymode %d: %d\n",
+					    sta->addr, peer_phymode, err);
 		}
 	}
 
@@ -4346,6 +4379,7 @@ static void ath11k_sta_rc_update_wk(struct work_struct *wk)
 		}
 	}
 
+err_rc_bw_changed:
 	mutex_unlock(&ar->conf_mutex);
 }
 
@@ -4499,6 +4533,34 @@ static int ath11k_mac_station_add(struct ath11k *ar,
 	return ret;
 }
 
+static u32 ath11k_mac_ieee80211_sta_bw_to_wmi(struct ath11k *ar,
+					      struct ieee80211_sta *sta)
+{
+	u32 bw = WMI_PEER_CHWIDTH_20MHZ;
+
+	switch (sta->deflink.bandwidth) {
+	case IEEE80211_STA_RX_BW_20:
+		bw = WMI_PEER_CHWIDTH_20MHZ;
+		break;
+	case IEEE80211_STA_RX_BW_40:
+		bw = WMI_PEER_CHWIDTH_40MHZ;
+		break;
+	case IEEE80211_STA_RX_BW_80:
+		bw = WMI_PEER_CHWIDTH_80MHZ;
+		break;
+	case IEEE80211_STA_RX_BW_160:
+		bw = WMI_PEER_CHWIDTH_160MHZ;
+		break;
+	default:
+		ath11k_warn(ar->ab, "Invalid bandwidth %d for %pM\n",
+			    sta->deflink.bandwidth, sta->addr);
+		bw = WMI_PEER_CHWIDTH_20MHZ;
+		break;
+	}
+
+	return bw;
+}
+
 static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_sta *sta,
@@ -4583,6 +4645,12 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 		if (ret)
 			ath11k_warn(ar->ab, "Failed to associate station: %pM\n",
 				    sta->addr);
+
+		spin_lock_bh(&ar->data_lock);
+		/* Set arsta bw and prev bw */
+		arsta->bw = ath11k_mac_ieee80211_sta_bw_to_wmi(ar, sta);
+		arsta->bw_prev = arsta->bw;
+		spin_unlock_bh(&ar->data_lock);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTHORIZED) {
 		spin_lock_bh(&ar->ab->base_lock);
@@ -4706,28 +4774,8 @@ static void ath11k_mac_op_sta_rc_update(struct ieee80211_hw *hw,
 	spin_lock_bh(&ar->data_lock);
 
 	if (changed & IEEE80211_RC_BW_CHANGED) {
-		bw = WMI_PEER_CHWIDTH_20MHZ;
-
-		switch (sta->deflink.bandwidth) {
-		case IEEE80211_STA_RX_BW_20:
-			bw = WMI_PEER_CHWIDTH_20MHZ;
-			break;
-		case IEEE80211_STA_RX_BW_40:
-			bw = WMI_PEER_CHWIDTH_40MHZ;
-			break;
-		case IEEE80211_STA_RX_BW_80:
-			bw = WMI_PEER_CHWIDTH_80MHZ;
-			break;
-		case IEEE80211_STA_RX_BW_160:
-			bw = WMI_PEER_CHWIDTH_160MHZ;
-			break;
-		default:
-			ath11k_warn(ar->ab, "Invalid bandwidth %d in rc update for %pM\n",
-				    sta->deflink.bandwidth, sta->addr);
-			bw = WMI_PEER_CHWIDTH_20MHZ;
-			break;
-		}
-
+		bw = ath11k_mac_ieee80211_sta_bw_to_wmi(ar, sta);
+		arsta->bw_prev = arsta->bw;
 		arsta->bw = bw;
 	}
 
-- 
2.35.1



