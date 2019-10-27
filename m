Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14C1E6888
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbfJ0VaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729627AbfJ0VTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:31 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 230862184C;
        Sun, 27 Oct 2019 21:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211169;
        bh=9acb4oAkh0WGN71y8Jm334a0rqrCESm234EOcS+Qo1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W21DVycSipEeP8ca/mAdjXNlL62oJwRPYKcX/aR3S2WgA2emmnOj651eSr7j04xUf
         2JipFssTTJoEIkPp2BF31YTO0CFqYKldPB9+piXehjhbnYP57tTL2xzqjnjxY3YjTx
         qjP6PYEfsGWK5F0wfLFxijXjx+t2Rc/GdeObp+Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 057/197] Convert filldir[64]() from __put_user() to unsafe_put_user()
Date:   Sun, 27 Oct 2019 21:59:35 +0100
Message-Id: <20191027203354.749614096@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 9f79b78ef74436c7507bac6bfb7b8b989263bccb ]

We really should avoid the "__{get,put}_user()" functions entirely,
because they can easily be mis-used and the original intent of being
used for simple direct user accesses no longer holds in a post-SMAP/PAN
world.

Manually optimizing away the user access range check makes no sense any
more, when the range check is generally much cheaper than the "enable
user accesses" code that the __{get,put}_user() functions still need.

So instead of __put_user(), use the unsafe_put_user() interface with
user_access_{begin,end}() that really does generate better code these
days, and which is generally a nicer interface.  Under some loads, the
multiple user writes that filldir() does are actually quite noticeable.

This also makes the dirent name copy use unsafe_put_user() with a couple
of macros.  We do not want to make function calls with SMAP/PAN
disabled, and the code this generates is quite good when the
architecture uses "asm goto" for unsafe_put_user() like x86 does.

Note that this doesn't bother with the legacy cases.  Nobody should use
them anyway, so performance doesn't really matter there.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/readdir.c | 128 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 93 insertions(+), 35 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 2f6a4534e0dfe..579c8ea894ae3 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -20,9 +20,63 @@
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
 #include <linux/compat.h>
-
 #include <linux/uaccess.h>
 
+#include <asm/unaligned.h>
+
+/*
+ * Note the "unsafe_put_user() semantics: we goto a
+ * label for errors.
+ *
+ * Also note how we use a "while()" loop here, even though
+ * only the biggest size needs to loop. The compiler (well,
+ * at least gcc) is smart enough to turn the smaller sizes
+ * into just if-statements, and this way we don't need to
+ * care whether 'u64' or 'u32' is the biggest size.
+ */
+#define unsafe_copy_loop(dst, src, len, type, label) 		\
+	while (len >= sizeof(type)) {				\
+		unsafe_put_user(get_unaligned((type *)src),	\
+			(type __user *)dst, label);		\
+		dst += sizeof(type);				\
+		src += sizeof(type);				\
+		len -= sizeof(type);				\
+	}
+
+/*
+ * We avoid doing 64-bit copies on 32-bit architectures. They
+ * might be better, but the component names are mostly small,
+ * and the 64-bit cases can end up being much more complex and
+ * put much more register pressure on the code, so it's likely
+ * not worth the pain of unaligned accesses etc.
+ *
+ * So limit the copies to "unsigned long" size. I did verify
+ * that at least the x86-32 case is ok without this limiting,
+ * but I worry about random other legacy 32-bit cases that
+ * might not do as well.
+ */
+#define unsafe_copy_type(dst, src, len, type, label) do {	\
+	if (sizeof(type) <= sizeof(unsigned long))		\
+		unsafe_copy_loop(dst, src, len, type, label);	\
+} while (0)
+
+/*
+ * Copy the dirent name to user space, and NUL-terminate
+ * it. This should not be a function call, since we're doing
+ * the copy inside a "user_access_begin/end()" section.
+ */
+#define unsafe_copy_dirent_name(_dst, _src, _len, label) do {	\
+	char __user *dst = (_dst);				\
+	const char *src = (_src);				\
+	size_t len = (_len);					\
+	unsafe_copy_type(dst, src, len, u64, label);	 	\
+	unsafe_copy_type(dst, src, len, u32, label);		\
+	unsafe_copy_type(dst, src, len, u16, label);		\
+	unsafe_copy_type(dst, src, len, u8,  label);		\
+	unsafe_put_user(0, dst, label);				\
+} while (0)
+
+
 int iterate_dir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
