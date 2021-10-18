Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C54A4329AB
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 00:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhJRWS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 18:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229790AbhJRWSZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 18:18:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 336026112D;
        Mon, 18 Oct 2021 22:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595373;
        bh=Wj4LSQ5SnZUVixO5M1QY3f7xKJYPQktCc54fJQ6BKFA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TM/OwVr7Z1a5OYnT6ttA9P2a77OzWqDwuqEND8jk1JKg56H7HvpjZ/tTtkyeKVItx
         IrsuYj/2qhRlRTXQoHbOv1YZIq6GpfFwleSK15Ukq0AWTTmuuy9T5/zunRNGg4vhyg
         I5htCzccBxwpgUBol9fZGJSd974lnMTTZhFudHF0=
Date:   Mon, 18 Oct 2021 15:16:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christian.brauner@ubuntu.com,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        sunhao.th@gmail.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, willy@infradead.org, zohar@linux.ibm.com
Subject:  [patch 16/19] vfs: check fd has read access in
 kernel_read_file_from_fd()
Message-ID: <20211018221612.hYn1e83d3%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vfs: check fd has read access in kernel_read_file_from_fd()

If we open a file without read access and then pass the fd to a syscall
whose implementation calls kernel_read_file_from_fd(), we get a warning
from __kernel_read():

        if (WARN_ON_ONCE(!(file->f_mode & FMODE_READ)))

This currently affects both finit_module() and kexec_file_load(), but it
could affect other syscalls in the future.

Link: https://lkml.kernel.org/r/20211007220110.600005-1-willy@infradead.org
Fixes: b844f0ecbc56 ("vfs: define kernel_copy_file_from_fd()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Hao Sun <sunhao.th@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/kernel_read_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/kernel_read_file.c~vfs-check-fd-has-read-access-in-kernel_read_file_from_fd
+++ a/fs/kernel_read_file.c
@@ -178,7 +178,7 @@ int kernel_read_file_from_fd(int fd, lof
 	struct fd f = fdget(fd);
 	int ret = -EBADF;
 
-	if (!f.file)
+	if (!f.file || !(f.file->f_mode & FMODE_READ))
 		goto out;
 
 	ret = kernel_read_file(f.file, offset, buf, buf_size, file_size, id);
_
