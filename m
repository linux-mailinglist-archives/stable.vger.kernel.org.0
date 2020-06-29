Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E16920E838
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391839AbgF2WEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgF2SfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 143182474A;
        Mon, 29 Jun 2020 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444066;
        bh=5l6+rKtmr1boCMKwk/zkfnGh7MPSWATG2k0KxQ0ouFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjuMLq/J58cSOJHChXHuvDzbejnTaQ9eR2dOIDvEn1ayIPpccHROLmgYarlvU2FVw
         zvI1ruz+yJ/amNxCd21kDg9SKD+EQ92h4H5vwGy0tvRCQOhlaVFpJfPLbly+3lrFct
         S1SER8QPwRTyfLH1zGFk9Vx6nCLrOLFnQmKwAPBc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 175/265] wil6210: account for napi_gro_receive never returning GRO_DROP
Date:   Mon, 29 Jun 2020 11:16:48 -0400
Message-Id: <20200629151818.2493727-176-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 045790b7bc66a75070c112a61558c639cef2263e ]

The napi_gro_receive function no longer returns GRO_DROP ever, making
handling GRO_DROP dead code. This commit removes that dead code.
Further, it's not even clear that device drivers have any business in
taking action after passing off received packets; that's arguably out of
their hands. In this case, too, the non-gro path didn't bother checking
the return value. Plus, this had some clunky debugging functions that
duplicated code from elsewhere and was generally pretty messy. So, this
commit cleans that all up too.

Fixes: 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 39 +++++++------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index bc8c15fb609dc..080e5aa60bea4 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -897,7 +897,6 @@ static void wil_rx_handle_eapol(struct wil6210_vif *vif, struct sk_buff *skb)
 void wil_netif_rx(struct sk_buff *skb, struct net_device *ndev, int cid,
 		  struct wil_net_stats *stats, bool gro)
 {
-	gro_result_t rc = GRO_NORMAL;
 	struct wil6210_vif *vif = ndev_to_vif(ndev);
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 	struct wireless_dev *wdev = vif_to_wdev(vif);
@@ -908,22 +907,16 @@ void wil_netif_rx(struct sk_buff *skb, struct net_device *ndev, int cid,
 	 */
 	int mcast = is_multicast_ether_addr(da);
 	struct sk_buff *xmit_skb = NULL;
-	static const char * const gro_res_str[] = {
-		[GRO_MERGED]		= "GRO_MERGED",
-		[GRO_MERGED_FREE]	= "GRO_MERGED_FREE",
-		[GRO_HELD]		= "GRO_HELD",
-		[GRO_NORMAL]		= "GRO_NORMAL",
-		[GRO_DROP]		= "GRO_DROP",
-		[GRO_CONSUMED]		= "GRO_CONSUMED",
-	};
 
 	if (wdev->iftype == NL80211_IFTYPE_STATION) {
 		sa = wil_skb_get_sa(skb);
 		if (mcast && ether_addr_equal(sa, ndev->dev_addr)) {
 			/* mcast packet looped back to us */
-			rc = GRO_DROP;
 			dev_kfree_skb(skb);
-			goto stats;
+			ndev->stats.rx_dropped++;
+			stats->rx_dropped++;
+			wil_dbg_txrx(wil, "Rx drop %d bytes\n", len);
+			return;
 		}
 	} else if (wdev->iftype == NL80211_IFTYPE_AP && !vif->ap_isolate) {
 		if (mcast) {
@@ -967,26 +960,16 @@ void wil_netif_rx(struct sk_buff *skb, struct net_device *ndev, int cid,
 			wil_rx_handle_eapol(vif, skb);
 
 		if (gro)
-			rc = napi_gro_receive(&wil->napi_rx, skb);
+			napi_gro_receive(&wil->napi_rx, skb);
 		else
 			netif_rx_ni(skb);
-		wil_dbg_txrx(wil, "Rx complete %d bytes => %s\n",
-			     len, gro_res_str[rc]);
-	}
-stats:
-	/* statistics. rc set to GRO_NORMAL for AP bridging */
-	if (unlikely(rc == GRO_DROP)) {
-		ndev->stats.rx_dropped++;
-		stats->rx_dropped++;
-		wil_dbg_txrx(wil, "Rx drop %d bytes\n", len);
-	} else {
-		ndev->stats.rx_packets++;
-		stats->rx_packets++;
-		ndev->stats.rx_bytes += len;
-		stats->rx_bytes += len;
-		if (mcast)
-			ndev->stats.multicast++;
 	}
+	ndev->stats.rx_packets++;
+	stats->rx_packets++;
+	ndev->stats.rx_bytes += len;
+	stats->rx_bytes += len;
+	if (mcast)
+		ndev->stats.multicast++;
 }
 
 void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
-- 
2.25.1

