Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E06C2C9D20
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390742AbgLAJTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:19:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389644AbgLAJKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:10:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E0F9221FF;
        Tue,  1 Dec 2020 09:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813771;
        bh=IBKo153u6tCyF/G1i86IGoLG+Sjwvg5SFXRm9IGDGj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHEUdwUzWNRuYkhInCWDHOYhXji1sdh0McWHnUkULkTAkHMa76ZjQh2xO8qIWgUat
         Q1geRIH/+pDS9JoRSsjKH1TJJiUVD+SGMrEWAlEc2W6x1iESrjvT0sAAS2ClqEUemq
         DQCUqJw8657bLKWTURjLD+Yl19fnXbsVvi0bvHYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 054/152] io_uring: handle -EOPNOTSUPP on path resolution
Date:   Tue,  1 Dec 2020 09:52:49 +0100
Message-Id: <20201201084719.013832675@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 185c206e5683f..5d9f8e40b93d3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -436,6 +436,7 @@ struct io_sr_msg {
 struct io_open {
 	struct file			*file;
 	int				dfd;
+	bool				ignore_nonblock;
 	struct filename			*filename;
 	struct open_how			how;
 	unsigned long			nofile;
@@ -3591,6 +3592,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return ret;
 	}
 	req->open.nofile = rlimit(RLIMIT_NOFILE);
+	req->open.ignore_nonblock = false;
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
@@ -3638,7 +3640,7 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	struct file *file;
 	int ret;
 
-	if (force_nonblock)
+	if (force_nonblock && !req->open.ignore_nonblock)
 		return -EAGAIN;
 
 	ret = build_open_flags(&req->open.how, &op);
@@ -3653,6 +3655,21 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
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



