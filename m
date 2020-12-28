Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAFE2E4002
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502992AbgL1OYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502984AbgL1OYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 744282245C;
        Mon, 28 Dec 2020 14:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165404;
        bh=F0FnHfMERRw5xu6UhLVLDLTxoiecxzuy0pehTAoY8tI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YIdvop3oy8YITbyZGjlKjS7paaDHHJg7S+83nJjLDI1K7tGcLuJS/uOQpkNVaHKfs
         ZAlW76QzIVun19UOYsTANgxM7XtexL/IFnxKvYGq3sBpz13mZrDk+ToMyDl6VfAjzv
         ZSbg1sCQHAJusZO8T/uKWev+D5jSvQ/M0lIUwz4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c9937dfb2303a5f18640@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 520/717] io_uring: fix double io_uring free
Date:   Mon, 28 Dec 2020 13:48:38 +0100
Message-Id: <20201228125045.874173758@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 9faadcc8abe4b83d0263216dc3a6321d5bbd616b upstream.

Once we created a file for current context during setup, we should not
call io_ring_ctx_wait_and_kill() directly as it'll be done by fput(file)

Cc: stable@vger.kernel.org # 5.10
Reported-by: syzbot+c9937dfb2303a5f18640@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
[axboe: fix unused 'ret' for !CONFIG_UNIX]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   71 +++++++++++++++++++++++++++++++---------------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9195,55 +9195,52 @@ static int io_allocate_scq_urings(struct
 	return 0;
 }
 
+static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
+{
+	int ret, fd;
+
+	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	ret = io_uring_add_task_file(ctx, file);
+	if (ret) {
+		put_unused_fd(fd);
+		return ret;
+	}
+	fd_install(fd, file);
+	return fd;
+}
+
 /*
  * Allocate an anonymous fd, this is what constitutes the application
  * visible backing of an io_uring instance. The application mmaps this
  * fd to gain access to the SQ/CQ ring details. If UNIX sockets are enabled,
  * we have to tie this fd to a socket for file garbage collection purposes.
  */
-static int io_uring_get_fd(struct io_ring_ctx *ctx)
+static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 {
 	struct file *file;
+#if defined(CONFIG_UNIX)
 	int ret;
-	int fd;
 
-#if defined(CONFIG_UNIX)
 	ret = sock_create_kern(&init_net, PF_UNIX, SOCK_RAW, IPPROTO_IP,
 				&ctx->ring_sock);
 	if (ret)
-		return ret;
+		return ERR_PTR(ret);
 #endif
 
-	ret = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
-	if (ret < 0)
-		goto err;
-	fd = ret;
-
 	file = anon_inode_getfile("[io_uring]", &io_uring_fops, ctx,
 					O_RDWR | O_CLOEXEC);
-	if (IS_ERR(file)) {
-		put_unused_fd(fd);
-		ret = PTR_ERR(file);
-		goto err;
-	}
-
 #if defined(CONFIG_UNIX)
-	ctx->ring_sock->file = file;
-#endif
-	ret = io_uring_add_task_file(ctx, file);
-	if (ret) {
-		fput(file);
-		put_unused_fd(fd);
-		goto err;
+	if (IS_ERR(file)) {
+		sock_release(ctx->ring_sock);
+		ctx->ring_sock = NULL;
+	} else {
+		ctx->ring_sock->file = file;
 	}
-	fd_install(fd, file);
-	return fd;
-err:
-#if defined(CONFIG_UNIX)
-	sock_release(ctx->ring_sock);
-	ctx->ring_sock = NULL;
 #endif
-	return ret;
+	return file;
 }
 
 static int io_uring_create(unsigned entries, struct io_uring_params *p,
@@ -9251,6 +9248,7 @@ static int io_uring_create(unsigned entr
 {
 	struct user_struct *user = NULL;
 	struct io_ring_ctx *ctx;
+	struct file *file;
 	bool limit_mem;
 	int ret;
 
@@ -9397,13 +9395,22 @@ static int io_uring_create(unsigned entr
 		goto err;
 	}
 
+	file = io_uring_get_file(ctx);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto err;
+	}
+
 	/*
 	 * Install ring fd as the very last thing, so we don't risk someone
 	 * having closed it before we finish setup
 	 */
-	ret = io_uring_get_fd(ctx);
-	if (ret < 0)
-		goto err;
+	ret = io_uring_install_fd(ctx, file);
+	if (ret < 0) {
+		/* fput will clean it up */
+		fput(file);
+		return ret;
+	}
 
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;


