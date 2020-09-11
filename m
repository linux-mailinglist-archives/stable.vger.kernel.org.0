Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD5526669E
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgIKRaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:30:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgIKM5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:57:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B8F52224C;
        Fri, 11 Sep 2020 12:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828915;
        bh=Uwbfi8W/Cl7IDwfcCRT5yuJmKg1LKpGoXBrox13rh+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yi3GgI6ma5pdTLb7J2HbuMUK9zcmsAxlbXgf9Z8/Er4WZSpBvD5mr1rzQ/sF6/0Lz
         dUssWO/HkV7w2/23QC1IS3O1/I6JhhOvSkFlPr1U7DyvxhzsxnaC08l9FRlOwGpXIz
         o3XnkGH5mt1eYqlpJpw83TRefoi76wbu2uSPgj5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 27/62] uaccess: Add non-pagefault user-space write function
Date:   Fri, 11 Sep 2020 14:46:10 +0200
Message-Id: <20200911122503.743743910@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 1d1585ca0f48fe7ed95c3571f3e4a82b2b5045dc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/uaccess.h | 12 +++++++++++
 mm/maccess.c            | 45 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index b9e538176349c..c82dcea216b15 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -113,6 +113,18 @@ extern long probe_user_read(void *dst, const void __user *src, size_t size);
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
diff --git a/mm/maccess.c b/mm/maccess.c
index 78add1654b41a..18717e893a758 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -17,6 +17,18 @@ probe_read_common(void *dst, const void __user *src, size_t size)
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
@@ -84,6 +96,7 @@ EXPORT_SYMBOL_GPL(probe_user_read);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
+
 long __weak probe_kernel_write(void *dst, const void *src, size_t size)
     __attribute__((alias("__probe_kernel_write")));
 
@@ -93,15 +106,39 @@ long __probe_kernel_write(void *dst, const void *src, size_t size)
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
+	if (access_ok(VERIFY_WRITE, dst, size))
+		ret = probe_write_common(dst, src, size);
+	set_fs(old_fs);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(probe_user_write);
 
 /**
  * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.
-- 
2.25.1



