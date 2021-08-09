Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF643E4241
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 11:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbhHIJPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 05:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234157AbhHIJPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 05:15:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D72BB6101D;
        Mon,  9 Aug 2021 09:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628500500;
        bh=Y5miPN2bAchfzTwSAbu2ABqZRNCaICsvHN7pSynHdWo=;
        h=Subject:To:Cc:From:Date:From;
        b=X5aAiXBNCXl+OStHWTFGfbH/uJSuJGheGLVs5mNQ1R4S3UyEeRtleKBGl3xhWPXdp
         tgKz4hYzmfqSWPDzG71FA+tCFWLH0hlWTSpB2A/WgZ7N7hNjGM6ybKn66fyFuNien7
         833dSK45C/Tt4X+j/Gk/DwaykleEYo2Mh3P7XQLg=
Subject: FAILED: patch "[PATCH] tracing: Reject string operand in the histogram expression" failed to apply to 5.4-stable tree
To:     mhiramat@kernel.org, rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Aug 2021 11:14:50 +0200
Message-ID: <162850049016165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a9d10ca4986571bffc19778742d508cc8dd13e02 Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Wed, 28 Jul 2021 07:55:43 +0900
Subject: [PATCH] tracing: Reject string operand in the histogram expression

Since the string type can not be the target of the addition / subtraction
operation, it must be rejected. Without this fix, the string type silently
converted to digits.

Link: https://lkml.kernel.org/r/162742654278.290973.1523000673366456634.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 100719dcef447 ("tracing: Add simple expression support to hist triggers")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 362db9b81b8d..949ef09dc537 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -65,7 +65,8 @@
 	C(INVALID_SORT_MODIFIER,"Invalid sort modifier"),		\
 	C(EMPTY_SORT_FIELD,	"Empty sort field"),			\
 	C(TOO_MANY_SORT_FIELDS,	"Too many sort fields (Max = 2)"),	\
-	C(INVALID_SORT_FIELD,	"Sort field must be a key or a val"),
+	C(INVALID_SORT_FIELD,	"Sort field must be a key or a val"),	\
+	C(INVALID_STR_OPERAND,	"String type can not be an operand in expression"),
 
 #undef C
 #define C(a, b)		HIST_ERR_##a
@@ -2156,6 +2157,13 @@ static struct hist_field *parse_unary(struct hist_trigger_data *hist_data,
 		ret = PTR_ERR(operand1);
 		goto free;
 	}
+	if (operand1->flags & HIST_FIELD_FL_STRING) {
+		/* String type can not be the operand of unary operator. */
+		hist_err(file->tr, HIST_ERR_INVALID_STR_OPERAND, errpos(str));
+		destroy_hist_field(operand1, 0);
+		ret = -EINVAL;
+		goto free;
+	}
 
 	expr->flags |= operand1->flags &
 		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS);
@@ -2257,6 +2265,11 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
 		operand1 = NULL;
 		goto free;
 	}
+	if (operand1->flags & HIST_FIELD_FL_STRING) {
+		hist_err(file->tr, HIST_ERR_INVALID_STR_OPERAND, errpos(operand1_str));
+		ret = -EINVAL;
+		goto free;
+	}
 
 	/* rest of string could be another expression e.g. b+c in a+b+c */
 	operand_flags = 0;
@@ -2266,6 +2279,11 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
 		operand2 = NULL;
 		goto free;
 	}
+	if (operand2->flags & HIST_FIELD_FL_STRING) {
+		hist_err(file->tr, HIST_ERR_INVALID_STR_OPERAND, errpos(str));
+		ret = -EINVAL;
+		goto free;
+	}
 
 	ret = check_expr_operands(file->tr, operand1, operand2);
 	if (ret)

