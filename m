Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A503F6440
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239243AbhHXRCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239284AbhHXRAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:00:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E735261555;
        Tue, 24 Aug 2021 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824268;
        bh=FSbH8QbQrePsPQn/czJeGKEeHplfEIkslJRYepzNeVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hI6A7UZ6/vZndt8tR1vaEzgMqXkExlxUmlVpySw2F63ei2gh6neihryBJlPGGvaG1
         aUfjmuFM943cSH9J4Wh71Erbil6TdZ+5RRSf21n3aB92/4gY8G6yOKsoJqeu7Xmb0S
         Dbt9JROM82wk5Zj+6AmqVM2qrgzHziLqO8YOSsa17FktHcrBFNoUl5GVCh/GbMQwE7
         MSDMYTV/PRcOj8qApUTeYRnE/G8be2VBiGI6WUyBfmiv2VMHeWMvJyjXWt56vJ9/Ca
         VO9x3A7/9CZ0ddXj8RRkIRm2QxtY7oPlJGjpTeVYQsHOR3JjYYSGb9Wc9qf6ux9gLk
         /EaSqYZzFZfDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 102/127] io_uring: fix code style problems
Date:   Tue, 24 Aug 2021 12:55:42 -0400
Message-Id: <20210824165607.709387-103-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit fe7e325750299126b9cc86d3071af594b46c4518 ]

Fix a bunch of problems mostly found by checkpatch.pl

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/cfaf9a2f27b43934144fe9422a916bd327099f44.1624543113.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0a5f105c657c..00746109e0c8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -165,7 +165,7 @@ struct io_rings {
 	 * Written by the application, shouldn't be modified by the
 	 * kernel.
 	 */
-	u32                     cq_flags;
+	u32			cq_flags;
 	/*
 	 * Number of completion events lost because the queue was full;
 	 * this should be avoided by the application by making sure
@@ -850,7 +850,7 @@ struct io_kiocb {
 	struct hlist_node		hash_node;
 	struct async_poll		*apoll;
 	struct io_wq_work		work;
-	const struct cred 		*creds;
+	const struct cred		*creds;
 
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
@@ -1721,7 +1721,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
-	BUILD_BUG_ON(IO_REQ_ALLOC_BATCH > ARRAY_SIZE(state->reqs));
+	BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);
 
 	if (!state->free_reqs) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
@@ -2778,7 +2778,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	else
 		io_rw_done(kiocb, ret);
 
-	if (check_reissue && req->flags & REQ_F_REISSUE) {
+	if (check_reissue && (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req)) {
 			req_ref_get(req);
@@ -3608,7 +3608,7 @@ static int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
 static int __io_splice_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
-	struct io_splice* sp = &req->splice;
+	struct io_splice *sp = &req->splice;
 	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -3662,7 +3662,7 @@ static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_splice* sp = &req->splice;
+	struct io_splice *sp = &req->splice;
 
 	sp->off_in = READ_ONCE(sqe->splice_off_in);
 	sp->off_out = READ_ONCE(sqe->off);
@@ -8563,6 +8563,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 	ctx->cq_ev_fd = eventfd_ctx_fdget(fd);
 	if (IS_ERR(ctx->cq_ev_fd)) {
 		int ret = PTR_ERR(ctx->cq_ev_fd);
+
 		ctx->cq_ev_fd = NULL;
 		return ret;
 	}
@@ -9362,9 +9363,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		io_cqring_overflow_flush(ctx, false);
 
 		ret = -EOWNERDEAD;
-		if (unlikely(ctx->sq_data->thread == NULL)) {
+		if (unlikely(ctx->sq_data->thread == NULL))
 			goto out;
-		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT) {
-- 
2.30.2

