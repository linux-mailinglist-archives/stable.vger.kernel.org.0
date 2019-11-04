Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42D8EED3A
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388950AbfKDWEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:04:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389718AbfKDWEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:04:43 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63BE2217F4;
        Mon,  4 Nov 2019 22:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905082;
        bh=YWefkR9LMZuyDk383P/EHzICtHOQ03NgYUEwjlP1mDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DC9WG9LjdfrcPowBQAXEg/nWwEJ9IViZ8FhonkMcc82E6S7KG36k6vi4MaMofANB1
         PU1D2e82eVRiHe/KC7a6+cqf3KoR5zrEuPytADU6LfnrFZ+02e52Slgh57IIy5dFf6
         gG3K1IEhXdMe3n2M9YZD8vSQdo7GNOSwoI9pNqws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rahul Kundu <rahul.kundu@chelsio.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 023/163] RDMA/iw_cxgb4: fix SRQ access from dump_qp()
Date:   Mon,  4 Nov 2019 22:43:33 +0100
Message-Id: <20191104212142.043159001@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Potnuri Bharat Teja <bharat@chelsio.com>

[ Upstream commit 91724c1e5afe45b64970036170659726e7dc5cff ]

dump_qp() is wrongly trying to dump SRQ structures as QP when SRQ is used
by the application. This patch matches the QPID before dumping them.  Also
removes unwanted SRQ id addition to QP id xarray.

Fixes: 2f43129127e6 ("cxgb4: Convert qpidr to XArray")
Link: https://lore.kernel.org/r/20190930074119.20046-1-bharat@chelsio.com
Signed-off-by: Rahul Kundu <rahul.kundu@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/device.c |  7 +++++--
 drivers/infiniband/hw/cxgb4/qp.c     | 10 +---------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index a8b9548bd1a26..599340c1f0b82 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -242,10 +242,13 @@ static void set_ep_sin6_addrs(struct c4iw_ep *ep,
 	}
 }
 
-static int dump_qp(struct c4iw_qp *qp, struct c4iw_debugfs_data *qpd)
+static int dump_qp(unsigned long id, struct c4iw_qp *qp,
+		   struct c4iw_debugfs_data *qpd)
 {
 	int space;
 	int cc;
+	if (id != qp->wq.sq.qid)
+		return 0;
 
 	space = qpd->bufsize - qpd->pos - 1;
 	if (space == 0)
@@ -350,7 +353,7 @@ static int qp_open(struct inode *inode, struct file *file)
 
 	xa_lock_irq(&qpd->devp->qps);
 	xa_for_each(&qpd->devp->qps, index, qp)
-		dump_qp(qp, qpd);
+		dump_qp(index, qp, qpd);
 	xa_unlock_irq(&qpd->devp->qps);
 
 	qpd->buf[qpd->pos++] = 0;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index eb9368be28c1d..bbcac539777a2 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -2737,15 +2737,11 @@ int c4iw_create_srq(struct ib_srq *ib_srq, struct ib_srq_init_attr *attrs,
 	if (CHELSIO_CHIP_VERSION(rhp->rdev.lldi.adapter_type) > CHELSIO_T6)
 		srq->flags = T4_SRQ_LIMIT_SUPPORT;
 
-	ret = xa_insert_irq(&rhp->qps, srq->wq.qid, srq, GFP_KERNEL);
-	if (ret)
-		goto err_free_queue;
-
 	if (udata) {
 		srq_key_mm = kmalloc(sizeof(*srq_key_mm), GFP_KERNEL);
 		if (!srq_key_mm) {
 			ret = -ENOMEM;
-			goto err_remove_handle;
+			goto err_free_queue;
 		}
 		srq_db_key_mm = kmalloc(sizeof(*srq_db_key_mm), GFP_KERNEL);
 		if (!srq_db_key_mm) {
@@ -2789,8 +2785,6 @@ err_free_srq_db_key_mm:
 	kfree(srq_db_key_mm);
 err_free_srq_key_mm:
 	kfree(srq_key_mm);
-err_remove_handle:
-	xa_erase_irq(&rhp->qps, srq->wq.qid);
 err_free_queue:
 	free_srq_queue(srq, ucontext ? &ucontext->uctx : &rhp->rdev.uctx,
 		       srq->wr_waitp);
@@ -2813,8 +2807,6 @@ void c4iw_destroy_srq(struct ib_srq *ibsrq, struct ib_udata *udata)
 	rhp = srq->rhp;
 
 	pr_debug("%s id %d\n", __func__, srq->wq.qid);
-
-	xa_erase_irq(&rhp->qps, srq->wq.qid);
 	ucontext = rdma_udata_to_drv_context(udata, struct c4iw_ucontext,
 					     ibucontext);
 	free_srq_queue(srq, ucontext ? &ucontext->uctx : &rhp->rdev.uctx,
-- 
2.20.1



