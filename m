Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEAD3A92A
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388801AbfFIRHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388751AbfFIRHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:07:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4821205F4;
        Sun,  9 Jun 2019 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560100066;
        bh=23axblYHinbgnmdYaUFFt2A1buYUfE62lykn/XH6DWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eS2+KAZqXr8xwTEpsOFJQm0vEa0/cDzT4LzhZxEd/TRaGFNxzf1WxFviyJsPmIeJD
         p3M0n9rrRSOtaPwspd09Fw4tF+/Up+kBJfVBgzLQFF4alWqrddzDRk1oO52UBe2Oh7
         RhNFwZmF4JWNOhAKLnnLgClngGtT8Sp3LCTo47kY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Harris, James R" <james.r.harris@intel.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 5.1 43/70] nvme-rdma: fix queue mapping when queue count is limited
Date:   Sun,  9 Jun 2019 18:41:54 +0200
Message-Id: <20190609164130.922394717@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit 5651cd3c43368873d0787b52acb2e0e08f3c5da4 upstream.

When the controller supports less queues than requested, we
should make sure that queue mapping does the right thing and
not assume that all queues are available. This fixes a crash
when the controller supports less queues than requested.

The rules are:
1. if no write/poll queues are requested, we assign the available queues
   to the default queue map. The default and read queue maps share the
   existing queues.
2. if write queues are requested:
  - first make sure that read queue map gets the requested
    nr_io_queues count
  - then grant the default queue map the minimum between the requested
    nr_write_queues and the remaining queues. If there are no available
    queues to dedicate to the default queue map, fallback to (1) and
    share all the queues in the existing queue map.
3. if poll queues are requested:
  - map the remaining queues to the poll queue map.

Also, provide a log indication on how we constructed the different
queue maps.

Reported-by: Harris, James R <james.r.harris@intel.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Tested-by: Jim Harris <james.r.harris@intel.com>
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/rdma.c |   99 ++++++++++++++++++++++++++++-------------------
 1 file changed, 61 insertions(+), 38 deletions(-)

