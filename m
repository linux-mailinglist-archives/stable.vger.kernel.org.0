Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9821344249
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhCVMkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231643AbhCVMil (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:38:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 537E1619BC;
        Mon, 22 Mar 2021 12:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416668;
        bh=Ng00wofhpmt7vNfYKmjR5cNotRFRjRfBjSRQNPEIWB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiVXU5fOXOXStE9asrbwXB0axvqUOOWc6sEQE/QpE/tjCfDGLssanMKJDBMOHoRvp
         QmumbT6cvfyjPxvFRS8ORbN5XUpLEkF7Z3KcmkXojSaV/nvfTYpcNSvMjQ6VQRYqmN
         30WI9fP+W8ghqg3wAgEqIl8WPtL7cuiKlERov7DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/157] RDMA/rtrs: Remove unnecessary argument dir of rtrs_iu_free
Date:   Mon, 22 Mar 2021 13:27:05 +0100
Message-Id: <20210322121935.920180058@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gioh Kim <gi-oh.kim@cloud.ionos.com>

[ Upstream commit 8bd372ace32ec88fe3ad1421929ae1604f2a2c2c ]

The direction of DMA operation is already in the rtrs_iu

Link: https://lore.kernel.org/r/20201023074353.21946-8-jinpu.wang@cloud.ionos.com
Signed-off-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 14 ++++++--------
 drivers/infiniband/ulp/rtrs/rtrs-pri.h |  3 +--
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 14 ++++++--------
 drivers/infiniband/ulp/rtrs/rtrs.c     |  9 ++++-----
 4 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 5c2107ce7f6e..6eb95e3c4c8a 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1237,8 +1237,7 @@ static void free_sess_reqs(struct rtrs_clt_sess *sess)
 		if (req->mr)
 			ib_dereg_mr(req->mr);
 		kfree(req->sge);
-		rtrs_iu_free(req->iu, DMA_TO_DEVICE,
-			      sess->s.dev->ib_dev, 1);
+		rtrs_iu_free(req->iu, sess->s.dev->ib_dev, 1);
 	}
 	kfree(sess->reqs);
 	sess->reqs = NULL;
@@ -1611,8 +1610,7 @@ static void destroy_con_cq_qp(struct rtrs_clt_con *con)
 
 	rtrs_cq_qp_destroy(&con->c);
 	if (con->rsp_ius) {
-		rtrs_iu_free(con->rsp_ius, DMA_FROM_DEVICE,
-			      sess->s.dev->ib_dev, con->queue_size);
+		rtrs_iu_free(con->rsp_ius, sess->s.dev->ib_dev, con->queue_size);
 		con->rsp_ius = NULL;
 		con->queue_size = 0;
 	}
@@ -2252,7 +2250,7 @@ static void rtrs_clt_info_req_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct rtrs_iu *iu;
 
 	iu = container_of(wc->wr_cqe, struct rtrs_iu, cqe);
-	rtrs_iu_free(iu, DMA_TO_DEVICE, sess->s.dev->ib_dev, 1);
+	rtrs_iu_free(iu, sess->s.dev->ib_dev, 1);
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		rtrs_err(sess->clt, "Sess info request send failed: %s\n",
@@ -2381,7 +2379,7 @@ static void rtrs_clt_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
 
 out:
 	rtrs_clt_update_wc_stats(con);
-	rtrs_iu_free(iu, DMA_FROM_DEVICE, sess->s.dev->ib_dev, 1);
+	rtrs_iu_free(iu, sess->s.dev->ib_dev, 1);
 	rtrs_clt_change_state(sess, state);
 }
 
@@ -2443,9 +2441,9 @@ static int rtrs_send_sess_info(struct rtrs_clt_sess *sess)
 
 out:
 	if (tx_iu)
-		rtrs_iu_free(tx_iu, DMA_TO_DEVICE, sess->s.dev->ib_dev, 1);
+		rtrs_iu_free(tx_iu, sess->s.dev->ib_dev, 1);
 	if (rx_iu)
