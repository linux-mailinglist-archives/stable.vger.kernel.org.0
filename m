Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D38534C829
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbhC2IUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233313AbhC2ITp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:19:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48FD961932;
        Mon, 29 Mar 2021 08:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005975;
        bh=TQSv2BXvLW+3o1IcqsLwhZpUcIGkmdd0YbR3yohtGzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z87b5AEYi+JKU7kqoLolF/b1MG+7ymc1CebpxEtKVPK9dtzsXcz0gnL7pZHOSqd+m
         hMC7TcuXNLgDo6VHZLWkhymSDmNd6i1deTFprFbu1Ra1GUTe+HnL8FL4Nfp4NQf4SF
         Hq6VBRgSpNE/dUTciXdQl1+mw9sTEEspaHTwwl4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Prasad Sodagudi <psodagud@quicinc.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 073/221] gcov: fix clang-11+ support
Date:   Mon, 29 Mar 2021 09:56:44 +0200
Message-Id: <20210329075631.623446266@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 60bcf728ee7c60ac2a1f9a0eaceb3a7b3954cd2b upstream.

LLVM changed the expected function signatures for llvm_gcda_start_file()
and llvm_gcda_emit_function() in the clang-11 release.  Users of
clang-11 or newer may have noticed their kernels failing to boot due to
a panic when enabling CONFIG_GCOV_KERNEL=y +CONFIG_GCOV_PROFILE_ALL=y.
Fix up the function signatures so calling these functions doesn't panic
the kernel.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/gcov/clang.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

--- a/kernel/gcov/clang.c
+++ b/kernel/gcov/clang.c
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
 


