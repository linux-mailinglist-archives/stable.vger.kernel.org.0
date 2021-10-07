Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B95426042
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 01:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhJGXPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 19:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233133AbhJGXPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 19:15:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC98C61212;
        Thu,  7 Oct 2021 23:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633648404;
        bh=kmg5vcQlK9/G5lvRhCDWhfUU1nTblXYM7AsOwThfvOs=;
        h=Date:From:To:Subject:From;
        b=Reh5uARHfp+hXXDcLdD0FBlRELjEQep1r87Fy6lcfYjc+AK6+uw0DQK8u39ZMjVgl
         LrALjlQNdZDEmYbv7rJGkt3FUiKb52PbdtCDXU1SsarP1cX/1XWlBCJW02JoYXa27j
         AVThLiZPU2PHts992ps5un8kiq62LrODm2uqxh4U=
Date:   Thu, 07 Oct 2021 16:13:23 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, sunhao.th@gmail.com,
        viro@zeniv.linux.org.uk, willy@infradead.org, zohar@linux.ibm.com
Subject:  +
 vfs-check-fd-has-read-access-in-kernel_read_file_from_fd.patch added to -mm
 tree
Message-ID: <20211007231323.DvjVgT6QM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: vfs: check fd has read access in kernel_read_file_from_fd()
has been added to the -mm tree.  Its filename is
     vfs-check-fd-has-read-access-in-kernel_read_file_from_fd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vfs-check-fd-has-read-access-in-kernel_read_file_from_fd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vfs-check-fd-has-read-access-in-kernel_read_file_from_fd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Kees Cook <keescook@chromium.org>
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

vfs-check-fd-has-read-access-in-kernel_read_file_from_fd.patch
mm-move-kvmalloc-related-functions-to-slabh.patch
mm-remove-bogus-vm_bug_on.patch
mm-optimise-put_pages_list.patch
kasan-fix-tag-for-large-allocations-when-using-config_slab.patch

