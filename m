Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0AF3E806B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhHJRsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236221AbhHJRq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:46:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB18F61244;
        Tue, 10 Aug 2021 17:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617245;
        bh=yGcgg81hQyuFSu2gycDmdWaDhQk87dsk40QNIF5z+fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bnrf95Qb1Xc19M5hN7csOvl549jdTUJviMve8xZQyqJFEaYF53AjOs887BzNMKziD
         0CBIUCy5RvUwSysxwpP4hQdvsyUch43zzlu3ZcqoKOpH526AcpApMdozVYfKGi7I0Z
         WPTjDm6c7kgXdSRaS2bb6g3g/oMBWVeYqbegJRsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 076/135] tracing: Reject string operand in the histogram expression
Date:   Tue, 10 Aug 2021 19:30:10 +0200
Message-Id: <20210810172958.310402555@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit a9d10ca4986571bffc19778742d508cc8dd13e02 upstream.

Since the string type can not be the target of the addition / subtraction
operation, it must be rejected. Without this fix, the string type silently
converted to digits.

Link: https://lkml.kernel.org/r/162742654278.290973.1523000673366456634.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 100719dcef447 ("tracing: Add simple expression support to hist triggers")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

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
@@ -2140,6 +2141,13 @@ static struct hist_field *parse_unary(st
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
@@ -2241,6 +2249,11 @@ static struct hist_field *parse_expr(str
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
@@ -2250,6 +2263,11 @@ static struct hist_field *parse_expr(str
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