--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -641,34 +641,16 @@ static int nvme_rdma_alloc_io_queues(str
 {
 	struct nvmf_ctrl_options *opts = ctrl->ctrl.opts;
 	struct ib_device *ibdev = ctrl->device->dev;
-	unsigned int nr_io_queues;
+	unsigned int nr_io_queues, nr_default_queues;
+	unsigned int nr_read_queues, nr_poll_queues;
 	int i, ret;
 
-	nr_io_queues = min(opts->nr_io_queues, num_online_cpus());
-
-	/*
-	 * we map queues according to the device irq vectors for
-	 * optimal locality so we don't need more queues than
-	 * completion vectors.
-	 */
-	nr_io_queues = min_t(unsigned int, nr_io_queues,
-				ibdev->num_comp_vectors);
-
-	if (opts->nr_write_queues) {
-		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
-				min(opts->nr_write_queues, nr_io_queues);
-		nr_io_queues += ctrl->io_queues[HCTX_TYPE_DEFAULT];
-	} else {
-		ctrl->io_queues[HCTX_TYPE_DEFAULT] = nr_io_queues;
-	}
-
-	ctrl->io_queues[HCTX_TYPE_READ] = nr_io_queues;
-
-	if (opts->nr_poll_queues) {
-		ctrl->io_queues[HCTX_TYPE_POLL] =
-			min(opts->nr_poll_queues, num_online_cpus());
-		nr_io_queues += ctrl->io_queues[HCTX_TYPE_POLL];
-	}
+	nr_read_queues = min_t(unsigned int, ibdev->num_comp_vectors,
+				min(opts->nr_io_queues, num_online_cpus()));
+	nr_default_queues =  min_t(unsigned int, ibdev->num_comp_vectors,
+				min(opts->nr_write_queues, num_online_cpus()));
+	nr_poll_queues = min(opts->nr_poll_queues, num_online_cpus());
+	nr_io_queues = nr_read_queues + nr_default_queues + nr_poll_queues;
 
 	ret = nvme_set_queue_count(&ctrl->ctrl, &nr_io_queues);
 	if (ret)
@@ -681,6 +663,34 @@ static int nvme_rdma_alloc_io_queues(str
 	dev_info(ctrl->ctrl.device,
 		"creating %d I/O queues.\n", nr_io_queues);
 
+	if (opts->nr_write_queues && nr_read_queues < nr_io_queues) {
+		/*
+		 * separate read/write queues
+		 * hand out dedicated default queues only after we have
+		 * sufficient read queues.
+		 */
+		ctrl->io_queues[HCTX_TYPE_READ] = nr_read_queues;
+		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_READ];
+		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
+			min(nr_default_queues, nr_io_queues);
+		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
+	} else {
+		/*
+		 * shared read/write queues
+		 * either no write queues were requested, or we don't have
+		 * sufficient queue count to have dedicated default queues.
+		 */
+		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
+			min(nr_read_queues, nr_io_queues);
+		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
+	}
+
+	if (opts->nr_poll_queues && nr_io_queues) {
+		/* map dedicated poll queues only if we have queues left */
+		ctrl->io_queues[HCTX_TYPE_POLL] =
+			min(nr_poll_queues, nr_io_queues);
+	}
+
 	for (i = 1; i < ctrl->ctrl.queue_count; i++) {
 		ret = nvme_rdma_alloc_queue(ctrl, i,
 				ctrl->ctrl.sqsize + 1);
@@ -1787,17 +1797,24 @@ static void nvme_rdma_complete_rq(struct
 static int nvme_rdma_map_queues(struct blk_mq_tag_set *set)
 {
 	struct nvme_rdma_ctrl *ctrl = set->driver_data;
+	struct nvmf_ctrl_options *opts = ctrl->ctrl.opts;
 
-	set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
-	set->map[HCTX_TYPE_DEFAULT].nr_queues =
-			ctrl->io_queues[HCTX_TYPE_DEFAULT];
-	set->map[HCTX_TYPE_READ].nr_queues = ctrl->io_queues[HCTX_TYPE_READ];
-	if (ctrl->ctrl.opts->nr_write_queues) {
+	if (opts->nr_write_queues && ctrl->io_queues[HCTX_TYPE_READ]) {
 		/* separate read/write queues */
+		set->map[HCTX_TYPE_DEFAULT].nr_queues =
+			ctrl->io_queues[HCTX_TYPE_DEFAULT];
+		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
+		set->map[HCTX_TYPE_READ].nr_queues =
+			ctrl->io_queues[HCTX_TYPE_READ];
 		set->map[HCTX_TYPE_READ].queue_offset =
-				ctrl->io_queues[HCTX_TYPE_DEFAULT];
+			ctrl->io_queues[HCTX_TYPE_DEFAULT];
 	} else {
-		/* mixed read/write queues */
+		/* shared read/write queues */
+		set->map[HCTX_TYPE_DEFAULT].nr_queues =
+			ctrl->io_queues[HCTX_TYPE_DEFAULT];
+		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
+		set->map[HCTX_TYPE_READ].nr_queues =
+			ctrl->io_queues[HCTX_TYPE_DEFAULT];
 		set->map[HCTX_TYPE_READ].queue_offset = 0;
 	}
 	blk_mq_rdma_map_queues(&set->map[HCTX_TYPE_DEFAULT],
@@ -1805,16 +1822,22 @@ static int nvme_rdma_map_queues(struct b
 	blk_mq_rdma_map_queues(&set->map[HCTX_TYPE_READ],
 			ctrl->device->dev, 0);
 
-	if (ctrl->ctrl.opts->nr_poll_queues) {
+	if (opts->nr_poll_queues && ctrl->io_queues[HCTX_TYPE_POLL]) {
+		/* map dedicated poll queues only if we have queues left */
 		set->map[HCTX_TYPE_POLL].nr_queues =
 				ctrl->io_queues[HCTX_TYPE_POLL];
 		set->map[HCTX_TYPE_POLL].queue_offset =
-				ctrl->io_queues[HCTX_TYPE_DEFAULT];
-		if (ctrl->ctrl.opts->nr_write_queues)
-			set->map[HCTX_TYPE_POLL].queue_offset +=
-				ctrl->io_queues[HCTX_TYPE_READ];
+			ctrl->io_queues[HCTX_TYPE_DEFAULT] +
+			ctrl->io_queues[HCTX_TYPE_READ];
 		blk_mq_map_queues(&set->map[HCTX_TYPE_POLL]);
 	}
+
+	dev_info(ctrl->ctrl.device,
+		"mapped %d/%d/%d default/read/poll queues.\n",
+		ctrl->io_queues[HCTX_TYPE_DEFAULT],
+		ctrl->io_queues[HCTX_TYPE_READ],
+		ctrl->io_queues[HCTX_TYPE_POLL]);
+
 	return 0;
 }
 


