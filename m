Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A324F70E8
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239601AbiDGBXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236999AbiDGBQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:16:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303371947A7;
        Wed,  6 Apr 2022 18:12:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD2B361DA8;
        Thu,  7 Apr 2022 01:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3918CC385A3;
        Thu,  7 Apr 2022 01:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293947;
        bh=S06VxIl84gkmb5Uz7c+ZDp6/fpCrNyFZSTOLoIj17bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JeTs1EsPGipcNl3DV0sG5Om8DhiMPaiZ6paWZPFN5I6Dr7a9p7IZCjZkV3e00kso9
         KvnbCqHSGP2u5HFYmkGywvm0gAlpnPnTmhZfZRtOyE5/JsuuUIxEs0TGJYY9mZ4tVj
         yVWPloreUf8e/QnhB6hXX9z/ktQbHXNCC0Qvkys9aKA0DmcdZpFt3vRXYEhp4tG23+
         f+Q7d0UTcdwJ/VSXsFGsOT6eNGk5+96FA3DdXPc3NJMHa0/qL0qbesLN4O1hfjOcrP
         IBHJwRm37++uSg8bzO+XhyL8GcQ4RiJrNtn9ZISoVwRAwDloVOgkCzOanMhF7XpGnA
         /yrm6MDZQGiNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 21/30] nvmet: use a private workqueue instead of the system workqueue
Date:   Wed,  6 Apr 2022 21:11:31 -0400
Message-Id: <20220407011140.113856-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011140.113856-1-sashal@kernel.org>
References: <20220407011140.113856-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 8832cf922151e9dfa2821736beb0ae2dd3968b6e ]

Any attempt to flush kernel-global WQs has possibility of deadlock
so we should simply stop using them, instead introduce nvmet_wq
which is the generic nvmet workqueue for work elements that
don't explicitly require a dedicated workqueue (by the mere fact
that they are using the system_wq).

