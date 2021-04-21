Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786AC366C6B
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241083AbhDUNRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:17:18 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:28794 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241647AbhDUNM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 09:12:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619010745; x=1650546745;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=zvmE2SQD2EUaZ6X04lwfy22RFgve7HWJGYg0gUkcLrI=;
  b=aIDfj1HudnFxyMr/OQDz7CaHnfbqfVPRi+DoposeMs8vcxDZfPM7fGiV
   QhAE/CSlcM6ZaRAiW8RQOtOMM+5hP7Kvh+6YeR9osxn3f/8MAZUpa0H7a
   WNkZRWtHmV8sjp+mCPtlsUlpsOSsweeZKHZRXSbcHKk0aHh1xjvJtZd86
   I=;
X-IronPort-AV: E=Sophos;i="5.82,240,1613433600"; 
   d="scan'208";a="120451172"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Apr 2021 13:12:23 +0000
Received: from EX13D01EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id CCBDEA20EF;
        Wed, 21 Apr 2021 13:12:22 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.160.209) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 13:12:20 +0000
Subject: [PATCH 6/8] maccess: rename strncpy_from_unsafe_user to,
 strncpy_from_user_nofault
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Greg KH <greg@kroah.com>
References: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Message-ID: <f2af09dc-a7eb-1459-e27d-139d0fd0b682@amazon.com>
Date:   Wed, 21 Apr 2021 16:12:14 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.160.209]
X-ClientProxiedBy: EX13D22UWC003.ant.amazon.com (10.43.162.250) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


commit bd88bb5d4007949be7154deae7cef7173c751a95 upstream

This matches the naming of strncpy_from_user, and also makes it more
clear what the function is supposed to do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20200521152301.2587579-7-hch@lst.de
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 5.4
Signed-off-by: Tsahi Zidenberg <tsahee@amazon.com>
---
 include/linux/uaccess.h     | 4 ++--
 kernel/trace/bpf_trace.c    | 4 ++--
 kernel/trace/trace_kprobe.c | 2 +-
 mm/maccess.c                | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 67f016010aad..23e655549be2 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -354,8 +354,8 @@ extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 extern long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
                        long count);
 extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
-extern long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
-                     long count);
+long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
+        long count);
 extern long strnlen_unsafe_user(const void __user *unsafe_addr, long count);
 
 /**
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 396b91a9b669..720d78c62d05 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -161,7 +161,7 @@ static const struct bpf_func_proto bpf_probe_read_user_proto = {
 BPF_CALL_3(bpf_probe_read_user_str, void *, dst, u32, size,
        const void __user *, unsafe_ptr)
 {
-    int ret = strncpy_from_unsafe_user(dst, unsafe_ptr, size);
+    int ret = strncpy_from_user_nofault(dst, unsafe_ptr, size);
 
     if (unlikely(ret < 0))
         memset(dst, 0, size);
@@ -418,7 +418,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
                                sizeof(buf));
                 break;
             case 'u':
-                strncpy_from_unsafe_user(buf,
+                strncpy_from_user_nofault(buf,
                     (__force void __user *)unsafe_ptr,
                              sizeof(buf));
                 break;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 233322c77b76..6e26364f1005 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1104,7 +1104,7 @@ fetch_store_string_user(unsigned long addr, void *dest, void *base)
 
     __dest = get_loc_data(dest, base);
 
-    ret = strncpy_from_unsafe_user(__dest, uaddr, maxlen);
+    ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
     if (ret >= 0)
         *(u32 *)dest = make_data_loc(ret, __dest - base);
 
diff --git a/mm/maccess.c b/mm/maccess.c
index 3ca8d97e5010..84c598673aa9 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -205,7 +205,7 @@ long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
 }
 
 /**
- * strncpy_from_unsafe_user: - Copy a NUL terminated string from unsafe user
+ * strncpy_from_user_nofault: - Copy a NUL terminated string from unsafe user
  *                address.
  * @dst:   Destination address, in kernel space.  This buffer must be at
  *         least @count bytes long.
@@ -222,7 +222,7 @@ long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  */
-long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
+long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
                   long count)
 {
     mm_segment_t old_fs = get_fs();
-- 
2.25.1


