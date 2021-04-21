Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A608366C6D
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241062AbhDUNRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:17:19 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:53036 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242508AbhDUNPK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 09:15:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619010878; x=1650546878;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=+p7LL96OPesTTJ2+Gjoku94KKXlIqR8BPVG20QQ92yI=;
  b=I5+Z0S8NUyT2zYLwy57cpRxnpfi3jrcz9/DMTgP7tGfj7auyWBgC1u80
   yMzXRHf15HHvOZC/CiYg9eVfadaf104ro8ExwErL0SFxOR+QZs8ZZuOBj
   PFyUNdPFpXbfbLBDJrTK36EgbwKLPTVxn1CtXmIlXRPzdUlud/CeFoWac
   s=;
X-IronPort-AV: E=Sophos;i="5.82,240,1613433600"; 
   d="scan'208";a="107554639"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 21 Apr 2021 13:14:31 +0000
Received: from EX13D01EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 8FA4F240BD0;
        Wed, 21 Apr 2021 13:14:30 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.161.253) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 13:14:26 +0000
Subject: [PATCH 8/8] bpf: rework the compat kernel probe handling
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Greg KH <greg@kroah.com>
References: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Message-ID: <c2869537-9090-8555-1506-37f6ac4684c9@amazon.com>
Date:   Wed, 21 Apr 2021 16:14:21 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D17UWB003.ant.amazon.com (10.43.161.42) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


commit 8d92db5c04d10381f4db70ed99b1b576f5db18a7 upstream

Instead of using the dangerous probe_kernel_read and strncpy_from_unsafe
helpers, rework the compat probes to check if an address is a kernel or
userspace one, and then use the low-level kernel or user probe helper
shared by the proper kernel and user probe helpers.  This slightly
changes behavior as the compat probe on a user address doesn't check
the lockdown flags, just as the pure user probes do.

conflict resolution: in kernel 5.4, these bpf_func_proto structs are
static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20200521152301.2587579-14-hch@lst.de
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 5.4
Signed-off-by: Tsahi Zidenberg <tsahee@amazon.com>
---
 kernel/trace/bpf_trace.c | 109 ++++++++++++++++++++++++---------------
 1 file changed, 67 insertions(+), 42 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7b905aa800b2..ac07eeb4fa06 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -138,17 +138,23 @@ static const struct bpf_func_proto bpf_override_return_proto = {
 };
 #endif
 
-BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size,
-       const void __user *, unsafe_ptr)
+static __always_inline int
+bpf_probe_read_user_common(void *dst, u32 size, const void __user *unsafe_ptr)
 {
-    int ret = probe_user_read(dst, unsafe_ptr, size);
+    int ret;
 
+    ret = probe_user_read(dst, unsafe_ptr, size);
     if (unlikely(ret < 0))
         memset(dst, 0, size);
-
     return ret;
 }
 
+BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size,
+       const void __user *, unsafe_ptr)
+{
+    return bpf_probe_read_user_common(dst, size, unsafe_ptr);
+}
+
 static const struct bpf_func_proto bpf_probe_read_user_proto = {
     .func        = bpf_probe_read_user,
     .gpl_only    = true,
@@ -158,17 +164,24 @@ static const struct bpf_func_proto bpf_probe_read_user_proto = {
     .arg3_type    = ARG_ANYTHING,
 };
 
-BPF_CALL_3(bpf_probe_read_user_str, void *, dst, u32, size,
-       const void __user *, unsafe_ptr)
+static __always_inline int
+bpf_probe_read_user_str_common(void *dst, u32 size,
+                   const void __user *unsafe_ptr)
 {
-    int ret = strncpy_from_user_nofault(dst, unsafe_ptr, size);
+    int ret;
 
+    ret = strncpy_from_user_nofault(dst, unsafe_ptr, size);
     if (unlikely(ret < 0))
         memset(dst, 0, size);
-
     return ret;
 }
 
+BPF_CALL_3(bpf_probe_read_user_str, void *, dst, u32, size,
+       const void __user *, unsafe_ptr)
+{
+    return bpf_probe_read_user_str_common(dst, size, unsafe_ptr);
+}
+
 static const struct bpf_func_proto bpf_probe_read_user_str_proto = {
     .func        = bpf_probe_read_user_str,
     .gpl_only    = true,
@@ -179,25 +192,25 @@ static const struct bpf_func_proto bpf_probe_read_user_str_proto = {
 };
 
 static __always_inline int
-bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr,
-                 const bool compat)
+bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr)
 {
     int ret = security_locked_down(LOCKDOWN_BPF_READ);
 
     if (unlikely(ret < 0))
-        goto out;
-    ret = compat ? probe_kernel_read(dst, unsafe_ptr, size) :
-          probe_kernel_read_strict(dst, unsafe_ptr, size);
+        goto fail;
+    ret = probe_kernel_read_strict(dst, unsafe_ptr, size);
     if (unlikely(ret < 0))
-out:
-        memset(dst, 0, size);
+        goto fail;
+    return ret;
+fail:
+    memset(dst, 0, size);
     return ret;
 }
 
 BPF_CALL_3(bpf_probe_read_kernel, void *, dst, u32, size,
        const void *, unsafe_ptr)
 {
-    return bpf_probe_read_kernel_common(dst, size, unsafe_ptr, false);
+    return bpf_probe_read_kernel_common(dst, size, unsafe_ptr);
 }
 
 static const struct bpf_func_proto bpf_probe_read_kernel_proto = {
@@ -209,50 +222,37 @@ static const struct bpf_func_proto bpf_probe_read_kernel_proto = {
     .arg3_type    = ARG_ANYTHING,
 };
 
-BPF_CALL_3(bpf_probe_read_compat, void *, dst, u32, size,
-       const void *, unsafe_ptr)
-{
-    return bpf_probe_read_kernel_common(dst, size, unsafe_ptr, true);
-}
-
-static const struct bpf_func_proto bpf_probe_read_compat_proto = {
-    .func        = bpf_probe_read_compat,
-    .gpl_only    = true,
-    .ret_type    = RET_INTEGER,
-    .arg1_type    = ARG_PTR_TO_UNINIT_MEM,
-    .arg2_type    = ARG_CONST_SIZE_OR_ZERO,
-    .arg3_type    = ARG_ANYTHING,
-};
-
 static __always_inline int
-bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr,
-                 const bool compat)
+bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr)
 {
     int ret = security_locked_down(LOCKDOWN_BPF_READ);
 
     if (unlikely(ret < 0))
-        goto out;
+        goto fail;
+
     /*
-     * The strncpy_from_unsafe_*() call will likely not fill the entire
-     * buffer, but that's okay in this circumstance as we're probing
+     * The strncpy_from_kernel_nofault() call will likely not fill the
+     * entire buffer, but that's okay in this circumstance as we're probing
      * arbitrary memory anyway similar to bpf_probe_read_*() and might
      * as well probe the stack. Thus, memory is explicitly cleared
      * only in error case, so that improper users ignoring return
      * code altogether don't copy garbage; otherwise length of string
      * is returned that can be used for bpf_perf_event_output() et al.
      */
-    ret = compat ? strncpy_from_unsafe(dst, unsafe_ptr, size) :
-          strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
+    ret = strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
     if (unlikely(ret < 0))
-out:
-        memset(dst, 0, size);
+        goto fail;
+
+    return 0;
+fail:
+    memset(dst, 0, size);
     return ret;
 }
 
 BPF_CALL_3(bpf_probe_read_kernel_str, void *, dst, u32, size,
        const void *, unsafe_ptr)
 {
-    return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, false);
+    return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr);
 }
 
 static const struct bpf_func_proto bpf_probe_read_kernel_str_proto = {
@@ -264,10 +264,34 @@ static const struct bpf_func_proto bpf_probe_read_kernel_str_proto = {
     .arg3_type    = ARG_ANYTHING,
 };
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+BPF_CALL_3(bpf_probe_read_compat, void *, dst, u32, size,
+       const void *, unsafe_ptr)
+{
+    if ((unsigned long)unsafe_ptr < TASK_SIZE) {
+        return bpf_probe_read_user_common(dst, size,
+                (__force void __user *)unsafe_ptr);
+    }
+    return bpf_probe_read_kernel_common(dst, size, unsafe_ptr);
+}
+
+static const struct bpf_func_proto bpf_probe_read_compat_proto = {
+    .func        = bpf_probe_read_compat,
+    .gpl_only    = true,
+    .ret_type    = RET_INTEGER,
+    .arg1_type    = ARG_PTR_TO_UNINIT_MEM,
+    .arg2_type    = ARG_CONST_SIZE_OR_ZERO,
+    .arg3_type    = ARG_ANYTHING,
+};
+
 BPF_CALL_3(bpf_probe_read_compat_str, void *, dst, u32, size,
        const void *, unsafe_ptr)
 {
-    return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, true);
+    if ((unsigned long)unsafe_ptr < TASK_SIZE) {
+        return bpf_probe_read_user_str_common(dst, size,
+                (__force void __user *)unsafe_ptr);
+    }
+    return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr);
 }
 
 static const struct bpf_func_proto bpf_probe_read_compat_str_proto = {
@@ -278,6 +302,7 @@ static const struct bpf_func_proto bpf_probe_read_compat_str_proto = {
     .arg2_type    = ARG_CONST_SIZE_OR_ZERO,
     .arg3_type    = ARG_ANYTHING,
 };
+#endif /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
 
 BPF_CALL_3(bpf_probe_write_user, void __user *, unsafe_ptr, const void *, src,
        u32, size)
-- 
2.25.1


