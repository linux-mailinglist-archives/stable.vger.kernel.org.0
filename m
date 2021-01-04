Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11072E9A48
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbhADQIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:08:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbhADQBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB05F224D2;
        Mon,  4 Jan 2021 16:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776098;
        bh=dM5Mv6sIRfVrmAb6P2xDAxq9iPE1eI4jm2Z3Kndta5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUY6OkQ8r2MY7SdAGnCWCVgh8EdA4hArLNZUabPRG/WtmaPPL5z8d+apRxfcVUMqD
         U4Ehdjm1GEuiB+MMyDtWXqnoH7Ogi+Uue8pUjukP9qwfa2RQDEQV5I9+U3M5+gLnmA
         n660Cck6WNs2IMuXzBLBC6y2QGdtYCqmQOv0NLX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 20/63] io_uring: fix io_sqe_files_unregister() hangs
Date:   Mon,  4 Jan 2021 16:57:13 +0100
Message-Id: <20210104155709.797363028@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 1ffc54220c444774b7f09e6d2121e732f8e19b94 upstream.

io_sqe_files_unregister() uninterruptibly waits for enqueued ref nodes,
however requests keeping them may never complete, e.g. because of some
userspace dependency. Make sure it's interruptible otherwise it would
hang forever.

Cc: stable@vger.kernel.org # 5.6+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -941,6 +941,10 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
+static void destroy_fixed_file_ref_node(struct fixed_file_ref_node *ref_node);
+static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
+			struct io_ring_ctx *ctx);
+
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 			     struct io_comp_state *cs);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
@@ -7004,11 +7008,15 @@ static void io_sqe_files_set_node(struct
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_file_data *data = ctx->file_data;
-	struct fixed_file_ref_node *ref_node = NULL;
+	struct fixed_file_ref_node *backup_node, *ref_node = NULL;
 	unsigned nr_tables, i;
+	int ret;
 
 	if (!data)
 		return -ENXIO;
+	backup_node = alloc_fixed_file_ref_node(ctx);
+	if (!backup_node)
+		return -ENOMEM;
 
 	spin_lock_bh(&data->lock);
 	ref_node = data->node;
@@ -7020,7 +7028,18 @@ static int io_sqe_files_unregister(struc
 
 	/* wait for all refs nodes to complete */
 	flush_delayed_work(&ctx->file_put_work);
-	wait_for_completion(&data->done);
+	do {
+		ret = wait_for_completion_interruptible(&data->done);
+		if (!ret)
+			break;
+		ret = io_run_task_work_sig();
+		if (ret < 0) {
+			percpu_ref_resurrect(&data->refs);
+			reinit_completion(&data->done);
+			io_sqe_files_set_node(data, backup_node);
+			return ret;
+		}
+	} while (1);
 
 	__io_sqe_files_unregister(ctx);
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
@@ -7031,6 +7050,7 @@ static int io_sqe_files_unregister(struc
 	kfree(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
+	destroy_fixed_file_ref_node(backup_node);
 	return 0;
 }
 


