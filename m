Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28ECAF438B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 10:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbfKHJi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 04:38:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:39774 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731447AbfKHJi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 04:38:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2AA8AE68;
        Fri,  8 Nov 2019 09:38:24 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ajay Kaher <akaher@vmware.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH STABLE 4.4 6/8] pipe: add pipe_buf_get() helper
Date:   Fri,  8 Nov 2019 10:38:12 +0100
Message-Id: <20191108093814.16032-7-vbabka@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108093814.16032-1-vbabka@suse.cz>
References: <20191108093814.16032-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 7bf2d1df80822ec056363627e2014990f068f7aa upstream.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 fs/fuse/dev.c             |  2 +-
 fs/splice.c               |  4 ++--
 include/linux/pipe_fs_i.h | 11 +++++++++++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index f5d2d2340b44..36a5df92eb9c 100644
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
index 8398974e1538..fde126369966 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1876,7 +1876,7 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
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
index 24f5470d3944..10876f3cb3da 100644
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
2.23.0

