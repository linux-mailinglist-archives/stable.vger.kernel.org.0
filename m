Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E20A3EB8B0
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241302AbhHMPP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242486AbhHMPOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A98FC6112D;
        Fri, 13 Aug 2021 15:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867629;
        bh=Gc/SZpxnY9PK3il6g3SOaosaSRoUaCLDr5Cug2sQylg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HBDBK4ZfUcvL1yMlVyRupmoA7/4PGu5InaIDN3oSoWtGsF4IIBB4aht19Z2rh4uz
         MSpeOs5agHk/0sbZr6AnbuJUmUmu3GGQHQzZnHUcA7WnechB9f5ViRxo4aDqaHpTQG
         MADbng50lbJY9rirklj9VvwGbntTSznO0BvUOwU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 04/27] tracing: Reject string operand in the histogram expression
Date:   Fri, 13 Aug 2021 17:07:02 +0200
Message-Id: <20210813150523.509525049@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
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
@@ -66,7 +66,8 @@
 	C(INVALID_SUBSYS_EVENT,	"Invalid subsystem or event name"),	\
 	C(INVALID_REF_KEY,	"Using variable references in keys not supported"), \
 	C(VAR_NOT_FOUND,	"Couldn't find variable"),		\
-	C(FIELD_NOT_FOUND,	"Couldn't find field"),
+	C(FIELD_NOT_FOUND,	"Couldn't find field"),			\
+	C(INVALID_STR_OPERAND,	"String type can not be an operand in expression"),
 
 #undef C
 #define C(a, b)		HIST_ERR_##a
@@ -3038,6 +3039,13 @@ static struct hist_field *parse_unary(st
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
@@ -3139,6 +3147,11 @@ static struct hist_field *parse_expr(str
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
@@ -3148,6 +3161,11 @@ static struct hist_field *parse_expr(str
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


