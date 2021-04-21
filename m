Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3AA366C6E
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241081AbhDUNRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:17:20 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:11589 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242848AbhDUNQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 09:16:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619010945; x=1650546945;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=WjzUlaz2xJdprzzr617dUyV82cAgxp9xTWw8V0VCbx0=;
  b=SGsbirHAdDeVy2baySu9QjsF78q/Y+ba03xvuTPA/lpQoufihmoRQWP3
   PsIMA5Q5MLtMrj92bStQCZmP23yY/spQfb5t+fCmRdnVDpxberXEgsn8o
   uPGvew/+JhtUbb28o5/pXnMmBEIBcIATnFMfHRw1pxqf1Z5pkk1wTBwy3
   Q=;
X-IronPort-AV: E=Sophos;i="5.82,240,1613433600"; 
   d="scan'208";a="927962501"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 21 Apr 2021 13:15:42 +0000
Received: from EX13D01EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 748F7A2251;
        Wed, 21 Apr 2021 13:15:41 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.161.253) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 13:15:37 +0000
Subject: [PATCH 2/8] bpf: Add probe_read_{user, kernel} and probe_read_{user,,
 kernel}_str helpers
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Greg KH <greg@kroah.com>
References: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Message-ID: <73702b7e-166f-b3d0-2853-ae8d545e56eb@amazon.com>
Date:   Wed, 21 Apr 2021 16:15:32 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D17UWB004.ant.amazon.com (10.43.161.132) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


commit 6ae08ae3dea2cfa03dd3665a3c8475c2d429ef47 upstream

The current bpf_probe_read() and bpf_probe_read_str() helpers are broken
in that they assume they can be used for probing memory access for kernel
space addresses /as well as/ user space addresses.

However, plain use of probe_kernel_read() for both cases will attempt to
always access kernel space address space given access is performed under
KERNEL_DS and some archs in-fact have overlapping address spaces where a
kernel pointer and user pointer would have the /same/ address value and
therefore accessing application memory via bpf_probe_read{,_str}() would
read garbage values.

