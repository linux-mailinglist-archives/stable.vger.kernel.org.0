Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD8316C097
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 13:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgBYMSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 07:18:01 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:8410 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726019AbgBYMSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 07:18:01 -0500
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 25 Feb 2020 04:17:59 -0800
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 3B5E7405C3;
        Tue, 25 Feb 2020 04:17:54 -0800 (PST)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <willy@infradead.org>,
        <jannh@google.com>, <vbabka@suse.cz>, <will.deacon@arm.com>,
        <punit.agrawal@arm.com>, <steve.capper@arm.com>,
        <kirill.shutemov@linux.intel.com>,
        <aneesh.kumar@linux.vnet.ibm.com>, <catalin.marinas@arm.com>,
        <n-horiguchi@ah.jp.nec.com>, <mark.rutland@arm.com>,
        <mhocko@suse.com>, <mike.kravetz@oracle.com>,
        <akpm@linux-foundation.org>, <mszeredi@redhat.com>,
        <viro@zeniv.linux.org.uk>, <stable@vger.kernel.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <amakhalov@vmware.com>, <srinidhir@vmware.com>,
        <bvikas@vmware.com>, <anishs@vmware.com>, <vsirnapalli@vmware.com>,
        <sharathg@vmware.com>, <srostedt@vmware.com>, <akaher@vmware.com>
Subject: [PATCH v4 v4.4.y 6/7] pipe: add pipe_buf_get() helper
Date:   Wed, 26 Feb 2020 01:46:13 +0530
Message-ID: <1582661774-30925-7-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582661774-30925-1-git-send-email-akaher@vmware.com>
References: <1582661774-30925-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
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
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
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

