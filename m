Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 662871196C6
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbfLJV3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:29:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728434AbfLJVKR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 829F8246A3;
        Tue, 10 Dec 2019 21:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012216;
        bh=zOKZqSf4jAxFn+TyXskDfTFMnxYCixEt7x57fI3Jy/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouuWJ2pzec7JHrkH0ep6Wy8PtDIpQoZur3iNfGtoJSls7SOoP4vXpVDirJbkY7QjM
         TcIskpnz3PhUw7RxyZ3936pt6lbDjW71sZUdRCMHZ7QvMmcxnlKBilY7WWIdxr5+Lq
         Ot5+HdXyBdn/ikPMjErl16WKJwQvLLFtu/neQrao=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, cyphar@cyphar.com,
        keescook@chromium.org, linux@rasmusvillemoes.dk,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 167/350] ubsan, x86: Annotate and allow __ubsan_handle_shift_out_of_bounds() in uaccess regions
Date:   Tue, 10 Dec 2019 16:04:32 -0500
Message-Id: <20191210210735.9077-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 9a50dcaf0416a43e1fe411dc61a99c8333c90119 ]

The new check_zeroed_user() function uses variable shifts inside of a
user_access_begin()/user_access_end() section and that results in GCC
emitting __ubsan_handle_shift_out_of_bounds() calls, even though
through value range analysis it would be able to see that the UB in
question is impossible.

Annotate and whitelist this UBSAN function; continued use of
user_access_begin()/user_access_end() will undoubtedly result in
further uses of function.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: cyphar@cyphar.com
Cc: keescook@chromium.org
Cc: linux@rasmusvillemoes.dk
Fixes: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")
Link: https://lkml.kernel.org/r/20191021131149.GA19358@hirez.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/ubsan.c           | 5 ++++-
 tools/objtool/check.c | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/ubsan.c b/lib/ubsan.c
index e7d31735950de..0c4681118fcd2 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -374,9 +374,10 @@ void __ubsan_handle_shift_out_of_bounds(struct shift_out_of_bounds_data *data,
 	struct type_descriptor *lhs_type = data->lhs_type;
 	char rhs_str[VALUE_LENGTH];
 	char lhs_str[VALUE_LENGTH];
+	unsigned long ua_flags = user_access_save();
 
 	if (suppress_report(&data->location))
-		return;
+		goto out;
 
 	ubsan_prologue(&data->location, &flags);
 
@@ -402,6 +403,8 @@ void __ubsan_handle_shift_out_of_bounds(struct shift_out_of_bounds_data *data,
 			lhs_type->type_name);
 
 	ubsan_epilogue(&flags);
+out:
+	user_access_restore(ua_flags);
 }
 EXPORT_SYMBOL(__ubsan_handle_shift_out_of_bounds);
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 543c068096b12..4768d91c6d686 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -482,6 +482,7 @@ static const char *uaccess_safe_builtin[] = {
 	"ubsan_type_mismatch_common",
 	"__ubsan_handle_type_mismatch",
 	"__ubsan_handle_type_mismatch_v1",
+	"__ubsan_handle_shift_out_of_bounds",
 	/* misc */
 	"csum_partial_copy_generic",
 	"__memcpy_mcsafe",
-- 
2.20.1

