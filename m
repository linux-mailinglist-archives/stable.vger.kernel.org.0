Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C92395DEE
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhEaNvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233057AbhEaNtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:49:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B70A613B6;
        Mon, 31 May 2021 13:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467911;
        bh=mjDBZ/MFxDXzFeXVAl411RYQ4QEJ69HfNtNIa9pe61Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVtG167CaMEEqXtW1cP4QaPvsOcKKEu73HZmTYq6+Cz5XquAajI6Ht4Kfe36CZje4
         xYk5L7ZX9s2DGgfE+2ITrYCc6Zzz881YHu9EfsD4v6quwURiBHO70KP5YCz6EpaT+n
         pEXUUPwnTHSF1SvUWYF/TxThnLUz7FEQ4kvdCvZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sriram R <srirrama@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 039/252] ath11k: Clear the fragment cache during key install
Date:   Mon, 31 May 2021 15:11:44 +0200
Message-Id: <20210531130659.319473840@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriram R <srirrama@codeaurora.org>

commit c3944a5621026c176001493d48ee66ff94e1a39a upstream.

Currently the fragment cache setup during peer assoc is
cleared only during peer delete. In case a key reinstallation
happens with the same peer, the same fragment cache with old
fragments added before key installation could be clubbed
with fragments received after. This might be exploited
to mix fragments of different data resulting in a proper
unintended reassembled packet to be passed up the stack.

Hence flush the fragment cache on every key installation to prevent
potential attacks (CVE-2020-24587).

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01734-QCAHKSWPL_SILICONZ-1 v2

Cc: stable@vger.kernel.org
Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.218dc777836f.I9af6fc76215a35936c4152552018afb5079c5d8c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c |   18 ++++++++++++++++++
 drivers/net/wireless/ath/ath11k/dp_rx.h |    1 +
 drivers/net/wireless/ath/ath11k/mac.c   |    6 ++++++
 3 files changed, 25 insertions(+)

--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -832,6 +832,24 @@ static void ath11k_dp_rx_frags_cleanup(s
 	__skb_queue_purge(&rx_tid->rx_frags);
 }
 
+void ath11k_peer_frags_flush(struct ath11k *ar, struct ath11k_peer *peer)
+{
+	struct dp_rx_tid *rx_tid;
+	int i;
+
+	lockdep_assert_held(&ar->ab->base_lock);
+
+	for (i = 0; i <= IEEE80211_NUM_TIDS; i++) {
+		rx_tid = &peer->rx_tid[i];
+
+		spin_unlock_bh(&ar->ab->base_lock);
+		del_timer_sync(&rx_tid->frag_timer);
+		spin_lock_bh(&ar->ab->base_lock);
+
+		ath11k_dp_rx_frags_cleanup(rx_tid, true);
+	}
+}
+
 void ath11k_peer_rx_tid_cleanup(struct ath11k *ar, struct ath11k_peer *peer)
 {
 	struct dp_rx_tid *rx_tid;
--- a/drivers/net/wireless/ath/ath11k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.h
@@ -49,6 +49,7 @@ int ath11k_dp_peer_rx_pn_replay_config(s
 				       const u8 *peer_addr,
 				       enum set_key_cmd key_cmd,
 				       struct ieee80211_key_conf *key);
+void ath11k_peer_frags_flush(struct ath11k *ar, struct ath11k_peer *peer);
 void ath11k_peer_rx_tid_cleanup(struct ath11k *ar, struct ath11k_peer *peer);
 void ath11k_peer_rx_tid_delete(struct ath11k *ar,
 			       struct ath11k_peer *peer, u8 tid);
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2525,6 +2525,12 @@ static int ath11k_mac_op_set_key(struct
 	 */
 	spin_lock_bh(&ab->base_lock);
 	peer = ath11k_peer_find(ab, arvif->vdev_id, peer_addr);
+
+	/* flush the fragments cache during key (re)install to
+	 * ensure all frags in the new frag list belong to the same key.
+	 */
+	if (peer && cmd == SET_KEY)
+		ath11k_peer_frags_flush(ar, peer);
 	spin_unlock_bh(&ab->base_lock);
 
 	if (!peer) {


