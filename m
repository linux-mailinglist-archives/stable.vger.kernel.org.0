Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEA0366C68
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243387AbhDUNRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:17:12 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:6804 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241372AbhDUNMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 09:12:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619010695; x=1650546695;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=1Fo1DEpE+EuWqINvjKMYf9vDxCxl7txKdsxYq0F7drA=;
  b=SLr64dMagwqpdLXJYXnn6vrdDUEnt5loLoUTMn/Rp7C3aSJdwkkhJty/
   x9XWvb7eg/tZcshLGBDAh4IpnUEVfEXXrKBE0KSEWBJFteFrT3PgMFUtw
   szpayat/5r5OD6s6Ve4q5Gkq7ccpozsS4LKbQ1hmYU5Ljdvk/qjlPgVV8
   0=;
X-IronPort-AV: E=Sophos;i="5.82,240,1613433600"; 
   d="scan'208";a="927961451"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 21 Apr 2021 13:11:35 +0000
Received: from EX13D01EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id A4C5EA1ACF;
        Wed, 21 Apr 2021 13:11:34 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.162.239) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 13:11:31 +0000
Subject: [PATCH 5/8] bpf: Restrict bpf_trace_printk()'s %s usage and add
 %pks,, %pus specifier
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Greg KH <greg@kroah.com>
References: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Message-ID: <c59befae-27eb-dfb4-5f79-dc7dcb35dc08@amazon.com>
Date:   Wed, 21 Apr 2021 16:11:26 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.162.239]
X-ClientProxiedBy: EX13D40UWA004.ant.amazon.com (10.43.160.36) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


commit b2a5212fb634561bb734c6356904e37f6665b955 upstream

Usage of plain %s conversion specifier in bpf_trace_printk() suffers from the
very same issue as bpf_probe_read{,str}() helpers, that is, it is broken on
archs with overlapping address ranges.

