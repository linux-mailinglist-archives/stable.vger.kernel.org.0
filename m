Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E46BE81CD6
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbfHENY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731105AbfHENYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:24:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E99D2075B;
        Mon,  5 Aug 2019 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011494;
        bh=tF5l4vY/ZytGIGsA1ZiECEOzN6+zhjA3RpfxlO/nO/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqPYfOjbeW2C0shRLwAz/eh6Pxgw+s4OwsEA6HOp0LQzsSaf1brHczWuwngtG0ziy
         ssFMCsrnPRV9RqKxvTh/yD0PCq3KhsIAW3OmICFDeiVeyHozKkAkTND/z+RSDI4THt
         pRvQIkLgQqVBib/jx+BFvDCO+c+SjZHHB9laUS2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.2 082/131] fgraph: Remove redundant ftrace_graph_notrace_addr() test
Date:   Mon,  5 Aug 2019 15:02:49 +0200
Message-Id: <20190805124957.435614683@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>

commit 6c77221df96177da0520847ce91e33f539fb8b2d upstream.

We already have tested it before. The second one should be removed.
With this change, the performance should have little improvement.

Link: http://lkml.kernel.org/r/20190730140850.7927-1-changbin.du@gmail.com

Cc: stable@vger.kernel.org
Fixes: 9cd2992f2d6c ("fgraph: Have set_graph_notrace only affect function_graph tracer")
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_functions_graph.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -137,6 +137,13 @@ int trace_graph_entry(struct ftrace_grap
 	if (trace_recursion_test(TRACE_GRAPH_NOTRACE_BIT))
 		return 0;
 
+	/*
+	 * Do not trace a function if it's filtered by set_graph_notrace.
+	 * Make the index of ret stack negative to indicate that it should
+	 * ignore further functions.  But it needs its own ret stack entry
+	 * to recover the original index in order to continue tracing after
+	 * returning from the function.
+	 */
 	if (ftrace_graph_notrace_addr(trace->func)) {
 		trace_recursion_set(TRACE_GRAPH_NOTRACE_BIT);
 		/*
@@ -156,16 +163,6 @@ int trace_graph_entry(struct ftrace_grap
 		return 0;
 
 	/*
-	 * Do not trace a function if it's filtered by set_graph_notrace.
-	 * Make the index of ret stack negative to indicate that it should
-	 * ignore further functions.  But it needs its own ret stack entry
-	 * to recover the original index in order to continue tracing after
-	 * returning from the function.
-	 */
-	if (ftrace_graph_notrace_addr(trace->func))
-		return 1;
-
-	/*
 	 * Stop here if tracing_threshold is set. We only write function return
 	 * events to the ring buffer.
 	 */


