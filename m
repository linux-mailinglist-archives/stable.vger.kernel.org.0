Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDD3512061C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 13:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfLPMqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 07:46:33 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:35028 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727750AbfLPMq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 07:46:26 -0500
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 16 Dec 2019 04:46:24 -0800
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 4532E402B6;
        Mon, 16 Dec 2019 04:46:20 -0800 (PST)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <punit.agrawal@arm.com>,
        <akpm@linux-foundation.org>, <kirill.shutemov@linux.intel.com>,
        <willy@infradead.org>, <will.deacon@arm.com>,
        <mszeredi@redhat.com>, <stable@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <amakhalov@vmware.com>, <srinidhir@vmware.com>,
        <bvikas@vmware.com>, <anishs@vmware.com>, <vsirnapalli@vmware.com>,
        <srostedt@vmware.com>, <akaher@vmware.com>, <stable@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v3 7/8] fs: prevent page refcount overflow in pipe_buf_get
Date:   Tue, 17 Dec 2019 02:15:47 +0530
Message-ID: <1576529149-14269-8-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576529149-14269-1-git-send-email-akaher@vmware.com>
References: <1576529149-14269-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
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
---
 fs/fuse/dev.c             | 12 ++++++------
 fs/pipe.c                 |  4 ++--
 fs/splice.c               | 12 ++++++++++--
 include/linux/pipe_fs_i.h | 10 ++++++----
 kernel/trace/trace.c      |  6 +++++-
 5 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 36a5df9..16891f5 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2031,10 +2031,8 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
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
@@ -2052,7 +2050,9 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
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
@@ -2075,13 +2075,13 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
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
diff --git a/fs/pipe.c b/fs/pipe.c
index 1e7263b..6534470 100644
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
 
diff --git a/fs/splice.c b/fs/splice.c
index fde1263..57ccc58 100644
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
@@ -1948,7 +1952,11 @@ static int link_pipe(struct pipe_inode_info *ipipe,
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
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 10876f3..0b28b65 100644
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
@@ -148,7 +150,7 @@ struct pipe_inode_info *alloc_pipe_info(void);
 void free_pipe_info(struct pipe_inode_info *);
 
 /* Generic pipe buffer ops functions */
-void generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
+bool generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
 void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ae00e68..7fe8d04 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5731,12 +5731,16 @@ static void buffer_pipe_buf_release(struct pipe_inode_info *pipe,
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
-- 
2.7.4

