Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98366358CE1
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 20:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhDHSqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 14:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbhDHSqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 14:46:50 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB2AC061761
        for <stable@vger.kernel.org>; Thu,  8 Apr 2021 11:46:39 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id h26so1659119qtm.13
        for <stable@vger.kernel.org>; Thu, 08 Apr 2021 11:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6gAnMk/3QmoHKKKOynZbE6ARTru22AXVPx9J9ennqYk=;
        b=CsxGIoVitXO3OMbftljWu8Ki/FTK07cSA2VhLFY87N/obK/8HhQZTl3uWoLXcLQY+9
         5XeUpzxisdaS1wXSrhGdjDUBgEN1xJqho2avlRpMrJ7x7wFuZZVox4bm9t8ME1fvefAB
         73l3UAuQ3P/qkAZ3I0b8k8OxQAk/XlFrKuzbvy75sQxwVEfiGZu38eaC8C/qvX7fr3F4
         wpBLuRw7iEovcshgem96DIb8CJLc4UWoFJ8pbS73TaWo3YhI1iQvwHvOsyTBv5bMBF4d
         8BMw9g/iWrTuB6XFmPbApdr7P7ADW4iVgnCP/7uCEimfRvK7CcPlJ56vNkQfvR971+Nm
         z5Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6gAnMk/3QmoHKKKOynZbE6ARTru22AXVPx9J9ennqYk=;
        b=N0fb/J8MfTRuje84PsPofkl75GlY0ojFm3SeoE+3Na2ZvlVRyONko77JTPcwcutQjZ
         /g3MCTU8NevbjbzTruOz++q9a8DerWVQ7E6LFvmo4kdvgtrMhXm2ihz4PROAufNn3YvQ
         YP16WYVtpx//7rHXECv2d2arTW7MlO+YewN21yQn2177DJLeVhu2XAoH4WCMUmauVnl6
         KrEI49zAO1K0HAG3H7a0Gx73NSXfQYnq23F80H/9Kh2ebxqB2vc6OPgbZ1j+TR1l9ngI
         BZZxzCMvxEw7CWT6SYAl/xiUs6YyJMns5dsfkfU/IIxntGcQErFlLhntOIEKguXBg1ZA
         yTkw==
X-Gm-Message-State: AOAM531HasooV5R2VonzIsLFyW2aOis2Rffg6d0eh1Lq15waitWroanw
        6jh6XQlRPE73kj4NVvLhpRVDAMgJRt+Y2pSc6no=
X-Google-Smtp-Source: ABdhPJx+2L0KBR1ZPGbYTlVAcnVbbQqhcwdmzzAvpjnvX13zyvL6J85xqR1BgJt7Q//RHnzPLAzwNyrX2hirSOEK2yc=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:258e:3713:7415:ce58])
 (user=ndesaulniers job=sendgmr) by 2002:a05:6214:2628:: with SMTP id
 gv8mr10352013qvb.19.1617907598457; Thu, 08 Apr 2021 11:46:38 -0700 (PDT)
Date:   Thu,  8 Apr 2021 11:46:31 -0700
In-Reply-To: <20210407152621.3826f93e893c0cf9b327071f@linux-foundation.org>
Message-Id: <20210408184631.1156669-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20210407152621.3826f93e893c0cf9b327071f@linux-foundation.org>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH v2] gcov: re-fix clang-11+ support
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     akpm@linux-foundation.org
Cc:     clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        maskray@google.com, nathan@kernel.org, ndesaulniers@google.com,
        oberpar@linux.ibm.com, psodagud@quicinc.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LLVM changed the expected function signature for
llvm_gcda_emit_function() in the clang-11 release.  Users of clang-11 or
newer may have noticed their kernels producing invalid coverage
information:

$ llvm-cov gcov -a -c -u -f -b <input>.gcda -- gcno=<input>.gcno
1 <func>: checksum mismatch, \
  (<lineno chksum A>, <cfg chksum B>) != (<lineno chksum A>, <cfg chksum C>)
2 Invalid .gcda File!
...

Fix up the function signatures so calling this function interprets its
parameters correctly and computes the correct cfg checksum. In
particular, in clang-11, the additional checksum is no longer optional.

Link: https://reviews.llvm.org/rG25544ce2df0daa4304c07e64b9c8b0f7df60c11d
Cc: stable@vger.kernel.org #5.4+
Reported-by: Prasad Sodagudi <psodagud@quicinc.com>
Tested-by: Prasad Sodagudi <psodagud@quicinc.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
---
Changes V1 -> V2:
* Carried Nathan's reviewed-by tag.
* Rebased on mainline, as per Andrew.
* Left off patch 2/2 from the series
https://lore.kernel.org/lkml/20210407185456.41943-1-ndesaulniers@google.com/
  I assume that dropping support for clang-10+GCOV will be held
  separately for -next for 5.13, while this will be sent for 5.12?

 kernel/gcov/clang.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/kernel/gcov/clang.c b/kernel/gcov/clang.c
index 8743150db2ac..c466c7fbdece 100644
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
@@ -145,10 +147,8 @@ void llvm_gcda_emit_function(u32 ident, const char *function_name,
 
 	list_add_tail(&info->head, &current_info->functions);
 }
-EXPORT_SYMBOL(llvm_gcda_emit_function);
 #else
-void llvm_gcda_emit_function(u32 ident, u32 func_checksum,
-		u8 use_extra_checksum, u32 cfg_checksum)
+void llvm_gcda_emit_function(u32 ident, u32 func_checksum, u32 cfg_checksum)
 {
 	struct gcov_fn_info *info = kzalloc(sizeof(*info), GFP_KERNEL);
 
@@ -158,12 +158,11 @@ void llvm_gcda_emit_function(u32 ident, u32 func_checksum,
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
@@ -293,11 +292,16 @@ int gcov_info_is_compatible(struct gcov_info *info1, struct gcov_info *info2)
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
@@ -529,17 +533,22 @@ static size_t convert_to_gcda(char *buffer, struct gcov_info *info)
 
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

base-commit: 3fb4f979b4fa1f92a02b538ae86e725b73e703d0
-- 
2.31.1.295.g9ea45b61b8-goog

