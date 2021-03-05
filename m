Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58DE32E841
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhCEMZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:25:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhCEMZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:25:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B323D65030;
        Fri,  5 Mar 2021 12:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947134;
        bh=icmuhJ+JFwMM8bJLBVOBx/fA5KiVvP+2ReSggjueXz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDyUDZykIKJdH1NvAzXf3/p8Rjbq+2U58nKMyEAfhuIWExv4gQmjgtD0z0JAmQ3zH
         0/Qv7/k/HKkyAyJCB48kZ2q3Ph4ltLm3W09fdtqYDDK1FN3lu4YIpGYtsdd0k8qTRD
         Xdpc1qpEcvE8hXcjCbMWWxd14Lv45++gAN/T3/qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vsevolod Kozlov <zaba@mm.st>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 059/104] wilc1000: Fix use of void pointer as a wrong struct type
Date:   Fri,  5 Mar 2021 13:21:04 +0100
Message-Id: <20210305120906.073779646@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vsevolod Kozlov <zaba@mm.st>

[ Upstream commit 6fe91b69ceceea832a73d35185df04b3e877f399 ]

ac_classify() expects a struct sk_buff* as its second argument, which is
a member of struct tx_complete_data. priv happens to be a pointer to
struct tx_complete_data, so passing it directly to ac_classify() leads
to wrong behaviour and occasional panics.

Since there is only one caller of wilc_wlan_txq_add_net_pkt and it
already knows the type behind this pointer, and the structure is already
in the header file, change the function signature to use the real type
instead of void* in order to prevent confusion.

Signed-off-by: Vsevolod Kozlov <zaba@mm.st>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/YCQomJ1mO5BLxYOT@Vsevolods-Mini.lan
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/netdev.c |  2 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c   | 15 ++++++++-------
 drivers/net/wireless/microchip/wilc1000/wlan.h   |  3 ++-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 2a1fbbdd6a4b..0c188310919e 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -737,7 +737,7 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	vif->netstats.tx_packets++;
 	vif->netstats.tx_bytes += tx_data->size;
-	queue_count = wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
+	queue_count = wilc_wlan_txq_add_net_pkt(ndev, tx_data,
 						tx_data->buff, tx_data->size,
 						wilc_tx_complete);
 
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index c12f27be9f79..31d51385ba93 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -408,7 +408,8 @@ static inline u8 ac_change(struct wilc *wilc, u8 *ac)
 	return 1;
 }
 
-int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
+int wilc_wlan_txq_add_net_pkt(struct net_device *dev,
+			      struct tx_complete_data *tx_data, u8 *buffer,
 			      u32 buffer_size,
 			      void (*tx_complete_fn)(void *, int))
 {
@@ -420,27 +421,27 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	wilc = vif->wilc;
 
 	if (wilc->quit) {
-		tx_complete_fn(priv, 0);
+		tx_complete_fn(tx_data, 0);
 		return 0;
 	}
 
 	tqe = kmalloc(sizeof(*tqe), GFP_ATOMIC);
 
 	if (!tqe) {
-		tx_complete_fn(priv, 0);
+		tx_complete_fn(tx_data, 0);
 		return 0;
 	}
 	tqe->type = WILC_NET_PKT;
 	tqe->buffer = buffer;
 	tqe->buffer_size = buffer_size;
 	tqe->tx_complete_func = tx_complete_fn;
-	tqe->priv = priv;
+	tqe->priv = tx_data;
 	tqe->vif = vif;
 
-	q_num = ac_classify(wilc, priv);
+	q_num = ac_classify(wilc, tx_data->skb);
 	tqe->q_num = q_num;
 	if (ac_change(wilc, &q_num)) {
-		tx_complete_fn(priv, 0);
+		tx_complete_fn(tx_data, 0);
 		kfree(tqe);
 		return 0;
 	}
@@ -451,7 +452,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			tcp_process(dev, tqe);
 		wilc_wlan_txq_add_to_tail(dev, q_num, tqe);
 	} else {
-		tx_complete_fn(priv, 0);
+		tx_complete_fn(tx_data, 0);
 		kfree(tqe);
 	}
 
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.h b/drivers/net/wireless/microchip/wilc1000/wlan.h
index 3d2104f19819..d55eb6b3a12a 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.h
@@ -399,7 +399,8 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 				u32 buffer_size);
 int wilc_wlan_start(struct wilc *wilc);
 int wilc_wlan_stop(struct wilc *wilc, struct wilc_vif *vif);
-int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
+int wilc_wlan_txq_add_net_pkt(struct net_device *dev,
+			      struct tx_complete_data *tx_data, u8 *buffer,
 			      u32 buffer_size,
 			      void (*tx_complete_fn)(void *, int));
 int wilc_wlan_handle_txq(struct wilc *wl, u32 *txq_count);
-- 
2.30.1



