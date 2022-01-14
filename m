Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BE148E5A9
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239726AbiANIUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239883AbiANITj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:19:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BBDC06161C;
        Fri, 14 Jan 2022 00:19:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A407E61E06;
        Fri, 14 Jan 2022 08:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA612C36AEA;
        Fri, 14 Jan 2022 08:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148378;
        bh=obnlzU5z/ht91Uf2nqUr1xVnL3inmP1jYsLOQBQ5nyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OdXM2qGCvruYZE97CTlX/SFyKnWKXFTa9Fxv4fLuv/ilxh/WifIYdySSG1/0JL2V
         r/vqm2s12fwcxHzlaqgs6rpUVNCUjaXWPC4acNNXYgRQgUdxGh/1uX3EDuUsnjn9c7
         X4P6rTdV3N1P6vSmsJuZBg82CyH8C3gZhS6rcdBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Carel Si <beibei.si@intel.com>, Jann Horn <jannh@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 13/41] fget: clarify and improve __fget_files() implementation
Date:   Fri, 14 Jan 2022 09:16:13 +0100
Message-Id: <20220114081545.603027941@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit e386dfc56f837da66d00a078e5314bc8382fab83 upstream.

Commit 054aa8d439b9 ("fget: check that the fd still exists after getting
a ref to it") fixed a race with getting a reference to a file just as it
was being closed.  It was a fairly minimal patch, and I didn't think
re-checking the file pointer lookup would be a measurable overhead,
since it was all right there and cached.

But I was wrong, as pointed out by the kernel test robot.

The 'poll2' case of the will-it-scale.per_thread_ops benchmark regressed
quite noticeably.  Admittedly it seems to be a very artificial test:
doing "poll()" system calls on regular files in a very tight loop in
multiple threads.

That means that basically all the time is spent just looking up file
descriptors without ever doing anything useful with them (not that doing
'poll()' on a regular file is useful to begin with).  And as a result it
shows the extra "re-check fd" cost as a sore thumb.

Happily, the regression is fixable by just writing the code to loook up
the fd to be better and clearer.  There's still a cost to verify the
file pointer, but now it's basically in the noise even for that
benchmark that does nothing else - and the code is more understandable
and has better comments too.

[ Side note: this patch is also a classic case of one that looks very
  messy with the default greedy Myers diff - it's much more legible with
  either the patience of histogram diff algorithm ]

Link: https://lore.kernel.org/lkml/20211210053743.GA36420@xsang-OptiPlex-9020/
Link: https://lore.kernel.org/lkml/20211213083154.GA20853@linux.intel.com/
Reported-by: kernel test robot <oliver.sang@intel.com>
Tested-by: Carel Si <beibei.si@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 16 deletions(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -841,28 +841,68 @@ void do_close_on_exec(struct files_struc
 	spin_unlock(&files->file_lock);
 }
 
-static struct file *__fget_files(struct files_struct *files, unsigned int fd,
-				 fmode_t mask, unsigned int refs)
+static inline struct file *__fget_files_rcu(struct files_struct *files,
+	unsigned int fd, fmode_t mask, unsigned int refs)
 {
-	struct file *file;
+	for (;;) {
+		struct file *file;
+		struct fdtable *fdt = rcu_dereference_raw(files->fdt);
+		struct file __rcu **fdentry;
 
-	rcu_read_lock();
-loop:
-	file = files_lookup_fd_rcu(files, fd);
-	if (file) {
-		/* File object ref couldn't be taken.
-		 * dup2() atomicity guarantee is the reason
-		 * we loop to catch the new file (or NULL pointer)
+		if (unlikely(fd >= fdt->max_fds))
+			return NULL;
+
+		fdentry = fdt->fd + array_index_nospec(fd, fdt->max_fds);
+		file = rcu_dereference_raw(*fdentry);
+		if (unlikely(!file))
+			return NULL;
+
+		if (unlikely(file->f_mode & mask))
+			return NULL;
+
+		/*
+		 * Ok, we have a file pointer. However, because we do
+		 * this all locklessly under RCU, we may be racing with
+		 * that file being closed.
+		 *
+		 * Such a race can take two forms:
+		 *
+		 *  (a) the file ref already went down to zero,
+		 *      and get_file_rcu_many() fails. Just try
+		 *      again:
 		 */
-		if (file->f_mode & mask)
-			file = NULL;
-		else if (!get_file_rcu_many(file, refs))
-			goto loop;
-		else if (files_lookup_fd_raw(files, fd) != file) {
+		if (unlikely(!get_file_rcu_many(file, refs)))
+			continue;
+
+		/*
+		 *  (b) the file table entry has changed under us.
+		 *       Note that we don't need to re-check the 'fdt->fd'
+		 *       pointer having changed, because it always goes
+		 *       hand-in-hand with 'fdt'.
+		 *
+		 * If so, we need to put our refs and try again.
+		 */
+		if (unlikely(rcu_dereference_raw(files->fdt) != fdt) ||
+		    unlikely(rcu_dereference_raw(*fdentry) != file)) {
 			fput_many(file, refs);
-			goto loop;
+			continue;
 		}
+
+		/*
+		 * Ok, we have a ref to the file, and checked that it
+		 * still exists.
+		 */
+		return file;
 	}
+}
+
+static struct file *__fget_files(struct files_struct *files, unsigned int fd,
+				 fmode_t mask, unsigned int refs)
+{
+	struct file *file;
+
+	rcu_read_lock();
+	file = __fget_files_rcu(files, fd, mask, refs);
 	rcu_read_unlock();
 
 	return file;


