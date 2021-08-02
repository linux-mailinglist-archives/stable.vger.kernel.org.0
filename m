Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31583DDA22
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbhHBOGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236376AbhHBOEH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12C236121F;
        Mon,  2 Aug 2021 13:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912655;
        bh=G0PIvq9s0DOagE/IHDbUslPQGfgB6iAjvxtsdY/vI2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuUxH4wC2MoX+iUNUmMQ2/tDcaB1JlrJlYequfTVJ5pqX3vmj9l32yYuPgCkrTGmQ
         tUY1AcCkNi5B1xFVOB3smwdtV6dWMqP7nGe55+K2Ta3+2IfL1oDYiKft5hcDeGdcLU
         6163VS2ad4OtYjMwdJ/36TZHkKQjisgVa1fZZq3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 057/104] ionic: remove intr coalesce update from napi
Date:   Mon,  2 Aug 2021 15:44:54 +0200
Message-Id: <20210802134345.882482813@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit a6ff85e0a2d9d074a4b4c291ba9ec1e5b0aba22b ]

Move the interrupt coalesce value update out of the napi
thread and into the dim_work thread and set it only when it
has actually changed.

Fixes: 04a834592bf5 ("ionic: dynamic interrupt moderation")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  | 14 +++++++++++++-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c |  4 ----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 7815e9034fb8..e795fa63ca12 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -53,7 +53,19 @@ static void ionic_dim_work(struct work_struct *work)
 	cur_moder = net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
 	qcq = container_of(dim, struct ionic_qcq, dim);
 	new_coal = ionic_coal_usec_to_hw(qcq->q.lif->ionic, cur_moder.usec);
-	qcq->intr.dim_coal_hw = new_coal ? new_coal : 1;
+	new_coal = new_coal ? new_coal : 1;
+
+	if (qcq->intr.dim_coal_hw != new_coal) {
+		unsigned int qi = qcq->cq.bound_q->index;
+		struct ionic_lif *lif = qcq->q.lif;
+
+		qcq->intr.dim_coal_hw = new_coal;
+
+		ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
+				     lif->rxqcqs[qi]->intr.index,
+				     qcq->intr.dim_coal_hw);
+	}
+
 	dim->state = DIM_START_MEASURE;
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 08934888575c..9d3a04110685 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -463,10 +463,6 @@ static void ionic_dim_update(struct ionic_qcq *qcq)
 	lif = qcq->q.lif;
 	qi = qcq->cq.bound_q->index;
 
-	ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
-			     lif->rxqcqs[qi]->intr.index,
-			     qcq->intr.dim_coal_hw);
-
 	dim_update_sample(qcq->cq.bound_intr->rearm_count,
 			  lif->txqstats[qi].pkts,
 			  lif->txqstats[qi].bytes,
-- 
2.30.2



