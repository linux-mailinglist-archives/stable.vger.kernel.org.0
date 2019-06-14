Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B33146432
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 18:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfFNQc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 12:32:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:4453 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbfFNQc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 12:32:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 09:32:28 -0700
X-ExtLoop1: 1
Received: from sedona.ch.intel.com ([10.2.136.157])
  by orsmga005.jf.intel.com with ESMTP; 14 Jun 2019 09:32:27 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x5EGWRp1060957;
        Fri, 14 Jun 2019 09:32:27 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x5EGWQeK045017;
        Fri, 14 Jun 2019 12:32:26 -0400
Subject: [PATCH for-rc 1/7] IB/hfi1: Avoid hardlockup with flushlist_lock
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org
Date:   Fri, 14 Jun 2019 12:32:26 -0400
Message-ID: <20190614163225.44927.41903.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20190614163146.44927.95985.stgit@awfm-01.aw.intel.com>
References: <20190614163146.44927.95985.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

Heavy contention of the sde flushlist_lock can cause hard lockups at
extreme scale when the flushing logic is under stress.

Mitigate by replacing the item at a time copy to the local list with
an O(1) list_splice_init() and using the high priority work queue to
do the flushes.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: <stable@vger.kernel.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/sdma.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index b011072..70828de 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -410,10 +410,7 @@ static void sdma_flush(struct sdma_engine *sde)
 	sdma_flush_descq(sde);
 	spin_lock_irqsave(&sde->flushlist_lock, flags);
 	/* copy flush list */
-	list_for_each_entry_safe(txp, txp_next, &sde->flushlist, list) {
-		list_del_init(&txp->list);
-		list_add_tail(&txp->list, &flushlist);
-	}
+	list_splice_init(&sde->flushlist, &flushlist);
 	spin_unlock_irqrestore(&sde->flushlist_lock, flags);
 	/* flush from flush list */
 	list_for_each_entry_safe(txp, txp_next, &flushlist, list)
@@ -2413,7 +2410,7 @@ int sdma_send_txreq(struct sdma_engine *sde,
 	list_add_tail(&tx->list, &sde->flushlist);
 	spin_unlock(&sde->flushlist_lock);
 	iowait_inc_wait_count(wait, tx->num_desc);
-	schedule_work(&sde->flush_worker);
+	queue_work_on(sde->cpu, system_highpri_wq, &sde->flush_worker);
 	ret = -ECOMM;
 	goto unlock;
 nodesc:
@@ -2511,7 +2508,7 @@ int sdma_send_txlist(struct sdma_engine *sde, struct iowait_work *wait,
 		iowait_inc_wait_count(wait, tx->num_desc);
 	}
 	spin_unlock(&sde->flushlist_lock);
-	schedule_work(&sde->flush_worker);
+	queue_work_on(sde->cpu, system_highpri_wq, &sde->flush_worker);
 	ret = -ECOMM;
 	goto update_tail;
 nodesc:

