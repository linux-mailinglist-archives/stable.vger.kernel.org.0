Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9ACC198F61
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbgCaJCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgCaJCw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:02:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05945208E0;
        Tue, 31 Mar 2020 09:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645371;
        bh=SWSUENhegR9oYvDbEkc+SvxkJkJG6McTNOPrAMSbUFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoFKZzN0R9acJcf3ZsJ4czErMdR37XaZsUIxV2jPoJJmbt5gUv7tCODEHVR8THWGJ
         af2iNl74tv/BINaomkah9j2sySncFvknHav/j6jkxKvnfpcAjFEKX5arO57K0StZDm
         q9AGoKUMmoQCk7s+15lkMOxtarrx+EUo72IHoc7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 009/170] cxgb4: fix Txq restart check during backpressure
Date:   Tue, 31 Mar 2020 10:57:03 +0200
Message-Id: <20200331085425.145828625@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
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
@@ -1307,8 +1307,9 @@ static inline void *write_tso_wr(struct
 int t4_sge_eth_txq_egress_update(struct adapter *adap, struct sge_eth_txq *eq,
 				 int maxreclaim)
 {
+	unsigned int reclaimed, hw_cidx;
 	struct sge_txq *q = &eq->q;
-	unsigned int reclaimed;
+	int hw_in_use;
 
 	if (!q->in_use || !__netif_tx_trylock(eq->txq))
 		return 0;
@@ -1316,12 +1317,17 @@ int t4_sge_eth_txq_egress_update(struct
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


