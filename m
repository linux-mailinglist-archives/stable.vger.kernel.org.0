Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46471247422
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387704AbgHQPos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387698AbgHQPol (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:44:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6303A20760;
        Mon, 17 Aug 2020 15:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679081;
        bh=l7DTXjuAfklnRbRkGFN8yM3xQMOqDlSYweAigS6M2Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1BNfWkaKGckK9yfyqwoQxqxR8f2FIJhomQUqlv5yMYoI7BbKeXM3d/WPMDLrJI/Y
         K//eZD3HRewsC2aZqkzvgNqRlpMB0bWHUwtPh70OwI3D5NV+i02WTyMx6cVDaVgv3Z
         Lcl+fZYSjgy3o7AYwhGjjvIibUT+Gup86cYnC+dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 059/393] nvme-rdma: fix controller reset hang during traffic
Date:   Mon, 17 Aug 2020 17:11:49 +0200
Message-Id: <20200817143822.485415520@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 9f98772ba307dd89a3d17dc2589f213d3972fc64 ]

commit fe35ec58f0d3 ("block: update hctx map when use multiple maps")
exposed an issue where we may hang trying to wait for queue freeze
during I/O. We call blk_mq_update_nr_hw_queues which in case of multiple
queue maps (which we have now for default/read/poll) is attempting to
freeze the queue. However we never started queue freeze when starting the
reset, which means that we have inflight pending requests that entered the
queue that we will not complete once the queue is quiesced.

So start a freeze before we quiesce the queue, and unfreeze the queue
after we successfully connected the I/O queues (and make sure to call
blk_mq_update_nr_hw_queues only after we are sure that the queue was
already frozen).

This follows to how the pci driver handles resets.

Fixes: fe35ec58f0d3 ("block: update hctx map when use multiple maps")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 1f9a45145d0d3..19c94080512cf 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -882,15 +882,20 @@ static int nvme_rdma_configure_io_queues(struct nvme_rdma_ctrl *ctrl, bool new)
 			ret = PTR_ERR(ctrl->ctrl.connect_q);
 			goto out_free_tag_set;
 		}
-	} else {
-		blk_mq_update_nr_hw_queues(&ctrl->tag_set,
-			ctrl->ctrl.queue_count - 1);
 	}
 
 	ret = nvme_rdma_start_io_queues(ctrl);
 	if (ret)
 		goto out_cleanup_connect_q;
 
+	if (!new) {
+		nvme_start_queues(&ctrl->ctrl);
+		nvme_wait_freeze(&ctrl->ctrl);
+		blk_mq_update_nr_hw_queues(ctrl->ctrl.tagset,
+			ctrl->ctrl.queue_count - 1);
+		nvme_unfreeze(&ctrl->ctrl);
+	}
+
 	return 0;
 
 out_cleanup_connect_q:
@@ -923,6 +928,7 @@ static void nvme_rdma_teardown_io_queues(struct nvme_rdma_ctrl *ctrl,
 		bool remove)
 {
 	if (ctrl->ctrl.queue_count > 1) {
+		nvme_start_freeze(&ctrl->ctrl);
 		nvme_stop_queues(&ctrl->ctrl);
 		nvme_rdma_stop_io_queues(ctrl);
 		if (ctrl->ctrl.tagset) {
-- 
2.25.1



