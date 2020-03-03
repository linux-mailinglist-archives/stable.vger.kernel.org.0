Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3C4177FAD
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCCRwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:52:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731876AbgCCRwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:52:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADD9D2146E;
        Tue,  3 Mar 2020 17:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257935;
        bh=242ju/f1UL0RmgOXdz4af0lNK8ENlCQQx6rAW3hkU6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GN3byUCTlLsELEx6H2hmA73HRYTHBZcNdnk8ktlPDqRapVagXwynzFSNfkFhyXZZm
         sLf3tgMlWYHy/U9gOYhfGMDuKrPxdwYNQiYhZtIptW1CsJanlVrOcvq3be4He4a1pi
         wFtLm16XonqDNEQoNricspapdRmIX1lqp8MEdB4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/152] io_uring: grab ->fs as part of async offload
Date:   Tue,  3 Mar 2020 18:41:39 +0100
Message-Id: <20200303174302.711223909@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commits 9392a27d88b9 and ff002b30181d ]

Ensure that the async work grabs ->fs from the queueing task if the
punted commands needs to do lookups.

We don't have these two commits in 5.4-stable:

ff002b30181d30cdfbca316dadd099c3ca0d739c
9392a27d88b9707145d713654eb26f0c29789e50

because they don't apply with the rework that was done in how io_uring
handles offload. Since there's no io-wq in 5.4, it doesn't make sense to
do two patches. I'm attaching my port of the two for 5.4-stable, it's
been tested. Please queue it up for the next 5.4-stable, thanks!

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ed9a551882cf3..f34a8f7eee5d1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -71,6 +71,7 @@
 #include <linux/sizes.h>
 #include <linux/hugetlb.h>
 #include <linux/highmem.h>
+#include <linux/fs_struct.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -334,6 +335,8 @@ struct io_kiocb {
 	u32			result;
 	u32			sequence;
 
+	struct fs_struct	*fs;
+
 	struct work_struct	work;
 };
 
@@ -651,6 +654,7 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->result = 0;
+	req->fs = NULL;
 	return req;
 out:
 	percpu_ref_put(&ctx->refs);
@@ -1663,6 +1667,16 @@ static int io_send_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			ret = -EINTR;
 	}
 
+	if (req->fs) {
+		struct fs_struct *fs = req->fs;
+
+		spin_lock(&req->fs->lock);
+		if (--fs->users)
+			fs = NULL;
+		spin_unlock(&req->fs->lock);
+		if (fs)
+			free_fs_struct(fs);
+	}
 	io_cqring_add_event(req->ctx, sqe->user_data, ret);
 	io_put_req(req);
 	return 0;
@@ -2159,6 +2173,7 @@ static inline bool io_sqe_needs_user(const struct io_uring_sqe *sqe)
 static void io_sq_wq_submit_work(struct work_struct *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct fs_struct *old_fs_struct = current->fs;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct mm_struct *cur_mm = NULL;
 	struct async_list *async_list;
@@ -2178,6 +2193,15 @@ restart:
 		/* Ensure we clear previously set non-block flag */
 		req->rw.ki_flags &= ~IOCB_NOWAIT;
 
+		if (req->fs != current->fs && current->fs != old_fs_struct) {
+			task_lock(current);
+			if (req->fs)
+				current->fs = req->fs;
+			else
+				current->fs = old_fs_struct;
+			task_unlock(current);
+		}
+
 		ret = 0;
 		if (io_sqe_needs_user(sqe) && !cur_mm) {
 			if (!mmget_not_zero(ctx->sqo_mm)) {
@@ -2276,6 +2300,11 @@ out:
 		mmput(cur_mm);
 	}
 	revert_creds(old_cred);
+	if (old_fs_struct) {
+		task_lock(current);
+		current->fs = old_fs_struct;
+		task_unlock(current);
+	}
 }
 
 /*
@@ -2503,6 +2532,23 @@ err:
 
 	req->user_data = s->sqe->user_data;
 
+#if defined(CONFIG_NET)
+	switch (READ_ONCE(s->sqe->opcode)) {
+	case IORING_OP_SENDMSG:
+	case IORING_OP_RECVMSG:
+		spin_lock(&current->fs->lock);
+		if (!current->fs->in_exec) {
+			req->fs = current->fs;
+			req->fs->users++;
+		}
+		spin_unlock(&current->fs->lock);
+		if (!req->fs) {
+			ret = -EAGAIN;
+			goto err_req;
+		}
+	}
+#endif
+
 	/*
 	 * If we already have a head request, queue this one for async
 	 * submittal once the head completes. If we don't have a head but
-- 
2.20.1



