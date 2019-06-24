Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5CF451C2A
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 22:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbfFXUT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 16:19:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:5806 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfFXUT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 16:19:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jun 2019 13:19:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,413,1557212400"; 
   d="scan'208";a="166439231"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by orsmga006.jf.intel.com with ESMTP; 24 Jun 2019 13:19:53 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x5OKJrqo023475;
        Mon, 24 Jun 2019 13:19:53 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x5OKJhIG170439;
        Mon, 24 Jun 2019 16:19:43 -0400
Subject: [PATCH] IB/hfi1: Close PSM sdma_progress sleep window
To:     stable@vger.kernel.org
From:   Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc:     linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
Date:   Mon, 24 Jun 2019 16:19:43 -0400
Message-ID: <20190624201943.170417.50138.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Ported to linux-4.19.y.

Cc: <stable@vger.kernel.org>
Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Gary Leshner <Gary.S.Leshner@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   12 ++++--------
 drivers/infiniband/hw/hfi1/user_sdma.h |    1 -
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 51831bf..cbff746 100644
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
index 91c343f..2c05670 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -245,7 +245,6 @@ struct user_sdma_txreq {
 	struct list_head list;
 	struct user_sdma_request *req;
 	u16 flags;
-	unsigned int busycount;
 	u64 seqnum;
 };
 

