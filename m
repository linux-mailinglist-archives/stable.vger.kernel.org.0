Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7825F40E4D9
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244698AbhIPRFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348385AbhIPRCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F95D61AFE;
        Thu, 16 Sep 2021 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810014;
        bh=oFoImvO9b21cT3FaDk9/kBnRacy5Lv/626L1KiGlNNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAss+mCR7evSbiKdyW0RR/Um27uUYG5khNj6msg3tJfyyValH0t+4j11JCyFXYkQg
         RaR8WMaUYMCX+OWYSBctO2PWomDsz9EZZABzfY8NqtBIN8hTJk80jHpOdgIkO65Qco
         UTdajTYmpWpWoJgrCjr2Z1D5hT7IwgWVocTbMT1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 367/380] net: stmmac: Fix overall budget calculation for rxtx_napi
Date:   Thu, 16 Sep 2021 18:02:04 +0200
Message-Id: <20210916155816.532440089@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Yoong Siang <yoong.siang.song@intel.com>

commit 81d0885d68ec427e62044cf46a400c9958ea0092 upstream.

tx_done is not used for napi_complete_done(). Thus, NAPI busy polling
mechanism by gro_flush_timeout and napi_defer_hard_irqs will not able
be triggered after a packet is transmitted when there is no receive
packet.

Fix this by taking the maximum value between tx_done and rx_done as
overall budget completed by the rxtx NAPI poll to ensure XDP Tx ZC
operation is continuously polling for next Tx frame. This gives
benefit of lower packet submission processing latency and jitter
under XDP Tx ZC mode.

Performance of tx-only using xdp-sock on Intel ADL-S platform is
the same with and without this patch.

root@intel-corei7-64:~# ./xdpsock -i enp0s30f4 -t -z -q 1 -n 10
 sock0@enp0s30f4:1 txonly xdp-drv
                   pps            pkts           10.00
rx                 0              0
tx                 511630         8659520

 sock0@enp0s30f4:1 txonly xdp-drv
                   pps            pkts           10.00
rx                 0              0
tx                 511625         13775808

 sock0@enp0s30f4:1 txonly xdp-drv
                   pps            pkts           10.00
rx                 0              0
tx                 511619         18892032

Fixes: 132c32ee5bc0 ("net: stmmac: Add TX via XDP zero-copy socket")
Cc: <stable@vger.kernel.org> # 5.13.x
Co-developed-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5358,7 +5358,7 @@ static int stmmac_napi_poll_rxtx(struct
 	struct stmmac_channel *ch =
 		container_of(napi, struct stmmac_channel, rxtx_napi);
 	struct stmmac_priv *priv = ch->priv_data;
-	int rx_done, tx_done;
+	int rx_done, tx_done, rxtx_done;
 	u32 chan = ch->index;
 
 	priv->xstats.napi_poll++;
@@ -5368,14 +5368,16 @@ static int stmmac_napi_poll_rxtx(struct
 
 	rx_done = stmmac_rx_zc(priv, budget, chan);
 
+	rxtx_done = max(tx_done, rx_done);
+
 	/* If either TX or RX work is not complete, return budget
 	 * and keep pooling
 	 */
-	if (tx_done >= budget || rx_done >= budget)
+	if (rxtx_done >= budget)
 		return budget;
 
 	/* all work done, exit the polling mode */
-	if (napi_complete_done(napi, rx_done)) {
+	if (napi_complete_done(napi, rxtx_done)) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&ch->lock, flags);
@@ -5386,7 +5388,7 @@ static int stmmac_napi_poll_rxtx(struct
 		spin_unlock_irqrestore(&ch->lock, flags);
 	}
 
-	return min(rx_done, budget - 1);
+	return min(rxtx_done, budget - 1);
 }
 
 /**