Lets fix BPF side by making use of recently added 3d7081822f7f ("uaccess:
Add non-pagefault user-space read functions"). Unfortunately, the only way
to fix this status quo is to add dedicated bpf_probe_read_{user,kernel}()
and bpf_probe_read_{user,kernel}_str() helpers. The bpf_probe_read{,_str}()
helpers are kept as-is to retain their current behavior.

The two *_user() variants attempt the access always under USER_DS set, the
two *_kernel() variants will -EFAULT when accessing user memory if the
underlying architecture has non-overlapping address ranges, also avoiding
throwing the kernel warning via 00c42373d397 ("x86-64: add warning for
non-canonical user access address dereferences").

conflict resolution:
upstream also defines skb_output helper. This commit adds skb_output to
FUNC_MAPPER, but does not take any code to add support or comments
detailing the support.

Fixes: a5e8c07059d0 ("bpf: add bpf_probe_read_str helper")
Fixes: 2541517c32be ("tracing, perf: Implement BPF programs attached to kprobes")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/796ee46e948bc808d54891a1108435f8652c6ca4.1572649915.git.daniel@iogearbox.net
Cc: <stable@vger.kernel.org> # 5.4
Signed-off-by: Tsahi Zidenberg <tsahee@amazon.com>
---
 include/uapi/linux/bpf.h       | 123 ++++++++++++++--------
 kernel/trace/bpf_trace.c       | 181 ++++++++++++++++++++++++---------
 tools/include/uapi/linux/bpf.h | 116 +++++++++++++--------
 3 files changed, 294 insertions(+), 126 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8649422e760c..2fe91a083f7a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -560,10 +560,13 @@ union bpf_attr {
  *     Return
  *         0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read(void *dst, u32 size, const void *src)
+ * int bpf_probe_read(void *dst, u32 size, const void *unsafe_ptr)
  *     Description
  *         For tracing programs, safely attempt to read *size* bytes from
- *         address *src* and store the data in *dst*.
+ *         kernel space address *unsafe_ptr* and store the data in *dst*.
+ *
+ *         Generally, use bpf_probe_read_user() or bpf_probe_read_kernel()
+ *         instead.
  *     Return
  *         0 on success, or a negative error in case of failure.
  *
@@ -1425,45 +1428,14 @@ union bpf_attr {
  *     Return
  *         0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read_str(void *dst, int size, const void *unsafe_ptr)
+ * int bpf_probe_read_str(void *dst, u32 size, const void *unsafe_ptr)
  *     Description
- *         Copy a NUL terminated string from an unsafe address
- *         *unsafe_ptr* to *dst*. The *size* should include the
- *         terminating NUL byte. In case the string length is smaller than
- *         *size*, the target is not padded with further NUL bytes. If the
- *         string length is larger than *size*, just *size*-1 bytes are
- *         copied and the last byte is set to NUL.
- *
- *         On success, the length of the copied string is returned. This
- *         makes this helper useful in tracing programs for reading
- *         strings, and more importantly to get its length at runtime. See
- *         the following snippet:
- *
- *         ::
- *
- *             SEC("kprobe/sys_open")
- *             void bpf_sys_open(struct pt_regs *ctx)
- *             {
- *                     char buf[PATHLEN]; // PATHLEN is defined to 256
- *                     int res = bpf_probe_read_str(buf, sizeof(buf),
- *                                              ctx->di);
- *
- *                 // Consume buf, for example push it to
- *                 // userspace via bpf_perf_event_output(); we
- *                 // can use res (the string length) as event
- *                 // size, after checking its boundaries.
- *             }
- *
- *         In comparison, using **bpf_probe_read()** helper here instead
- *         to read the string would require to estimate the length at
- *         compile time, and would often result in copying more memory
- *         than necessary.
+ *         Copy a NUL terminated string from an unsafe kernel address
+ *         *unsafe_ptr* to *dst*. See bpf_probe_read_kernel_str() for
+ *         more details.
  *
- *         Another useful use case is when parsing individual process
- *         arguments or individual environment variables navigating
- *         *current*\ **->mm->arg_start** and *current*\
- *         **->mm->env_start**: using this helper and the return value,
- *         one can quickly iterate at the right offset of the memory area.
+ *         Generally, use bpf_probe_read_user_str() or bpf_probe_read_kernel_str()
+ *         instead.
  *     Return
  *         On success, the strictly positive length of the string,
  *         including the trailing NUL character. On error, a negative
@@ -2750,6 +2722,72 @@ union bpf_attr {
  *        **-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *        **-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_probe_read_user(void *dst, u32 size, const void *unsafe_ptr)
+ *     Description
+ *         Safely attempt to read *size* bytes from user space address
+ *         *unsafe_ptr* and store the data in *dst*.
+ *     Return
+ *         0 on success, or a negative error in case of failure.
+ *
+ * int bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
+ *     Description
+ *         Safely attempt to read *size* bytes from kernel space address
+ *         *unsafe_ptr* and store the data in *dst*.
+ *     Return
+ *         0 on success, or a negative error in case of failure.
+ *
+ * int bpf_probe_read_user_str(void *dst, u32 size, const void *unsafe_ptr)
+ *     Description
+ *         Copy a NUL terminated string from an unsafe user address
+ *         *unsafe_ptr* to *dst*. The *size* should include the
+ *         terminating NUL byte. In case the string length is smaller than
+ *         *size*, the target is not padded with further NUL bytes. If the
+ *         string length is larger than *size*, just *size*-1 bytes are
+ *         copied and the last byte is set to NUL.
+ *
+ *         On success, the length of the copied string is returned. This
+ *         makes this helper useful in tracing programs for reading
+ *         strings, and more importantly to get its length at runtime. See
+ *         the following snippet:
+ *
+ *         ::
+ *
+ *             SEC("kprobe/sys_open")
+ *             void bpf_sys_open(struct pt_regs *ctx)
+ *             {
+ *                     char buf[PATHLEN]; // PATHLEN is defined to 256
+ *                     int res = bpf_probe_read_user_str(buf, sizeof(buf),
+ *                                                   ctx->di);
+ *
+ *                 // Consume buf, for example push it to
+ *                 // userspace via bpf_perf_event_output(); we
+ *                 // can use res (the string length) as event
+ *                 // size, after checking its boundaries.
+ *             }
+ *
+ *         In comparison, using **bpf_probe_read_user()** helper here
+ *         instead to read the string would require to estimate the length
+ *         at compile time, and would often result in copying more memory
+ *         than necessary.
+ *
+ *         Another useful use case is when parsing individual process
+ *         arguments or individual environment variables navigating
+ *         *current*\ **->mm->arg_start** and *current*\
+ *         **->mm->env_start**: using this helper and the return value,
+ *         one can quickly iterate at the right offset of the memory area.
+ *     Return
+ *         On success, the strictly positive length of the string,
+ *         including the trailing NUL character. On error, a negative
+ *         value.
+ *
+ * int bpf_probe_read_kernel_str(void *dst, u32 size, const void *unsafe_ptr)
+ *     Description
+ *         Copy a NUL terminated string from an unsafe kernel address *unsafe_ptr*
+ *         to *dst*. Same semantics as with bpf_probe_read_user_str() apply.
+ *     Return
+ *         On success, the strictly positive length of the string,    including
+ *         the trailing NUL character. On error, a negative value.
  */
 #define __BPF_FUNC_MAPPER(FN)        \
     FN(unspec),            \
@@ -2862,7 +2900,12 @@ union bpf_attr {
     FN(sk_storage_get),        \
     FN(sk_storage_delete),        \
     FN(send_signal),        \
-    FN(tcp_gen_syncookie),
+    FN(tcp_gen_syncookie),        \
+    FN(skb_output),            \
+    FN(probe_read_user),        \
+    FN(probe_read_kernel),        \
+    FN(probe_read_user_str),    \
+    FN(probe_read_kernel_str),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 74c1db7178cf..0e329d48ab08 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -138,24 +138,140 @@ static const struct bpf_func_proto bpf_override_return_proto = {
 };
 #endif
 
-BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
+BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size,
+       const void __user *, unsafe_ptr)
 {
-    int ret;
+    int ret = probe_user_read(dst, unsafe_ptr, size);
 
-    ret = security_locked_down(LOCKDOWN_BPF_READ);
-    if (ret < 0)
-        goto out;
+    if (unlikely(ret < 0))
+        memset(dst, 0, size);
+
+    return ret;
+}
+
+static const struct bpf_func_proto bpf_probe_read_user_proto = {
+    .func        = bpf_probe_read_user,
+    .gpl_only    = true,
+    .ret_type    = RET_INTEGER,
+    .arg1_type    = ARG_PTR_TO_UNINIT_MEM,
+    .arg2_type    = ARG_CONST_SIZE_OR_ZERO,
+    .arg3_type    = ARG_ANYTHING,
+};
+
+BPF_CALL_3(bpf_probe_read_user_str, void *, dst, u32, size,
+       const void __user *, unsafe_ptr)
+{
+    int ret = strncpy_from_unsafe_user(dst, unsafe_ptr, size);
+
+    if (unlikely(ret < 0))
+        memset(dst, 0, size);
+
+    return ret;
+}
+
+static const struct bpf_func_proto bpf_probe_read_user_str_proto = {
+    .func        = bpf_probe_read_user_str,
+    .gpl_only    = true,
+    .ret_type    = RET_INTEGER,
+    .arg1_type    = ARG_PTR_TO_UNINIT_MEM,
+    .arg2_type    = ARG_CONST_SIZE_OR_ZERO,
+    .arg3_type    = ARG_ANYTHING,
+};
 
-    ret = probe_kernel_read(dst, unsafe_ptr, size);
+static __always_inline int
+bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr,
+                 const bool compat)
+{
+    int ret = security_locked_down(LOCKDOWN_BPF_READ);
+
+    if (unlikely(ret < 0))
+        goto out;
+    ret = compat ? probe_kernel_read(dst, unsafe_ptr, size) :
+          probe_kernel_read_strict(dst, unsafe_ptr, size);
     if (unlikely(ret < 0))
 out:
         memset(dst, 0, size);
+    return ret;
+}
+
+BPF_CALL_3(bpf_probe_read_kernel, void *, dst, u32, size,
+       const void *, unsafe_ptr)
+{
+    return bpf_probe_read_kernel_common(dst, size, unsafe_ptr, false);
+}
+
+static const struct bpf_func_proto bpf_probe_read_kernel_proto = {
+    .func        = bpf_probe_read_kernel,
+    .gpl_only    = true,
+    .ret_type    = RET_INTEGER,
+    .arg1_type    = ARG_PTR_TO_UNINIT_MEM,
+    .arg2_type    = ARG_CONST_SIZE_OR_ZERO,
+    .arg3_type    = ARG_ANYTHING,
+};
+
+BPF_CALL_3(bpf_probe_read_compat, void *, dst, u32, size,
+       const void *, unsafe_ptr)
+{
+    return bpf_probe_read_kernel_common(dst, size, unsafe_ptr, true);
+}
 
+static const struct bpf_func_proto bpf_probe_read_compat_proto = {
+    .func        = bpf_probe_read_compat,
+    .gpl_only    = true,
+    .ret_type    = RET_INTEGER,
+    .arg1_type    = ARG_PTR_TO_UNINIT_MEM,
+    .arg2_type    = ARG_CONST_SIZE_OR_ZERO,
+    .arg3_type    = ARG_ANYTHING,
+};
+
+static __always_inline int
+bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr,
+                 const bool compat)
+{
+    int ret = security_locked_down(LOCKDOWN_BPF_READ);
+
+    if (unlikely(ret < 0))
+        goto out;
+    /*
+     * The strncpy_from_unsafe_*() call will likely not fill the entire
+     * buffer, but that's okay in this circumstance as we're probing
+     * arbitrary memory anyway similar to bpf_probe_read_*() and might
+     * as well probe the stack. Thus, memory is explicitly cleared
+     * only in error case, so that improper users ignoring return
+     * code altogether don't copy garbage; otherwise length of string
+     * is returned that can be used for bpf_perf_event_output() et al.
+     */
+    ret = compat ? strncpy_from_unsafe(dst, unsafe_ptr, size) :
+          strncpy_from_unsafe_strict(dst, unsafe_ptr, size);
+    if (unlikely(ret < 0))
+out:
+        memset(dst, 0, size);
     return ret;
 }
 
-static const struct bpf_func_proto bpf_probe_read_proto = {
-    .func        = bpf_probe_read,
+BPF_CALL_3(bpf_probe_read_kernel_str, void *, dst, u32, size,
+       const void *, unsafe_ptr)
+{
+    return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, false);
+}
+
+static const struct bpf_func_proto bpf_probe_read_kernel_str_proto = {
+    .func        = bpf_probe_read_kernel_str,
+    .gpl_only    = true,
+    .ret_type    = RET_INTEGER,
+    .arg1_type    = ARG_PTR_TO_UNINIT_MEM,
+    .arg2_type    = ARG_CONST_SIZE_OR_ZERO,
+    .arg3_type    = ARG_ANYTHING,
+};
+
+BPF_CALL_3(bpf_probe_read_compat_str, void *, dst, u32, size,
+       const void *, unsafe_ptr)
+{
+    return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, true);
+}
+
+static const struct bpf_func_proto bpf_probe_read_compat_str_proto = {
+    .func        = bpf_probe_read_compat_str,
     .gpl_only    = true,
     .ret_type    = RET_INTEGER,
     .arg1_type    = ARG_PTR_TO_UNINIT_MEM,
@@ -583,41 +699,6 @@ static const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
     .arg2_type      = ARG_ANYTHING,
 };
 
-BPF_CALL_3(bpf_probe_read_str, void *, dst, u32, size,
-       const void *, unsafe_ptr)
-{
-    int ret;
-
-    ret = security_locked_down(LOCKDOWN_BPF_READ);
-    if (ret < 0)
-        goto out;
-
-    /*
-     * The strncpy_from_unsafe() call will likely not fill the entire
-     * buffer, but that's okay in this circumstance as we're probing
-     * arbitrary memory anyway similar to bpf_probe_read() and might
-     * as well probe the stack. Thus, memory is explicitly cleared
-     * only in error case, so that improper users ignoring return
-     * code altogether don't copy garbage; otherwise length of string
-     * is returned that can be used for bpf_perf_event_output() et al.
-     */
-    ret = strncpy_from_unsafe(dst, unsafe_ptr, size);
-    if (unlikely(ret < 0))
-out:
-        memset(dst, 0, size);
-
-    return ret;
-}
-
-static const struct bpf_func_proto bpf_probe_read_str_proto = {
-    .func        = bpf_probe_read_str,
-    .gpl_only    = true,
-    .ret_type    = RET_INTEGER,
-    .arg1_type    = ARG_PTR_TO_UNINIT_MEM,
-    .arg2_type    = ARG_CONST_SIZE_OR_ZERO,
-    .arg3_type    = ARG_ANYTHING,
-};
-
 struct send_signal_irq_work {
     struct irq_work irq_work;
     struct task_struct *task;
@@ -697,8 +778,6 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
         return &bpf_map_pop_elem_proto;
     case BPF_FUNC_map_peek_elem:
         return &bpf_map_peek_elem_proto;
-    case BPF_FUNC_probe_read:
-        return &bpf_probe_read_proto;
     case BPF_FUNC_ktime_get_ns:
         return &bpf_ktime_get_ns_proto;
     case BPF_FUNC_tail_call:
@@ -725,8 +804,18 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
         return &bpf_current_task_under_cgroup_proto;
     case BPF_FUNC_get_prandom_u32:
         return &bpf_get_prandom_u32_proto;
+    case BPF_FUNC_probe_read_user:
+        return &bpf_probe_read_user_proto;
+    case BPF_FUNC_probe_read_kernel:
+        return &bpf_probe_read_kernel_proto;
+    case BPF_FUNC_probe_read:
+        return &bpf_probe_read_compat_proto;
+    case BPF_FUNC_probe_read_user_str:
+        return &bpf_probe_read_user_str_proto;
+    case BPF_FUNC_probe_read_kernel_str:
+        return &bpf_probe_read_kernel_str_proto;
     case BPF_FUNC_probe_read_str:
-        return &bpf_probe_read_str_proto;
+        return &bpf_probe_read_compat_str_proto;
 #ifdef CONFIG_CGROUPS
     case BPF_FUNC_get_current_cgroup_id:
         return &bpf_get_current_cgroup_id_proto;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 8649422e760c..e4014608849d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -560,10 +560,13 @@ union bpf_attr {
  *     Return
  *         0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read(void *dst, u32 size, const void *src)
+ * int bpf_probe_read(void *dst, u32 size, const void *unsafe_ptr)
  *     Description
  *         For tracing programs, safely attempt to read *size* bytes from
- *         address *src* and store the data in *dst*.
+ *         kernel space address *unsafe_ptr* and store the data in *dst*.
+ *
+ *         Generally, use bpf_probe_read_user() or bpf_probe_read_kernel()
+ *         instead.
  *     Return
  *         0 on success, or a negative error in case of failure.
  *
@@ -1425,45 +1428,14 @@ union bpf_attr {
  *     Return
  *         0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read_str(void *dst, int size, const void *unsafe_ptr)
+ * int bpf_probe_read_str(void *dst, u32 size, const void *unsafe_ptr)
  *     Description
- *         Copy a NUL terminated string from an unsafe address
- *         *unsafe_ptr* to *dst*. The *size* should include the
- *         terminating NUL byte. In case the string length is smaller than
- *         *size*, the target is not padded with further NUL bytes. If the
- *         string length is larger than *size*, just *size*-1 bytes are
- *         copied and the last byte is set to NUL.
- *
- *         On success, the length of the copied string is returned. This
- *         makes this helper useful in tracing programs for reading
- *         strings, and more importantly to get its length at runtime. See
- *         the following snippet:
- *
- *         ::
- *
- *             SEC("kprobe/sys_open")
- *             void bpf_sys_open(struct pt_regs *ctx)
- *             {
- *                     char buf[PATHLEN]; // PATHLEN is defined to 256
- *                     int res = bpf_probe_read_str(buf, sizeof(buf),
- *                                              ctx->di);
- *
- *                 // Consume buf, for example push it to
- *                 // userspace via bpf_perf_event_output(); we
- *                 // can use res (the string length) as event
- *                 // size, after checking its boundaries.
- *             }
+ *         Copy a NUL terminated string from an unsafe kernel address
+ *         *unsafe_ptr* to *dst*. See bpf_probe_read_kernel_str() for
+ *         more details.
  *
- *         In comparison, using **bpf_probe_read()** helper here instead
- *         to read the string would require to estimate the length at
- *         compile time, and would often result in copying more memory
- *         than necessary.
- *
- *         Another useful use case is when parsing individual process
- *         arguments or individual environment variables navigating
- *         *current*\ **->mm->arg_start** and *current*\
- *         **->mm->env_start**: using this helper and the return value,
- *         one can quickly iterate at the right offset of the memory area.
+ *         Generally, use bpf_probe_read_user_str() or bpf_probe_read_kernel_str()
+ *         instead.
  *     Return
  *         On success, the strictly positive length of the string,
  *         including the trailing NUL character. On error, a negative
@@ -2750,6 +2722,65 @@ union bpf_attr {
  *        **-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *        **-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
+ *     Description
+ *         Safely attempt to read *size* bytes from kernel space address
+ *         *unsafe_ptr* and store the data in *dst*.
+ *     Return
+ *         0 on success, or a negative error in case of failure.
+ *
+ * int bpf_probe_read_user_str(void *dst, u32 size, const void *unsafe_ptr)
+ *     Description
+ *         Copy a NUL terminated string from an unsafe user address
+ *         *unsafe_ptr* to *dst*. The *size* should include the
+ *         terminating NUL byte. In case the string length is smaller than
+ *         *size*, the target is not padded with further NUL bytes. If the
+ *         string length is larger than *size*, just *size*-1 bytes are
+ *         copied and the last byte is set to NUL.
+ *
+ *         On success, the length of the copied string is returned. This
+ *         makes this helper useful in tracing programs for reading
+ *         strings, and more importantly to get its length at runtime. See
+ *         the following snippet:
+ *
+ *         ::
+ *
+ *             SEC("kprobe/sys_open")
+ *             void bpf_sys_open(struct pt_regs *ctx)
+ *             {
+ *                     char buf[PATHLEN]; // PATHLEN is defined to 256
+ *                     int res = bpf_probe_read_user_str(buf, sizeof(buf),
+ *                                                   ctx->di);
+ *
+ *                 // Consume buf, for example push it to
+ *                 // userspace via bpf_perf_event_output(); we
+ *                 // can use res (the string length) as event
+ *                 // size, after checking its boundaries.
+ *             }
+ *
+ *         In comparison, using **bpf_probe_read_user()** helper here
+ *         instead to read the string would require to estimate the length
+ *         at compile time, and would often result in copying more memory
+ *         than necessary.
+ *
+ *         Another useful use case is when parsing individual process
+ *         arguments or individual environment variables navigating
+ *         *current*\ **->mm->arg_start** and *current*\
+ *         **->mm->env_start**: using this helper and the return value,
+ *         one can quickly iterate at the right offset of the memory area.
+ *     Return
+ *         On success, the strictly positive length of the string,
+ *         including the trailing NUL character. On error, a negative
+ *         value.
+ *
+ * int bpf_probe_read_kernel_str(void *dst, u32 size, const void *unsafe_ptr)
+ *     Description
+ *         Copy a NUL terminated string from an unsafe kernel address *unsafe_ptr*
+ *         to *dst*. Same semantics as with bpf_probe_read_user_str() apply.
+ *     Return
+ *         On success, the strictly positive length of the string,    including
+ *         the trailing NUL character. On error, a negative value.
  */
 #define __BPF_FUNC_MAPPER(FN)        \
     FN(unspec),            \
@@ -2862,7 +2893,12 @@ union bpf_attr {
     FN(sk_storage_get),        \
     FN(sk_storage_delete),        \
     FN(send_signal),        \
-    FN(tcp_gen_syncookie),
+    FN(tcp_gen_syncookie),        \
+    FN(skb_output),            \
+    FN(probe_read_user),        \
+    FN(probe_read_kernel),        \
+    FN(probe_read_user_str),    \
+    FN(probe_read_kernel_str),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.25.1


