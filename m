Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBB0419ACE
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbhI0RMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236428AbhI0RKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:10:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 871996124B;
        Mon, 27 Sep 2021 17:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762477;
        bh=O4Vj9G28sfBGq6oCww1lLllkkX3WmK24PgaHwPsA7cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXCZ7Hyif+74q31Bxg+y154DjWEJamBQI6KrDk/VWsFnf5gGPy9fsg/6hXUqGcVCI
         mku9NJ9K3KV0LsNm9+2UN8kO36kUJD+H28K3hZZEfwg/X0zzHqC4Koff4dTqAjkJNg
         CZVO2JywktRT8PLrOzpDelmpNJARj2+dPYsYaaow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadocm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/103] bnxt_en: Fix TX timeout when TX ring size is set to the smallest
Date:   Mon, 27 Sep 2021 19:02:10 +0200
Message-Id: <20210927170227.062240891@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 5bed8b0704c9ecccc8f4a2c377d7c8e21090a82e ]

The smallest TX ring size we support must fit a TX SKB with MAX_SKB_FRAGS
+ 1.  Because the first TX BD for a packet is always a long TX BD, we
need an extra TX BD to fit this packet.  Define BNXT_MIN_TX_DESC_CNT with
this value to make this more clear.  The current code uses a minimum
that is off by 1.  Fix it using this constant.

The tx_wake_thresh to determine when to wake up the TX queue is half the
ring size but we must have at least BNXT_MIN_TX_DESC_CNT for the next
packet which may have maximum fragments.  So the comparison of the
available TX BDs with tx_wake_thresh should be >= instead of > in the
current code.  Otherwise, at the smallest ring size, we will never wake
up the TX queue and will cause TX timeout.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadocm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 8 ++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 5 +++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 26179e437bbf..cb0c270418a4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -381,7 +381,7 @@ static bool bnxt_txr_netif_try_stop_queue(struct bnxt *bp,
 	 * netif_tx_queue_stopped().
 	 */
 	smp_mb();
-	if (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh) {
+	if (bnxt_tx_avail(bp, txr) >= bp->tx_wake_thresh) {
 		netif_tx_wake_queue(txq);
 		return false;
 	}
@@ -717,7 +717,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 	smp_mb();
 
 	if (unlikely(netif_tx_queue_stopped(txq)) &&
-	    bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
+	    bnxt_tx_avail(bp, txr) >= bp->tx_wake_thresh &&
 	    READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING)
 		netif_tx_wake_queue(txq);
 }
@@ -2300,7 +2300,7 @@ static int __bnxt_poll_work(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		if (TX_CMP_TYPE(txcmp) == CMP_TYPE_TX_L2_CMP) {
 			tx_pkts++;
 			/* return full budget so NAPI will complete. */
-			if (unlikely(tx_pkts > bp->tx_wake_thresh)) {
+			if (unlikely(tx_pkts >= bp->tx_wake_thresh)) {
 				rx_pkts = budget;
 				raw_cons = NEXT_RAW_CMP(raw_cons);
 				if (budget)
@@ -3431,7 +3431,7 @@ static int bnxt_init_tx_rings(struct bnxt *bp)
 	u16 i;
 
 	bp->tx_wake_thresh = max_t(int, bp->tx_ring_size / 2,
-				   MAX_SKB_FRAGS + 1);
+				   BNXT_MIN_TX_DESC_CNT);
 
 	for (i = 0; i < bp->tx_nr_rings; i++) {
 		struct bnxt_tx_ring_info *txr = &bp->tx_ring[i];
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 95d10e7bbb04..92f9f7f5240b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -611,6 +611,11 @@ struct nqe_cn {
 #define BNXT_MAX_RX_JUM_DESC_CNT	(RX_DESC_CNT * MAX_RX_AGG_PAGES - 1)
 #define BNXT_MAX_TX_DESC_CNT		(TX_DESC_CNT * MAX_TX_PAGES - 1)
 
+/* Minimum TX BDs for a TX packet with MAX_SKB_FRAGS + 1.  We need one extra
+ * BD because the first TX BD is always a long BD.
+ */
+#define BNXT_MIN_TX_DESC_CNT		(MAX_SKB_FRAGS + 2)
+
 #define RX_RING(x)	(((x) & ~(RX_DESC_CNT - 1)) >> (BNXT_PAGE_SHIFT - 4))
 #define RX_IDX(x)	((x) & (RX_DESC_CNT - 1))
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 1471c9a36238..6f9196ff2ac4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -780,7 +780,7 @@ static int bnxt_set_ringparam(struct net_device *dev,
 
 	if ((ering->rx_pending > BNXT_MAX_RX_DESC_CNT) ||
 	    (ering->tx_pending > BNXT_MAX_TX_DESC_CNT) ||
-	    (ering->tx_pending <= MAX_SKB_FRAGS))
+	    (ering->tx_pending < BNXT_MIN_TX_DESC_CNT))
 		return -EINVAL;
 
 	if (netif_running(dev))
-- 
2.33.0