Changes were done using the following replaces:

 - s/schedule_work(/queue_work(nvmet_wq, /g
 - s/schedule_delayed_work(/queue_delayed_work(nvmet_wq, /g
 - s/flush_scheduled_work()/flush_workqueue(nvmet_wq)/g

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c   |  2 +-
 drivers/nvme/target/configfs.c    |  2 +-
 drivers/nvme/target/core.c        | 24 ++++++++++++++++++------
 drivers/nvme/target/fc.c          |  8 ++++----
 drivers/nvme/target/fcloop.c      | 16 ++++++++--------
 drivers/nvme/target/io-cmd-file.c |  6 +++---
 drivers/nvme/target/loop.c        |  4 ++--
 drivers/nvme/target/nvmet.h       |  1 +
 drivers/nvme/target/passthru.c    |  2 +-
 drivers/nvme/target/rdma.c        | 12 ++++++------
 drivers/nvme/target/tcp.c         | 10 +++++-----
 11 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 6fb24746de06..c3a9df5545cf 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -984,7 +984,7 @@ void nvmet_execute_async_event(struct nvmet_req *req)
 	ctrl->async_event_cmds[ctrl->nr_async_event_cmds++] = req;
 	mutex_unlock(&ctrl->lock);
 
-	schedule_work(&ctrl->async_event_work);
+	queue_work(nvmet_wq, &ctrl->async_event_work);
 }
 
 void nvmet_execute_keep_alive(struct nvmet_req *req)
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 496d775c6770..cea30e4f5053 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1554,7 +1554,7 @@ static void nvmet_port_release(struct config_item *item)
 	struct nvmet_port *port = to_nvmet_port(item);
 
 	/* Let inflight controllers teardown complete */
-	flush_scheduled_work();
+	flush_workqueue(nvmet_wq);
 	list_del(&port->global_entry);
 
 	kfree(port->ana_state);
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 626caf6f1e4b..1c026a21f218 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -20,6 +20,9 @@ struct workqueue_struct *zbd_wq;
 static const struct nvmet_fabrics_ops *nvmet_transports[NVMF_TRTYPE_MAX];
 static DEFINE_IDA(cntlid_ida);
 
+struct workqueue_struct *nvmet_wq;
+EXPORT_SYMBOL_GPL(nvmet_wq);
+
 /*
  * This read/write semaphore is used to synchronize access to configuration
  * information on a target system that will result in discovery log page
@@ -205,7 +208,7 @@ void nvmet_add_async_event(struct nvmet_ctrl *ctrl, u8 event_type,
 	list_add_tail(&aen->entry, &ctrl->async_events);
 	mutex_unlock(&ctrl->lock);
 
-	schedule_work(&ctrl->async_event_work);
+	queue_work(nvmet_wq, &ctrl->async_event_work);
 }
 
 static void nvmet_add_to_changed_ns_log(struct nvmet_ctrl *ctrl, __le32 nsid)
@@ -385,7 +388,7 @@ static void nvmet_keep_alive_timer(struct work_struct *work)
 	if (reset_tbkas) {
 		pr_debug("ctrl %d reschedule traffic based keep-alive timer\n",
 			ctrl->cntlid);
-		schedule_delayed_work(&ctrl->ka_work, ctrl->kato * HZ);
+		queue_delayed_work(nvmet_wq, &ctrl->ka_work, ctrl->kato * HZ);
 		return;
 	}
 
@@ -403,7 +406,7 @@ void nvmet_start_keep_alive_timer(struct nvmet_ctrl *ctrl)
 	pr_debug("ctrl %d start keep-alive timer for %d secs\n",
 		ctrl->cntlid, ctrl->kato);
 
-	schedule_delayed_work(&ctrl->ka_work, ctrl->kato * HZ);
+	queue_delayed_work(nvmet_wq, &ctrl->ka_work, ctrl->kato * HZ);
 }
 
 void nvmet_stop_keep_alive_timer(struct nvmet_ctrl *ctrl)
@@ -1479,7 +1482,7 @@ void nvmet_ctrl_fatal_error(struct nvmet_ctrl *ctrl)
 	mutex_lock(&ctrl->lock);
 	if (!(ctrl->csts & NVME_CSTS_CFS)) {
 		ctrl->csts |= NVME_CSTS_CFS;
-		schedule_work(&ctrl->fatal_err_work);
+		queue_work(nvmet_wq, &ctrl->fatal_err_work);
 	}
 	mutex_unlock(&ctrl->lock);
 }
@@ -1620,9 +1623,15 @@ static int __init nvmet_init(void)
 		goto out_free_zbd_work_queue;
 	}
 
+	nvmet_wq = alloc_workqueue("nvmet-wq", WQ_MEM_RECLAIM, 0);
+	if (!nvmet_wq) {
+		error = -ENOMEM;
+		goto out_free_buffered_work_queue;
+	}
+
 	error = nvmet_init_discovery();
 	if (error)
-		goto out_free_work_queue;
+		goto out_free_nvmet_work_queue;
 
 	error = nvmet_init_configfs();
 	if (error)
@@ -1631,7 +1640,9 @@ static int __init nvmet_init(void)
 
 out_exit_discovery:
 	nvmet_exit_discovery();
-out_free_work_queue:
+out_free_nvmet_work_queue:
+	destroy_workqueue(nvmet_wq);
+out_free_buffered_work_queue:
 	destroy_workqueue(buffered_io_wq);
 out_free_zbd_work_queue:
 	destroy_workqueue(zbd_wq);
@@ -1643,6 +1654,7 @@ static void __exit nvmet_exit(void)
 	nvmet_exit_configfs();
 	nvmet_exit_discovery();
 	ida_destroy(&cntlid_ida);
+	destroy_workqueue(nvmet_wq);
 	destroy_workqueue(buffered_io_wq);
 	destroy_workqueue(zbd_wq);
 
diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 22b5108168a6..c43bc5e1c7a2 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1491,7 +1491,7 @@ __nvmet_fc_free_assocs(struct nvmet_fc_tgtport *tgtport)
 	list_for_each_entry_rcu(assoc, &tgtport->assoc_list, a_list) {
 		if (!nvmet_fc_tgt_a_get(assoc))
 			continue;
-		if (!schedule_work(&assoc->del_work))
+		if (!queue_work(nvmet_wq, &assoc->del_work))
 			/* already deleting - release local reference */
 			nvmet_fc_tgt_a_put(assoc);
 	}
@@ -1546,7 +1546,7 @@ nvmet_fc_invalidate_host(struct nvmet_fc_target_port *target_port,
 			continue;
 		assoc->hostport->invalid = 1;
 		noassoc = false;
-		if (!schedule_work(&assoc->del_work))
+		if (!queue_work(nvmet_wq, &assoc->del_work))
 			/* already deleting - release local reference */
 			nvmet_fc_tgt_a_put(assoc);
 	}
@@ -1592,7 +1592,7 @@ nvmet_fc_delete_ctrl(struct nvmet_ctrl *ctrl)
 		nvmet_fc_tgtport_put(tgtport);
 
 		if (found_ctrl) {
-			if (!schedule_work(&assoc->del_work))
+			if (!queue_work(nvmet_wq, &assoc->del_work))
 				/* already deleting - release local reference */
 				nvmet_fc_tgt_a_put(assoc);
 			return;
@@ -2060,7 +2060,7 @@ nvmet_fc_rcv_ls_req(struct nvmet_fc_target_port *target_port,
 	iod->rqstdatalen = lsreqbuf_len;
 	iod->hosthandle = hosthandle;
 
-	schedule_work(&iod->work);
+	queue_work(nvmet_wq, &iod->work);
 
 	return 0;
 }
diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index 54606f1872b4..5c16372f3b53 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -360,7 +360,7 @@ fcloop_h2t_ls_req(struct nvme_fc_local_port *localport,
 		spin_lock(&rport->lock);
 		list_add_tail(&rport->ls_list, &tls_req->ls_list);
 		spin_unlock(&rport->lock);
-		schedule_work(&rport->ls_work);
+		queue_work(nvmet_wq, &rport->ls_work);
 		return ret;
 	}
 
@@ -393,7 +393,7 @@ fcloop_h2t_xmt_ls_rsp(struct nvmet_fc_target_port *targetport,
 		spin_lock(&rport->lock);
 		list_add_tail(&rport->ls_list, &tls_req->ls_list);
 		spin_unlock(&rport->lock);
-		schedule_work(&rport->ls_work);
+		queue_work(nvmet_wq, &rport->ls_work);
 	}
 
 	return 0;
@@ -448,7 +448,7 @@ fcloop_t2h_ls_req(struct nvmet_fc_target_port *targetport, void *hosthandle,
 		spin_lock(&tport->lock);
 		list_add_tail(&tport->ls_list, &tls_req->ls_list);
 		spin_unlock(&tport->lock);
-		schedule_work(&tport->ls_work);
+		queue_work(nvmet_wq, &tport->ls_work);
 		return ret;
 	}
 
@@ -480,7 +480,7 @@ fcloop_t2h_xmt_ls_rsp(struct nvme_fc_local_port *localport,
 		spin_lock(&tport->lock);
 		list_add_tail(&tport->ls_list, &tls_req->ls_list);
 		spin_unlock(&tport->lock);
-		schedule_work(&tport->ls_work);
+		queue_work(nvmet_wq, &tport->ls_work);
 	}
 
 	return 0;
@@ -520,7 +520,7 @@ fcloop_tgt_discovery_evt(struct nvmet_fc_target_port *tgtport)
 	tgt_rscn->tport = tgtport->private;
 	INIT_WORK(&tgt_rscn->work, fcloop_tgt_rscn_work);
 
-	schedule_work(&tgt_rscn->work);
+	queue_work(nvmet_wq, &tgt_rscn->work);
 }
 
 static void
@@ -739,7 +739,7 @@ fcloop_fcp_req(struct nvme_fc_local_port *localport,
 	INIT_WORK(&tfcp_req->tio_done_work, fcloop_tgt_fcprqst_done_work);
 	kref_init(&tfcp_req->ref);
 
-	schedule_work(&tfcp_req->fcp_rcv_work);
+	queue_work(nvmet_wq, &tfcp_req->fcp_rcv_work);
 
 	return 0;
 }
@@ -921,7 +921,7 @@ fcloop_fcp_req_release(struct nvmet_fc_target_port *tgtport,
 {
 	struct fcloop_fcpreq *tfcp_req = tgt_fcp_req_to_fcpreq(tgt_fcpreq);
 
-	schedule_work(&tfcp_req->tio_done_work);
+	queue_work(nvmet_wq, &tfcp_req->tio_done_work);
 }
 
 static void
@@ -976,7 +976,7 @@ fcloop_fcp_abort(struct nvme_fc_local_port *localport,
 
 	if (abortio)
 		/* leave the reference while the work item is scheduled */
-		WARN_ON(!schedule_work(&tfcp_req->abort_rcv_work));
+		WARN_ON(!queue_work(nvmet_wq, &tfcp_req->abort_rcv_work));
 	else  {
 		/*
 		 * as the io has already had the done callback made,
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 6be6e59d273b..80f079a7015d 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -292,7 +292,7 @@ static void nvmet_file_execute_flush(struct nvmet_req *req)
 	if (!nvmet_check_transfer_len(req, 0))
 		return;
 	INIT_WORK(&req->f.work, nvmet_file_flush_work);
-	schedule_work(&req->f.work);
+	queue_work(nvmet_wq, &req->f.work);
 }
 
 static void nvmet_file_execute_discard(struct nvmet_req *req)
@@ -352,7 +352,7 @@ static void nvmet_file_execute_dsm(struct nvmet_req *req)
 	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
 		return;
 	INIT_WORK(&req->f.work, nvmet_file_dsm_work);
-	schedule_work(&req->f.work);
+	queue_work(nvmet_wq, &req->f.work);
 }
 
 static void nvmet_file_write_zeroes_work(struct work_struct *w)
@@ -382,7 +382,7 @@ static void nvmet_file_execute_write_zeroes(struct nvmet_req *req)
 	if (!nvmet_check_transfer_len(req, 0))
 		return;
 	INIT_WORK(&req->f.work, nvmet_file_write_zeroes_work);
-	schedule_work(&req->f.work);
+	queue_work(nvmet_wq, &req->f.work);
 }
 
 u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index eb1094254c82..2a968eeddda3 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -166,7 +166,7 @@ static blk_status_t nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		iod->req.transfer_len = blk_rq_payload_bytes(req);
 	}
 
-	schedule_work(&iod->work);
+	queue_work(nvmet_wq, &iod->work);
 	return BLK_STS_OK;
 }
 
@@ -187,7 +187,7 @@ static void nvme_loop_submit_async_event(struct nvme_ctrl *arg)
 		return;
 	}
 
-	schedule_work(&iod->work);
+	queue_work(nvmet_wq, &iod->work);
 }
 
 static int nvme_loop_init_iod(struct nvme_loop_ctrl *ctrl,
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index af193423c10b..ff26dbde8c1e 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -366,6 +366,7 @@ struct nvmet_req {
 
 extern struct workqueue_struct *buffered_io_wq;
 extern struct workqueue_struct *zbd_wq;
+extern struct workqueue_struct *nvmet_wq;
 
 static inline void nvmet_set_result(struct nvmet_req *req, u32 result)
 {
diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index f0efb3537989..6220e1dd961a 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -281,7 +281,7 @@ static void nvmet_passthru_execute_cmd(struct nvmet_req *req)
 	if (req->p.use_workqueue || effects) {
 		INIT_WORK(&req->p.work, nvmet_passthru_execute_cmd_work);
 		req->p.rq = rq;
-		schedule_work(&req->p.work);
+		queue_work(nvmet_wq, &req->p.work);
 	} else {
 		rq->end_io_data = req;
 		blk_execute_rq_nowait(ns ? ns->disk : NULL, rq, 0,
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 1deb4043e242..0ebfe2191165 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1584,7 +1584,7 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 
 	if (queue->host_qid == 0) {
 		/* Let inflight controller teardown complete */
-		flush_scheduled_work();
+		flush_workqueue(nvmet_wq);
 	}
 
 	ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
@@ -1669,7 +1669,7 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 
 	if (disconnect) {
 		rdma_disconnect(queue->cm_id);
-		schedule_work(&queue->release_work);
+		queue_work(nvmet_wq, &queue->release_work);
 	}
 }
 
@@ -1699,7 +1699,7 @@ static void nvmet_rdma_queue_connect_fail(struct rdma_cm_id *cm_id,
 	mutex_unlock(&nvmet_rdma_queue_mutex);
 
 	pr_err("failed to connect queue %d\n", queue->idx);
-	schedule_work(&queue->release_work);
+	queue_work(nvmet_wq, &queue->release_work);
 }
 
 /**
@@ -1773,7 +1773,7 @@ static int nvmet_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		if (!queue) {
 			struct nvmet_rdma_port *port = cm_id->context;
 
-			schedule_delayed_work(&port->repair_work, 0);
+			queue_delayed_work(nvmet_wq, &port->repair_work, 0);
 			break;
 		}
 		fallthrough;
@@ -1903,7 +1903,7 @@ static void nvmet_rdma_repair_port_work(struct work_struct *w)
 	nvmet_rdma_disable_port(port);
 	ret = nvmet_rdma_enable_port(port);
 	if (ret)
-		schedule_delayed_work(&port->repair_work, 5 * HZ);
+		queue_delayed_work(nvmet_wq, &port->repair_work, 5 * HZ);
 }
 
 static int nvmet_rdma_add_port(struct nvmet_port *nport)
@@ -2053,7 +2053,7 @@ static void nvmet_rdma_remove_one(struct ib_device *ib_device, void *client_data
 	}
 	mutex_unlock(&nvmet_rdma_queue_mutex);
 
-	flush_scheduled_work();
+	flush_workqueue(nvmet_wq);
 }
 
 static struct ib_client nvmet_rdma_ib_client = {
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 7c1c43ce466b..31bab7477d53 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1269,7 +1269,7 @@ static void nvmet_tcp_schedule_release_queue(struct nvmet_tcp_queue *queue)
 	spin_lock(&queue->state_lock);
 	if (queue->state != NVMET_TCP_Q_DISCONNECTING) {
 		queue->state = NVMET_TCP_Q_DISCONNECTING;
-		schedule_work(&queue->release_work);
+		queue_work(nvmet_wq, &queue->release_work);
 	}
 	spin_unlock(&queue->state_lock);
 }
@@ -1684,7 +1684,7 @@ static void nvmet_tcp_listen_data_ready(struct sock *sk)
 		goto out;
 
 	if (sk->sk_state == TCP_LISTEN)
-		schedule_work(&port->accept_work);
+		queue_work(nvmet_wq, &port->accept_work);
 out:
 	read_unlock_bh(&sk->sk_callback_lock);
 }
@@ -1815,7 +1815,7 @@ static u16 nvmet_tcp_install_queue(struct nvmet_sq *sq)
 
 	if (sq->qid == 0) {
 		/* Let inflight controller teardown complete */
-		flush_scheduled_work();
+		flush_workqueue(nvmet_wq);
 	}
 
 	queue->nr_cmds = sq->size * 2;
@@ -1876,12 +1876,12 @@ static void __exit nvmet_tcp_exit(void)
 
 	nvmet_unregister_transport(&nvmet_tcp_ops);
 
-	flush_scheduled_work();
+	flush_workqueue(nvmet_wq);
 	mutex_lock(&nvmet_tcp_queue_mutex);
 	list_for_each_entry(queue, &nvmet_tcp_queue_list, queue_list)
 		kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	mutex_unlock(&nvmet_tcp_queue_mutex);
-	flush_scheduled_work();
+	flush_workqueue(nvmet_wq);
 
 	destroy_workqueue(nvmet_tcp_wq);
 }
-- 
2.35.1

