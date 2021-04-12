Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D66835BF39
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbhDLJDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239870AbhDLJB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADB3E6125F;
        Mon, 12 Apr 2021 08:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217984;
        bh=kO2E0vSvri/q/aGGjNFCKIdR/saloXrxctn9XBnpA9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdxjbnKFnwWqmtfzhe98rrDN3ubGW9HnYlPIAESbhmWabjsReDBfcvAG7FBBWDjy2
         i2tZhD273dw/7XVlI6+dZXuoGsTHMAAuIrL98sHLMKc28kNOiBvyj+zU8NsL60711G
         LvLbZQHI2rctCqDbnlAfjqPsH2sUTj3Oth7LJrb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prasad Sodagudi <psodagud@quicinc.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 029/210] gcov: re-fix clang-11+ support
Date:   Mon, 12 Apr 2021 10:38:54 +0200
Message-Id: <20210412084016.976892511@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 9562fd132985ea9185388a112e50f2a51557827d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/gcov/clang.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/kernel/gcov/clang.c
+++ b/kernel/gcov/clang.c
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


