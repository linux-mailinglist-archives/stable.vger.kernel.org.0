Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFA89DD18F
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfJRWDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbfJRWDz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:03:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CBBF222D3;
        Fri, 18 Oct 2019 22:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436233;
        bh=fDteLza2W1wJUfSTg/wf7TafiBkuex3xqUTpb6zVZQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XO9LiVOcRnV+PwvlVBaFRzIAZptSebYrbl4XPH4uMa1sPB/ouESXF1TshMop+SZhz
         9goy0YuL3qnSqu1kQ8pcbopSj68Ic77zCQVMMjmsB8p/AKMRh/wUsZ1f8sNBM4DHpD
         kMWe9gZBuqB+pWhK2cKIV9vpF3nIXZEVjsAZX8wY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Potnuri Bharat Teja <bharat@chelsio.com>,
        Rahul Kundu <rahul.kundu@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 19/89] RDMA/iw_cxgb4: fix SRQ access from dump_qp()
Date:   Fri, 18 Oct 2019 18:02:14 -0400
Message-Id: <20191018220324.8165-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -2789,8 +2785,6 @@ int c4iw_create_srq(struct ib_srq *ib_srq, struct ib_srq_init_attr *attrs,
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

