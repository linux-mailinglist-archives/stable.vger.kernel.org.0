Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F083E8068
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhHJRsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236536AbhHJRqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:46:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9065261250;
        Tue, 10 Aug 2021 17:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617243;
        bh=wYNRb5K+W5Sb+ruNgoPPWVVHC9OHvcJNXq68vjnx3aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvXIcRKDCcDkHoyiBByEsd/br77q0Y9mHST/z8LMPH0yvS6BvJHe6MsMxgXhHPn58
         yircaPOVBQkeF46AlZZTxZYdxF6bMy/ndXAeI6YgRHit9FPwIALm620EjWJI6ZEeaH
         46DusGHi79e63GaOCZzmZXb3UOG/fvF+0aoi0y+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 075/135] tracing / histogram: Give calculation hist_fields a size
Date:   Tue, 10 Aug 2021 19:30:09 +0200
Message-Id: <20210810172958.273678036@linuxfoundation.org>
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

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 2c05caa7ba8803209769b9e4fe02c38d77ae88d0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2271,6 +2271,10 @@ static struct hist_field *parse_expr(str
 
 	expr->operands[0] = operand1;
 	expr->operands[1] = operand2;
+
+	/* The operand sizes should be the same, so just pick one */
+	expr->size = operand1->size;
+
 	expr->operator = field_op;
 	expr->name = expr_str(expr, 0);
 	expr->type = kstrdup(operand1->type, GFP_KERNEL);


