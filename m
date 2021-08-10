Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5482D3E7E6F
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhHJRdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232070AbhHJRc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:32:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B25D60F41;
        Tue, 10 Aug 2021 17:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616757;
        bh=xaZu6tkYFf24mjrTiqt+gPN7MxQWXWLAQ0yVEU1hgRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ID6eL2gjU45l7Agt31DJbU7ZmUG6op8Ylhfz9OKthppig74QLVRJNGD0zFqOJG5gR
         k06r+vwpXikH0gQnnXMY3AEKdjo3Oj92FjzPhJXHfZPBBi58MBpbyA9yx8swflK6Oy
         0cL2CiLsNNfgUbldMiIOnU73MqC2m/Uq+ELNOYZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 33/54] tracing / histogram: Give calculation hist_fields a size
Date:   Tue, 10 Aug 2021 19:30:27 +0200
Message-Id: <20210810172945.272938083@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
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
@@ -2911,6 +2911,10 @@ static struct hist_field *parse_expr(str
 
 	expr->operands[0] = operand1;
 	expr->operands[1] = operand2;
+
+	/* The operand sizes should be the same, so just pick one */
+	expr->size = operand1->size;
+
 	expr->operator = field_op;
 	expr->name = expr_str(expr, 0);
 	expr->type = kstrdup(operand1->type, GFP_KERNEL);


