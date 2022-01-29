Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB2B4A2F7B
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 13:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241633AbiA2Mqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 07:46:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57964 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239539AbiA2Mqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 07:46:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FB92B827B5
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 12:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C046C340E5;
        Sat, 29 Jan 2022 12:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643460401;
        bh=jWWj8csJYJBs1wfdiXQP+uXD/TvW2ppDaVH2XRatlGg=;
        h=Subject:To:Cc:From:Date:From;
        b=mux1iHuGyhJd0j4QRhZVXIoofqiBKwswRYAvJEJsVaAvcFuCZ7wB11Fo5iXk1DrN1
         wpB+i3NL8ncBnAmxuu8kSaN//BqrDlboxrv9SilRLdF3CJpgEdcPT8dSIrKJZ/YLVx
         shG6/RqHyJxft+KTS/TPsWoZ4PD/Zq2pKbcBQ8uo=
Subject: FAILED: patch "[PATCH] tracing: Propagate is_signed to expression" failed to apply to 4.19-stable tree
To:     zanussi@kernel.org, rostedt@goodmis.org, ykaradzhov@vmware.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 13:46:39 +0100
Message-ID: <16434603993522@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 097f1eefedeab528cecbd35586dfe293853ffb17 Mon Sep 17 00:00:00 2001
From: Tom Zanussi <zanussi@kernel.org>
Date: Thu, 27 Jan 2022 15:44:17 -0600
Subject: [PATCH] tracing: Propagate is_signed to expression

During expression parsing, a new expression field is created which
should inherit the properties of the operands, such as size and
is_signed.

is_signed propagation was missing, causing spurious errors with signed
operands.  Add it in parse_expr() and parse_unary() to fix the problem.

Link: https://lkml.kernel.org/r/f4dac08742fd7a0920bf80a73c6c44042f5eaa40.1643319703.git.zanussi@kernel.org

Cc: stable@vger.kernel.org
Fixes: 100719dcef447 ("tracing: Add simple expression support to hist triggers")
Reported-by: Yordan Karadzhov <ykaradzhov@vmware.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215513
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index b894d68082ea..ada87bfb5bb8 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2503,6 +2503,8 @@ static struct hist_field *parse_unary(struct hist_trigger_data *hist_data,
 		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS);
 	expr->fn = hist_field_unary_minus;
 	expr->operands[0] = operand1;
+	expr->size = operand1->size;
+	expr->is_signed = operand1->is_signed;
 	expr->operator = FIELD_OP_UNARY_MINUS;
 	expr->name = expr_str(expr, 0);
 	expr->type = kstrdup_const(operand1->type, GFP_KERNEL);
@@ -2719,6 +2721,7 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
 
 		/* The operand sizes should be the same, so just pick one */
 		expr->size = operand1->size;
+		expr->is_signed = operand1->is_signed;
 
 		expr->operator = field_op;
 		expr->type = kstrdup_const(operand1->type, GFP_KERNEL);

