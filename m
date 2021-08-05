Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140503E18A2
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 17:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242401AbhHEPtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 11:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242344AbhHEPtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 11:49:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDD1260E78;
        Thu,  5 Aug 2021 15:49:36 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mBfcl-0037wR-TP; Thu, 05 Aug 2021 11:49:35 -0400
Message-ID: <20210805154935.750263326@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 05 Aug 2021 11:43:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, stable@vger.kernel.org
Subject: [for-linus][PATCH 2/6] tracing / histogram: Give calculation hist_fields a size
References: <20210805154336.208362117@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When working on my user space applications, I found a bug in the synthetic
event code where the automated synthetic event field was not matching the
event field calculation it was attached to. Looking deeper into it, it was
because the calculation hist_field was not given a size.

The synthetic event fields are matched to their hist_fields either by
having the field have an identical string type, or if that does not match,
then the size and signed values are used to match the fields.

The problem arose when I tried to match a calculation where the fields
were "unsigned int". My tool created a synthetic event of type "u32". But
it failed to match. The string was:

  diff=field1-field2:onmatch(event).trace(synth,$diff)

Adding debugging into the kernel, I found that the size of "diff" was 0.
And since it was given "unsigned int" as a type, the histogram fallback
code used size and signed. The signed matched, but the size of u32 (4) did
not match zero, and the event failed to be created.

This can be worse if the field you want to match is not one of the
acceptable fields for a synthetic event. As event fields can have any type
that is supported in Linux, this can cause an issue. For example, if a
type is an enum. Then there's no way to use that with any calculations.

Have the calculation field simply take on the size of what it is
calculating.

Link: https://lkml.kernel.org/r/20210730171951.59c7743f@oasis.local.home

Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Fixes: 100719dcef447 ("tracing: Add simple expression support to hist triggers")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 34325f41ebc0..362db9b81b8d 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2287,6 +2287,10 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
 
 	expr->operands[0] = operand1;
 	expr->operands[1] = operand2;
+
+	/* The operand sizes should be the same, so just pick one */
+	expr->size = operand1->size;
+
 	expr->operator = field_op;
 	expr->name = expr_str(expr, 0);
 	expr->type = kstrdup(operand1->type, GFP_KERNEL);
-- 
2.30.2
