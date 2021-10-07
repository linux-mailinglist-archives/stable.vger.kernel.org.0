Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042D2425FA3
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 00:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241328AbhJGWE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 18:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbhJGWEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 18:04:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92576C061570;
        Thu,  7 Oct 2021 15:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=wU3g/Q5bFjmC/RAMo5fBPaUCFZ25fOmYlGFoJIgvs+M=; b=GZ6EgglK2XeevxRN6kzltXxI4l
        SB+zNBpDfOxFS/o3wdRt1gOWqNXiNEkOvcTYK7vSkneawOK551B91yH560OKlcrXv+IvkMiiIiKko
        /+/yb/qe23IId1TrW7KIt4L7pWpvhWNR+WDDz+KEaKIx0RrJHMma+D7Zf56MeHPZdazEPh3GIMTsq
        r3dgFH4YFw991Ex1GUELN2InzNPn33t5PLJSgdsV7Vv0jthN/Wr3F6tGuPrijljuwAb3Y2el3EHSd
        PBvl9BMxh7jMjWDAk62ayq0eavdGJLg7er9GexDtVC09OsahNFhKOMQlzzLvhNf6gLPUFq7mndl7k
        bdyu0/7A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mYbRz-002W6J-2w; Thu, 07 Oct 2021 22:01:23 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Hao Sun <sunhao.th@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] vfs: Check fd has read access in kernel_read_file_from_fd()
Date:   Thu,  7 Oct 2021 23:01:10 +0100
Message-Id: <20211007220110.600005-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we open a file without read access and then pass the fd to a syscall
whose implementation calls kernel_read_file_from_fd(), we get a warning
from __kernel_read():

        if (WARN_ON_ONCE(!(file->f_mode & FMODE_READ)))

This currently affects both finit_module() and kexec_file_load(), but
it could affect other syscalls in the future.

Reported-by: Hao Sun <sunhao.th@gmail.com>
Fixes: b844f0ecbc56 ("vfs: define kernel_copy_file_from_fd()")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/kernel_read_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/kernel_read_file.c b/fs/kernel_read_file.c
index 87aac4c72c37..1b07550485b9 100644
--- a/fs/kernel_read_file.c
+++ b/fs/kernel_read_file.c
@@ -178,7 +178,7 @@ int kernel_read_file_from_fd(int fd, loff_t offset, void **buf,
 	struct fd f = fdget(fd);
 	int ret = -EBADF;
 
-	if (!f.file)
+	if (!f.file || !(f.file->f_mode & FMODE_READ))
 		goto out;
 
 	ret = kernel_read_file(f.file, offset, buf, buf_size, file_size, id);
-- 
2.32.0

