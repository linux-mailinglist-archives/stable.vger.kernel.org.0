Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE97670FA0
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 05:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbfGWDJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 23:09:19 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:6500 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387971AbfGWDJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 23:09:19 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Jul 2019 20:09:04 -0700
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id E05E6B24DB;
        Mon, 22 Jul 2019 23:09:13 -0400 (EDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <aarcange@redhat.com>,
        <hughd@google.com>, <dave.hansen@intel.com>, <mgorman@suse.de>,
        <riel@redhat.com>, <mhocko@suse.cz>, <jannh@google.com>,
        <linux-kernel@vger.kernel.org>, <stable@kernel.org>,
        <stable@vger.kernel.org>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <srostedt@vmware.com>,
        <akaher@vmware.com>, Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 7/8] pipe: add pipe_buf_get() helper
Date:   Tue, 23 Jul 2019 16:38:30 +0530
Message-ID: <1563880111-19058-8-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563880111-19058-1-git-send-email-akaher@vmware.com>
References: <1563880111-19058-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 7bf2d1df80822ec056363627e2014990f068f7aa upstream.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Reviewed-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
---
 fs/fuse/dev.c             |  2 +-
 fs/splice.c               |  4 ++--
 include/linux/pipe_fs_i.h | 11 +++++++++++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index f5d2d23..36a5df9 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2052,7 +2052,7 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
 			pipe->curbuf = (pipe->curbuf + 1) & (pipe->buffers - 1);
 			pipe->nrbufs--;
 		} else {
-			ibuf->ops->get(pipe, ibuf);
+			pipe_buf_get(pipe, ibuf);
 			*obuf = *ibuf;
 			obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
 			obuf->len = rem;
diff --git a/fs/splice.c b/fs/splice.c
index 8398974..fde1263 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1876,7 +1876,7 @@ retry:
 			 * Get a reference to this pipe buffer,
 			 * so we can copy the contents over.
 			 */
-			ibuf->ops->get(ipipe, ibuf);
+			pipe_buf_get(ipipe, ibuf);
 			*obuf = *ibuf;
 
 			/*
@@ -1948,7 +1948,7 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 		 * Get a reference to this pipe buffer,
 		 * so we can copy the contents over.
 		 */
-		ibuf->ops->get(ipipe, ibuf);
+		pipe_buf_get(ipipe, ibuf);
 
 		obuf = opipe->bufs + nbuf;
 		*obuf = *ibuf;
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 24f5470..10876f3 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -115,6 +115,17 @@ struct pipe_buf_operations {
 	void (*get)(struct pipe_inode_info *, struct pipe_buffer *);
 };
 
+/**
+ * pipe_buf_get - get a reference to a pipe_buffer
+ * @pipe:	the pipe that the buffer belongs to
+ * @buf:	the buffer to get a reference to
+ */
+static inline void pipe_buf_get(struct pipe_inode_info *pipe,
+				struct pipe_buffer *buf)
+{
+	buf->ops->get(pipe, buf);
+}
+
 /* Differs from PIPE_BUF in that PIPE_SIZE is the length of the actual
    memory allocation, whereas PIPE_BUF makes atomicity guarantees.  */
 #define PIPE_SIZE		PAGE_SIZE
-- 
2.7.4

