Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63AC25182D
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 18:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbfFXQOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 12:14:31 -0400
Received: from mga17.intel.com ([192.55.52.151]:42048 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfFXQOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 12:14:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jun 2019 09:14:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,412,1557212400"; 
   d="scan'208";a="163362194"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jun 2019 09:14:30 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x5OGEUb9052032;
        Mon, 24 Jun 2019 09:14:30 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x5OGEToZ017483;
        Mon, 24 Jun 2019 12:14:29 -0400
Subject: [PATCH] IB/hfi1: Avoid hardlockup with flushlist_lock
To:     stable@vger.kernel.org
From:   Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc:     linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
Date:   Mon, 24 Jun 2019 12:14:29 -0400
Message-ID: <20190624161428.17461.31880.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit cf131a81967583ae737df6383a0893b9fee75b4e upstream.

Heavy contention of the sde flushlist_lock can cause hard lockups at
extreme scale when the flushing logic is under stress.

Mitigate by replacing the item at a time copy to the local list with
an O(1) list_splice_init() and using the high priority work queue to
do the flushes.

Ported to linux-4.14.y.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: <stable@vger.kernel.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 drivers/infiniband/hw/hfi1/sdma.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 6781bcd..ec613d5 100644
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
@@ -2437,7 +2434,7 @@ int sdma_send_txreq(struct sdma_engine *sde,
 		wait->tx_count++;
 		wait->count += tx->num_desc;
 	}
-	schedule_work(&sde->flush_worker);
+	queue_work_on(sde->cpu, system_highpri_wq, &sde->flush_worker);
 	ret = -ECOMM;
 	goto unlock;
 nodesc:
@@ -2537,7 +2534,7 @@ int sdma_send_txlist(struct sdma_engine *sde, struct iowait *wait,
 		}
 	}
 	spin_unlock(&sde->flushlist_lock);
-	schedule_work(&sde->flush_worker);
+	queue_work_on(sde->cpu, system_highpri_wq, &sde->flush_worker);
 	ret = -ECOMM;
 	goto update_tail;
 nodesc:

