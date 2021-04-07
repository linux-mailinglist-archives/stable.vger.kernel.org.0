Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B6B357498
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 20:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344788AbhDGSzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 14:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbhDGSzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 14:55:14 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B88C061761
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 11:55:05 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 71so21841481ybl.0
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 11:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/gR9Ty4JZXDPsNPdLjznxvXioeerIHzHsL4Fen6xU1U=;
        b=kJ22aMNQIfFXGVMQiKwfbQW3A8aS4n5OKTXXtKoy2tOtKbZ5sveNWwXkW41JRZ1+2I
         P13YGxxyK+57NNHrszU/vP1yleMjLLDk3bW1VEAdo6X6v8iqysIGAG7AdkrssBHdHQBo
         XHYZhCKlY78qBBUwIIuVsOAxavnwdZoPmOBmyBkapOEmcEfnxiwxlEIjLOgv10UBHAEz
         UocGhah+miptm6iW/OQbdxMXbVF1RUwO511bHCbpdT6R5nz3QWP51rlgWVeJv6w0PkIz
         h1VyApQQ8i0OOkV905dB8upSt0ykYhk9v1oZd9l11Pdp4m6VmpU+iJlpyTgHM5pO6P95
         MeJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/gR9Ty4JZXDPsNPdLjznxvXioeerIHzHsL4Fen6xU1U=;
        b=g+nfcVGf0vo4PaK9PHoYDW9i2hlFFl1te1DnEVstHrN06XIY2acHHljGBSz4ZDm+B2
         8U6DcSCU93Gi3+j7fQV/UmIW8YtU+ZaoL/ib0sHNv3roLubf+8Skay6xIwuUTeY3Txli
         eM71TRmvcwu100gKOUVB1+fMZHQoN3mpNFtkQKJAPtRFLZGx18okHuZCttmvxh2BswWB
         7i91jiDU7AXwSWAlvs3tx8Th1HOOYfnZnJ1lPKWCoIkclQOLETw1RurEuListDvF1shH
         Cdprw0RDSpSdBKboM/ry0z6kFC9GSZeLIuPNGlETzaA+yf9WXj1yFhs+GOhcd+qjI39Y
         tw9g==
X-Gm-Message-State: AOAM533/2wZFyHDhWrhGDnItR4wKdlvtrzPVquRS86/5m/XSGp4uuqHK
        eC3knj413+hI84bGGteXBlN8/wTjA9+tJfJZwsw=
X-Google-Smtp-Source: ABdhPJwPMNy6IRcmExulR9MCR1vcQCNmfIHGc9HGamIK0SxX/x86lIIw/i0JtpjrWuCRXIPe2t60eNGwb5/pn+f5RhM=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:c454:8587:ce1c:e900])
 (user=ndesaulniers job=sendgmr) by 2002:a25:9108:: with SMTP id
 v8mr6177944ybl.460.1617821704165; Wed, 07 Apr 2021 11:55:04 -0700 (PDT)
Date:   Wed,  7 Apr 2021 11:54:55 -0700
In-Reply-To: <20210407185456.41943-1-ndesaulniers@google.com>
Message-Id: <20210407185456.41943-2-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20210407185456.41943-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH 1/2] gcov: re-fix clang-11+ support
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Peter Oberparleiter <oberpar@linux.ibm.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Fangrui Song <maskray@google.com>,
        Prasad Sodagudi <psodagud@quicinc.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org
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
---
 kernel/gcov/clang.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/kernel/gcov/clang.c b/kernel/gcov/clang.c
index d41f5ecda9db..1747204541bf 100644
--- a/kernel/gcov/clang.c
+++ b/kernel/gcov/clang.c
@@ -69,7 +69,9 @@ struct gcov_fn_info {
 
 	u32 ident;
 	u32 checksum;
+#if CONFIG_CLANG_VERSION < 110000
 	u8 use_extra_checksum;
+#endif
 	u32 cfg_checksum;
 
 	u32 num_counters;
@@ -111,6 +113,7 @@ void llvm_gcda_start_file(const char *orig_filename, u32 version, u32 checksum)
 }
 EXPORT_SYMBOL(llvm_gcda_start_file);
 
+#if CONFIG_CLANG_VERSION < 110000
 void llvm_gcda_emit_function(u32 ident, u32 func_checksum,
 		u8 use_extra_checksum, u32 cfg_checksum)
 {
@@ -126,6 +129,21 @@ void llvm_gcda_emit_function(u32 ident, u32 func_checksum,
 	info->cfg_checksum = cfg_checksum;
 	list_add_tail(&info->head, &current_info->functions);
 }
+#else
+void llvm_gcda_emit_function(u32 ident, u32 func_checksum, u32 cfg_checksum)
+{
+	struct gcov_fn_info *info = kzalloc(sizeof(*info), GFP_KERNEL);
+
+	if (!info)
+		return;
+
+	INIT_LIST_HEAD(&info->head);
+	info->ident = ident;
+	info->checksum = func_checksum;
+	info->cfg_checksum = cfg_checksum;
+	list_add_tail(&info->head, &current_info->functions);
+}
+#endif
 EXPORT_SYMBOL(llvm_gcda_emit_function);
 
 void llvm_gcda_emit_arcs(u32 num_counters, u64 *counters)
@@ -256,11 +274,16 @@ int gcov_info_is_compatible(struct gcov_info *info1, struct gcov_info *info2)
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
@@ -378,17 +401,22 @@ size_t convert_to_gcda(char *buffer, struct gcov_info *info)
 
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
-- 
2.31.1.295.g9ea45b61b8-goog

