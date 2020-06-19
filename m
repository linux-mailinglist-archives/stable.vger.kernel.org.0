Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7573201791
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388782AbgFSQkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388772AbgFSOpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:45:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C46021556;
        Fri, 19 Jun 2020 14:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577954;
        bh=qYHsVPLeJyJtI5aSyfx39wYG2ZSr8ZIZm0DUZYpNNs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDGY3Ew8y5zQRdZlo2kWOVxhxnMCN55I29yjgTIq3F1bbsbrCQXJS/HWfk+ItTEQl
         Dse5XUWTXG4z8HWIcSXysQR5xCFRLktTy3E7zWV5RobmybdG0OZF6U6GLdMrgKfLzw
         /IQu8tEAqpwD2qvvVziVMGphCB1mQaUeRq9b5+XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miles Chen <miles.chen@mediatek.com>
Subject: [PATCH 4.14 003/190] make user_access_begin() do access_ok()
Date:   Fri, 19 Jun 2020 16:30:48 +0200
Message-Id: <20200619141633.635178494@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 594cc251fdd0d231d342d88b2fdff4bc42fb0690 upstream.

Originally, the rule used to be that you'd have to do access_ok()
separately, and then user_access_begin() before actually doing the
direct (optimized) user access.

But experience has shown that people then decide not to do access_ok()
at all, and instead rely on it being implied by other operations or
similar.  Which makes it very hard to verify that the access has
actually been range-checked.

If you use the unsafe direct user accesses, hardware features (either
SMAP - Supervisor Mode Access Protection - on x86, or PAN - Privileged
Access Never - on ARM) do force you to use user_access_begin().  But
nothing really forces the range check.

By putting the range check into user_access_begin(), we actually force
people to do the right thing (tm), and the range check vill be visible
near the actual accesses.  We have way too long a history of people
trying to avoid them.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/uaccess.h             |   12 +++++++++++-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   17 +++++++++++++++--
 include/linux/uaccess.h                    |    2 +-
 kernel/compat.c                            |    6 ++----
 kernel/exit.c                              |    6 ++----
 lib/strncpy_from_user.c                    |    9 +++++----
 lib/strnlen_user.c                         |    9 +++++----
 7 files changed, 41 insertions(+), 20 deletions(-)