@@ -182,28 +236,31 @@ static int filldir(struct dir_context *ctx, const char *name, int namlen,
 		return -EOVERFLOW;
 	}
 	dirent = buf->previous;
-	if (dirent) {
-		if (signal_pending(current))
-			return -EINTR;
-		if (__put_user(offset, &dirent->d_off))
-			goto efault;
-	}
-	dirent = buf->current_dir;
-	if (__put_user(d_ino, &dirent->d_ino))
-		goto efault;
-	if (__put_user(reclen, &dirent->d_reclen))
-		goto efault;
-	if (copy_to_user(dirent->d_name, name, namlen))
-		goto efault;
-	if (__put_user(0, dirent->d_name + namlen))
-		goto efault;
-	if (__put_user(d_type, (char __user *) dirent + reclen - 1))
+	if (dirent && signal_pending(current))
+		return -EINTR;
+
+	/*
+	 * Note! This range-checks 'previous' (which may be NULL).
+	 * The real range was checked in getdents
+	 */
+	if (!user_access_begin(dirent, sizeof(*dirent)))
 		goto efault;
+	if (dirent)
+		unsafe_put_user(offset, &dirent->d_off, efault_end);
+	dirent = buf->current_dir;
+	unsafe_put_user(d_ino, &dirent->d_ino, efault_end);
+	unsafe_put_user(reclen, &dirent->d_reclen, efault_end);
+	unsafe_put_user(d_type, (char __user *) dirent + reclen - 1, efault_end);
+	unsafe_copy_dirent_name(dirent->d_name, name, namlen, efault_end);
+	user_access_end();
+
 	buf->previous = dirent;
 	dirent = (void __user *)dirent + reclen;
 	buf->current_dir = dirent;
 	buf->count -= reclen;
 	return 0;
+efault_end:
+	user_access_end();
 efault:
 	buf->error = -EFAULT;
 	return -EFAULT;
@@ -263,30 +320,31 @@ static int filldir64(struct dir_context *ctx, const char *name, int namlen,
 	if (reclen > buf->count)
 		return -EINVAL;
 	dirent = buf->previous;
-	if (dirent) {
-		if (signal_pending(current))
-			return -EINTR;
-		if (__put_user(offset, &dirent->d_off))
-			goto efault;
-	}
-	dirent = buf->current_dir;
-	if (__put_user(ino, &dirent->d_ino))
-		goto efault;
-	if (__put_user(0, &dirent->d_off))
-		goto efault;
-	if (__put_user(reclen, &dirent->d_reclen))
-		goto efault;
-	if (__put_user(d_type, &dirent->d_type))
-		goto efault;
-	if (copy_to_user(dirent->d_name, name, namlen))
-		goto efault;
-	if (__put_user(0, dirent->d_name + namlen))
+	if (dirent && signal_pending(current))
+		return -EINTR;
+
+	/*
+	 * Note! This range-checks 'previous' (which may be NULL).
+	 * The real range was checked in getdents
+	 */
+	if (!user_access_begin(dirent, sizeof(*dirent)))
 		goto efault;
+	if (dirent)
+		unsafe_put_user(offset, &dirent->d_off, efault_end);
+	dirent = buf->current_dir;
+	unsafe_put_user(ino, &dirent->d_ino, efault_end);
+	unsafe_put_user(reclen, &dirent->d_reclen, efault_end);
+	unsafe_put_user(d_type, &dirent->d_type, efault_end);
+	unsafe_copy_dirent_name(dirent->d_name, name, namlen, efault_end);
+	user_access_end();
+
 	buf->previous = dirent;
 	dirent = (void __user *)dirent + reclen;
 	buf->current_dir = dirent;
 	buf->count -= reclen;
 	return 0;
+efault_end:
+	user_access_end();
 efault:
 	buf->error = -EFAULT;
 	return -EFAULT;
-- 
2.20.1



