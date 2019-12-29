Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E153812C818
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731957AbfL2Ru4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:50:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731972AbfL2Ru4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B88320718;
        Sun, 29 Dec 2019 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641854;
        bh=eyMennrsYxgBk8lQdqcO0vm1enPfe43n+1GlBfz2JkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5Hpuk+PoMNhbKTgx+W9ob4TFVa3yn7ILKfw0rZ0XSXDw1CFCQRUhoYD5hLnEmwpd
         SoehZxbbnalmd7FpkEo96vPWUllGGyK1FW1CGcDx8ntIeNH6mSxArA5YLmrPMgyK37
         6b0cZxyk9PQ/aXFbTyczW7WEcz0jAP7tMJBnlTT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, cyphar@cyphar.com,
        keescook@chromium.org, linux@rasmusvillemoes.dk,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 196/434] ubsan, x86: Annotate and allow __ubsan_handle_shift_out_of_bounds() in uaccess regions
Date:   Sun, 29 Dec 2019 18:24:09 +0100
Message-Id: <20191229172714.846581295@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e7d31735950d..0c4681118fcd 100644
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
index 044c9a3cb247..f53d3c515cdc 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -481,6 +481,7 @@ static const char *uaccess_safe_builtin[] = {
 	"ubsan_type_mismatch_common",
 	"__ubsan_handle_type_mismatch",
 	"__ubsan_handle_type_mismatch_v1",
+	"__ubsan_handle_shift_out_of_bounds",
 	/* misc */
 	"csum_partial_copy_generic",
 	"__memcpy_mcsafe",
-- 
2.20.1