--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -711,7 +711,17 @@ extern struct movsl_mask {
  * checking before using them, but you have to surround them with the
  * user_access_begin/end() pair.
  */
-#define user_access_begin()	__uaccess_begin()
+static __must_check inline bool user_access_begin(int type,
+						  const void __user *ptr,
+						  size_t len)
+{
+	if (unlikely(!access_ok(type, ptr, len)))
+		return 0;
+	__uaccess_begin();
+	return 1;
+}
+
+#define user_access_begin(a, b, c)	user_access_begin(a, b, c)
 #define user_access_end()	__uaccess_end()
 
 #define unsafe_put_user(x, ptr, err_label)					\
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1566,7 +1566,9 @@ static int eb_copy_relocations(const str
 		 * happened we would make the mistake of assuming that the
 		 * relocations were valid.
 		 */
-		user_access_begin();
+		if (!user_access_begin(VERIFY_WRITE, urelocs, size))
+			goto end_user;
+
 		for (copied = 0; copied < nreloc; copied++)
 			unsafe_put_user(-1,
 					&urelocs[copied].presumed_offset,
@@ -2601,6 +2603,7 @@ i915_gem_execbuffer2(struct drm_device *
 	struct drm_i915_gem_execbuffer2 *args = data;
 	struct drm_i915_gem_exec_object2 *exec2_list;
 	struct drm_syncobj **fences = NULL;
+	const size_t count = args->buffer_count;
 	int err;
 
 	if (args->buffer_count < 1 || args->buffer_count > SIZE_MAX / sz - 1) {
@@ -2649,7 +2652,17 @@ i915_gem_execbuffer2(struct drm_device *
 		unsigned int i;
 
 		/* Copy the new buffer offsets back to the user's exec list. */
-		user_access_begin();
+		/*
+		 * Note: count * sizeof(*user_exec_list) does not overflow,
+		 * because we checked 'count' in check_buffer_count().
+		 *
+		 * And this range already got effectively checked earlier
+		 * when we did the "copy_from_user()" above.
+		 */
+		if (!user_access_begin(VERIFY_WRITE, user_exec_list,
+				       count * sizeof(*user_exec_list)))
+			goto end_user;
+
 		for (i = 0; i < args->buffer_count; i++) {
 			if (!(exec2_list[i].offset & UPDATE))
 				continue;
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -267,7 +267,7 @@ extern long strncpy_from_unsafe(char *ds
 	probe_kernel_read(&retval, addr, sizeof(retval))
 
 #ifndef user_access_begin
-#define user_access_begin() do { } while (0)
+#define user_access_begin(type, ptr, len) access_ok(type, ptr, len)
 #define user_access_end() do { } while (0)
 #define unsafe_get_user(x, ptr, err) do { if (unlikely(__get_user(x, ptr))) goto err; } while (0)
 #define unsafe_put_user(x, ptr, err) do { if (unlikely(__put_user(x, ptr))) goto err; } while (0)
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -437,10 +437,9 @@ long compat_get_bitmap(unsigned long *ma
 	bitmap_size = ALIGN(bitmap_size, BITS_PER_COMPAT_LONG);
 	nr_compat_longs = BITS_TO_COMPAT_LONGS(bitmap_size);
 
-	if (!access_ok(VERIFY_READ, umask, bitmap_size / 8))
+	if (!user_access_begin(VERIFY_READ, umask, bitmap_size / 8))
 		return -EFAULT;
 
-	user_access_begin();
 	while (nr_compat_longs > 1) {
 		compat_ulong_t l1, l2;
 		unsafe_get_user(l1, umask++, Efault);
@@ -467,10 +466,9 @@ long compat_put_bitmap(compat_ulong_t __
 	bitmap_size = ALIGN(bitmap_size, BITS_PER_COMPAT_LONG);
 	nr_compat_longs = BITS_TO_COMPAT_LONGS(bitmap_size);
 
-	if (!access_ok(VERIFY_WRITE, umask, bitmap_size / 8))
+	if (!user_access_begin(VERIFY_WRITE, umask, bitmap_size / 8))
 		return -EFAULT;
 
-	user_access_begin();
 	while (nr_compat_longs > 1) {
 		unsigned long m = *mask++;
 		unsafe_put_user((compat_ulong_t)m, umask++, Efault);
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1597,10 +1597,9 @@ SYSCALL_DEFINE5(waitid, int, which, pid_
 	if (!infop)
 		return err;
 
-	if (!access_ok(VERIFY_WRITE, infop, sizeof(*infop)))
+	if (!user_access_begin(VERIFY_WRITE, infop, sizeof(*infop)))
 		return -EFAULT;
 
-	user_access_begin();
 	unsafe_put_user(signo, &infop->si_signo, Efault);
 	unsafe_put_user(0, &infop->si_errno, Efault);
 	unsafe_put_user(info.cause, &infop->si_code, Efault);
@@ -1725,10 +1724,9 @@ COMPAT_SYSCALL_DEFINE5(waitid,
 	if (!infop)
 		return err;
 
-	if (!access_ok(VERIFY_WRITE, infop, sizeof(*infop)))
+	if (!user_access_begin(VERIFY_WRITE, infop, sizeof(*infop)))
 		return -EFAULT;
 
-	user_access_begin();
 	unsafe_put_user(signo, &infop->si_signo, Efault);
 	unsafe_put_user(0, &infop->si_errno, Efault);
 	unsafe_put_user(info.cause, &infop->si_code, Efault);
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -115,10 +115,11 @@ long strncpy_from_user(char *dst, const
 
 		kasan_check_write(dst, count);
 		check_object_size(dst, count, false);
-		user_access_begin();
-		retval = do_strncpy_from_user(dst, src, count, max);
-		user_access_end();
-		return retval;
+		if (user_access_begin(VERIFY_READ, src, max)) {
+			retval = do_strncpy_from_user(dst, src, count, max);
+			user_access_end();
+			return retval;
+		}
 	}
 	return -EFAULT;
 }
--- a/lib/strnlen_user.c
+++ b/lib/strnlen_user.c
@@ -114,10 +114,11 @@ long strnlen_user(const char __user *str
 		unsigned long max = max_addr - src_addr;
 		long retval;
 
-		user_access_begin();
-		retval = do_strnlen_user(str, count, max);
-		user_access_end();
-		return retval;
+		if (user_access_begin(VERIFY_READ, str, max)) {
+			retval = do_strnlen_user(str, count, max);
+			user_access_end();
+			return retval;
+		}
 	}
 	return 0;
 }