-		rtrs_iu_free(rx_iu, DMA_FROM_DEVICE, sess->s.dev->ib_dev, 1);
+		rtrs_iu_free(rx_iu, sess->s.dev->ib_dev, 1);
 	if (unlikely(err))
 		/* If we've never taken async path because of malloc problems */
 		rtrs_clt_change_state(sess, RTRS_CLT_CONNECTING_ERR);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index 2e1d2f7e372a..8caad0a2322b 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -289,8 +289,7 @@ struct rtrs_msg_rdma_hdr {
 struct rtrs_iu *rtrs_iu_alloc(u32 queue_size, size_t size, gfp_t t,
 			      struct ib_device *dev, enum dma_data_direction,
 			      void (*done)(struct ib_cq *cq, struct ib_wc *wc));
-void rtrs_iu_free(struct rtrs_iu *iu, enum dma_data_direction dir,
-		  struct ib_device *dev, u32 queue_size);
+void rtrs_iu_free(struct rtrs_iu *iu, struct ib_device *dev, u32 queue_size);
 int rtrs_iu_post_recv(struct rtrs_con *con, struct rtrs_iu *iu);
 int rtrs_iu_post_send(struct rtrs_con *con, struct rtrs_iu *iu, size_t size,
 		      struct ib_send_wr *head);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index b690a3b8f94d..0fd2a7f8f9f2 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -584,8 +584,7 @@ static void unmap_cont_bufs(struct rtrs_srv_sess *sess)
 		struct rtrs_srv_mr *srv_mr;
 
 		srv_mr = &sess->mrs[i];
-		rtrs_iu_free(srv_mr->iu, DMA_TO_DEVICE,
-			      sess->s.dev->ib_dev, 1);
+		rtrs_iu_free(srv_mr->iu, sess->s.dev->ib_dev, 1);
 		ib_dereg_mr(srv_mr->mr);
 		ib_dma_unmap_sg(sess->s.dev->ib_dev, srv_mr->sgt.sgl,
 				srv_mr->sgt.nents, DMA_BIDIRECTIONAL);
@@ -689,8 +688,7 @@ static int map_cont_bufs(struct rtrs_srv_sess *sess)
 			sgt = &srv_mr->sgt;
 			mr = srv_mr->mr;
 free_iu:
-			rtrs_iu_free(srv_mr->iu, DMA_TO_DEVICE,
-				      sess->s.dev->ib_dev, 1);
+			rtrs_iu_free(srv_mr->iu, sess->s.dev->ib_dev, 1);
 dereg_mr:
 			ib_dereg_mr(mr);
 unmap_sg:
@@ -742,7 +740,7 @@ static void rtrs_srv_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct rtrs_iu *iu;
 
 	iu = container_of(wc->wr_cqe, struct rtrs_iu, cqe);
-	rtrs_iu_free(iu, DMA_TO_DEVICE, sess->s.dev->ib_dev, 1);
+	rtrs_iu_free(iu, sess->s.dev->ib_dev, 1);
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		rtrs_err(s, "Sess info response send failed: %s\n",
@@ -868,7 +866,7 @@ static int process_info_req(struct rtrs_srv_con *con,
 	if (unlikely(err)) {
 		rtrs_err(s, "rtrs_iu_post_send(), err: %d\n", err);
 iu_free:
-		rtrs_iu_free(tx_iu, DMA_TO_DEVICE, sess->s.dev->ib_dev, 1);
+		rtrs_iu_free(tx_iu, sess->s.dev->ib_dev, 1);
 	}
 rwr_free:
 	kfree(rwr);
@@ -913,7 +911,7 @@ static void rtrs_srv_info_req_done(struct ib_cq *cq, struct ib_wc *wc)
 		goto close;
 
 out:
-	rtrs_iu_free(iu, DMA_FROM_DEVICE, sess->s.dev->ib_dev, 1);
+	rtrs_iu_free(iu, sess->s.dev->ib_dev, 1);
 	return;
 close:
 	close_sess(sess);
@@ -936,7 +934,7 @@ static int post_recv_info_req(struct rtrs_srv_con *con)
 	err = rtrs_iu_post_recv(&con->c, rx_iu);
 	if (unlikely(err)) {
 		rtrs_err(s, "rtrs_iu_post_recv(), err: %d\n", err);
-		rtrs_iu_free(rx_iu, DMA_FROM_DEVICE, sess->s.dev->ib_dev, 1);
+		rtrs_iu_free(rx_iu, sess->s.dev->ib_dev, 1);
 		return err;
 	}
 
diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index a3e1a027f808..8321e8a52045 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -31,6 +31,7 @@ struct rtrs_iu *rtrs_iu_alloc(u32 queue_size, size_t size, gfp_t gfp_mask,
 		return NULL;
 	for (i = 0; i < queue_size; i++) {
 		iu = &ius[i];
+		iu->direction = dir;
 		iu->buf = kzalloc(size, gfp_mask);
 		if (!iu->buf)
 			goto err;
@@ -41,17 +42,15 @@ struct rtrs_iu *rtrs_iu_alloc(u32 queue_size, size_t size, gfp_t gfp_mask,
 
 		iu->cqe.done  = done;
 		iu->size      = size;
-		iu->direction = dir;
 	}
 	return ius;
 err:
-	rtrs_iu_free(ius, dir, dma_dev, i);
+	rtrs_iu_free(ius, dma_dev, i);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(rtrs_iu_alloc);
 
-void rtrs_iu_free(struct rtrs_iu *ius, enum dma_data_direction dir,
-		   struct ib_device *ibdev, u32 queue_size)
+void rtrs_iu_free(struct rtrs_iu *ius, struct ib_device *ibdev, u32 queue_size)
 {
 	struct rtrs_iu *iu;
 	int i;
@@ -61,7 +60,7 @@ void rtrs_iu_free(struct rtrs_iu *ius, enum dma_data_direction dir,
 
 	for (i = 0; i < queue_size; i++) {
 		iu = &ius[i];
-		ib_dma_unmap_single(ibdev, iu->dma_addr, iu->size, dir);
+		ib_dma_unmap_single(ibdev, iu->dma_addr, iu->size, iu->direction);
 		kfree(iu->buf);
 	}
 	kfree(ius);
-- 
2.30.1



