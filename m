Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55274199062
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbgCaJL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731430AbgCaJL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:11:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8F7620675;
        Tue, 31 Mar 2020 09:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645886;
        bh=O3FDISHoAiPz15RmgglneoLtgMFI0IG2j0nxtYl0R+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISNcEtL66sClbH2l5CBysWqkqswo7Wps2MGoE5ortdnEQvqwINzv8WNH/1cK3mcAD
         z/WGS2ILoTWb54tUeyv8/t02wM6sQ9IEW9Z83rHi/bDHvsUekiW2MrwSBALjcY137p
         Y1RvrUEvSdxs0d/YowZBxz/5DkD2KKRzvbjm9N2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 008/155] cxgb4: fix Txq restart check during backpressure
Date:   Tue, 31 Mar 2020 10:57:28 +0200
Message-Id: <20200331085419.325664975@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit f1f20a8666c55cb534b8f3fc1130eebf01a06155 ]

Driver reclaims descriptors in much smaller batches, even if hardware
indicates more to reclaim, during backpressure. So, fix the check to
restart the Txq during backpressure, by looking at how many
descriptors hardware had indicated to reclaim, and not on how many
descriptors that driver had actually reclaimed. Once the Txq is
restarted, driver will reclaim even more descriptors when Tx path
is entered again.

Fixes: d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE doorbell queue timer")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1324,8 +1324,9 @@ static inline void t6_fill_tnl_lso(struc
 int t4_sge_eth_txq_egress_update(struct adapter *adap, struct sge_eth_txq *eq,
 				 int maxreclaim)
 {
+	unsigned int reclaimed, hw_cidx;
 	struct sge_txq *q = &eq->q;
-	unsigned int reclaimed;
+	int hw_in_use;
 
 	if (!q->in_use || !__netif_tx_trylock(eq->txq))
 		return 0;
@@ -1333,12 +1334,17 @@ int t4_sge_eth_txq_egress_update(struct
 	/* Reclaim pending completed TX Descriptors. */
 	reclaimed = reclaim_completed_tx(adap, &eq->q, maxreclaim, true);
 
+	hw_cidx = ntohs(READ_ONCE(q->stat->cidx));
+	hw_in_use = q->pidx - hw_cidx;
+	if (hw_in_use < 0)
+		hw_in_use += q->size;
+
 	/* If the TX Queue is currently stopped and there's now more than half
 	 * the queue available, restart it.  Otherwise bail out since the rest
 	 * of what we want do here is with the possibility of shipping any
 	 * currently buffered Coalesced TX Work Request.
 	 */
-	if (netif_tx_queue_stopped(eq->txq) && txq_avail(q) > (q->size / 2)) {
+	if (netif_tx_queue_stopped(eq->txq) && hw_in_use < (q->size / 2)) {
 		netif_tx_wake_queue(eq->txq);
 		eq->q.restarts++;
 	}


