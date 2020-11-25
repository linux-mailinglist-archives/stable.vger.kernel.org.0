Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBE22C4446
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbgKYPml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:42:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730448AbgKYPgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB81520B1F;
        Wed, 25 Nov 2020 15:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318571;
        bh=zLdUa7DqXAtVf2HBtkkB2urCKJUPTXFbXahkOAQ5eUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHR+XvV3uUTvdhFJ2AqieotIyCBMtHCWm8pDfrnaootyOsmSzA7rWKZaytlX2KHQ2
         ooGMm9DQ8ibhsXRstCQ1IQqJRw/Bc7Zdr7CxdF0jiQWITXb/naPFYl/tXVeop+3M3s
         q6Xqvp9KV7foRaCHDEOWepUsFriarnLeFIx5IibE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 16/33] io_uring: handle -EOPNOTSUPP on path resolution
Date:   Wed, 25 Nov 2020 10:35:33 -0500
Message-Id: <20201125153550.810101-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153550.810101-1-sashal@kernel.org>
References: <20201125153550.810101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 944d1444d53f5a213457e5096db370cfd06923d4 ]

Any attempt to do path resolution on /proc/self from an async worker will
yield -EOPNOTSUPP. We can safely do that resolution from the task itself,
and without blocking, so retry it from there.

Ideally io_uring would know this upfront and not have to go through the
worker thread to find out, but that doesn't currently seem feasible.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e74a56f6915c0..46a68a8439895 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -435,6 +435,7 @@ struct io_sr_msg {
 struct io_open {
 	struct file			*file;
 	int				dfd;
+	bool				ignore_nonblock;
 	struct filename			*filename;
 	struct open_how			how;
 	unsigned long			nofile;
@@ -3590,6 +3591,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return ret;
 	}
 	req->open.nofile = rlimit(RLIMIT_NOFILE);
+	req->open.ignore_nonblock = false;
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
@@ -3637,7 +3639,7 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	struct file *file;
 	int ret;
 
-	if (force_nonblock)
+	if (force_nonblock && !req->open.ignore_nonblock)
 		return -EAGAIN;
 
 	ret = build_open_flags(&req->open.how, &op);
@@ -3652,6 +3654,21 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	if (IS_ERR(file)) {
 		put_unused_fd(ret);
 		ret = PTR_ERR(file);
+		/*
+		 * A work-around to ensure that /proc/self works that way
+		 * that it should - if we get -EOPNOTSUPP back, then assume
+		 * that proc_self_get_link() failed us because we're in async
+		 * context. We should be safe to retry this from the task
+		 * itself with force_nonblock == false set, as it should not
+		 * block on lookup. Would be nice to know this upfront and
+		 * avoid the async dance, but doesn't seem feasible.
+		 */
+		if (ret == -EOPNOTSUPP && io_wq_current_is_worker()) {
+			req->open.ignore_nonblock = true;
+			refcount_inc(&req->refs);
+			io_req_task_queue(req);
+			return 0;
+		}
 	} else {
 		fsnotify_open(file);
 		fd_install(ret, file);
-- 
2.27.0

