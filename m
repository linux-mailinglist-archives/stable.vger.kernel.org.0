Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCE22A59A0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgKCUkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:40:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730118AbgKCUkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:40:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9D9D223EA;
        Tue,  3 Nov 2020 20:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436001;
        bh=BziPCTJLCAWSER9QJjLifg+x9+tNUm0Ng0iRmcdDZAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WqM1jl4Uv3AyAvOZxETQtibs5IyPvNX+lLkBVuaN0LHAJ3s9E8Bt7W86jUnD+5iiL
         HZsezUAd8XZgbuSZfRnfcuUHitmncGIcyZ5QVpiBbbjkePs8sYAGwfOyKcmY3AY26i
         DH9FGic8iSV6+Jdx+Ra9DemhlHl99qIJCGDbMRHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 022/391] ionic: no rx flush in deinit
Date:   Tue,  3 Nov 2020 21:31:13 +0100
Message-Id: <20201103203349.379559871@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 43ecf7b46f2688fd37909801aee264f288b3917b ]

Kmemleak pointed out to us that ionic_rx_flush() is sending
skbs into napi_gro_XXX with a disabled napi context, and these
end up getting lost and leaked.  We can safely remove the flush.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  |  1 -
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 13 -------------
 drivers/net/ethernet/pensando/ionic/ionic_txrx.h |  1 -
 3 files changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 26988ad7ec979..8867d4ac871c1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1512,7 +1512,6 @@ static void ionic_txrx_deinit(struct ionic_lif *lif)
 	if (lif->rxqcqs) {
 		for (i = 0; i < lif->nxqs; i++) {
 			ionic_lif_qcq_deinit(lif, lif->rxqcqs[i].qcq);
-			ionic_rx_flush(&lif->rxqcqs[i].qcq->cq);
 			ionic_rx_empty(&lif->rxqcqs[i].qcq->q);
 		}
 	}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index def65fee27b5a..39e85870c15e9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -253,19 +253,6 @@ static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	return true;
 }
 
-void ionic_rx_flush(struct ionic_cq *cq)
-{
-	struct ionic_dev *idev = &cq->lif->ionic->idev;
-	u32 work_done;
-
-	work_done = ionic_cq_service(cq, cq->num_descs,
-				     ionic_rx_service, NULL, NULL);
-
-	if (work_done)
-		ionic_intr_credits(idev->intr_ctrl, cq->bound_intr->index,
-				   work_done, IONIC_INTR_CRED_RESET_COALESCE);
-}
-
 static struct page *ionic_rx_page_alloc(struct ionic_queue *q,
 					dma_addr_t *dma_addr)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
index a5883be0413f6..7667b72232b8a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
@@ -4,7 +4,6 @@
 #ifndef _IONIC_TXRX_H_
 #define _IONIC_TXRX_H_
 
-void ionic_rx_flush(struct ionic_cq *cq);
 void ionic_tx_flush(struct ionic_cq *cq);
 
 void ionic_rx_fill(struct ionic_queue *q);
-- 
2.27.0



