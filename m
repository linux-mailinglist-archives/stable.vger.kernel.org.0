Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5F177F1A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731665AbgCCRsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:48:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731624AbgCCRsp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:48:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96DE220CC7;
        Tue,  3 Mar 2020 17:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257724;
        bh=fiow1jOLrBPF2kIgyQleElQONaYdG2nWNG10FhoHcNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8XQjzVP8DXTMOz6J3UocclH4tDYZjwUbLJmXaxc3/Ym65PgXzardnaRlxtGgS1eG
         qp0wFqUgkl2tuQ3ZiA0S+qnR68oMj6xqe4aR87HoYHuLmdPUQUHoIErzreeJ1We3g+
         YTsa5FWuPQ+8Mw6NG1m81nW/Pa6Pdro74xBjveC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nigel Kirkland <nigel.kirkland@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 079/176] nvme: prevent warning triggered by nvme_stop_keep_alive
Date:   Tue,  3 Mar 2020 18:42:23 +0100
Message-Id: <20200303174313.772741002@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nigel Kirkland <nigel.kirkland@broadcom.com>

[ Upstream commit 97b2512ad000a409b4073dd1a71e4157d76675cb ]

Delayed keep alive work is queued on system workqueue and may be cancelled
via nvme_stop_keep_alive from nvme_reset_wq, nvme_fc_wq or nvme_wq.

Check_flush_dependency detects mismatched attributes between the work-queue
context used to cancel the keep alive work and system-wq. Specifically
system-wq does not have the WQ_MEM_RECLAIM flag, whereas the contexts used
to cancel keep alive work have WQ_MEM_RECLAIM flag.

Example warning:

  workqueue: WQ_MEM_RECLAIM nvme-reset-wq:nvme_fc_reset_ctrl_work [nvme_fc]
	is flushing !WQ_MEM_RECLAIM events:nvme_keep_alive_work [nvme_core]

To avoid the flags mismatch, delayed keep alive work is queued on nvme_wq.

However this creates a secondary concern where work and a request to cancel
that work may be in the same work queue - namely err_work in the rdma and
tcp transports, which will want to flush/cancel the keep alive work which
will now be on nvme_wq.

After reviewing the transports, it looks like err_work can be moved to
nvme_reset_wq. In fact that aligns them better with transition into
RESETTING and performing related reset work in nvme_reset_wq.

Change nvme-rdma and nvme-tcp to perform err_work in nvme_reset_wq.

Signed-off-by: Nigel Kirkland <nigel.kirkland@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 10 +++++-----
 drivers/nvme/host/rdma.c |  2 +-
 drivers/nvme/host/tcp.c  |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 641c07347e8d8..ada59df642d29 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -66,8 +66,8 @@ MODULE_PARM_DESC(streams, "turn on support for Streams write directives");
  * nvme_reset_wq - hosts nvme reset works
  * nvme_delete_wq - hosts nvme delete works
  *
- * nvme_wq will host works such are scan, aen handling, fw activation,
- * keep-alive error recovery, periodic reconnects etc. nvme_reset_wq
+ * nvme_wq will host works such as scan, aen handling, fw activation,
+ * keep-alive, periodic reconnects etc. nvme_reset_wq
  * runs reset works which also flush works hosted on nvme_wq for
  * serialization purposes. nvme_delete_wq host controller deletion
  * works which flush reset works for serialization.
@@ -976,7 +976,7 @@ static void nvme_keep_alive_end_io(struct request *rq, blk_status_t status)
 		startka = true;
 	spin_unlock_irqrestore(&ctrl->lock, flags);
 	if (startka)
-		schedule_delayed_work(&ctrl->ka_work, ctrl->kato * HZ);
+		queue_delayed_work(nvme_wq, &ctrl->ka_work, ctrl->kato * HZ);
 }
 
 static int nvme_keep_alive(struct nvme_ctrl *ctrl)
@@ -1006,7 +1006,7 @@ static void nvme_keep_alive_work(struct work_struct *work)
 		dev_dbg(ctrl->device,
 			"reschedule traffic based keep-alive timer\n");
 		ctrl->comp_seen = false;
-		schedule_delayed_work(&ctrl->ka_work, ctrl->kato * HZ);
+		queue_delayed_work(nvme_wq, &ctrl->ka_work, ctrl->kato * HZ);
 		return;
 	}
 
@@ -1023,7 +1023,7 @@ static void nvme_start_keep_alive(struct nvme_ctrl *ctrl)
 	if (unlikely(ctrl->kato == 0))
 		return;
 
-	schedule_delayed_work(&ctrl->ka_work, ctrl->kato * HZ);
+	queue_delayed_work(nvme_wq, &ctrl->ka_work, ctrl->kato * HZ);
 }
 
 void nvme_stop_keep_alive(struct nvme_ctrl *ctrl)
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 2a47c6c5007e1..3e85c5cacefd2 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1088,7 +1088,7 @@ static void nvme_rdma_error_recovery(struct nvme_rdma_ctrl *ctrl)
 	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_RESETTING))
 		return;
 
-	queue_work(nvme_wq, &ctrl->err_work);
+	queue_work(nvme_reset_wq, &ctrl->err_work);
 }
 
 static void nvme_rdma_wr_error(struct ib_cq *cq, struct ib_wc *wc,
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index f8fa5c5b79f17..49d4373b84eb3 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -422,7 +422,7 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
 	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING))
 		return;
 
-	queue_work(nvme_wq, &to_tcp_ctrl(ctrl)->err_work);
+	queue_work(nvme_reset_wq, &to_tcp_ctrl(ctrl)->err_work);
 }
 
 static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
-- 
2.20.1



