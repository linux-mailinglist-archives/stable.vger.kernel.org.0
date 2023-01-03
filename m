Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47BC65BBC7
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbjACIPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236992AbjACIPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21C5DF89
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:15:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2930AB80E49
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A28C433EF;
        Tue,  3 Jan 2023 08:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733720;
        bh=IDrKzpD1fxvyoT0AmoVcnuK9z+5K3Sm4S4ew/GbJU3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfQwekgqjAsSz6kDoRMMyLss+B2TredPQ9ZWQbLf9PBD+OwYtImGDZwfnbFuIupKX
         Fgc9b2Jmi0PGaxcQ8oMQ1O8TxRVmvdfKvPAFhzz+F+yfwSZmYAMSJNXypRFrmKycrx
         6fBZCw0k3jlPtBcfdjO6QtzlvUH3+0tU0QNN3XYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.10 13/63] file: Rename __close_fd_get_file close_fd_get_file
Date:   Tue,  3 Jan 2023 09:13:43 +0100
Message-Id: <20230103081309.357832365@linuxfoundation.org>
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

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 9fe83c43e71cdb8e5b9520bcb98706a2b3c680c8 ]

The function close_fd_get_file is explicitly a variant of
__close_fd[1].  Now that __close_fd has been renamed close_fd, rename
close_fd_get_file to be consistent with close_fd.

When __alloc_fd, __close_fd and __fd_install were introduced the
double underscore indicated that the function took a struct
files_struct parameter.  The function __close_fd_get_file never has so
the naming has always been inconsistent.  This just cleans things up
so there are not any lingering mentions or references __close_fd left
in the code.

[1] 80cd795630d6 ("binder: fix use-after-free due to ksys_close() during fdget()")
Link: https://lkml.kernel.org/r/20201120231441.29911-23-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    2 +-
 fs/file.c                |    4 ++--
 fs/io_uring.c            |    2 +-
 include/linux/fdtable.h  |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2255,7 +2255,7 @@ static void binder_deferred_fd_close(int
 	if (!twcb)
 		return;
 	init_task_work(&twcb->twork, binder_do_fd_close);
-	__close_fd_get_file(fd, &twcb->file);
+	close_fd_get_file(fd, &twcb->file);
 	if (twcb->file) {
 		filp_close(twcb->file, current->files);
 		task_work_add(current, &twcb->twork, TWA_RESUME);
--- a/fs/file.c
+++ b/fs/file.c
@@ -780,11 +780,11 @@ int __close_range(unsigned fd, unsigned
 }
 
 /*
- * variant of __close_fd that gets a ref on the file for later fput.
+ * variant of close_fd that gets a ref on the file for later fput.
  * The caller must ensure that filp_close() called on the file, and then
  * an fput().
  */
-int __close_fd_get_file(unsigned int fd, struct file **res)
+int close_fd_get_file(unsigned int fd, struct file **res)
 {
 	struct files_struct *files = current->files;
 	struct file *file;
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4270,7 +4270,7 @@ static int io_close(struct io_kiocb *req
 
 	/* might be already done during nonblock submission */
 	if (!close->put_file) {
-		ret = __close_fd_get_file(close->fd, &close->put_file);
+		ret = close_fd_get_file(close->fd, &close->put_file);
 		if (ret < 0)
 			return (ret == -ENOENT) ? -EBADF : ret;
 	}
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -123,7 +123,7 @@ extern void __fd_install(struct files_st
 extern int __close_fd(struct files_struct *files,
 		      unsigned int fd);
 extern int __close_range(unsigned int fd, unsigned int max_fd, unsigned int flags);
-extern int __close_fd_get_file(unsigned int fd, struct file **res);
+extern int close_fd_get_file(unsigned int fd, struct file **res);
 extern int unshare_fd(unsigned long unshare_flags, unsigned int max_fds,
 		      struct files_struct **new_fdp);
 


