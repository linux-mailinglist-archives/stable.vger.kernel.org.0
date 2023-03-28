Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3676E6CBDFF
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjC1LlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjC1LlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 07:41:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683F555BB
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 04:41:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97251CE0FC5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 11:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A227EC433D2;
        Tue, 28 Mar 2023 11:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003669;
        bh=Gk8rUGbwWYgXhCkFKYvdBC1Xq/i2XayxTFLDtAxOBOQ=;
        h=Subject:To:Cc:From:Date:From;
        b=aIDdZXps+P746VclDbgbdKkI1Wd0alwqBBo0boLtcY+VkGmHwygWqRrt6JdrZQFGN
         MvA5JoeSGIYCa1yod3T8VdT/RN+5Ff1guM9TkUXxWgeFMQ8JCWmTWy8OcRY3eXEw4J
         lpt/8A2dVWlOugo1A+6mrFx2nBoNB1LskJFn6kto=
Subject: FAILED: patch "[PATCH] block/io_uring: pass in issue_flags for uring_cmd task_work" failed to apply to 6.1-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:41:06 +0200
Message-ID: <168000366614476@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 9d2789ac9d60c049d26ef6d3005d9c94c5a559e9
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '168000366614476@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

9d2789ac9d60 ("block/io_uring: pass in issue_flags for uring_cmd task_work handling")
b2cf789f6cb6 ("Merge branch 'for-6.2/io_uring' into for-6.2/io_uring-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9d2789ac9d60c049d26ef6d3005d9c94c5a559e9 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 20 Mar 2023 20:01:25 -0600
Subject: [PATCH] block/io_uring: pass in issue_flags for uring_cmd task_work
 handling

io_uring_cmd_done() currently assumes that the uring_lock is held
when invoked, and while it generally is, this is not guaranteed.
Pass in the issue_flags associated with it, so that we have
IO_URING_F_UNLOCKED available to be able to lock the CQ ring
appropriately when completing events.

Cc: stable@vger.kernel.org
Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index fb5a557afde8..c73cc57ec547 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -715,7 +715,8 @@ static void __ublk_fail_req(struct ublk_queue *ubq, struct ublk_io *io,
 	}
 }
 
-static void ubq_complete_io_cmd(struct ublk_io *io, int res)
+static void ubq_complete_io_cmd(struct ublk_io *io, int res,
+				unsigned issue_flags)
 {
 	/* mark this cmd owned by ublksrv */
 	io->flags |= UBLK_IO_FLAG_OWNED_BY_SRV;
@@ -727,7 +728,7 @@ static void ubq_complete_io_cmd(struct ublk_io *io, int res)
 	io->flags &= ~UBLK_IO_FLAG_ACTIVE;
 
 	/* tell ublksrv one io request is coming */
-	io_uring_cmd_done(io->cmd, res, 0);
+	io_uring_cmd_done(io->cmd, res, 0, issue_flags);
 }
 
 #define UBLK_REQUEUE_DELAY_MS	3
@@ -744,7 +745,8 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 	mod_delayed_work(system_wq, &ubq->dev->monitor_work, 0);
 }
 
-static inline void __ublk_rq_task_work(struct request *req)
+static inline void __ublk_rq_task_work(struct request *req,
+				       unsigned issue_flags)
 {
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
 	int tag = req->tag;
@@ -782,7 +784,7 @@ static inline void __ublk_rq_task_work(struct request *req)
 			pr_devel("%s: need get data. op %d, qid %d tag %d io_flags %x\n",
 					__func__, io->cmd->cmd_op, ubq->q_id,
 					req->tag, io->flags);
-			ubq_complete_io_cmd(io, UBLK_IO_RES_NEED_GET_DATA);
+			ubq_complete_io_cmd(io, UBLK_IO_RES_NEED_GET_DATA, issue_flags);
 			return;
 		}
 		/*
@@ -820,17 +822,18 @@ static inline void __ublk_rq_task_work(struct request *req)
 			mapped_bytes >> 9;
 	}
 
-	ubq_complete_io_cmd(io, UBLK_IO_RES_OK);
+	ubq_complete_io_cmd(io, UBLK_IO_RES_OK, issue_flags);
 }
 
-static inline void ublk_forward_io_cmds(struct ublk_queue *ubq)
+static inline void ublk_forward_io_cmds(struct ublk_queue *ubq,
+					unsigned issue_flags)
 {
 	struct llist_node *io_cmds = llist_del_all(&ubq->io_cmds);
 	struct ublk_rq_data *data, *tmp;
 
 	io_cmds = llist_reverse_order(io_cmds);
 	llist_for_each_entry_safe(data, tmp, io_cmds, node)
-		__ublk_rq_task_work(blk_mq_rq_from_pdu(data));
+		__ublk_rq_task_work(blk_mq_rq_from_pdu(data), issue_flags);
 }
 
 static inline void ublk_abort_io_cmds(struct ublk_queue *ubq)
@@ -842,12 +845,12 @@ static inline void ublk_abort_io_cmds(struct ublk_queue *ubq)
 		__ublk_abort_rq(ubq, blk_mq_rq_from_pdu(data));
 }
 
-static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd)
+static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd, unsigned issue_flags)
 {
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
 	struct ublk_queue *ubq = pdu->ubq;
 
-	ublk_forward_io_cmds(ubq);
+	ublk_forward_io_cmds(ubq, issue_flags);
 }
 
 static void ublk_rq_task_work_fn(struct callback_head *work)
@@ -856,8 +859,9 @@ static void ublk_rq_task_work_fn(struct callback_head *work)
 			struct ublk_rq_data, work);
 	struct request *req = blk_mq_rq_from_pdu(data);
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+	unsigned issue_flags = IO_URING_F_UNLOCKED;
 
-	ublk_forward_io_cmds(ubq);
+	ublk_forward_io_cmds(ubq, issue_flags);
 }
 
 static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
@@ -1111,7 +1115,8 @@ static void ublk_cancel_queue(struct ublk_queue *ubq)
 		struct ublk_io *io = &ubq->ios[i];
 
 		if (io->flags & UBLK_IO_FLAG_ACTIVE)
-			io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0);
+			io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0,
+						IO_URING_F_UNLOCKED);
 	}
 
 	/* all io commands are canceled */