While the helpers have been addressed through work in 6ae08ae3dea2 ("bpf: Add
probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers"), we need
an option for bpf_trace_printk() as well to fix it.

Similarly as with the helpers, force users to make an explicit choice by adding
%pks and %pus specifier to bpf_trace_printk() which will then pick the corresponding
strncpy_from_unsafe*() variant to perform the access under KERNEL_DS or USER_DS.
The %pk* (kernel specifier) and %pu* (user specifier) can later also be extended
for other objects aside strings that are probed and printed under tracing, and
reused out of other facilities like bpf_seq_printf() or BTF based type printing.

Existing behavior of %s for current users is still kept working for archs where it
is not broken and therefore gated through CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE.
For archs not having this property we fall-back to pick probing under KERNEL_DS as
a sensible default.

conflict resolution: in vsprintf.c, add the new options [u/k] without
other options added upstream

Fixes: 8d3b7dce8622 ("bpf: add support for %s specifier to bpf_trace_printk()")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Link: https://lore.kernel.org/bpf/20200515101118.6508-4-daniel@iogearbox.net
Cc: <stable@vger.kernel.org> # 5.4
Signed-off-by: Tsahi Zidenberg <tsahee@amazon.com>
---
 Documentation/core-api/printk-formats.rst | 14 ++++
 kernel/trace/bpf_trace.c                  | 94 +++++++++++++++--------
 lib/vsprintf.c                            | 12 +++
 3 files changed, 88 insertions(+), 32 deletions(-)

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index ecbebf4ca8e7..cf8c2ad8abef 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -110,6 +110,20 @@ used when printing stack backtraces. The specifier takes into
 consideration the effect of compiler optimisations which may occur
 when tail-calls are used and marked with the noreturn GCC attribute.
 
+Probed Pointers from BPF / tracing
+----------------------------------
+
+::
+
+    %pks    kernel string
+    %pus    user string
+
+The ``k`` and ``u`` specifiers are used for printing prior probed memory from
+either kernel memory (k) or user memory (u). The subsequent ``s`` specifier
+results in printing a string. For direct use in regular vsnprintf() the (k)
+and (u) annotation is ignored, however, when used out of BPF's bpf_trace_printk(),
+for example, it reads the memory it is pointing to without faulting.
+
 Kernel Pointers
 ---------------
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 80f0072b31e0..396b91a9b669 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -325,17 +325,15 @@ static const struct bpf_func_proto *bpf_get_probe_write_proto(void)
 
 /*
  * Only limited trace_printk() conversion specifiers allowed:
- * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %s
+ * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pks %pus %s
  */
 BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
        u64, arg2, u64, arg3)
 {
+    int i, mod[3] = {}, fmt_cnt = 0;
+    char buf[64], fmt_ptype;
+    void *unsafe_ptr = NULL;
     bool str_seen = false;
-    int mod[3] = {};
-    int fmt_cnt = 0;
-    u64 unsafe_addr;
-    char buf[64];
-    int i;
 
     /*
      * bpf_check()->check_func_arg()->check_stack_boundary()
@@ -361,40 +359,71 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
         if (fmt[i] == 'l') {
             mod[fmt_cnt]++;
             i++;
-        } else if (fmt[i] == 'p' || fmt[i] == 's') {
+        } else if (fmt[i] == 'p') {
             mod[fmt_cnt]++;
+            if ((fmt[i + 1] == 'k' ||
+                 fmt[i + 1] == 'u') &&
+                fmt[i + 2] == 's') {
+                fmt_ptype = fmt[i + 1];
+                i += 2;
+                goto fmt_str;
+            }
+
             /* disallow any further format extensions */
             if (fmt[i + 1] != 0 &&
                 !isspace(fmt[i + 1]) &&
                 !ispunct(fmt[i + 1]))
                 return -EINVAL;
-            fmt_cnt++;
-            if (fmt[i] == 's') {
-                if (str_seen)
-                    /* allow only one '%s' per fmt string */
-                    return -EINVAL;
-                str_seen = true;
-
-                switch (fmt_cnt) {
-                case 1:
-                    unsafe_addr = arg1;
-                    arg1 = (long) buf;
-                    break;
-                case 2:
-                    unsafe_addr = arg2;
-                    arg2 = (long) buf;
-                    break;
-                case 3:
-                    unsafe_addr = arg3;
-                    arg3 = (long) buf;
-                    break;
-                }
-                buf[0] = 0;
-                strncpy_from_unsafe(buf,
-                            (void *) (long) unsafe_addr,
+
+            goto fmt_next;
+        } else if (fmt[i] == 's') {
+            mod[fmt_cnt]++;
+            fmt_ptype = fmt[i];
+fmt_str:
+            if (str_seen)
+                /* allow only one '%s' per fmt string */
+                return -EINVAL;
+            str_seen = true;
+
+            if (fmt[i + 1] != 0 &&
+                !isspace(fmt[i + 1]) &&
+                !ispunct(fmt[i + 1]))
+                return -EINVAL;
+
+            switch (fmt_cnt) {
+            case 0:
+                unsafe_ptr = (void *)(long)arg1;
+                arg1 = (long)buf;
+                break;
+            case 1:
+                unsafe_ptr = (void *)(long)arg2;
+                arg2 = (long)buf;
+                break;
+            case 2:
+                unsafe_ptr = (void *)(long)arg3;
+                arg3 = (long)buf;
+                break;
+            }
+
+            buf[0] = 0;
+            switch (fmt_ptype) {
+            case 's':
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+                strncpy_from_unsafe(buf, unsafe_ptr,
                             sizeof(buf));
+                break;
+#endif
+            case 'k':
+                strncpy_from_unsafe_strict(buf, unsafe_ptr,
+                               sizeof(buf));
+                break;
+            case 'u':
+                strncpy_from_unsafe_user(buf,
+                    (__force void __user *)unsafe_ptr,
+                             sizeof(buf));
+                break;
             }
-            continue;
+            goto fmt_next;
         }
 
         if (fmt[i] == 'l') {
@@ -405,6 +434,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
         if (fmt[i] != 'i' && fmt[i] != 'd' &&
             fmt[i] != 'u' && fmt[i] != 'x')
             return -EINVAL;
+fmt_next:
         fmt_cnt++;
     }
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index fb4af73142b4..985ea5c87465 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2116,6 +2116,10 @@ static char *kobject_string(char *buf, char *end, void *ptr,
  *                  c major compatible string
  *                  C full compatible string
  * - 'x' For printing the address. Equivalent to "%lx".
+ * - '[ku]s' For a BPF/tracing related format specifier, e.g. used out of
+ *           bpf_trace_printk() where [ku] prefix specifies either kernel (k)
+ *           or user (u) memory to probe, and:
+ *              s a string, equivalent to "%s" on direct vsnprintf() use
  *
  * ** When making changes please also update:
  *    Documentation/core-api/printk-formats.rst
@@ -2194,6 +2198,14 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
         return kobject_string(buf, end, ptr, spec, fmt);
     case 'x':
         return pointer_string(buf, end, ptr, spec);
+    case 'u':
+    case 'k':
+        switch (fmt[1]) {
+        case 's':
+            return string(buf, end, ptr, spec);
+        default:
+            return error_string(buf, end, "(einval)", spec);
+        }
     }
 
     /* default is to _not_ leak addresses, hash before printing */
-- 
2.25.1


