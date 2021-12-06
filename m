Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269534699E3
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345508AbhLFPEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:04:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54046 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345384AbhLFPDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:03:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9630861316;
        Mon,  6 Dec 2021 15:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A819FC341C1;
        Mon,  6 Dec 2021 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802822;
        bh=3BKyn+NGRlJHZTQLbWw7t3YNkqx7ASLTDFR79FF3Ahs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3oChcZX7n05hKQMXF4eBbMdjFv9DAdngL07qtvb/kXVTGNHxeR3nHYG7IjaypUVZ
         5WvI1R+v+DP6HFMxQMufOu6rfUovs1/DR55SsYzgtGQ3O9F08dDXSA+WBvoqfDh5+t
         DcQNpNLjdyBzUA4IlvJBHpPTHfwNsp4M44MDuAGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.4 44/52] fs: add fget_many() and fput_many()
Date:   Mon,  6 Dec 2021 15:56:28 +0100
Message-Id: <20211206145549.409594804@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 091141a42e15fe47ada737f3996b317072afcefb upstream.

Some uses cases repeatedly get and put references to the same file, but
the only exposed interface is doing these one at the time. As each of
these entail an atomic inc or dec on a shared structure, that cost can
add up.

Add fget_many(), which works just like fget(), except it takes an
argument for how many references to get on the file. Ditto fput_many(),
which can drop an arbitrary number of references to a file.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c            |   15 ++++++++++-----
 fs/file_table.c      |    9 +++++++--
 include/linux/file.h |    2 ++
 include/linux/fs.h   |    4 +++-
 4 files changed, 22 insertions(+), 8 deletions(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -691,7 +691,7 @@ void do_close_on_exec(struct files_struc
 	spin_unlock(&files->file_lock);
 }
 
-static struct file *__fget(unsigned int fd, fmode_t mask)
+static struct file *__fget(unsigned int fd, fmode_t mask, unsigned int refs)
 {
 	struct files_struct *files = current->files;
 	struct file *file;
@@ -706,7 +706,7 @@ loop:
 		 */
 		if (file->f_mode & mask)
 			file = NULL;
-		else if (!get_file_rcu(file))
+		else if (!get_file_rcu_many(file, refs))
 			goto loop;
 	}
 	rcu_read_unlock();
@@ -714,15 +714,20 @@ loop:
 	return file;
 }
 
+struct file *fget_many(unsigned int fd, unsigned int refs)
+{
+	return __fget(fd, FMODE_PATH, refs);
+}
+
 struct file *fget(unsigned int fd)
 {
-	return __fget(fd, FMODE_PATH);
+	return __fget(fd, FMODE_PATH, 1);
 }
 EXPORT_SYMBOL(fget);
 
 struct file *fget_raw(unsigned int fd)
 {
-	return __fget(fd, 0);
+	return __fget(fd, 0, 1);
 }
 EXPORT_SYMBOL(fget_raw);
 
@@ -753,7 +758,7 @@ static unsigned long __fget_light(unsign
 			return 0;
 		return (unsigned long)file;
 	} else {
-		file = __fget(fd, mask);
+		file = __fget(fd, mask, 1);
 		if (!file)
 			return 0;
 		return FDPUT_FPUT | (unsigned long)file;
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -261,9 +261,9 @@ void flush_delayed_fput(void)
 
 static DECLARE_DELAYED_WORK(delayed_fput_work, delayed_fput);
 
-void fput(struct file *file)
+void fput_many(struct file *file, unsigned int refs)
 {
-	if (atomic_long_dec_and_test(&file->f_count)) {
+	if (atomic_long_sub_and_test(refs, &file->f_count)) {
 		struct task_struct *task = current;
 
 		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
@@ -282,6 +282,11 @@ void fput(struct file *file)
 	}
 }
 
+void fput(struct file *file)
+{
+	fput_many(file, 1);
+}
+
 /*
  * synchronous analog of fput(); for kernel threads that might be needed
  * in some umount() (and thus can't use flush_delayed_fput() without
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -12,6 +12,7 @@
 struct file;
 
 extern void fput(struct file *);
+extern void fput_many(struct file *, unsigned int);
 
 struct file_operations;
 struct vfsmount;
@@ -40,6 +41,7 @@ static inline void fdput(struct fd fd)
 }
 
 extern struct file *fget(unsigned int fd);
+extern struct file *fget_many(unsigned int fd, unsigned int refs);
 extern struct file *fget_raw(unsigned int fd);
 extern unsigned long __fdget(unsigned int fd);
 extern unsigned long __fdget_raw(unsigned int fd);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -923,7 +923,9 @@ static inline struct file *get_file(stru
 	atomic_long_inc(&f->f_count);
 	return f;
 }
-#define get_file_rcu(x) atomic_long_inc_not_zero(&(x)->f_count)
+#define get_file_rcu_many(x, cnt)	\
+	atomic_long_add_unless(&(x)->f_count, (cnt), 0)
+#define get_file_rcu(x) get_file_rcu_many((x), 1)
 #define fput_atomic(x)	atomic_long_add_unless(&(x)->f_count, -1, 1)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
 


