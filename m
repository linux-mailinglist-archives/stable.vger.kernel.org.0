Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8129311F0A
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfEBPZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbfEBPZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:25:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65AB120B7C;
        Thu,  2 May 2019 15:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810745;
        bh=Y+B0AXuPHXPR9VLf1LNIwFEu7tS9YzTWPOEc8FjP7pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tC1+R/DQU7mPflMPF1XsEuhw0saujUU8ssR3Km1R27RL88mrupJ0K1XbFomkuodDh
         cFzl54xFkf46dTGLAr+GoQOA8k6rNDnhd6egGwYw8Onb86QSp6rq4Y+qFzY9O+++p5
         wIu1yneXH+94xZsey00aY/oAty2uDIG4t5J4zRwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 06/72] fs: prevent page refcount overflow in pipe_buf_get
Date:   Thu,  2 May 2019 17:20:28 +0200
Message-Id: <20190502143333.929606334@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>

commit 15fab63e1e57be9fdb5eec1bbc5916e9825e9acb upstream.

Change pipe_buf_get() to return a bool indicating whether it succeeded
in raising the refcount of the page (if the thing in the pipe is a page).
This removes another mechanism for overflowing the page refcount.  All
callers converted to handle a failure.

Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dev.c             |   12 ++++++------
 fs/pipe.c                 |    4 ++--
 fs/splice.c               |   12 ++++++++++--
 include/linux/pipe_fs_i.h |   10 ++++++----
 kernel/trace/trace.c      |    6 +++++-
 5 files changed, 29 insertions(+), 15 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1989,10 +1989,8 @@ static ssize_t fuse_dev_splice_write(str
 		rem += pipe->bufs[(pipe->curbuf + idx) & (pipe->buffers - 1)].len;
 
 	ret = -EINVAL;
-	if (rem < len) {
-		pipe_unlock(pipe);
-		goto out;
-	}
+	if (rem < len)
+		goto out_free;
 
 	rem = len;
 	while (rem) {
@@ -2010,7 +2008,9 @@ static ssize_t fuse_dev_splice_write(str
 			pipe->curbuf = (pipe->curbuf + 1) & (pipe->buffers - 1);
 			pipe->nrbufs--;
 		} else {
-			pipe_buf_get(pipe, ibuf);
+			if (!pipe_buf_get(pipe, ibuf))
+				goto out_free;
+
 			*obuf = *ibuf;
 			obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
 			obuf->len = rem;
@@ -2033,11 +2033,11 @@ static ssize_t fuse_dev_splice_write(str
 	ret = fuse_dev_do_write(fud, &cs, len);
 
 	pipe_lock(pipe);
+out_free:
 	for (idx = 0; idx < nbuf; idx++)
 		pipe_buf_release(pipe, &bufs[idx]);
 	pipe_unlock(pipe);
 
-out:
 	kvfree(bufs);
 	return ret;
 }
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -189,9 +189,9 @@ EXPORT_SYMBOL(generic_pipe_buf_steal);
  *	in the tee() system call, when we duplicate the buffers in one
  *	pipe into another.
  */
-void generic_pipe_buf_get(struct pipe_inode_info *pipe, struct pipe_buffer *buf)
+bool generic_pipe_buf_get(struct pipe_inode_info *pipe, struct pipe_buffer *buf)
 {
-	get_page(buf->page);
+	return try_get_page(buf->page);
 }
 EXPORT_SYMBOL(generic_pipe_buf_get);
 
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1584,7 +1584,11 @@ retry:
 			 * Get a reference to this pipe buffer,
 			 * so we can copy the contents over.
 			 */
-			pipe_buf_get(ipipe, ibuf);
+			if (!pipe_buf_get(ipipe, ibuf)) {
+				if (ret == 0)
+					ret = -EFAULT;
+				break;
+			}
 			*obuf = *ibuf;
 
 			/*
@@ -1658,7 +1662,11 @@ static int link_pipe(struct pipe_inode_i
 		 * Get a reference to this pipe buffer,
 		 * so we can copy the contents over.
 		 */
-		pipe_buf_get(ipipe, ibuf);
+		if (!pipe_buf_get(ipipe, ibuf)) {
+			if (ret == 0)
+				ret = -EFAULT;
+			break;
+		}
 
 		obuf = opipe->bufs + nbuf;
 		*obuf = *ibuf;
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -108,18 +108,20 @@ struct pipe_buf_operations {
 	/*
 	 * Get a reference to the pipe buffer.
 	 */
-	void (*get)(struct pipe_inode_info *, struct pipe_buffer *);
+	bool (*get)(struct pipe_inode_info *, struct pipe_buffer *);
 };
 
 /**
  * pipe_buf_get - get a reference to a pipe_buffer
  * @pipe:	the pipe that the buffer belongs to
  * @buf:	the buffer to get a reference to
+ *
+ * Return: %true if the reference was successfully obtained.
  */
-static inline void pipe_buf_get(struct pipe_inode_info *pipe,
+static inline __must_check bool pipe_buf_get(struct pipe_inode_info *pipe,
 				struct pipe_buffer *buf)
 {
-	buf->ops->get(pipe, buf);
+	return buf->ops->get(pipe, buf);
 }
 
 /**
@@ -178,7 +180,7 @@ struct pipe_inode_info *alloc_pipe_info(
 void free_pipe_info(struct pipe_inode_info *);
 
 /* Generic pipe buffer ops functions */
-void generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
+bool generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_nosteal(struct pipe_inode_info *, struct pipe_buffer *);
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6823,12 +6823,16 @@ static void buffer_pipe_buf_release(stru
 	buf->private = 0;
 }
 
-static void buffer_pipe_buf_get(struct pipe_inode_info *pipe,
+static bool buffer_pipe_buf_get(struct pipe_inode_info *pipe,
 				struct pipe_buffer *buf)
 {
 	struct buffer_ref *ref = (struct buffer_ref *)buf->private;
 
+	if (refcount_read(&ref->refcount) > INT_MAX/2)
+		return false;
+
 	refcount_inc(&ref->refcount);
+	return true;
 }
 
 /* Pipe buffer operations for a buffer. */


