Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E54A433EA2
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 20:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbhJSSly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234909AbhJSSlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABDDD611AE;
        Tue, 19 Oct 2021 18:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668780;
        bh=OScqNCxqOWnwi1WBTEGXdMRJYyt4cLPVAT4Lfj2nitI=;
        h=Date:From:To:Subject:From;
        b=MfyQuM0bsPJvmm4viORliukghw5952AqE6BraJkshsBo7HErQXBIkiSV/gfTQZYgh
         W+oxvJpDc+4MJLGNwT3b5dDdPoKD9wO74DUZ/8a0GHvk/MUJYg0OhtJib0Pe3fAEo0
         /hCKWRhYgUxcn8KRyi/Rmiz04jVAgdIg3EZlFSY4=
Date:   Tue, 19 Oct 2021 11:39:40 -0700
From:   akpm@linux-foundation.org
To:     christian.brauner@ubuntu.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        sunhao.th@gmail.com, viro@zeniv.linux.org.uk, willy@infradead.org,
        zohar@linux.ibm.com
Subject:  [merged]
 vfs-check-fd-has-read-access-in-kernel_read_file_from_fd.patch removed from
 -mm tree
Message-ID: <20211019183940.qCDdqI0sY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: vfs: check fd has read access in kernel_read_file_from_fd()
has been removed from the -mm tree.  Its filename was
     vfs-check-fd-has-read-access-in-kernel_read_file_from_fd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are

mm-move-kvmalloc-related-functions-to-slabh.patch
mm-remove-bogus-vm_bug_on.patch
mm-optimise-put_pages_list.patch
kasan-fix-tag-for-large-allocations-when-using-config_slab.patch

