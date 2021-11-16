Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5B1453A57
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240118AbhKPTpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:45:39 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:45330
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239957AbhKPTpi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 14:45:38 -0500
Received: from mussarela.. (201-43-193-232.dsl.telesp.net.br [201.43.193.232])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 6DFB8419B8;
        Tue, 16 Nov 2021 19:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637091760;
        bh=kzcLOjg5kb6IxTXUpScjR66bWU9pWYlU9H7WOk3tx/A=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=kVwnQp1tWDcIeL3p45+jAHOR5xj+YeQOkEfCx2+Kd6T+S0p+alTZVFmGxuT+6eFT/
         WvSi+9Ow/reSL2Z+g+4ClF3joGmSU4bufxT65P/I0dFF5Rd1mq6HbtoILs22hb61A8
         dnwt15r0DWt80L6zsjrpNSOoHSvLLV68XnhHIqkUxdAw4S56+kdeZsEWo9/itZnOD8
         nXjvpC3GS4197Va0j7ysc2tX/+us/J482VIocB96s2/0w/Vq+pCY7BGmI+W0/hoS3c
         +iPmP7BDHhY2JE0vTY5jJP0xxLsegrgRrUsKASjO9UR8vL/bgsJFX1GJ0i7SYfb1xD
         x5apY399xYhqA==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     kernel-team@lists.ubuntu.com
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Hao Sun <sunhao.th@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [SRU Focal/Bionic] vfs: check fd has read access in kernel_read_file_from_fd()
Date:   Tue, 16 Nov 2021 16:42:17 -0300
Message-Id: <20211116194217.481966-3-cascardo@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211116194217.481966-1-cascardo@canonical.com>
References: <20211116194217.481966-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

BugLink: https://bugs.launchpad.net/bugs/1950644

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
(cherry picked from commit 0f218ba4c8aac7041cd8b81a5a893b0d121e6316 linux-5.4.y)
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index eeba096e8a38..006f7fb40b96 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1000,7 +1000,7 @@ int kernel_read_file_from_fd(int fd, void **buf, loff_t *size, loff_t max_size,
 	struct fd f = fdget(fd);
 	int ret = -EBADF;
 
-	if (!f.file)
+	if (!f.file || !(f.file->f_mode & FMODE_READ))
 		goto out;
 
 	ret = kernel_read_file(f.file, buf, size, max_size, id);
-- 
2.32.0

