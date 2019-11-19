Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B070B1018AC
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfKSF1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfKSF1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C755121783;
        Tue, 19 Nov 2019 05:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141254;
        bh=dD/bHB9IMDtRfXZwt5TsNRbb32hxDd5JIvgnXY4MEV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHXA95KknhRniMt5VogXKwUUs9TjAs19jDjCPJfY553TUhdTSMIMdSDif0opjLu7R
         H12iJ8Ll70DBIu73CGsAPXUAovB0YJsYnL5Y4gmEsWLnQQJRVCOF57pAULV56oxa2P
         ciGOoJZ3Jh2uEINxNiIVUSHposqk2tcLFvcv1HdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/422] wil6210: prevent usage of tx ring 0 for eDMA
Date:   Tue, 19 Nov 2019 06:14:16 +0100
Message-Id: <20191119051403.567562124@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maya Erez <merez@codeaurora.org>

[ Upstream commit df2b53884a5a454bf441ca78e5b57307262c73f4 ]

In enhanced DMA ring 0 is used for RX ring, hence TX ring 0
is an unused element in ring_tx and ring2cid_tid arrays.
Initialize ring2cid_tid CID to WIL6210_MAX_CID to prevent a false
match of CID 0.
Go over the ring_tx and ring2cid_tid from wil_get_min_tx_ring_id
and on to prevent access to index 0 in eDMA.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 7 +++++--
 drivers/net/wireless/ath/wil6210/txrx.c | 6 ++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index d186b6886c6bf..920cb233f4db7 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -223,6 +223,7 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 	struct net_device *ndev = vif_to_ndev(vif);
 	struct wireless_dev *wdev = vif_to_wdev(vif);
 	struct wil_sta_info *sta = &wil->sta[cid];
+	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
 	might_sleep();
 	wil_dbg_misc(wil, "disconnect_cid: CID %d, MID %d, status %d\n",
@@ -273,7 +274,7 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 	memset(sta->tid_crypto_rx, 0, sizeof(sta->tid_crypto_rx));
 	memset(&sta->group_crypto_rx, 0, sizeof(sta->group_crypto_rx));
 	/* release vrings */
-	for (i = 0; i < ARRAY_SIZE(wil->ring_tx); i++) {
+	for (i = min_ring_id; i < ARRAY_SIZE(wil->ring_tx); i++) {
 		if (wil->ring2cid_tid[i][0] == cid)
 			wil_ring_fini_tx(wil, i);
 	}
@@ -604,8 +605,10 @@ int wil_priv_init(struct wil6210_priv *wil)
 		wil->sta[i].mid = U8_MAX;
 	}
 
-	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++)
+	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
 		spin_lock_init(&wil->ring_tx_data[i].lock);
+		wil->ring2cid_tid[i][0] = WIL6210_MAX_CID;
+	}
 
 	mutex_init(&wil->mutex);
 	mutex_init(&wil->vif_mutex);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 25a65ca424c84..73cdf54521f9b 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -77,8 +77,9 @@ bool wil_is_tx_idle(struct wil6210_priv *wil)
 {
 	int i;
 	unsigned long data_comp_to;
+	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
-	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
+	for (i = min_ring_id; i < WIL6210_MAX_TX_RINGS; i++) {
 		struct wil_ring *vring = &wil->ring_tx[i];
 		int vring_index = vring - wil->ring_tx;
 		struct wil_ring_tx_data *txdata =
@@ -1945,6 +1946,7 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 					   bool check_stop)
 {
 	int i;
+	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
 	if (unlikely(!vif))
 		return;
@@ -1977,7 +1979,7 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 		return;
 
 	/* check wake */
-	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
+	for (i = min_ring_id; i < WIL6210_MAX_TX_RINGS; i++) {
 		struct wil_ring *cur_ring = &wil->ring_tx[i];
 		struct wil_ring_tx_data  *txdata = &wil->ring_tx_data[i];
 
-- 
2.20.1



