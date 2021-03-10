Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD6C333DA4
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhCJNYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232565AbhCJNYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C90F864FD8;
        Wed, 10 Mar 2021 13:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382645;
        bh=jlDMQqt2Fi37WONNSWPUAljt6UEZEUdSaECPGdDiatc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTlBgEqQX4JqajaZisFVPBMf5RGVo4YIafZhaI1SZatxxcGcp2MwNjUGS9t+BjeW7
         4bcUzLfNWymvi8AyoRK/Q8ICykylQ/Ux46h1xCGOKxEgc8An+/NvCqNos+LVFwNUqu
         JKO1EvFQgLqYliduJ2Qsnh0fODYb/lQVhpbuXbKI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.11 06/36] fs: provide locked helper variant of close_fd_get_file()
Date:   Wed, 10 Mar 2021 14:23:19 +0100
Message-Id: <20210310132320.723697369@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jens Axboe <axboe@kernel.dk>

commit 53dec2ea74f2ef360e8455439be96a780baa6097 upstream

Assumes current->files->file_lock is already held on invocation. Helps
the caller check the file before removing the fd, if it needs to.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c     |   36 +++++++++++++++++++++++++-----------
 fs/internal.h |    1 +
 2 files changed, 26 insertions(+), 11 deletions(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -22,6 +22,8 @@
 #include <linux/close_range.h>
 #include <net/sock.h>
 
+#include "internal.h"
+
 unsigned int sysctl_nr_open __read_mostly = 1024*1024;
 unsigned int sysctl_nr_open_min = BITS_PER_LONG;
 /* our min() is unusable in constant expressions ;-/ */
@@ -732,36 +734,48 @@ int __close_range(unsigned fd, unsigned
 }
 
 /*
- * variant of close_fd that gets a ref on the file for later fput.
- * The caller must ensure that filp_close() called on the file, and then
- * an fput().
+ * See close_fd_get_file() below, this variant assumes current->files->file_lock
+ * is held.
  */
-int close_fd_get_file(unsigned int fd, struct file **res)
+int __close_fd_get_file(unsigned int fd, struct file **res)
 {
 	struct files_struct *files = current->files;
 	struct file *file;
 	struct fdtable *fdt;
 
-	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
 	if (fd >= fdt->max_fds)
-		goto out_unlock;
+		goto out_err;
 	file = fdt->fd[fd];
 	if (!file)
-		goto out_unlock;
+		goto out_err;
 	rcu_assign_pointer(fdt->fd[fd], NULL);
 	__put_unused_fd(files, fd);
-	spin_unlock(&files->file_lock);
 	get_file(file);
 	*res = file;
 	return 0;
-
-out_unlock:
-	spin_unlock(&files->file_lock);
+out_err:
 	*res = NULL;
 	return -ENOENT;
 }
 
+/*
+ * variant of close_fd that gets a ref on the file for later fput.
+ * The caller must ensure that filp_close() called on the file, and then
+ * an fput().
+ */
+int close_fd_get_file(unsigned int fd, struct file **res)
+{
+	struct files_struct *files = current->files;
+	int ret;
+
+	spin_lock(&files->file_lock);
+	ret = __close_fd_get_file(fd, res);
+	spin_unlock(&files->file_lock);
+
+	return ret;
+}
+
 void do_close_on_exec(struct files_struct *files)
 {
 	unsigned i;
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -132,6 +132,7 @@ extern struct file *do_file_open_root(st
 		const char *, const struct open_flags *);
 extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
+extern int __close_fd_get_file(unsigned int fd, struct file **res);
 
 long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 int chmod_common(const struct path *path, umode_t mode);


