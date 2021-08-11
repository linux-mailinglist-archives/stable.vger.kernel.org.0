Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EDD3E8B29
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 09:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbhHKHkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 03:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235491AbhHKHkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 03:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C9086056B;
        Wed, 11 Aug 2021 07:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628667588;
        bh=xEewjdDdfE0mxlx8ul99HQBHj3kH3dks4WnvkOwjcEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UysuxZinq96f0aDMySjvO+TQYL7grnpKjqaJel6DntTYNC+Ur2NybP5WLoDHgwqj4
         ZB4H0+lEhb4jAfTXdmHE6wc5/hqHb917bGTjACcm12QoemP6IVdS6Hmmj5CUhyNJz2
         zaaVchMwEJxAdtRgMjVLjOBegi1EebNA4GHLBbHyH621LTfV6LN/crmiMgcr5h1+c3
         XNkevUVj9samnOCEBHoU5Ha2FCbi/PRdkBf46DqxbdVN0y//lGHLXDMTy3PUTG9p+Z
         jBXK6gKcSt4YEXIHIk2BlhOytkqCjztL3LlG+4FWyBMALevFqmuGroDB5wbvYMv3/5
         UZjYlobHH76Rg==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     mhiramat@kernel.org, rostedt@goodmis.org
Subject: [PATCH 4.19.y] tracing: Reject string operand in the histogram expression
Date:   Wed, 11 Aug 2021 16:39:46 +0900
Message-Id: <162866758593.360697.15659863374890557625.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <162850048982205@kroah.com>
References: <162850048982205@kroah.com>
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
 - Since there is no hist_err() APIs in 4.19, this just check the flag
   and return an error without any error messages.
---
 kernel/trace/trace_events_hist.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 28e4ff45cb4c..e9106c976a48 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2781,6 +2781,12 @@ static struct hist_field *parse_unary(struct hist_trigger_data *hist_data,
 		ret = PTR_ERR(operand1);
 		goto free;
 	}
+	if (operand1->flags & HIST_FIELD_FL_STRING) {
+		/* String type can not be the operand of unary operator. */
+		destroy_hist_field(operand1, 0);
+		ret = -EINVAL;
+		goto free;
+	}
 
 	expr->flags |= operand1->flags &
 		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS);
@@ -2881,6 +2887,10 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
 		operand1 = NULL;
 		goto free;
 	}
+	if (operand1->flags & HIST_FIELD_FL_STRING) {
+		ret = -EINVAL;
+		goto free;
+	}
 
 	/* rest of string could be another expression e.g. b+c in a+b+c */
 	operand_flags = 0;
@@ -2890,6 +2900,10 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
 		operand2 = NULL;
 		goto free;
 	}
+	if (operand2->flags & HIST_FIELD_FL_STRING) {
+		ret = -EINVAL;
+		goto free;
+	}
 
 	ret = check_expr_operands(operand1, operand2);
 	if (ret)

