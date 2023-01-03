Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC4965BBD8
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbjACIQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237026AbjACIP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07149278
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:15:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9FA2B80E56
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1B1C433D2;
        Tue,  3 Jan 2023 08:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733753;
        bh=NinGCVOC9xKRlCNOLVMTHzJOhxCFZn+947TRj4iAUdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVehDNE27QpJvgV9V3YEsR9T1Pt2sxozXsPlYCFq9/TkTAJi3SvVx0VhfWXtLtgHQ
         Kp8/1JP4zPmwMjfxNZy51rqCaEFVZogKNjSqGnK9yOdJYlxwkBVV7st531r6e0o7iv
         quUOdDjd1Nt2CSGEmDFP5XrrGynMvzWTtLjdF0CE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 14/63] fs: provide locked helper variant of close_fd_get_file()
Date:   Tue,  3 Jan 2023 09:13:44 +0100
Message-Id: <20230103081309.418857619@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 53dec2ea74f2ef360e8455439be96a780baa6097 ]

Assumes current->files->file_lock is already held on invocation. Helps
the caller check the file before removing the fd, if it needs to.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
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
@@ -780,36 +782,48 @@ int __close_range(unsigned fd, unsigned
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
@@ -134,6 +134,7 @@ extern struct file *do_file_open_root(st
 		const char *, const struct open_flags *);
 extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
+extern int __close_fd_get_file(unsigned int fd, struct file **res);
 
 long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 int chmod_common(const struct path *path, umode_t mode);


