Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6373359365
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 05:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhDIDtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 23:49:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233234AbhDIDtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Apr 2021 23:49:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9653061055;
        Fri,  9 Apr 2021 03:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617940149;
        bh=0gUWXb3/doFw11CsQ5dxmRy4Vyr8oi5eKYlMmI2lp8Y=;
        h=Date:From:To:Subject:From;
        b=WI4xvS3fURCKxu1E3aXhjfbe0mZCLhbKj6kYBvvxnkd+LbVt4tGFp76zGkySR70T0
         NONhSB0akpgTHvwdcI2RWBbVG3FbMVBHI/HYShxPK5+UwmwrWDQ6FkslqlPz9IkAgd
         v+VupFREXkqmYoXZkH/V0Rc0049yKkEIoAbqdI0k=
Date:   Thu, 08 Apr 2021 20:49:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, psodagud@quicinc.com,
        stable@vger.kernel.org
Subject:  + gcov-re-fix-clang-11-support.patch added to -mm tree
Message-ID: <20210409034909.Jv0bVKDo3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: gcov: re-fix clang-11+ support
has been added to the -mm tree.  Its filename is
     gcov-re-fix-clang-11-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gcov-re-fix-clang-11-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gcov-re-fix-clang-11-support.patch

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
Subject: gcov: re-fix clang-11+ support

LLVM changed the expected function signature for llvm_gcda_emit_function()
in the clang-11 release.  Users of clang-11 or newer may have noticed
their kernels producing invalid coverage information:

$ llvm-cov gcov -a -c -u -f -b <input>.gcda -- gcno=<input>.gcno
1 <func>: checksum mismatch, \
  (<lineno chksum A>, <cfg chksum B>) != (<lineno chksum A>, <cfg chksum C>)
2 Invalid .gcda File!
...

Fix up the function signatures so calling this function interprets its
parameters correctly and computes the correct cfg checksum.  In
particular, in clang-11, the additional checksum is no longer optional.

Link: https://reviews.llvm.org/rG25544ce2df0daa4304c07e64b9c8b0f7df60c11d
Link: https://lkml.kernel.org/r/20210408184631.1156669-1-ndesaulniers@google.com
Reported-by: Prasad Sodagudi <psodagud@quicinc.com>
Tested-by: Prasad Sodagudi <psodagud@quicinc.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: <stable@vger.kernel.org>	[5.4+]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/clang.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/kernel/gcov/clang.c~gcov-re-fix-clang-11-support
+++ a/kernel/gcov/clang.c
@@ -70,7 +70,9 @@ struct gcov_fn_info {
 
 	u32 ident;
 	u32 checksum;
+#if CONFIG_CLANG_VERSION < 110000
 	u8 use_extra_checksum;
+#endif
 	u32 cfg_checksum;
 
 	u32 num_counters;
@@ -145,10 +147,8 @@ void llvm_gcda_emit_function(u32 ident,
 
 	list_add_tail(&info->head, &current_info->functions);
 }
-EXPORT_SYMBOL(llvm_gcda_emit_function);
 #else
-void llvm_gcda_emit_function(u32 ident, u32 func_checksum,
-		u8 use_extra_checksum, u32 cfg_checksum)
+void llvm_gcda_emit_function(u32 ident, u32 func_checksum, u32 cfg_checksum)
 {
 	struct gcov_fn_info *info = kzalloc(sizeof(*info), GFP_KERNEL);
 
@@ -158,12 +158,11 @@ void llvm_gcda_emit_function(u32 ident,
 	INIT_LIST_HEAD(&info->head);
 	info->ident = ident;
 	info->checksum = func_checksum;
-	info->use_extra_checksum = use_extra_checksum;
 	info->cfg_checksum = cfg_checksum;
 	list_add_tail(&info->head, &current_info->functions);
 }
-EXPORT_SYMBOL(llvm_gcda_emit_function);
 #endif
+EXPORT_SYMBOL(llvm_gcda_emit_function);
 
 void llvm_gcda_emit_arcs(u32 num_counters, u64 *counters)
 {
@@ -293,11 +292,16 @@ int gcov_info_is_compatible(struct gcov_
 		!list_is_last(&fn_ptr2->head, &info2->functions)) {
 		if (fn_ptr1->checksum != fn_ptr2->checksum)
 			return false;
+#if CONFIG_CLANG_VERSION < 110000
 		if (fn_ptr1->use_extra_checksum != fn_ptr2->use_extra_checksum)
 			return false;
 		if (fn_ptr1->use_extra_checksum &&
 			fn_ptr1->cfg_checksum != fn_ptr2->cfg_checksum)
 			return false;
+#else
+		if (fn_ptr1->cfg_checksum != fn_ptr2->cfg_checksum)
+			return false;
+#endif
 		fn_ptr1 = list_next_entry(fn_ptr1, head);
 		fn_ptr2 = list_next_entry(fn_ptr2, head);
 	}
@@ -529,17 +533,22 @@ static size_t convert_to_gcda(char *buff
 
 	list_for_each_entry(fi_ptr, &info->functions, head) {
 		u32 i;
-		u32 len = 2;
-
-		if (fi_ptr->use_extra_checksum)
-			len++;
 
 		pos += store_gcov_u32(buffer, pos, GCOV_TAG_FUNCTION);
-		pos += store_gcov_u32(buffer, pos, len);
+#if CONFIG_CLANG_VERSION < 110000
+		pos += store_gcov_u32(buffer, pos,
+			fi_ptr->use_extra_checksum ? 3 : 2);
+#else
+		pos += store_gcov_u32(buffer, pos, 3);
+#endif
 		pos += store_gcov_u32(buffer, pos, fi_ptr->ident);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->checksum);
+#if CONFIG_CLANG_VERSION < 110000
 		if (fi_ptr->use_extra_checksum)
 			pos += store_gcov_u32(buffer, pos, fi_ptr->cfg_checksum);
+#else
+		pos += store_gcov_u32(buffer, pos, fi_ptr->cfg_checksum);
+#endif
 
 		pos += store_gcov_u32(buffer, pos, GCOV_TAG_COUNTER_BASE);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->num_counters * 2);
_

Patches currently in -mm which might be from ndesaulniers@google.com are

gcov-re-fix-clang-11-support.patch
gcov-clang-drop-support-for-clang-10-and-older.patch

