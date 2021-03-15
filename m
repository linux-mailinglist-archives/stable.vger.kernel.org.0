Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D168933C8E9
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 22:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhCOV5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 17:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231338AbhCOV5n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 17:57:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D881564F02;
        Mon, 15 Mar 2021 21:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615845463;
        bh=USBT0gsrBPJBvrzJvar2zf5pp00rcGlumJ9wrGYq8fA=;
        h=Date:From:To:Subject:From;
        b=BmXKdZvJzxEj8YvMOLbdQ+/ng9QvT3DL9fKnR1JJQZhIK+DBAggzINqJu3BUwbCQU
         N7NjKdhb2zOQAhb8amko/kagpx1OjcFE1Ib3M/4k69/HL3LG1ThuzEalwP/s+ZKFkP
         MlVw+EMRrJhI00EeozYBwVLUlZrdwrI3D34mds+I=
Date:   Mon, 15 Mar 2021 14:57:42 -0700
From:   akpm@linux-foundation.org
To:     maskray@google.com, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, oberpar@linux.ibm.com,
        psodagud@quicinc.com, stable@vger.kernel.org
Subject:  + gcov-fix-clang-11-support.patch added to -mm tree
Message-ID: <20210315215742.9KP0e4jO9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: gcov: fix clang-11+ support
has been added to the -mm tree.  Its filename is
     gcov-fix-clang-11-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gcov-fix-clang-11-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gcov-fix-clang-11-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: gcov: fix clang-11+ support

LLVM changed the expected function signatures for llvm_gcda_start_file()
and llvm_gcda_emit_function() in the clang-11 release.  Users of clang-11
or newer may have noticed their kernels failing to boot due to a panic
when enabling CONFIG_GCOV_KERNEL=y +CONFIG_GCOV_PROFILE_ALL=y.  Fix up the
function signatures so calling these functions doesn't panic the kernel.

Link: https://reviews.llvm.org/rGcdd683b516d147925212724b09ec6fb792a40041
Link: https://reviews.llvm.org/rG13a633b438b6500ecad9e4f936ebadf3411d0f44
Link: https://lkml.kernel.org/r/20210312224132.3413602-2-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: Prasad Sodagudi <psodagud@quicinc.com>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Fangrui Song <maskray@google.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/clang.c |   69 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

--- a/kernel/gcov/clang.c~gcov-fix-clang-11-support
+++ a/kernel/gcov/clang.c
@@ -75,7 +75,9 @@ struct gcov_fn_info {
 
 	u32 num_counters;
 	u64 *counters;
+#if CONFIG_CLANG_VERSION < 110000
 	const char *function_name;
+#endif
 };
 
 static struct gcov_info *current_info;
@@ -105,6 +107,7 @@ void llvm_gcov_init(llvm_gcov_callback w
 }
 EXPORT_SYMBOL(llvm_gcov_init);
 
+#if CONFIG_CLANG_VERSION < 110000
 void llvm_gcda_start_file(const char *orig_filename, const char version[4],
 		u32 checksum)
 {
@@ -113,7 +116,17 @@ void llvm_gcda_start_file(const char *or
 	current_info->checksum = checksum;
 }
 EXPORT_SYMBOL(llvm_gcda_start_file);
+#else
+void llvm_gcda_start_file(const char *orig_filename, u32 version, u32 checksum)
+{
+	current_info->filename = orig_filename;
+	current_info->version = version;
+	current_info->checksum = checksum;
+}
+EXPORT_SYMBOL(llvm_gcda_start_file);
+#endif
 
+#if CONFIG_CLANG_VERSION < 110000
 void llvm_gcda_emit_function(u32 ident, const char *function_name,
 		u32 func_checksum, u8 use_extra_checksum, u32 cfg_checksum)
 {
@@ -133,6 +146,24 @@ void llvm_gcda_emit_function(u32 ident,
 	list_add_tail(&info->head, &current_info->functions);
 }
 EXPORT_SYMBOL(llvm_gcda_emit_function);
+#else
+void llvm_gcda_emit_function(u32 ident, u32 func_checksum,
+		u8 use_extra_checksum, u32 cfg_checksum)
+{
+	struct gcov_fn_info *info = kzalloc(sizeof(*info), GFP_KERNEL);
+
+	if (!info)
+		return;
+
+	INIT_LIST_HEAD(&info->head);
+	info->ident = ident;
+	info->checksum = func_checksum;
+	info->use_extra_checksum = use_extra_checksum;
+	info->cfg_checksum = cfg_checksum;
+	list_add_tail(&info->head, &current_info->functions);
+}
+EXPORT_SYMBOL(llvm_gcda_emit_function);
+#endif
 
 void llvm_gcda_emit_arcs(u32 num_counters, u64 *counters)
 {
@@ -295,6 +326,7 @@ void gcov_info_add(struct gcov_info *dst
 	}
 }
 
+#if CONFIG_CLANG_VERSION < 110000
 static struct gcov_fn_info *gcov_fn_info_dup(struct gcov_fn_info *fn)
 {
 	size_t cv_size; /* counter values size */
@@ -322,6 +354,28 @@ err_name:
 	kfree(fn_dup);
 	return NULL;
 }
+#else
+static struct gcov_fn_info *gcov_fn_info_dup(struct gcov_fn_info *fn)
+{
+	size_t cv_size; /* counter values size */
+	struct gcov_fn_info *fn_dup = kmemdup(fn, sizeof(*fn),
+			GFP_KERNEL);
+	if (!fn_dup)
+		return NULL;
+	INIT_LIST_HEAD(&fn_dup->head);
+
+	cv_size = fn->num_counters * sizeof(fn->counters[0]);
+	fn_dup->counters = vmalloc(cv_size);
+	if (!fn_dup->counters) {
+		kfree(fn_dup);
+		return NULL;
+	}
+
+	memcpy(fn_dup->counters, fn->counters, cv_size);
+
+	return fn_dup;
+}
+#endif
 
 /**
  * gcov_info_dup - duplicate profiling data set
@@ -362,6 +416,7 @@ err:
  * gcov_info_free - release memory for profiling data set duplicate
  * @info: profiling data set duplicate to free
  */
+#if CONFIG_CLANG_VERSION < 110000
 void gcov_info_free(struct gcov_info *info)
 {
 	struct gcov_fn_info *fn, *tmp;
@@ -375,6 +430,20 @@ void gcov_info_free(struct gcov_info *in
 	kfree(info->filename);
 	kfree(info);
 }
+#else
+void gcov_info_free(struct gcov_info *info)
+{
+	struct gcov_fn_info *fn, *tmp;
+
+	list_for_each_entry_safe(fn, tmp, &info->functions, head) {
+		vfree(fn->counters);
+		list_del(&fn->head);
+		kfree(fn);
+	}
+	kfree(info->filename);
+	kfree(info);
+}
+#endif
 
 #define ITER_STRIDE	PAGE_SIZE
 
_

Patches currently in -mm which might be from ndesaulniers@google.com are

gcov-fix-clang-11-support.patch

