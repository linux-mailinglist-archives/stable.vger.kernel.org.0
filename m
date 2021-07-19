Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918043CE3AD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346680AbhGSPjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347620AbhGSPfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ED5261480;
        Mon, 19 Jul 2021 16:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711148;
        bh=Hd5RaIB8crBXWykHtWnoyYa6aeBOl1R/uK9PjfeVkeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Icb1MN5n3ygqcFNOgWRLBiGAgHdO8b+vx1I6KFPc1IJ7m77rnBv6J5NA4FbBrrFzz
         c4lRctnB11hGd0dY3EHVsmkJtRG3dGbN/M0xMyIXNhk+meb3B1bwIaY4WDqxzxdWgN
         myIDfL9CP7Ess3P6oBwyuf7w6/qTkDnZFCn2IidA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 246/351] io_uring: move creds from io-wq work to io_kiocb
Date:   Mon, 19 Jul 2021 16:53:12 +0200
Message-Id: <20210719144953.077959817@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit c10d1f986b4e2a906862148c77a97f186cc08b9e ]

io-wq now doesn't have anything to do with creds now, so move ->creds
from struct io_wq_work into request (aka struct io_kiocb).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/8520c72ab8b8f4b96db12a228a2ab4c094ae64e1.1623949695.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.h    |  1 -
 fs/io_uring.c | 24 +++++++++++++-----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index af2df0680ee2..32c7b4e82484 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -87,7 +87,6 @@ static inline void wq_list_del(struct io_wq_work_list *list,
 
 struct io_wq_work {
 	struct io_wq_work_node list;
-	const struct cred *creds;
 	unsigned flags;
 };
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf3566ff9516..ab1dcf69217f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -849,6 +849,8 @@ struct io_kiocb {
 	struct hlist_node		hash_node;
 	struct async_poll		*apoll;
 	struct io_wq_work		work;
+	const struct cred 		*creds;
+
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
 };
@@ -1227,8 +1229,8 @@ static void io_prep_async_work(struct io_kiocb *req)
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->work.creds)
-		req->work.creds = get_current_cred();
+	if (!req->creds)
+		req->creds = get_current_cred();
 
 	req->work.list.next = NULL;
 	req->work.flags = 0;
@@ -1742,9 +1744,9 @@ static void io_dismantle_req(struct io_kiocb *req)
 		percpu_ref_put(req->fixed_rsrc_refs);
 	if (req->async_data)
 		kfree(req->async_data);
-	if (req->work.creds) {
-		put_cred(req->work.creds);
-		req->work.creds = NULL;
+	if (req->creds) {
+		put_cred(req->creds);
+		req->creds = NULL;
 	}
 }
 
@@ -6110,8 +6112,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	const struct cred *creds = NULL;
 	int ret;
 
-	if (req->work.creds && req->work.creds != current_cred())
-		creds = override_creds(req->work.creds);
+	if (req->creds && req->creds != current_cred())
+		creds = override_creds(req->creds);
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
@@ -6518,7 +6520,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	atomic_set(&req->refs, 2);
 	req->task = current;
 	req->result = 0;
-	req->work.creds = NULL;
+	req->creds = NULL;
 
 	/* enforce forwards compatibility on users */
 	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
@@ -6534,10 +6536,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	personality = READ_ONCE(sqe->personality);
 	if (personality) {
-		req->work.creds = xa_load(&ctx->personalities, personality);
-		if (!req->work.creds)
+		req->creds = xa_load(&ctx->personalities, personality);
+		if (!req->creds)
 			return -EINVAL;
-		get_cred(req->work.creds);
+		get_cred(req->creds);
 	}
 	state = &ctx->submit_state;
 
-- 
2.30.2



