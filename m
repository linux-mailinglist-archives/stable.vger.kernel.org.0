Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6706943A03A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbhJYT32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235318AbhJYT1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:27:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE5DA610FD;
        Mon, 25 Oct 2021 19:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189831;
        bh=hQJPHq4qgyQXrxad6e6ocRLz8J9mShDe681FBv+TYfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njaqvQ6juZubVF72avRRgbl5sfPraEo80CMf4RqkW8F9gO8QEgpQHFscBvThD4+m5
         8ztCy2zBjqdondf1cuU4EVwKrOFFUrwCXsq1ZaUyQh7RnwpSkg2YhOB9KrS7CXcAwm
         pziJT5hcI31CX73Px+0s8znQKJqS4f0Yc6EQkK70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Hao Sun <sunhao.th@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 18/37] vfs: check fd has read access in kernel_read_file_from_fd()
Date:   Mon, 25 Oct 2021 21:14:43 +0200
Message-Id: <20211025190931.974851341@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 032146cda85566abcd1c4884d9d23e4e30a07e9a upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -984,7 +984,7 @@ int kernel_read_file_from_fd(int fd, voi
 	struct fd f = fdget(fd);
 	int ret = -EBADF;
 
-	if (!f.file)
+	if (!f.file || !(f.file->f_mode & FMODE_READ))
 		goto out;
 
 	ret = kernel_read_file(f.file, buf, size, max_size, id);


