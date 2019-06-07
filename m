Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6353F38A29
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 14:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbfFGMZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 08:25:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:39615 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728526AbfFGMZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 08:25:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 05:25:36 -0700
X-ExtLoop1: 1
Received: from sedona.ch.intel.com ([10.2.136.157])
  by fmsmga008.fm.intel.com with ESMTP; 07 Jun 2019 05:25:35 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x57CPXnv062822;
        Fri, 7 Jun 2019 05:25:34 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x57CPVAv158521;
        Fri, 7 Jun 2019 08:25:32 -0400
Subject: [PATCH for-rc 2/3] IB/hfi1: Close PSM sdma_progress sleep window
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Gary Leshner <Gary.S.Leshner@intel.com>
Date:   Fri, 07 Jun 2019 08:25:31 -0400
Message-ID: <20190607122531.158478.35392.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
References: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

The call to sdma_progress() is called outside the wait lock.

In this case, there is a race condition where sdma_progress() can return
false and the sdma_engine can idle.  If that happens, there will be no
more sdma interrupts to cause the wakeup and the user_sdma xmit will hang.

Fix by moving the lock to enclose the sdma_progress() call.

Also, delete busycount. The need for this was removed by:
commit bcad29137a97 ("IB/hfi1: Serve the most starved iowait entry first")

Cc: <stable@vger.kernel.org>
Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Gary Leshner <Gary.S.Leshner@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   12 ++++--------
 drivers/infiniband/hw/hfi1/user_sdma.h |    1 -
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 8bfbc6d..fd754a1 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -130,20 +130,16 @@ static int defer_packet_queue(
 {
 	struct hfi1_user_sdma_pkt_q *pq =
 		container_of(wait->iow, struct hfi1_user_sdma_pkt_q, busy);
-	struct user_sdma_txreq *tx =
-		container_of(txreq, struct user_sdma_txreq, txreq);
 
-	if (sdma_progress(sde, seq, txreq)) {
-		if (tx->busycount++ < MAX_DEFER_RETRY_COUNT)
-			goto eagain;
-	}
+	write_seqlock(&sde->waitlock);
+	if (sdma_progress(sde, seq, txreq))
+		goto eagain;
 	/*
 	 * We are assuming that if the list is enqueued somewhere, it
 	 * is to the dmawait list since that is the only place where
 	 * it is supposed to be enqueued.
 	 */
 	xchg(&pq->state, SDMA_PKT_Q_DEFERRED);
-	write_seqlock(&sde->waitlock);
 	if (list_empty(&pq->busy.list)) {
 		iowait_get_priority(&pq->busy);
 		iowait_queue(pkts_sent, &pq->busy, &sde->dmawait);
@@ -151,6 +147,7 @@ static int defer_packet_queue(
 	write_sequnlock(&sde->waitlock);
 	return -EBUSY;
 eagain:
+	write_sequnlock(&sde->waitlock);
 	return -EAGAIN;
 }
 
@@ -804,7 +801,6 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, u16 maxpkts)
 
 		tx->flags = 0;
 		tx->req = req;
-		tx->busycount = 0;
 		INIT_LIST_HEAD(&tx->list);
 
 		/*
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 14dfd75..4d8510b0 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -245,7 +245,6 @@ struct user_sdma_txreq {
 	struct list_head list;
 	struct user_sdma_request *req;
 	u16 flags;
-	unsigned int busycount;
 	u16 seqnum;
 };
 

