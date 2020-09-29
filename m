Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C2227CB74
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbgI2M1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728702AbgI2LdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5A5523B3E;
        Tue, 29 Sep 2020 11:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378756;
        bh=sMtUXiLrD2CTS5yhYpl994m8qcR94OVzzB4WmWh4BGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D98/Y+p6f3RoD9jTec0NkI0k42cwc/vSDSSstHbRcJta0yCu6pLdd6cwULwiBa40f
         GWgWdIGJEU296WEfossWogM6UuHFuIKXF5Vb8+8qOJ4kwycteEVR3zqKzZ/WyNI+g5
         BOt7dHNcfW3J8QGMrkwybOk8FzoTZ7ERRN883/R4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        John Meneghini <johnm@netapp.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.19 127/245] nvme-multipath: do not reset on unknown status
Date:   Tue, 29 Sep 2020 12:59:38 +0200
Message-Id: <20200929105953.167165041@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Meneghini <johnm@netapp.com>

[ Upstream commit 764e9332098c0e60251386a507fe46ac91276120 ]

The nvme multipath error handling defaults to controller reset if the
error is unknown. There are, however, no existing nvme status codes that
indicate a reset should be used, and resetting causes unnecessary
disruption to the rest of IO.

Change nvme's error handling to first check if failover should happen.
If not, let the normal error handling take over rather than reset the
controller.

Based-on-a-patch-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Meneghini <johnm@netapp.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      |  5 +----
 drivers/nvme/host/multipath.c | 21 +++++++++------------
 drivers/nvme/host/nvme.h      |  5 +++--
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0d60f2f8f3eec..4b182ac15687e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -255,11 +255,8 @@ void nvme_complete_rq(struct request *req)
 	trace_nvme_complete_rq(req);
 
 	if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
-		if ((req->cmd_flags & REQ_NVME_MPATH) &&
-		    blk_path_error(status)) {
-			nvme_failover_req(req);
+		if ((req->cmd_flags & REQ_NVME_MPATH) && nvme_failover_req(req))
 			return;
-		}
 
 		if (!blk_queue_dying(req->q)) {
 			nvme_req(req)->retries++;
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 2e63c1106030b..e71075338ff5c 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -73,17 +73,12 @@ void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
 	}
 }
 
-void nvme_failover_req(struct request *req)
+bool nvme_failover_req(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
 	u16 status = nvme_req(req)->status;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ns->head->requeue_lock, flags);
-	blk_steal_bios(&ns->head->requeue_list, req);
-	spin_unlock_irqrestore(&ns->head->requeue_lock, flags);
-	blk_mq_end_request(req, 0);
-
 	switch (status & 0x7ff) {
 	case NVME_SC_ANA_TRANSITION:
 	case NVME_SC_ANA_INACCESSIBLE:
@@ -111,15 +106,17 @@ void nvme_failover_req(struct request *req)
 		nvme_mpath_clear_current_path(ns);
 		break;
 	default:
-		/*
-		 * Reset the controller for any non-ANA error as we don't know
-		 * what caused the error.
-		 */
-		nvme_reset_ctrl(ns->ctrl);
-		break;
+		/* This was a non-ANA error so follow the normal error path. */
+		return false;
 	}
 
+	spin_lock_irqsave(&ns->head->requeue_lock, flags);
+	blk_steal_bios(&ns->head->requeue_list, req);
+	spin_unlock_irqrestore(&ns->head->requeue_lock, flags);
+	blk_mq_end_request(req, 0);
+
 	kblockd_schedule_work(&ns->head->requeue_work);
+	return true;
 }
 
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index cc4273f119894..31c1496f938fb 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -477,7 +477,7 @@ void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys);
 void nvme_mpath_start_freeze(struct nvme_subsystem *subsys);
 void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
 			struct nvme_ctrl *ctrl, int *flags);
-void nvme_failover_req(struct request *req);
+bool nvme_failover_req(struct request *req);
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
 void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id);
@@ -521,8 +521,9 @@ static inline void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
 	sprintf(disk_name, "nvme%dn%d", ctrl->instance, ns->head->instance);
 }
 
-static inline void nvme_failover_req(struct request *req)
+static inline bool nvme_failover_req(struct request *req)
 {
+	return false;
 }
 static inline void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
 {
-- 
2.25.1



