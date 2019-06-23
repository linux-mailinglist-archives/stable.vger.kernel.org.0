Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5864FC84
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 17:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfFWP6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 11:58:49 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36113 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbfFWP6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 11:58:48 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0293C220CB;
        Sun, 23 Jun 2019 11:58:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 11:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JfjKZv
        ziLROt4JA4rwDa/7Nad6mRBfK5xkZEYNbDftY=; b=bILsOqp0u1cYGol3g/J39D
        XRISTioL4Mm5AEgW/efHvBBaBPxlJ8n0o2tqDTIoN21Wn35HV/ULJR9h1qRKfuJM
        sME5JCR96LBMuq7xYtT+c5CtVHCKR741e1cZ07g3o2XomuwoC7k9LkVMTSFL7o2P
        u7hv/aiJ4GWCNniDz+eEpHEX9Iv5T+6F0cwBR79OXVOoP1BcZZD1hxqDD6p98lSy
        S07JpBPYoA+aaIkKl8EtDNAy4HqftdF2EcsZd5cZ/g+X79NpNvn2Q2bEBuYpbsPl
        YoUYQsts/ZrYfvTCMHnt468sSHu7Iv+hop8P/6/E3GPgy+I73S33sgbHCUwASeeQ
        ==
X-ME-Sender: <xms:t6EPXZkq_v-YyTs-FsranW-Qk-SRPo1Kab20CJDRhrhJcO5X6gXUiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekgedrvdeguddrudeliedrvddvtdenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:t6EPXc04_S3Hen7u4MK7YRIuGvDQmyadAYUpn8VwsDFQUZvvOJr3vg>
    <xmx:t6EPXQQzkmr4f5b6_zDuSKNnVbIaokqQ7r2GdIOg1GZT-WHnF1-rWQ>
    <xmx:t6EPXZKDstY5KQqVY7rpeP6SbXg9-dr-Ipn11PBS7VJDu_klpf4W4A>
    <xmx:t6EPXbgOs6YnkHhOYCnFEmkDTFnWZ1pdNOLDgW5K0kgNCE_zHIEwYA>
Received: from localhost (unknown [84.241.196.220])
        by mail.messagingengine.com (Postfix) with ESMTPA id 529E08005A;
        Sun, 23 Jun 2019 11:58:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/hfi1: Close PSM sdma_progress sleep window" failed to apply to 4.4-stable tree
To:     mike.marciniszyn@intel.com, Gary.S.Leshner@intel.com,
        dennis.dalessandro@intel.com, jgg@mellanox.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 17:58:34 +0200
Message-ID: <15613055141552@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From da9de5f8527f4b9efc82f967d29a583318c034c7 Mon Sep 17 00:00:00 2001
From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Date: Fri, 7 Jun 2019 08:25:31 -0400
Subject: [PATCH] IB/hfi1: Close PSM sdma_progress sleep window

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
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 8bfbc6d7ea34..fd754a16475a 100644
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
index 14dfd757dafd..4d8510b0fc38 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -245,7 +245,6 @@ struct user_sdma_txreq {
 	struct list_head list;
 	struct user_sdma_request *req;
 	u16 flags;
-	unsigned int busycount;
 	u16 seqnum;
 };
 

