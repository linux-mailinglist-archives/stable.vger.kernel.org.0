Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F83266040
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 15:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgIKN1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 09:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgIKNXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:23:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ACD222206;
        Fri, 11 Sep 2020 12:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829084;
        bh=JRFEEvBxHZ+5UW2JKOAE2P9aPjPgyywFcRup8jy2KJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Wyejw2GXK3hjUZMz2wP4g8nqP7H9FPv5v0e85aJbVs2QYDYRjE1n9DWEeu2TpaPL
         1uxWz13fbZcmKEO27O4ARmJG17DNUlL/BmJZUOrDt0rDnIz2L6H94BlUz0fc2Mk586
         Jq0B8rkFAtYH9tuGQA/xd2cpoBTIWuDvzMxrE5nI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 33/71] uaccess: Add non-pagefault user-space read functions
Date:   Fri, 11 Sep 2020 14:46:17 +0200
Message-Id: <20200911122506.583167246@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 3d7081822f7f9eab867d9bcc8fd635208ec438e0 ]

Add probe_user_read(), strncpy_from_unsafe_user() and
strnlen_unsafe_user() which allows caller to access user-space
in IRQ context.

Current probe_kernel_read() and strncpy_from_unsafe() are
not available for user-space memory, because it sets
KERNEL_DS while accessing data. On some arch, user address
space and kernel address space can be co-exist, but others
can not. In that case, setting KERNEL_DS means given
address is treated as a kernel address space.
Also strnlen_user() is only available from user context since
it can sleep if pagefault is enabled.

To access user-space memory without pagefault, we need
these new functions which sets USER_DS while accessing
the data.

Link: http://lkml.kernel.org/r/155789869802.26965.4940338412595759063.stgit@devnote2

Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/uaccess.h |  14 +++++
 mm/maccess.c            | 122 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 130 insertions(+), 6 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 9442423979c1c..6d27d58ca4e04 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -90,6 +90,17 @@ static inline unsigned long __copy_from_user_nocache(void *to,
 extern long probe_kernel_read(void *dst, const void *src, size_t size);
 extern long __probe_kernel_read(void *dst, const void *src, size_t size);
 
+/*
+ * probe_user_read(): safely attempt to read from a location in user space
+ * @dst: pointer to the buffer that shall take the data
+ * @src: address to read from
+ * @size: size of the data chunk
+ *
+ * Safely read from address @src to the buffer at @dst.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+extern long probe_user_read(void *dst, const void __user *src, size_t size);
+
 /*
  * probe_kernel_write(): safely attempt to write to a location
  * @dst: address to write to
@@ -103,6 +114,9 @@ extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
 extern long notrace __probe_kernel_write(void *dst, const void *src, size_t size);
 
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
+extern long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
+				     long count);
+extern long strnlen_unsafe_user(const void __user *unsafe_addr, long count);
 
 /**
  * probe_kernel_address(): safely attempt to read from a location
diff --git a/mm/maccess.c b/mm/maccess.c
index 78f9274dd49d0..5ebf9a3ca3674 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -5,8 +5,20 @@
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 
+static __always_inline long
+probe_read_common(void *dst, const void __user *src, size_t size)
+{
+	long ret;
+
+	pagefault_disable();
+	ret = __copy_from_user_inatomic(dst, src, size);
+	pagefault_enable();
+
+	return ret ? -EFAULT : 0;
+}
+
 /**
- * probe_kernel_read(): safely attempt to read from a location
+ * probe_kernel_read(): safely attempt to read from a kernel-space location
  * @dst: pointer to the buffer that shall take the data
  * @src: address to read from
  * @size: size of the data chunk
@@ -29,16 +41,40 @@ long __probe_kernel_read(void *dst, const void *src, size_t size)
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(KERNEL_DS);
-	pagefault_disable();
-	ret = __copy_from_user_inatomic(dst,
-			(__force const void __user *)src, size);
-	pagefault_enable();
+	ret = probe_read_common(dst, (__force const void __user *)src, size);
 	set_fs(old_fs);
 
-	return ret ? -EFAULT : 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(probe_kernel_read);
 
+/**
+ * probe_user_read(): safely attempt to read from a user-space location
+ * @dst: pointer to the buffer that shall take the data
+ * @src: address to read from. This must be a user address.
+ * @size: size of the data chunk
+ *
+ * Safely read from user address @src to the buffer at @dst. If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+
+long __weak probe_user_read(void *dst, const void __user *src, size_t size)
+    __attribute__((alias("__probe_user_read")));
+
+long __probe_user_read(void *dst, const void __user *src, size_t size)
+{
+	long ret = -EFAULT;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(USER_DS);
+	if (access_ok(VERIFY_READ, src, size))
+		ret = probe_read_common(dst, src, size);
+	set_fs(old_fs);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(probe_user_read);
+
 /**
  * probe_kernel_write(): safely attempt to write to a location
  * @dst: address to write to
@@ -66,6 +102,7 @@ long __probe_kernel_write(void *dst, const void *src, size_t size)
 }
 EXPORT_SYMBOL_GPL(probe_kernel_write);
 
+
 /**
  * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.
  * @dst:   Destination address, in kernel space.  This buffer must be at
@@ -105,3 +142,76 @@ long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
 
 	return ret ? -EFAULT : src - unsafe_addr;
 }
+
+/**
+ * strncpy_from_unsafe_user: - Copy a NUL terminated string from unsafe user
+ *				address.
+ * @dst:   Destination address, in kernel space.  This buffer must be at
+ *         least @count bytes long.
+ * @unsafe_addr: Unsafe user address.
+ * @count: Maximum number of bytes to copy, including the trailing NUL.
+ *
+ * Copies a NUL-terminated string from unsafe user address to kernel buffer.
+ *
+ * On success, returns the length of the string INCLUDING the trailing NUL.
+ *
+ * If access fails, returns -EFAULT (some data may have been copied
+ * and the trailing NUL added).
+ *
+ * If @count is smaller than the length of the string, copies @count-1 bytes,
+ * sets the last byte of @dst buffer to NUL and returns @count.
+ */
+long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
+			      long count)
+{
+	mm_segment_t old_fs = get_fs();
+	long ret;
+
+	if (unlikely(count <= 0))
+		return 0;
+
+	set_fs(USER_DS);
+	pagefault_disable();
+	ret = strncpy_from_user(dst, unsafe_addr, count);
+	pagefault_enable();
+	set_fs(old_fs);
+
+	if (ret >= count) {
+		ret = count;
+		dst[ret - 1] = '\0';
+	} else if (ret > 0) {
+		ret++;
+	}
+
+	return ret;
+}
+
+/**
+ * strnlen_unsafe_user: - Get the size of a user string INCLUDING final NUL.
+ * @unsafe_addr: The string to measure.
+ * @count: Maximum count (including NUL)
+ *
+ * Get the size of a NUL-terminated string in user space without pagefault.
+ *
+ * Returns the size of the string INCLUDING the terminating NUL.
+ *
+ * If the string is too long, returns a number larger than @count. User
+ * has to check the return value against "> count".
+ * On exception (or invalid count), returns 0.
+ *
+ * Unlike strnlen_user, this can be used from IRQ handler etc. because
+ * it disables pagefaults.
+ */
+long strnlen_unsafe_user(const void __user *unsafe_addr, long count)
+{
+	mm_segment_t old_fs = get_fs();
+	int ret;
+
+	set_fs(USER_DS);
+	pagefault_disable();
+	ret = strnlen_user(unsafe_addr, count);
+	pagefault_enable();
+	set_fs(old_fs);
+
+	return ret;
+}
-- 
2.25.1



