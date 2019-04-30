Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15192F717
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbfD3LtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730927AbfD3LtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF3D12054F;
        Tue, 30 Apr 2019 11:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624939;
        bh=UcgxxCxCfU2Luzk54hHPdAqm58Z5E8Ua2EOC7ZSKn0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Y/UwG5NP7yNTLemLQ9HlrUDvvIhmvg0jGZu7Xl/CP5TNoBb7O5HLYcrzw+Mr4kjk
         Xl2ANTRoubAK+oTHB80be3jBnPBwr6oIZ56U9U6EqoxNHb0v8O0OLw04DPDjrGmlaE
         UVU40kbAGOMWTtdjrjinY0SmKGtsPYzAfwuvu2J0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jann Horn <jannh@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.0 12/89] tracing: Fix buffer_ref pipe ops
Date:   Tue, 30 Apr 2019 13:38:03 +0200
Message-Id: <20190430113610.309054125@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit b987222654f84f7b4ca95b3a55eca784cb30235b upstream.

This fixes multiple issues in buffer_pipe_buf_ops:

 - The ->steal() handler must not return zero unless the pipe buffer has
   the only reference to the page. But generic_pipe_buf_steal() assumes
   that every reference to the pipe is tracked by the page's refcount,
   which isn't true for these buffers - buffer_pipe_buf_get(), which
   duplicates a buffer, doesn't touch the page's refcount.
   Fix it by using generic_pipe_buf_nosteal(), which refuses every
   attempted theft. It should be easy to actually support ->steal, but the
   only current users of pipe_buf_steal() are the virtio console and FUSE,
   and they also only use it as an optimization. So it's probably not worth
   the effort.
 - The ->get() and ->release() handlers can be invoked concurrently on pipe
   buffers backed by the same struct buffer_ref. Make them safe against
   concurrency by using refcount_t.
 - The pointers stored in ->private were only zeroed out when the last
   reference to the buffer_ref was dropped. As far as I know, this
   shouldn't be necessary anyway, but if we do it, let's always do it.

Link: http://lkml.kernel.org/r/20190404215925.253531-1-jannh@google.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
Fixes: 73a757e63114d ("ring-buffer: Return reader page back into existing ring buffer")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/splice.c               |    4 ++--
 include/linux/pipe_fs_i.h |    1 +
 kernel/trace/trace.c      |   28 ++++++++++++++--------------
 3 files changed, 17 insertions(+), 16 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -333,8 +333,8 @@ const struct pipe_buf_operations default
 	.get = generic_pipe_buf_get,
 };
 
-static int generic_pipe_buf_nosteal(struct pipe_inode_info *pipe,
-				    struct pipe_buffer *buf)
+int generic_pipe_buf_nosteal(struct pipe_inode_info *pipe,
+			     struct pipe_buffer *buf)
 {
 	return 1;
 }
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -181,6 +181,7 @@ void free_pipe_info(struct pipe_inode_in
 void generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
+int generic_pipe_buf_nosteal(struct pipe_inode_info *, struct pipe_buffer *);
 void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
 void pipe_buf_mark_unmergeable(struct pipe_buffer *buf);
 
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6823,19 +6823,23 @@ struct buffer_ref {
 	struct ring_buffer	*buffer;
 	void			*page;
 	int			cpu;
-	int			ref;
+	refcount_t		refcount;
 };
 
+static void buffer_ref_release(struct buffer_ref *ref)
+{
+	if (!refcount_dec_and_test(&ref->refcount))
+		return;
+	ring_buffer_free_read_page(ref->buffer, ref->cpu, ref->page);
+	kfree(ref);
+}
+
 static void buffer_pipe_buf_release(struct pipe_inode_info *pipe,
 				    struct pipe_buffer *buf)
 {
 	struct buffer_ref *ref = (struct buffer_ref *)buf->private;
 
-	if (--ref->ref)
-		return;
-
-	ring_buffer_free_read_page(ref->buffer, ref->cpu, ref->page);
-	kfree(ref);
+	buffer_ref_release(ref);
 	buf->private = 0;
 }
 
@@ -6844,7 +6848,7 @@ static void buffer_pipe_buf_get(struct p
 {
 	struct buffer_ref *ref = (struct buffer_ref *)buf->private;
 
-	ref->ref++;
+	refcount_inc(&ref->refcount);
 }
 
 /* Pipe buffer operations for a buffer. */
@@ -6852,7 +6856,7 @@ static const struct pipe_buf_operations
 	.can_merge		= 0,
 	.confirm		= generic_pipe_buf_confirm,
 	.release		= buffer_pipe_buf_release,
-	.steal			= generic_pipe_buf_steal,
+	.steal			= generic_pipe_buf_nosteal,
 	.get			= buffer_pipe_buf_get,
 };
 
@@ -6865,11 +6869,7 @@ static void buffer_spd_release(struct sp
 	struct buffer_ref *ref =
 		(struct buffer_ref *)spd->partial[i].private;
 
-	if (--ref->ref)
-		return;
-
-	ring_buffer_free_read_page(ref->buffer, ref->cpu, ref->page);
-	kfree(ref);
+	buffer_ref_release(ref);
 	spd->partial[i].private = 0;
 }
 
@@ -6924,7 +6924,7 @@ tracing_buffers_splice_read(struct file
 			break;
 		}
 
-		ref->ref = 1;
+		refcount_set(&ref->refcount, 1);
 		ref->buffer = iter->trace_buffer->buffer;
 		ref->page = ring_buffer_alloc_read_page(ref->buffer, iter->cpu_file);
 		if (IS_ERR(ref->page)) {


