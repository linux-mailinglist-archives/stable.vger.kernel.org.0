Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F823AE5E
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 06:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbfFJE63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 00:58:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53080 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387466AbfFJE63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 00:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:To:From:Sender:Reply-To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IY4zcsvWzZDpSp8lem+EUilTuMlYO8DQw4JeGdscBvA=; b=FWHJ+fI2FVRlxNjvxWiztF/Mf
        O4JLZPob+q7YSw652LnAvSDa8+4SwUZ03HDRA7yhNm+3g+N5QYSD4f0TL75RGPK4raSpSvFlQGkzY
        z2hC6ZdxC6QhyRrxvl+RK0CAkDsAgreSqozZsZPMipwJ7LYEpNoayul6endgJNJsAzZJrYPAkXw54
        39rpLdGC24BhY/1lkwpeaN+roAuXAZunS3rPwchien+3Km1JzggvePxWxLDOfd2WRQAt/ba+UMr6A
        nj2CEbiSJa8vdwIhRvhH9OexyRAcjLNNuU7GMM5NFATgQT82H6jpHmaDAuhrWnhG7hGU+0qpjoPeo
        5p74iFenA==;
Received: from [2601:647:4800:973f:619c:52d9:37be:b7bd] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1haCO4-0000I0-PQ
        for stable@vger.kernel.org; Mon, 10 Jun 2019 04:58:28 +0000
From:   Sagi Grimberg <sagi@grimberg.me>
To:     stable@vger.kernel.org
Subject: [PATCH stable-5.0+ 3/3] nvme-tcp: fix queue mapping when queue count is limited
Date:   Sun,  9 Jun 2019 21:58:26 -0700
Message-Id: <20190610045826.13176-3-sagi@grimberg.me>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190610045826.13176-1-sagi@grimberg.me>
References: <20190610045826.13176-1-sagi@grimberg.me>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit: 0ddbb30d5acc ("nvme-tcp: fix queue mapping when queue
count is limited")

When the controller supports less queues than requested, we
should make sure that queue mapping does the right thing and
not assume that all queues are available. This fixes a crash
when the controller supports less queues than requested.

The rules are:
1. if no write queues are requested, we assign the available queues
   to the default queue map. The default and read queue maps share the
   existing queues.
2. if write queues are requested:
  - first make sure that read queue map gets the requested
    nr_io_queues count
  - then grant the default queue map the minimum between the requested
    nr_write_queues and the remaining queues. If there are no available
    queues to dedicate to the default queue map, fallback to (1) and
    share all the queues in the existing queue map.

Also, provide a log indication on how we constructed the different
queue maps.

Reported-by: Harris, James R <james.r.harris@intel.com>
Tested-by: Jim Harris <james.r.harris@intel.com>
Cc: <stable@vger.kernel.org> # v5.0+
Suggested-by: Roy Shterman <roys@lightbitslabs.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/tcp.c | 57 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 2b107a1d152b..08a2501b9357 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -111,6 +111,7 @@ struct nvme_tcp_ctrl {
 	struct work_struct	err_work;
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
+	u32			io_queues[HCTX_MAX_TYPES];
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -1564,6 +1565,35 @@ static unsigned int nvme_tcp_nr_io_queues(struct nvme_ctrl *ctrl)
 	return nr_io_queues;
 }
 
+static void nvme_tcp_set_io_queues(struct nvme_ctrl *nctrl,
+		unsigned int nr_io_queues)
+{
+	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
+	struct nvmf_ctrl_options *opts = nctrl->opts;
+
+	if (opts->nr_write_queues && opts->nr_io_queues < nr_io_queues) {
+		/*
+		 * separate read/write queues
+		 * hand out dedicated default queues only after we have
+		 * sufficient read queues.
+		 */
+		ctrl->io_queues[HCTX_TYPE_READ] = opts->nr_io_queues;
+		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_READ];
+		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
+			min(opts->nr_write_queues, nr_io_queues);
+		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
+	} else {
+		/*
+		 * shared read/write queues
+		 * either no write queues were requested, or we don't have
+		 * sufficient queue count to have dedicated default queues.
+		 */
+		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
+			min(opts->nr_io_queues, nr_io_queues);
+		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
+	}
+}
+
 static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 {
 	unsigned int nr_io_queues;
@@ -1581,6 +1611,8 @@ static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 	dev_info(ctrl->device,
 		"creating %d I/O queues.\n", nr_io_queues);
 
+	nvme_tcp_set_io_queues(ctrl, nr_io_queues);
+
 	return __nvme_tcp_alloc_io_queues(ctrl);
 }
 
@@ -2089,23 +2121,34 @@ static blk_status_t nvme_tcp_queue_rq(struct blk_mq_hw_ctx *hctx,
 static int nvme_tcp_map_queues(struct blk_mq_tag_set *set)
 {
 	struct nvme_tcp_ctrl *ctrl = set->driver_data;
+	struct nvmf_ctrl_options *opts = ctrl->ctrl.opts;
 
-	set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
-	set->map[HCTX_TYPE_READ].nr_queues = ctrl->ctrl.opts->nr_io_queues;
-	if (ctrl->ctrl.opts->nr_write_queues) {
+	if (opts->nr_write_queues && ctrl->io_queues[HCTX_TYPE_READ]) {
 		/* separate read/write queues */
 		set->map[HCTX_TYPE_DEFAULT].nr_queues =
-				ctrl->ctrl.opts->nr_write_queues;
+			ctrl->io_queues[HCTX_TYPE_DEFAULT];
+		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
+		set->map[HCTX_TYPE_READ].nr_queues =
+			ctrl->io_queues[HCTX_TYPE_READ];
 		set->map[HCTX_TYPE_READ].queue_offset =
-				ctrl->ctrl.opts->nr_write_queues;
+			ctrl->io_queues[HCTX_TYPE_DEFAULT];
 	} else {
-		/* mixed read/write queues */
+		/* shared read/write queues */
 		set->map[HCTX_TYPE_DEFAULT].nr_queues =
-				ctrl->ctrl.opts->nr_io_queues;
+			ctrl->io_queues[HCTX_TYPE_DEFAULT];
+		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
+		set->map[HCTX_TYPE_READ].nr_queues =
+			ctrl->io_queues[HCTX_TYPE_DEFAULT];
 		set->map[HCTX_TYPE_READ].queue_offset = 0;
 	}
 	blk_mq_map_queues(&set->map[HCTX_TYPE_DEFAULT]);
 	blk_mq_map_queues(&set->map[HCTX_TYPE_READ]);
+
+	dev_info(ctrl->ctrl.device,
+		"mapped %d/%d default/read queues.\n",
+		ctrl->io_queues[HCTX_TYPE_DEFAULT],
+		ctrl->io_queues[HCTX_TYPE_READ]);
+
 	return 0;
 }
 
-- 
2.17.1