@@ -1351,7 +1356,7 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	return -EIOCBQUEUED;
 
  out:
-	io_uring_cmd_done(cmd, ret, 0);
+	io_uring_cmd_done(cmd, ret, 0, issue_flags);
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
 			__func__, cmd_op, tag, ret, io->flags);
 	return -EIOCBQUEUED;
@@ -2234,7 +2239,7 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	if (ub)
 		ublk_put_device(ub);
  out:
-	io_uring_cmd_done(cmd, ret, 0);
+	io_uring_cmd_done(cmd, ret, 0, issue_flags);
 	pr_devel("%s: cmd done ret %d cmd_op %x, dev id %d qid %d\n",
 			__func__, ret, cmd->cmd_op, header->dev_id, header->queue_id);
 	return -EIOCBQUEUED;
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 723e7d5b778f..d24ea2e05156 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -464,7 +464,8 @@ static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
 	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
 }
 
-static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd)
+static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd,
+				    unsigned issue_flags)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 	struct request *req = pdu->req;
@@ -485,17 +486,18 @@ static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd)
 		blk_rq_unmap_user(req->bio);
 	blk_mq_free_request(req);
 
-	io_uring_cmd_done(ioucmd, status, result);
+	io_uring_cmd_done(ioucmd, status, result, issue_flags);
 }
 
-static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
+static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd,
+			       unsigned issue_flags)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 
 	if (pdu->bio)
 		blk_rq_unmap_user(pdu->bio);
 
-	io_uring_cmd_done(ioucmd, pdu->nvme_status, pdu->u.result);
+	io_uring_cmd_done(ioucmd, pdu->nvme_status, pdu->u.result, issue_flags);
 }
 
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
@@ -517,7 +519,7 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	 * Otherwise, move the completion to task work.
 	 */
 	if (cookie != NULL && blk_rq_is_poll(req))
-		nvme_uring_task_cb(ioucmd);
+		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
 	else
 		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
 
@@ -539,7 +541,7 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req,
 	 * Otherwise, move the completion to task work.
 	 */
 	if (cookie != NULL && blk_rq_is_poll(req))
-		nvme_uring_task_meta_cb(ioucmd);
+		nvme_uring_task_meta_cb(ioucmd, IO_URING_F_UNLOCKED);
 	else
 		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_meta_cb);
 
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 934e5dd4ccc0..35b9328ca335 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -27,7 +27,7 @@ struct io_uring_cmd {
 	const void	*cmd;
 	union {
 		/* callback to defer completions to task context */
-		void (*task_work_cb)(struct io_uring_cmd *cmd);
+		void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
 		/* used for polled completion */
 		void *cookie;
 	};
@@ -39,9 +39,10 @@ struct io_uring_cmd {
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
-void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
+			unsigned issue_flags);
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *));
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
@@ -72,11 +73,11 @@ static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 	return -EOPNOTSUPP;
 }
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
-		ssize_t ret2)
+		ssize_t ret2, unsigned issue_flags)
 {
 }
 static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *))
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
 {
 }
 static inline struct sock *io_uring_get_socket(struct file *file)
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 446a189b78b0..e535e8db01e3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -15,12 +15,13 @@
 static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	unsigned issue_flags = *locked ? 0 : IO_URING_F_UNLOCKED;
 
-	ioucmd->task_work_cb(ioucmd);
+	ioucmd->task_work_cb(ioucmd, issue_flags);
 }
 
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *))
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
@@ -42,7 +43,8 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
  */
-void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
+void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
+		       unsigned issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
@@ -56,7 +58,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
 	else
-		io_req_complete_post(req, 0);
+		io_req_complete_post(req, issue_flags);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 

