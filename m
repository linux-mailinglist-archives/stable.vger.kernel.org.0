Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1285FE6865
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731528AbfJ0VTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731519AbfJ0VTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:41 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 322B5208C0;
        Sun, 27 Oct 2019 21:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211180;
        bh=BCr0QfKQ3lh2576nVaxgawXfWpPaIw9HHUMDjYub6tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruuC34rDvOuukrDJmjp7A+JhmGBJh1zeQbzQAItRtwfCWYLwiyz8OzLKSdKapDOD6
         AD2Id0PNRczNGZZO0MMdnjgL+2caegLhxCjM48QXdKavmTt6TK8szjM3r+yL18wrPb
         ApwltQnNqqotph5AoNqb/jcaPrcgZe7vLp+5CosI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.3 060/197] uaccess: implement a proper unsafe_copy_to_user() and switch filldir over to it
Date:   Sun, 27 Oct 2019 21:59:38 +0100
Message-Id: <20191027203354.909493306@linuxfoundation.org>
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

[ Upstream commit c512c69187197fe08026cb5bbe7b9709f4f89b73 ]

In commit 9f79b78ef744 ("Convert filldir[64]() from __put_user() to
unsafe_put_user()") I made filldir() use unsafe_put_user(), which
improves code generation on x86 enormously.

But because we didn't have a "unsafe_copy_to_user()", the dirent name
copy was also done by hand with unsafe_put_user() in a loop, and it
turns out that a lot of other architectures didn't like that, because
unlike x86, they have various alignment issues.

Most non-x86 architectures trap and fix it up, and some (like xtensa)
will just fail unaligned put_user() accesses unconditionally.  Which
makes that "copy using put_user() in a loop" not work for them at all.

I could make that code do explicit alignment etc, but the architectures
that don't like unaligned accesses also don't really use the fancy
"user_access_begin/end()" model, so they might just use the regular old
__copy_to_user() interface.

So this commit takes that looping implementation, turns it into the x86
version of "unsafe_copy_to_user()", and makes other architectures
implement the unsafe copy version as __copy_to_user() (the same way they
do for the other unsafe_xyz() accessor functions).

Note that it only does this for the copying _to_ user space, and we
still don't have a unsafe version of copy_from_user().

That's partly because we have no current users of it, but also partly
because the copy_from_user() case is slightly different and cannot
efficiently be implemented in terms of a unsafe_get_user() loop (because
gcc can't do asm goto with outputs).

It would be trivial to do this using "rep movsb", which would work
really nicely on newer x86 cores, but really badly on some older ones.

Al Viro is looking at cleaning up all our user copy routines to make
this all a non-issue, but for now we have this simple-but-stupid version
for x86 that works fine for the dirent name copy case because those
names are short strings and we simply don't need anything fancier.

Fixes: 9f79b78ef744 ("Convert filldir[64]() from __put_user() to unsafe_put_user()")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Reported-and-tested-by: Tony Luck <tony.luck@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/uaccess.h | 23 ++++++++++++++++++
 fs/readdir.c                   | 44 ++--------------------------------
 include/linux/uaccess.h        |  6 +++--
 3 files changed, 29 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 35c225ede0e4f..61d93f062a36e 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -734,5 +734,28 @@ do {										\
 	if (unlikely(__gu_err)) goto err_label;					\
 } while (0)
 
+/*
+ * We want the unsafe accessors to always be inlined and use
+ * the error labels - thus the macro games.
+ */
+#define unsafe_copy_loop(dst, src, len, type, label)			\
+	while (len >= sizeof(type)) {					\
+		unsafe_put_user(*(type *)src,(type __user *)dst,label);	\
+		dst += sizeof(type);					\
+		src += sizeof(type);					\
+		len -= sizeof(type);					\
+	}
+
+#define unsafe_copy_to_user(_dst,_src,_len,label)			\
+do {									\
+	char __user *__ucu_dst = (_dst);				\
+	const char *__ucu_src = (_src);					\
+	size_t __ucu_len = (_len);					\
+	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
+	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
+	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
+	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
+} while (0)
+
 #endif /* _ASM_X86_UACCESS_H */
 
diff --git a/fs/readdir.c b/fs/readdir.c
index 19bea591c3f1d..6e2623e57b2e8 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -27,53 +27,13 @@
 /*
  * Note the "unsafe_put_user() semantics: we goto a
  * label for errors.
- *
- * Also note how we use a "while()" loop here, even though
- * only the biggest size needs to loop. The compiler (well,
- * at least gcc) is smart enough to turn the smaller sizes
- * into just if-statements, and this way we don't need to
- * care whether 'u64' or 'u32' is the biggest size.
- */
-#define unsafe_copy_loop(dst, src, len, type, label) 		\
-	while (len >= sizeof(type)) {				\
-		unsafe_put_user(get_unaligned((type *)src),	\
-			(type __user *)dst, label);		\
-		dst += sizeof(type);				\
-		src += sizeof(type);				\
-		len -= sizeof(type);				\
-	}
-
-/*
- * We avoid doing 64-bit copies on 32-bit architectures. They
- * might be better, but the component names are mostly small,
- * and the 64-bit cases can end up being much more complex and
- * put much more register pressure on the code, so it's likely
- * not worth the pain of unaligned accesses etc.
- *
- * So limit the copies to "unsigned long" size. I did verify
- * that at least the x86-32 case is ok without this limiting,
- * but I worry about random other legacy 32-bit cases that
- * might not do as well.
- */
-#define unsafe_copy_type(dst, src, len, type, label) do {	\
-	if (sizeof(type) <= sizeof(unsigned long))		\
-		unsafe_copy_loop(dst, src, len, type, label);	\
-} while (0)
-
-/*
- * Copy the dirent name to user space, and NUL-terminate
- * it. This should not be a function call, since we're doing
- * the copy inside a "user_access_begin/end()" section.
  */
 #define unsafe_copy_dirent_name(_dst, _src, _len, label) do {	\
 	char __user *dst = (_dst);				\
 	const char *src = (_src);				\
 	size_t len = (_len);					\
-	unsafe_copy_type(dst, src, len, u64, label);	 	\
-	unsafe_copy_type(dst, src, len, u32, label);		\
-	unsafe_copy_type(dst, src, len, u16, label);		\
-	unsafe_copy_type(dst, src, len, u8,  label);		\
-	unsafe_put_user(0, dst, label);				\
+	unsafe_put_user(0, dst+len, label);			\
+	unsafe_copy_to_user(dst, src, len, label);		\
 } while (0)
 
 
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 34a038563d979..d38051dd414fd 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -284,8 +284,10 @@ extern long strnlen_unsafe_user(const void __user *unsafe_addr, long count);
 #ifndef user_access_begin
 #define user_access_begin(ptr,len) access_ok(ptr, len)
 #define user_access_end() do { } while (0)
-#define unsafe_get_user(x, ptr, err) do { if (unlikely(__get_user(x, ptr))) goto err; } while (0)
-#define unsafe_put_user(x, ptr, err) do { if (unlikely(__put_user(x, ptr))) goto err; } while (0)
+#define unsafe_op_wrap(op, err) do { if (unlikely(op)) goto err; } while (0)
+#define unsafe_get_user(x,p,e) unsafe_op_wrap(__get_user(x,p),e)
+#define unsafe_put_user(x,p,e) unsafe_op_wrap(__put_user(x,p),e)
+#define unsafe_copy_to_user(d,s,l,e) unsafe_op_wrap(__copy_to_user(d,s,l),e)
 static inline unsigned long user_access_save(void) { return 0UL; }
 static inline void user_access_restore(unsigned long flags) { }
 #endif
-- 
2.20.1



