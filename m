Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A837D6CC345
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbjC1Owp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbjC1OwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:52:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82FCD306
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:52:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C60561820
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E8BC4339B;
        Tue, 28 Mar 2023 14:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015129;
        bh=wwWCR8E0JSOtIAgTdxsT7Db9RJIYHCXIxgK03XXWh+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qAy6s0XgoAMUro3vJ/fIDqkzUdQMAnlNv0Mb0cLhWA4CXrp6KoiMUR3twtClfZFgL
         YRe4M0ooxdkKW0TDUAZ8WZN2p7wUhgrChne3ePUzEAclMkMTjMvfQYeGTu5YZ7IHS6
         2LNF+n4iRNZikOs1wDb/yaMufTFquav/LITXRRVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 177/240] block/io_uring: pass in issue_flags for uring_cmd task_work handling
Date:   Tue, 28 Mar 2023 16:42:20 +0200
Message-Id: <20230328142627.008518107@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 9d2789ac9d60c049d26ef6d3005d9c94c5a559e9 upstream.

io_uring_cmd_done() currently assumes that the uring_lock is held
when invoked, and while it generally is, this is not guaranteed.
Pass in the issue_flags associated with it, so that we have
IO_URING_F_UNLOCKED available to be able to lock the CQ ring
appropriately when completing events.

Cc: stable@vger.kernel.org
Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c  |   31 ++++++++++++++++++-------------
 drivers/nvme/host/ioctl.c |   14 ++++++++------
 include/linux/io_uring.h  |   11 ++++++-----
 io_uring/uring_cmd.c      |   10 ++++++----
 4 files changed, 38 insertions(+), 28 deletions(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -656,7 +656,8 @@ static void __ublk_fail_req(struct ublk_
 	}
 }
 
-static void ubq_complete_io_cmd(struct ublk_io *io, int res)
+static void ubq_complete_io_cmd(struct ublk_io *io, int res,
+				unsigned issue_flags)
 {
 	/* mark this cmd owned by ublksrv */
 	io->flags |= UBLK_IO_FLAG_OWNED_BY_SRV;
@@ -668,7 +669,7 @@ static void ubq_complete_io_cmd(struct u
 	io->flags &= ~UBLK_IO_FLAG_ACTIVE;
 
 	/* tell ublksrv one io request is coming */
-	io_uring_cmd_done(io->cmd, res, 0);
+	io_uring_cmd_done(io->cmd, res, 0, issue_flags);
 }
 
 #define UBLK_REQUEUE_DELAY_MS	3
@@ -685,7 +686,8 @@ static inline void __ublk_abort_rq(struc
 	mod_delayed_work(system_wq, &ubq->dev->monitor_work, 0);
 }
 
-static inline void __ublk_rq_task_work(struct request *req)
+static inline void __ublk_rq_task_work(struct request *req,
+				       unsigned issue_flags)
 {
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
 	int tag = req->tag;
@@ -723,7 +725,7 @@ static inline void __ublk_rq_task_work(s
 			pr_devel("%s: need get data. op %d, qid %d tag %d io_flags %x\n",
 					__func__, io->cmd->cmd_op, ubq->q_id,
 					req->tag, io->flags);
-			ubq_complete_io_cmd(io, UBLK_IO_RES_NEED_GET_DATA);
+			ubq_complete_io_cmd(io, UBLK_IO_RES_NEED_GET_DATA, issue_flags);
 			return;
 		}
 		/*
@@ -761,17 +763,18 @@ static inline void __ublk_rq_task_work(s
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
@@ -783,12 +786,12 @@ static inline void ublk_abort_io_cmds(st
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
@@ -797,8 +800,9 @@ static void ublk_rq_task_work_fn(struct
 			struct ublk_rq_data, work);
 	struct request *req = blk_mq_rq_from_pdu(data);
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+	unsigned issue_flags = IO_URING_F_UNLOCKED;
 
-	ublk_forward_io_cmds(ubq);
+	ublk_forward_io_cmds(ubq, issue_flags);
 }
 
 static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
@@ -1052,7 +1056,8 @@ static void ublk_cancel_queue(struct ubl
 		struct ublk_io *io = &ubq->ios[i];
 
 		if (io->flags & UBLK_IO_FLAG_ACTIVE)
-			io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0);
+			io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0,
+						IO_URING_F_UNLOCKED);
 	}
 
 	/* all io commands are canceled */
@@ -1295,7 +1300,7 @@ static int ublk_ch_uring_cmd(struct io_u
 	return -EIOCBQUEUED;
 
  out:
-	io_uring_cmd_done(cmd, ret, 0);
+	io_uring_cmd_done(cmd, ret, 0, issue_flags);
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
 			__func__, cmd_op, tag, ret, io->flags);
 	return -EIOCBQUEUED;
@@ -2053,7 +2058,7 @@ static int ublk_ctrl_uring_cmd(struct io
 		break;
 	}
  out:
-	io_uring_cmd_done(cmd, ret, 0);
+	io_uring_cmd_done(cmd, ret, 0, issue_flags);
 	pr_devel("%s: cmd done ret %d cmd_op %x, dev id %d qid %d\n",
 			__func__, ret, cmd->cmd_op, header->dev_id, header->queue_id);
 	return -EIOCBQUEUED;
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -463,7 +463,8 @@ static inline struct nvme_uring_cmd_pdu
 	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
 }
 
-static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd)
+static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd,
+				    unsigned issue_flags)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 	struct request *req = pdu->req;
@@ -484,17 +485,18 @@ static void nvme_uring_task_meta_cb(stru
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
@@ -516,7 +518,7 @@ static enum rq_end_io_ret nvme_uring_cmd
 	 * Otherwise, move the completion to task work.
 	 */
 	if (cookie != NULL && blk_rq_is_poll(req))
-		nvme_uring_task_cb(ioucmd);
+		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
 	else
 		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
 
@@ -538,7 +540,7 @@ static enum rq_end_io_ret nvme_uring_cmd
 	 * Otherwise, move the completion to task work.
 	 */
 	if (cookie != NULL && blk_rq_is_poll(req))
-		nvme_uring_task_meta_cb(ioucmd);
+		nvme_uring_task_meta_cb(ioucmd, IO_URING_F_UNLOCKED);
 	else
 		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_meta_cb);
 
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
@@ -72,11 +73,11 @@ static inline int io_uring_cmd_import_fi
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
 
@@ -42,7 +43,8 @@ static inline void io_req_set_cqe32_extr
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
  */
-void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
+void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
+		       unsigned issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
@@ -56,7 +58,7 @@ void io_uring_cmd_done(struct io_uring_c
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
 	else
-		io_req_complete_post(req, 0);
+		io_req_complete_post(req, issue_flags);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 


