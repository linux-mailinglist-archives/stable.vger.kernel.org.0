Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73DE31218E8
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfLPRzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:55:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbfLPRy7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:54:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FEF42053B;
        Mon, 16 Dec 2019 17:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518898;
        bh=98Jbf77nAwt1fSG0qBVGdDEDkG9mLiiWzrCEKzaMeNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ev4ZZJeY/1avEM3eP9DTtrInwyFqMi5POwblEQP3Ci/i1ofbW5OyxyPIjwf+fBJx2
         j243nxuyI+w4NgbIlcjrD5zlQSPL7NjLoUcHsvmUz3mUfIZm0I7IUDQHuXy7xs64NI
         CX5K/lOk+2InkuSrbLqWXiggTD8DrU89fCU2rwrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gary Leshner <Gary.S.Leshner@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 113/267] IB/hfi1: Close VNIC sdma_progress sleep window
Date:   Mon, 16 Dec 2019 18:47:19 +0100
Message-Id: <20191216174902.903414276@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit 18912c4524385dd6532c682cb9d4f6aa39ba8d47 ]

The call to sdma_progress() is called outside the wait lock.

In this case, there is a race condition where sdma_progress() can return
false and the sdma_engine can idle.  If that happens, there will be no
more sdma interrupts to cause the wakeup and the vnic_sdma xmit will hang.

Fix by moving the lock to enclose the sdma_progress() call.

Also, delete the tx_retry. The need for this was removed by:
commit bcad29137a97 ("IB/hfi1: Serve the most starved iowait entry first")

Fixes: 64551ede6cd1 ("IB/hfi1: VNIC SDMA support")
Reviewed-by: Gary Leshner <Gary.S.Leshner@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/vnic_sdma.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/vnic_sdma.c b/drivers/infiniband/hw/hfi1/vnic_sdma.c
index c3c96c5869ed4..718dcdef946ee 100644
--- a/drivers/infiniband/hw/hfi1/vnic_sdma.c
+++ b/drivers/infiniband/hw/hfi1/vnic_sdma.c
@@ -57,7 +57,6 @@
 
 #define HFI1_VNIC_TXREQ_NAME_LEN   32
 #define HFI1_VNIC_SDMA_DESC_WTRMRK 64
-#define HFI1_VNIC_SDMA_RETRY_COUNT 1
 
 /*
  * struct vnic_txreq - VNIC transmit descriptor
@@ -67,7 +66,6 @@
  * @pad: pad buffer
  * @plen: pad length
  * @pbc_val: pbc value
- * @retry_count: tx retry count
  */
 struct vnic_txreq {
 	struct sdma_txreq       txreq;
@@ -77,8 +75,6 @@ struct vnic_txreq {
 	unsigned char           pad[HFI1_VNIC_MAX_PAD];
 	u16                     plen;
 	__le64                  pbc_val;
-
-	u32                     retry_count;
 };
 
 static void vnic_sdma_complete(struct sdma_txreq *txreq,
@@ -196,7 +192,6 @@ int hfi1_vnic_send_dma(struct hfi1_devdata *dd, u8 q_idx,
 	ret = build_vnic_tx_desc(sde, tx, pbc);
 	if (unlikely(ret))
 		goto free_desc;
-	tx->retry_count = 0;
 
 	ret = sdma_send_txreq(sde, &vnic_sdma->wait, &tx->txreq,
 			      vnic_sdma->pkts_sent);
@@ -238,14 +233,14 @@ static int hfi1_vnic_sdma_sleep(struct sdma_engine *sde,
 	struct hfi1_vnic_sdma *vnic_sdma =
 		container_of(wait, struct hfi1_vnic_sdma, wait);
 	struct hfi1_ibdev *dev = &vnic_sdma->dd->verbs_dev;
-	struct vnic_txreq *tx = container_of(txreq, struct vnic_txreq, txreq);
 
-	if (sdma_progress(sde, seq, txreq))
-		if (tx->retry_count++ < HFI1_VNIC_SDMA_RETRY_COUNT)
-			return -EAGAIN;
+	write_seqlock(&dev->iowait_lock);
+	if (sdma_progress(sde, seq, txreq)) {
+		write_sequnlock(&dev->iowait_lock);
+		return -EAGAIN;
+	}
 
 	vnic_sdma->state = HFI1_VNIC_SDMA_Q_DEFERRED;
-	write_seqlock(&dev->iowait_lock);
 	if (list_empty(&vnic_sdma->wait.list))
 		iowait_queue(pkts_sent, wait, &sde->dmawait);
 	write_sequnlock(&dev->iowait_lock);
-- 
2.20.1



