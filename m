Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1287B17FEAD
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgCJMmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727201AbgCJMl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:41:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BF7024686;
        Tue, 10 Mar 2020 12:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844118;
        bh=mKajp1Fbx+JhuBoBL2JS9NsWyLifeaJJe/+eZpH9qIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qt9SnenmxUxaBz+d+LhIRdKcC0mpa6Hn+kgqNWXGDmFqSUKHN1UkKLNf1SibvGokz
         BB6zr46x6/feszgLfUQtF13xYuYU8NZOY6dN1GOa8r9cDx00dlMPGpFi+VE3U1fqIB
         g9yUBSFMoVmuyXVitB0eN/KIo+MHqkJkFeCQOGUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ajay Kaher <akaher@vmware.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 4.4 37/72] pipe: add pipe_buf_get() helper
Date:   Tue, 10 Mar 2020 13:38:50 +0100
Message-Id: <20200310123610.519964582@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit 7bf2d1df80822ec056363627e2014990f068f7aa upstream.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c             |    2 +-
 fs/splice.c               |    4 ++--
 include/linux/pipe_fs_i.h |   11 +++++++++++
 3 files changed, 14 insertions(+), 3 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2052,7 +2052,7 @@ static ssize_t fuse_dev_splice_write(str
 			pipe->curbuf = (pipe->curbuf + 1) & (pipe->buffers - 1);
 			pipe->nrbufs--;
 		} else {
-			ibuf->ops->get(pipe, ibuf);
+			pipe_buf_get(pipe, ibuf);
 			*obuf = *ibuf;
 			obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
 			obuf->len = rem;
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
@@ -1948,7 +1948,7 @@ static int link_pipe(struct pipe_inode_i
 		 * Get a reference to this pipe buffer,
 		 * so we can copy the contents over.
 		 */
-		ibuf->ops->get(ipipe, ibuf);
+		pipe_buf_get(ipipe, ibuf);
 
 		obuf = opipe->bufs + nbuf;
 		*obuf = *ibuf;
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


