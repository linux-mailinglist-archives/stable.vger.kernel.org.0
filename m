Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8AA3DD8DF
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbhHBNzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236094AbhHBNy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:54:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9818861102;
        Mon,  2 Aug 2021 13:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912400;
        bh=QGaWAku/PPXSmCt+AyDqwaH/JxxS7MUukL+O0MH1q8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZGn97aNX6kawO3Oomf1tFZpqre6JJ6QJnlXFF34w3TY5JHzAfXD9eX1Ncu3tTFci
         rm8Rc9sohWZg3zHVKV34C8ANSYU8eRAd8X3LvA0taz+OfOh8QKbOguptlVJmAmqIbB
         AI1VBsdYcNEZH65pOv81i+xnHutDIYR009NVMIlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/67] ionic: fix up dim accounting for tx and rx
Date:   Mon,  2 Aug 2021 15:45:05 +0200
Message-Id: <20210802134340.451375972@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 76ed8a4a00b484dcccef819ef2618bcf8e46f560 ]

We need to count the correct Tx and/or Rx packets for dynamic
interrupt moderation, depending on which we're processing on
the queue interrupt.

Fixes: 04a834592bf5 ("ionic: dynamic interrupt moderation")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 28 ++++++++++++++-----
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index ec064327c998..52213fee054d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -417,11 +417,12 @@ void ionic_rx_empty(struct ionic_queue *q)
 	}
 }
 
-static void ionic_dim_update(struct ionic_qcq *qcq)
+static void ionic_dim_update(struct ionic_qcq *qcq, int napi_mode)
 {
 	struct dim_sample dim_sample;
 	struct ionic_lif *lif;
 	unsigned int qi;
+	u64 pkts, bytes;
 
 	if (!qcq->intr.dim_coal_hw)
 		return;
@@ -429,10 +430,23 @@ static void ionic_dim_update(struct ionic_qcq *qcq)
 	lif = qcq->q.lif;
 	qi = qcq->cq.bound_q->index;
 
+	switch (napi_mode) {
+	case IONIC_LIF_F_TX_DIM_INTR:
+		pkts = lif->txqstats[qi].pkts;
+		bytes = lif->txqstats[qi].bytes;
+		break;
+	case IONIC_LIF_F_RX_DIM_INTR:
+		pkts = lif->rxqstats[qi].pkts;
+		bytes = lif->rxqstats[qi].bytes;
+		break;
+	default:
+		pkts = lif->txqstats[qi].pkts + lif->rxqstats[qi].pkts;
+		bytes = lif->txqstats[qi].bytes + lif->rxqstats[qi].bytes;
+		break;
+	}
+
 	dim_update_sample(qcq->cq.bound_intr->rearm_count,
-			  lif->txqstats[qi].pkts,
-			  lif->txqstats[qi].bytes,
-			  &dim_sample);
+			  pkts, bytes, &dim_sample);
 
 	net_dim(&qcq->dim, dim_sample);
 }
@@ -453,7 +467,7 @@ int ionic_tx_napi(struct napi_struct *napi, int budget)
 				     ionic_tx_service, NULL, NULL);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
-		ionic_dim_update(qcq);
+		ionic_dim_update(qcq, IONIC_LIF_F_TX_DIM_INTR);
 		flags |= IONIC_INTR_CRED_UNMASK;
 		cq->bound_intr->rearm_count++;
 	}
@@ -489,7 +503,7 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 		ionic_rx_fill(cq->bound_q);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
-		ionic_dim_update(qcq);
+		ionic_dim_update(qcq, IONIC_LIF_F_RX_DIM_INTR);
 		flags |= IONIC_INTR_CRED_UNMASK;
 		cq->bound_intr->rearm_count++;
 	}
@@ -531,7 +545,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 		ionic_rx_fill_cb(rxcq->bound_q);
 
 	if (rx_work_done < budget && napi_complete_done(napi, rx_work_done)) {
-		ionic_dim_update(qcq);
+		ionic_dim_update(qcq, 0);
 		flags |= IONIC_INTR_CRED_UNMASK;
 		rxcq->bound_intr->rearm_count++;
 	}
-- 
2.30.2



