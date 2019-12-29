Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E761612C3B6
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfL2RWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbfL2RW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:22:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45DF7207FD;
        Sun, 29 Dec 2019 17:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640148;
        bh=97AH1xh1Qq9DnQUA/Gr+AylmYm9mAMeokZWHItaRuCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jj6rfpkVl4H/xM6tL/Q4zk6Wg6Nm2GuvDb9/ONnNKl4NgsiILsdVwu+GpbWK/vyD
         rMCIeiSKykUnAnjQztYxTCYqXP6XDblcHZG8btvhICTmOr+O7zYPiYokY8OHCl1LhD
         D6rctMGyvP8KWCTd+4qPZRFfEB68FurT6sS+lbCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Antonio Quartulli <antonio.quartulli@kaiwoo.ai>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 037/161] ath10k: fix offchannel tx failure when no ath10k_mac_tx_frm_has_freq
Date:   Sun, 29 Dec 2019 18:18:05 +0100
Message-Id: <20191229162410.991105696@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit cc6df017e55764ffef9819dd9554053182535ffd ]

Offchannel management frames were failing:

[18099.253732] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3780
[18102.293686] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3780
[18105.333653] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3780
[18108.373712] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3780
[18111.413687] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e36c0
[18114.453726] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3f00
[18117.493773] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e36c0
[18120.533631] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3f00

This bug appears to have been added between 4.0 (which works for us),
and 4.4, which does not work.

I think this is because the tx-offchannel logic gets in a loop when
ath10k_mac_tx_frm_has_freq(ar) is false, so pkt is never actually
sent to the firmware for transmit.

This patch fixes the problem on 4.9 for me, and now HS20 clients
can work again with my firmware.

Antonio: tested with 10.4-3.5.3-00057 on QCA4019 and QCA9888

Signed-off-by: Ben Greear <greearb@candelatech.com>
Tested-by: Antonio Quartulli <antonio.quartulli@kaiwoo.ai>
[kvalo@codeaurora.org: improve commit log, remove unneeded parenthesis]
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index dff34448588f..ea47ad4b2343 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3627,7 +3627,7 @@ static int ath10k_mac_tx(struct ath10k *ar,
 			 struct ieee80211_vif *vif,
 			 enum ath10k_hw_txrx_mode txmode,
 			 enum ath10k_mac_tx_path txpath,
-			 struct sk_buff *skb)
+			 struct sk_buff *skb, bool noque_offchan)
 {
 	struct ieee80211_hw *hw = ar->hw;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -3655,10 +3655,10 @@ static int ath10k_mac_tx(struct ath10k *ar,
 		}
 	}
 
-	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
+	if (!noque_offchan && info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
 		if (!ath10k_mac_tx_frm_has_freq(ar)) {
-			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %pK\n",
-				   skb);
+			ath10k_dbg(ar, ATH10K_DBG_MAC, "mac queued offchannel skb %pK len %d\n",
+				   skb, skb->len);
 
 			skb_queue_tail(&ar->offchan_tx_queue, skb);
 			ieee80211_queue_work(hw, &ar->offchan_tx_work);
@@ -3720,8 +3720,8 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 
 		mutex_lock(&ar->conf_mutex);
 
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac offchannel skb %pK\n",
-			   skb);
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac offchannel skb %pK len %d\n",
+			   skb, skb->len);
 
 		hdr = (struct ieee80211_hdr *)skb->data;
 		peer_addr = ieee80211_get_DA(hdr);
@@ -3767,7 +3767,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 		txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
 
-		ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb);
+		ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb, true);
 		if (ret) {
 			ath10k_warn(ar, "failed to transmit offchannel frame: %d\n",
 				    ret);
@@ -3777,8 +3777,8 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		time_left =
 		wait_for_completion_timeout(&ar->offchan_tx_completed, 3 * HZ);
 		if (time_left == 0)
-			ath10k_warn(ar, "timed out waiting for offchannel skb %pK\n",
-				    skb);
+			ath10k_warn(ar, "timed out waiting for offchannel skb %pK, len: %d\n",
+				    skb, skb->len);
 
 		if (!peer && tmp_peer_created) {
 			ret = ath10k_peer_delete(ar, vdev_id, peer_addr);
@@ -3957,7 +3957,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 		spin_unlock_bh(&ar->htt.tx_lock);
 	}
 
-	ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb);
+	ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb, false);
 	if (unlikely(ret)) {
 		ath10k_warn(ar, "failed to push frame: %d\n", ret);
 
@@ -4239,7 +4239,7 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 		spin_unlock_bh(&ar->htt.tx_lock);
 	}
 
-	ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb);
+	ret = ath10k_mac_tx(ar, vif, txmode, txpath, skb, false);
 	if (ret) {
 		ath10k_warn(ar, "failed to transmit frame: %d\n", ret);
 		if (is_htt) {
-- 
2.20.1



