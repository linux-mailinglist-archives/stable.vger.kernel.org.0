Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DE94A4379
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359800AbiAaLVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50086 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359270AbiAaLQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:16:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18B606125A;
        Mon, 31 Jan 2022 11:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3D5C340E8;
        Mon, 31 Jan 2022 11:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627804;
        bh=9fgBVNgq6RGY40Q792fEXaIfV/J7zbIly9q8ulp5gc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pxjazB84qZqLvDB2bDRPmLNaA205aUjijXFCeDo5QzuAZ/sRGsWWGIEilWlNeSo7y
         DE/h/JvwhRgKdn3SSlQKqKZkcwCuw1OIvTIBYQmfKmx6Eo+/KW/sG/jZTEemuMfxkU
         N4CyEkdUs+AiOmYDwmeNxjkPLvA3gx8NXsu/S+MQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yordan Karadzhov <ykaradzhov@vmware.com>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.16 031/200] tracing: Propagate is_signed to expression
Date:   Mon, 31 Jan 2022 11:54:54 +0100
Message-Id: <20220131105234.619001978@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

commit 097f1eefedeab528cecbd35586dfe293853ffb17 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2487,6 +2487,8 @@ static struct hist_field *parse_unary(st
 		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS);
 	expr->fn = hist_field_unary_minus;
 	expr->operands[0] = operand1;
+	expr->size = operand1->size;
+	expr->is_signed = operand1->is_signed;
 	expr->operator = FIELD_OP_UNARY_MINUS;
 	expr->name = expr_str(expr, 0);
 	expr->type = kstrdup_const(operand1->type, GFP_KERNEL);
@@ -2703,6 +2705,7 @@ static struct hist_field *parse_expr(str
 
 		/* The operand sizes should be the same, so just pick one */
 		expr->size = operand1->size;
+		expr->is_signed = operand1->is_signed;
 
 		expr->operator = field_op;
 		expr->type = kstrdup_const(operand1->type, GFP_KERNEL);


