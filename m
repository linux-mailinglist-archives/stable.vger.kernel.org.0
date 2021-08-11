Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF263E8B03
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 09:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhHKH1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 03:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231472AbhHKH1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 03:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACCBC60FC0;
        Wed, 11 Aug 2021 07:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628666803;
        bh=gRbnWmWNakZb4G+Eb6ZXZX4pQS050WinYWorVeHuM9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VL1F7THgs2MLdRPnp0+Pdt5yvZjttDc+NQEgZe2aD9jV7TvY9qUIpfQYHe4Mrhr9J
         vVs0PdZZqwSpOYdaQ2NLsgMsg9yaBuwa93IZBFIqkd/tUCVGdzE19WQpdpCLt7QMS5
         DkzVbJrawsE/ZE1YU/Lj8qgKqglDnvPzL2X71zUfvKqwp9Na0tqHzB42Fk6EtHVBgk
         tgrUrZHHbQnrwIlnX2ppYlK5LxpoSrISGOBr8q8WRDepCIClvp8bTdKVYlTNcZJeiG
         cacQB1kzirstSD5/Sk47gPutU2gcNiwPk3Kn9fcDnffkw+Sl9wLOFSXEqL0WSF6VnF
         O3ASiGm5eTu/A==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     mhiramat@kernel.org, Jianlin.Lv@arm.com, rostedt@goodmis.org
Subject: [PATCH 5.4.y] tracing: Reject string operand in the histogram expression
Date:   Wed, 11 Aug 2021 16:26:40 +0900
Message-Id: <162866680063.358788.9555707549581313393.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <162850049016165@kroah.com>
References: <162850049016165@kroah.com>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a9d10ca4986571bffc19778742d508cc8dd13e02 upstream

Since the string type can not be the target of the addition / subtraction
operation, it must be rejected. Without this fix, the string type silently
converted to digits.

Link: https://lkml.kernel.org/r/162742654278.290973.1523000673366456634.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 100719dcef447 ("tracing: Add simple expression support to hist triggers")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 553add1eb457..07d1d2465096 100644
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
@@ -3038,6 +3039,13 @@ static struct hist_field *parse_unary(struct hist_trigger_data *hist_data,
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
@@ -3139,6 +3147,11 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
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
@@ -3148,6 +3161,11 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
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

