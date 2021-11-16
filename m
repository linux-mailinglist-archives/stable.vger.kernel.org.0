Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F99C453A56
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240113AbhKPTpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:45:36 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:45300
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239957AbhKPTpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 14:45:34 -0500
Received: from mussarela.. (201-43-193-232.dsl.telesp.net.br [201.43.193.232])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 133DE3F1CB;
        Tue, 16 Nov 2021 19:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637091756;
        bh=GupNkilR37VWVbjHttHkCvmnjtw2i6j40zM4iiXRUZQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=D1Y9VCpBvV8tHG/UxVf32nHZWq1z/0XgtHfhUSDPonVrxa8F3xUC4wPfuCtPjgiio
         BH2wiYl9GLYufWiFw36Zc1zRXPT05iZERfderXhM+83xm9EqU+TwsBmRMraJ9SxVNX
         OydqHKE99uuKv04zDt9zJbpzg1ItDjWYNLDlKdmzohPS4ujKIAXM1teQ+l0HkRvnhk
         +NVFl7oG9g2BBzmFZAXYeB3iwyvS0iKJG9NXA6y1m2WXjdDLmgCxXGlNA3Ky/6eDkd
         OmRxRkKzzVVNBGBF0nALB7AW9QoxB97I6MePkxM4jYPeuioejDM4ZeZCJAEmBY1Vvr
         XwiDlxljMP3lg==
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
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [SRU Hirsute/Impish] vfs: check fd has read access in kernel_read_file_from_fd()
Date:   Tue, 16 Nov 2021 16:42:16 -0300
Message-Id: <20211116194217.481966-2-cascardo@canonical.com>
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
(cherry picked from commit 032146cda85566abcd1c4884d9d23e4e30a07e9a)
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 fs/kernel_read_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/kernel_read_file.c b/fs/kernel_read_file.c
index 90d255fbdd9b..c84d87f558cb 100644
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

