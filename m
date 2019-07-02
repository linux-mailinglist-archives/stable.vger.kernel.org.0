Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7A15CAEB
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfGBIJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbfGBIJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:09:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36DE221479;
        Tue,  2 Jul 2019 08:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054966;
        bh=jxKyYLS206eyCqpUlU6qSBoV+PF/H1dACTeLISo2As8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUKcAe+U4KQZ0o4k2n9mioikyvdW+d3XD4RgvNJC6zFAS4VGjbi6vyAgMrh/EwGcB
         0+gCgtzQwgWwrKQBRH/9iO/bOf8k2B/lOL9/mBgAG1zosb73hFwEldVbT88e8lAe/2
         YNF2KDWGrgVOukhKZP3N27Pm/skNsXDmcqJzpFxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gary Leshner <Gary.S.Leshner@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/43] IB/hfi1: Close PSM sdma_progress sleep window
Date:   Tue,  2 Jul 2019 10:01:45 +0200
Message-Id: <20190702080124.144847078@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit da9de5f8527f4b9efc82f967d29a583318c034c7 upstream.

The call to sdma_progress() is called outside the wait lock.

In this case, there is a race condition where sdma_progress() can return
false and the sdma_engine can idle.  If that happens, there will be no
more sdma interrupts to cause the wakeup and the user_sdma xmit will hang.

Fix by moving the lock to enclose the sdma_progress() call.

Also, delete busycount. The need for this was removed by:
commit bcad29137a97 ("IB/hfi1: Serve the most starved iowait entry first")

Ported to linux-4.14.y.

Cc: <stable@vger.kernel.org>
Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Gary Leshner <Gary.S.Leshner@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 12 ++++--------
 drivers/infiniband/hw/hfi1/user_sdma.h |  1 -
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index cbe5ab26d95b..75275f9e363d 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -132,25 +132,22 @@ static int defer_packet_queue(
 	struct hfi1_user_sdma_pkt_q *pq =
 		container_of(wait, struct hfi1_user_sdma_pkt_q, busy);
 	struct hfi1_ibdev *dev = &pq->dd->verbs_dev;
-	struct user_sdma_txreq *tx =
-		container_of(txreq, struct user_sdma_txreq, txreq);
 
-	if (sdma_progress(sde, seq, txreq)) {
-		if (tx->busycount++ < MAX_DEFER_RETRY_COUNT)
-			goto eagain;
-	}
+	write_seqlock(&dev->iowait_lock);
+	if (sdma_progress(sde, seq, txreq))
+		goto eagain;
 	/*
 	 * We are assuming that if the list is enqueued somewhere, it
 	 * is to the dmawait list since that is the only place where
 	 * it is supposed to be enqueued.
 	 */
 	xchg(&pq->state, SDMA_PKT_Q_DEFERRED);
-	write_seqlock(&dev->iowait_lock);
 	if (list_empty(&pq->busy.list))
 		iowait_queue(pkts_sent, &pq->busy, &sde->dmawait);
 	write_sequnlock(&dev->iowait_lock);
 	return -EBUSY;
 eagain:
+	write_sequnlock(&dev->iowait_lock);
 	return -EAGAIN;
 }
 
@@ -803,7 +800,6 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 
 		tx->flags = 0;
 		tx->req = req;
-		tx->busycount = 0;
 		INIT_LIST_HEAD(&tx->list);
 
 		/*
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 2b5326d6db53..87b0c567f442 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -236,7 +236,6 @@ struct user_sdma_txreq {
 	struct list_head list;
 	struct user_sdma_request *req;
 	u16 flags;
-	unsigned int busycount;
 	u64 seqnum;
 };
 
-- 
2.20.1



