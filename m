Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820F417F7C0
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgCJMmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbgCJMmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:42:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8C92246C6;
        Tue, 10 Mar 2020 12:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844121;
        bh=TozLtoVh77U5/hOYYVw5gd42uWtqHnUz7UqzxkxfWjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVBX2DDjnHf0IX5EEAaxZFs5e06UE07CcR9KDu3sIpc8skr0vHQAI2gAUfsRqlMGo
         D/Y5vR5PNCTz9cKuwpnIqlZ+yqQ/NelEHgevma2Tay4KSN19n1FF6l9impxFJHhS0B
         oGswzTfKwjsJrC1iu3sp5JqlzJzprKrzDXf0D/BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ajay Kaher <akaher@vmware.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 4.4 38/72] fs: prevent page refcount overflow in pipe_buf_get
Date:   Tue, 10 Mar 2020 13:38:51 +0100
Message-Id: <20200310123610.971044185@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
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
[ 4.4.y backport notes:
  Regarding the change in generic_pipe_buf_get(), note that
  page_cache_get() is the same as get_page(). See mainline commit
  09cbfeaf1a5a6 "mm, fs: get rid of PAGE_CACHE_* and
  page_cache_{get,release} macros" for context. ]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
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
@@ -2031,10 +2031,8 @@ static ssize_t fuse_dev_splice_write(str
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
@@ -2052,7 +2050,9 @@ static ssize_t fuse_dev_splice_write(str
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
@@ -2075,13 +2075,13 @@ static ssize_t fuse_dev_splice_write(str
 	ret = fuse_dev_do_write(fud, &cs, len);
 
 	pipe_lock(pipe);
+out_free:
 	for (idx = 0; idx < nbuf; idx++) {
 		struct pipe_buffer *buf = &bufs[idx];
 		buf->ops->release(pipe, buf);
 	}
 	pipe_unlock(pipe);
 
-out:
 	kfree(bufs);
 	return ret;
 }
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -178,9 +178,9 @@ EXPORT_SYMBOL(generic_pipe_buf_steal);
  *	in the tee() system call, when we duplicate the buffers in one
  *	pipe into another.
  */
-void generic_pipe_buf_get(struct pipe_inode_info *pipe, struct pipe_buffer *buf)
+bool generic_pipe_buf_get(struct pipe_inode_info *pipe, struct pipe_buffer *buf)
 {
-	page_cache_get(buf->page);
+	return try_get_page(buf->page);
 }
 EXPORT_SYMBOL(generic_pipe_buf_get);
 
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1876,7 +1876,11 @@ retry:
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
@@ -1948,7 +1952,11 @@ static int link_pipe(struct pipe_inode_i
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
@@ -112,18 +112,20 @@ struct pipe_buf_operations {
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
 
 /* Differs from PIPE_BUF in that PIPE_SIZE is the length of the actual
@@ -148,7 +150,7 @@ struct pipe_inode_info *alloc_pipe_info(
 void free_pipe_info(struct pipe_inode_info *);
 
 /* Generic pipe buffer ops functions */
-void generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
+bool generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
 void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5749,12 +5749,16 @@ static void buffer_pipe_buf_release(stru
 	buf->private = 0;
 }
 
-static void buffer_pipe_buf_get(struct pipe_inode_info *pipe,
+static bool buffer_pipe_buf_get(struct pipe_inode_info *pipe,
 				struct pipe_buffer *buf)
 {
 	struct buffer_ref *ref = (struct buffer_ref *)buf->private;
 
+	if (ref->ref > INT_MAX/2)
+		return false;
+
 	ref->ref++;
+	return true;
 }
 
 /* Pipe buffer operations for a buffer. */


