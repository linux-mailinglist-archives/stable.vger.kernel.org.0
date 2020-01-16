Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1394813FFE5
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389680AbgAPXWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:22:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730651AbgAPXWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39E162072E;
        Thu, 16 Jan 2020 23:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216927;
        bh=77j/H3NJgU6yfAere1pTVjCPlRELhyyyD9Ei5/o5tXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUBo6J0fS03tLkG5imzuURdjwDS5wUTXzK+dn9dO7dwagr2DCyi+XNaF30U0syfuX
         YAM1I8fgwpsqA8mz2fPxV+EMMyRuAstz05WEQvIOgxPJVQiO1ByhjyUCyvBCFViTF8
         H9YRPIrlasVtUT13fgREHJxfN+bq4CTPmBSWBS4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH 5.4 077/203] uaccess: Add non-pagefault user-space write function
Date:   Fri, 17 Jan 2020 00:16:34 +0100
Message-Id: <20200116231751.126349691@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 1d1585ca0f48fe7ed95c3571f3e4a82b2b5045dc upstream.

Commit 3d7081822f7f ("uaccess: Add non-pagefault user-space read functions")
missed to add probe write function, therefore factor out a probe_write_common()
helper with most logic of probe_kernel_write() except setting KERNEL_DS, and
add a new probe_user_write() helper so it can be used from BPF side.

Again, on some archs, the user address space and kernel address space can
co-exist and be overlapping, so in such case, setting KERNEL_DS would mean
that the given address is treated as being in kernel address space.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/bpf/9df2542e68141bfa3addde631441ee45503856a8.1572649915.git.daniel@iogearbox.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/uaccess.h |   12 ++++++++++++
 mm/maccess.c            |   45 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 53 insertions(+), 4 deletions(-)

--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -337,6 +337,18 @@ extern long __probe_user_read(void *dst,
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
 extern long notrace __probe_kernel_write(void *dst, const void *src, size_t size);
 
+/*
+ * probe_user_write(): safely attempt to write to a location in user space
+ * @dst: address to write to
+ * @src: pointer to the data that shall be written
+ * @size: size of the data chunk
+ *
+ * Safely write to address @dst from the buffer at @src.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
+extern long notrace __probe_user_write(void __user *dst, const void *src, size_t size);
+
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 extern long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
 				     long count);
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -18,6 +18,18 @@ probe_read_common(void *dst, const void
 	return ret ? -EFAULT : 0;
 }
 
+static __always_inline long
+probe_write_common(void __user *dst, const void *src, size_t size)
+{
+	long ret;
+
+	pagefault_disable();
+	ret = __copy_to_user_inatomic(dst, src, size);
+	pagefault_enable();
+
+	return ret ? -EFAULT : 0;
+}
+
 /**
  * probe_kernel_read(): safely attempt to read from a kernel-space location
  * @dst: pointer to the buffer that shall take the data
@@ -85,6 +97,7 @@ EXPORT_SYMBOL_GPL(probe_user_read);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
+
 long __weak probe_kernel_write(void *dst, const void *src, size_t size)
     __attribute__((alias("__probe_kernel_write")));
 
@@ -94,15 +107,39 @@ long __probe_kernel_write(void *dst, con
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(KERNEL_DS);
-	pagefault_disable();
-	ret = __copy_to_user_inatomic((__force void __user *)dst, src, size);
-	pagefault_enable();
+	ret = probe_write_common((__force void __user *)dst, src, size);
 	set_fs(old_fs);
 
-	return ret ? -EFAULT : 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(probe_kernel_write);
 
+/**
+ * probe_user_write(): safely attempt to write to a user-space location
+ * @dst: address to write to
+ * @src: pointer to the data that shall be written
+ * @size: size of the data chunk
+ *
+ * Safely write to address @dst from the buffer at @src.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+
+long __weak probe_user_write(void __user *dst, const void *src, size_t size)
+    __attribute__((alias("__probe_user_write")));
+
+long __probe_user_write(void __user *dst, const void *src, size_t size)
+{
+	long ret = -EFAULT;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(USER_DS);
+	if (access_ok(dst, size))
+		ret = probe_write_common(dst, src, size);
+	set_fs(old_fs);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(probe_user_write);
 
 /**
  * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.


