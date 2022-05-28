Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3FD536A4A
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 04:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353024AbiE1Cwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 22:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiE1Cww (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 22:52:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08193880C6;
        Fri, 27 May 2022 19:52:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98A9B61D29;
        Sat, 28 May 2022 02:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E88C34114;
        Sat, 28 May 2022 02:52:50 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1numZN-000LKR-0j;
        Fri, 27 May 2022 22:52:49 -0400
Message-ID: <20220528025248.861126787@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 27 May 2022 22:50:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [for-next][PATCH 01/23] tracing: Have event format check not flag %p* on
 __get_dynamic_array()
References: <20220528025028.850906216@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The print fmt check against trace events to make sure that the format does
not use pointers that may be freed from the time of the trace to the time
the event is read, gives a false positive on %pISpc when reading data that
was saved in __get_dynamic_array() when it is perfectly fine to do so, as
the data being read is on the ring buffer.

Link: https://lore.kernel.org/all/20220407144524.2a592ed6@canb.auug.org.au/

Cc: stable@vger.kernel.org
Fixes: 5013f454a352c ("tracing: Add check of trace event print fmts for dereferencing pointers")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 78f313b7b315..d5913487821a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -392,12 +392,6 @@ static void test_event_printk(struct trace_event_call *call)
 			if (!(dereference_flags & (1ULL << arg)))
 				goto next_arg;
 
-			/* Check for __get_sockaddr */;
-			if (str_has_prefix(fmt + i, "__get_sockaddr(")) {
-				dereference_flags &= ~(1ULL << arg);
-				goto next_arg;
-			}
-
 			/* Find the REC-> in the argument */
 			c = strchr(fmt + i, ',');
 			r = strstr(fmt + i, "REC->");
@@ -413,7 +407,14 @@ static void test_event_printk(struct trace_event_call *call)
 				a = strchr(fmt + i, '&');
 				if ((a && (a < r)) || test_field(r, call))
 					dereference_flags &= ~(1ULL << arg);
+			} else if ((r = strstr(fmt + i, "__get_dynamic_array(")) &&
+				   (!c || r < c)) {
+				dereference_flags &= ~(1ULL << arg);
+			} else if ((r = strstr(fmt + i, "__get_sockaddr(")) &&
+				   (!c || r < c)) {
+				dereference_flags &= ~(1ULL << arg);
 			}
+
 		next_arg:
 			i--;
 			arg++;
-- 
2.35.1
