Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265E14C72AA
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbiB1R2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbiB1R1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:27:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179998932A;
        Mon, 28 Feb 2022 09:27:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A040AB815A6;
        Mon, 28 Feb 2022 17:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71C1C340F0;
        Mon, 28 Feb 2022 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069220;
        bh=pkOCGlI0oawlvjr58pfeQHv4Iga9CO17MGI1+uxuUoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJW4Rk3s8lIf4nOjfSOKJyd30ZrnzsBJvsYYacuQem57+J7elMvKKnXwFzFrQrw7S
         GYuedIuNTF0G2m4Vy+rqOtUlGj0zVOQGWoopbcFkpKw6MBc9O/IfgJmKMvijTCT6GJ
         YbNpno/ZcUQzgfqLo0tv/DHfdLEmt5o/YFzH6UN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Carel Si <beibei.si@intel.com>, Jann Horn <jannh@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Baokun Li <libaokun1@huawei.com>
Subject: [PATCH 4.9 29/29] fget: clarify and improve __fget_files() implementation
Date:   Mon, 28 Feb 2022 18:23:56 +0100
Message-Id: <20220228172144.557686370@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172141.744228435@linuxfoundation.org>
References: <20220228172141.744228435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 16 deletions(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -692,28 +692,69 @@ void do_close_on_exec(struct files_struc
 	spin_unlock(&files->file_lock);
 }
 
-static struct file *__fget(unsigned int fd, fmode_t mask, unsigned int refs)
+static inline struct file *__fget_files_rcu(struct files_struct *files,
+		unsigned int fd, fmode_t mask, unsigned int refs)
 {
-	struct files_struct *files = current->files;
-	struct file *file;
+	for (;;) {
+		struct file *file;
+		struct fdtable *fdt = rcu_dereference_raw(files->fdt);
+		struct file __rcu **fdentry;
 
-	rcu_read_lock();
-loop:
-	file = fcheck_files(files, fd);
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
-		else if (__fcheck_files(files, fd) != file) {
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
+
+static struct file *__fget(unsigned int fd, fmode_t mask, unsigned int refs)
+{
+	struct files_struct *files = current->files;
+	struct file *file;
+
+	rcu_read_lock();
+	file = __fget_files_rcu(files, fd, mask, refs);
 	rcu_read_unlock();
 
 	return file;


