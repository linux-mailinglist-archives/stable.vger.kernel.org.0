Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94856366C6A
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbhDUNRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:17:18 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:30186 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239666AbhDUNOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 09:14:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619010808; x=1650546808;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Y3lJQFkY7OhNxx6rHkrgq18kqGIQr7cXxaUh0AOL81s=;
  b=M9q6Voyo1vonPsYiYrFDDzGyYiyok95YYpFBfV5J0zBsoKhchcO7ui+T
   WEMVwygGT3W9mJibLmSCmCu3acBgUh5qoVPeyE4XLMcCwQtmnpOW9ldqH
   bP1RE6vAUuD8wHcEwkKCf6xdTfMzbF+ycwi+G/TUHK7FJY/o/oVD0Ql9H
   0=;
X-IronPort-AV: E=Sophos;i="5.82,240,1613433600"; 
   d="scan'208";a="120451457"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Apr 2021 13:13:28 +0000
Received: from EX13D01EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 88C09A0598;
        Wed, 21 Apr 2021 13:13:27 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.160.209) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 13:13:25 +0000
Subject: [PATCH 7/8] maccess: rename strncpy_from_unsafe_strict to,
 strncpy_from_kernel_nofault
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Greg KH <greg@kroah.com>
References: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Message-ID: <9239b0c8-50ac-2984-8d3e-e1f097d4bcd5@amazon.com>
Date:   Wed, 21 Apr 2021 16:13:18 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.160.209]
X-ClientProxiedBy: EX13D05UWC002.ant.amazon.com (10.43.162.92) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


commit c4cb164426aebd635baa53685b0ebf1a127e9803 upstream

This matches the naming of strncpy_from_user_nofault, and also makes it
more clear what the function is supposed to do.

conflict resolution: comments in mm/maccess.c

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20200521152301.2587579-8-hch@lst.de
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 5.4
Signed-off-by: Tsahi Zidenberg <tsahee@amazon.com>
---
 arch/x86/mm/maccess.c    |  2 +-
 include/linux/uaccess.h  |  4 ++--
 kernel/trace/bpf_trace.c |  4 ++--
 mm/maccess.c             | 31 +++++++++++++++++++++++++------
 4 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
index f5b85bdc0535..62c4017a2473 100644
--- a/arch/x86/mm/maccess.c
+++ b/arch/x86/mm/maccess.c
@@ -34,7 +34,7 @@ long probe_kernel_read_strict(void *dst, const void *src, size_t size)
     return __probe_kernel_read(dst, src, size);
 }
 
-long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr, long count)
+long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 {
     if (unlikely(invalid_probe_range((unsigned long)unsafe_addr)))
         return -EFAULT;
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 23e655549be2..7c61d3ddae57 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -351,8 +351,8 @@ extern long notrace probe_user_write(void __user *dst, const void *src, size_t s
 extern long notrace __probe_user_write(void __user *dst, const void *src, size_t size);
 
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
-extern long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
-                       long count);
+long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
+        long count);
 extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
         long count);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 720d78c62d05..7b905aa800b2 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -242,7 +242,7 @@ bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr,
      * is returned that can be used for bpf_perf_event_output() et al.
      */
     ret = compat ? strncpy_from_unsafe(dst, unsafe_ptr, size) :
-          strncpy_from_unsafe_strict(dst, unsafe_ptr, size);
+          strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
     if (unlikely(ret < 0))
 out:
         memset(dst, 0, size);
@@ -414,7 +414,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
                 break;
 #endif
             case 'k':
-                strncpy_from_unsafe_strict(buf, unsafe_ptr,
+                strncpy_from_kernel_nofault(buf, unsafe_ptr,
                                sizeof(buf));
                 break;
             case 'u':
diff --git a/mm/maccess.c b/mm/maccess.c
index 84c598673aa9..82863bc6b550 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -167,17 +167,36 @@ EXPORT_SYMBOL_GPL(probe_user_write);
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  *
- * strncpy_from_unsafe_strict() is the same as strncpy_from_unsafe() except
- * for the case where architectures have non-overlapping user and kernel address
- * ranges: strncpy_from_unsafe_strict() will additionally return -EFAULT for
- * probing memory on a user address range where strncpy_from_unsafe_user() is
- * supposed to be used instead.
+ * Same as strncpy_from_kernel_nofault() except that for architectures with
+ * not fully separated user and kernel address spaces this function also works
+ * for user address tanges.
+ *
+ * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
+ * separate kernel and user address spaces, and also a bad idea otherwise.
  */
 
 long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
     __attribute__((alias("__strncpy_from_unsafe")));
 
-long __weak strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
+/**
+ * strncpy_from_kernel_nofault: - Copy a NUL terminated string from unsafe
+ *                 address.
+ * @dst:   Destination address, in kernel space.  This buffer must be at
+ *         least @count bytes long.
+ * @unsafe_addr: Unsafe address.
+ * @count: Maximum number of bytes to copy, including the trailing NUL.
+ *
+ * Copies a NUL-terminated string from unsafe address to kernel buffer.
+ *
+ * On success, returns the length of the string INCLUDING the trailing NUL.
+ *
+ * If access fails, returns -EFAULT (some data may have been copied
+ * and the trailing NUL added).
+ *
+ * If @count is smaller than the length of the string, copies @count-1 bytes,
+ * sets the last byte of @dst buffer to NUL and returns @count.
+ */
+long __weak strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
                        long count)
     __attribute__((alias("__strncpy_from_unsafe")));
 
-- 
2.25.1


