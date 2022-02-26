Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9175F4C5425
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 07:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiBZGSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Feb 2022 01:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiBZGR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Feb 2022 01:17:59 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF022B20;
        Fri, 25 Feb 2022 22:17:24 -0800 (PST)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4K5GXJ5KvDz1FDZs;
        Sat, 26 Feb 2022 14:12:48 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Sat, 26 Feb
 2022 14:17:22 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <oliver.sang@intel.com>, <beibei.si@intel.com>, <jannh@google.com>,
        <mszeredi@redhat.com>, <torvalds@linux-foundation.org>,
        <libaokun1@huawei.com>, <yukuai3@huawei.com>
Subject: [PATCH 4.14] fget: clarify and improve __fget_files() implementation
Date:   Sat, 26 Feb 2022 14:32:56 +0800
Message-ID: <20220226063256.168114-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
---
 fs/file.c | 73 +++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 57 insertions(+), 16 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index f1943da6303b..5e79aa9f5d73 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -679,28 +679,69 @@ void do_close_on_exec(struct files_struct *files)
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
+		 */
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
 		 */
-		if (file->f_mode & mask)
-			file = NULL;
-		else if (!get_file_rcu_many(file, refs))
-			goto loop;
-		else if (__fcheck_files(files, fd) != file) {
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
-- 
2.31.1

