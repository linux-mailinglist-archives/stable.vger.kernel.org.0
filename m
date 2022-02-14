Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF9F4B468E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbiBNJrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:47:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245307AbiBNJpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:45:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845AF60DA0;
        Mon, 14 Feb 2022 01:38:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D82611BC;
        Mon, 14 Feb 2022 09:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C6DC340E9;
        Mon, 14 Feb 2022 09:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831532;
        bh=rmFaxeqV0WmNFAlFuIswJzBEHxPusxQB4kPuyZQRoGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0iARKuZQ4ssUFCPolUDnifxeZszQfQkpGZ8yZDr72A2zNQA8X1Hu59wzkt5zTibS9
         6Y80f5ucQd/HW4PV6QuYzJKEeQPAhYC38wlGcPQwMXLEufVQfpGL5fHqliOXoL3yCv
         ryPPmDBgOBUvaTpUZEYWVloR/bTBdYilUC8BdHxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yordan Karadzhov <ykaradzhov@vmware.com>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.10 013/116] tracing: Propagate is_signed to expression
Date:   Mon, 14 Feb 2022 10:25:12 +0100
Message-Id: <20220214092459.143523020@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2154,6 +2154,8 @@ static struct hist_field *parse_unary(st
 		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS);
 	expr->fn = hist_field_unary_minus;
 	expr->operands[0] = operand1;
+	expr->size = operand1->size;
+	expr->is_signed = operand1->is_signed;
 	expr->operator = FIELD_OP_UNARY_MINUS;
 	expr->name = expr_str(expr, 0);
 	expr->type = kstrdup(operand1->type, GFP_KERNEL);
@@ -2293,6 +2295,7 @@ static struct hist_field *parse_expr(str
 
 	/* The operand sizes should be the same, so just pick one */
 	expr->size = operand1->size;
+	expr->is_signed = operand1->is_signed;
 
 	expr->operator = field_op;
 	expr->name = expr_str(expr, 0);


