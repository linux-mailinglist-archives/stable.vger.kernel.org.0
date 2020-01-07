Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D6913332D
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgAGVQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:16:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729429AbgAGVGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:06:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668FB20880;
        Tue,  7 Jan 2020 21:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431211;
        bh=oODlMwsWmP0uvjxAg9CsM/Q88SZXX7bpWTVuq85UzJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1JcwhTLbA8OKec+iIEmYs9dx2GCckkQGE7SjH9Cn9CUH4O2jYPc8IFeWPbWdxq48S
         7aGshdCT7NO0Q6cgqGmPfEbGStOk9xwfjKhfMAwi/Zjx1we+L7MWNSISHYC2oxbuzy
         EcsIatVSwQBVdyT5uCmQJIDqYjlBKC2TKRjoFYac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 078/115] ftrace: Avoid potential division by zero in function profiler
Date:   Tue,  7 Jan 2020 21:54:48 +0100
Message-Id: <20200107205304.479906634@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

commit e31f7939c1c27faa5d0e3f14519eaf7c89e8a69d upstream.

The ftrace_profile->counter is unsigned long and
do_div truncates it to 32 bits, which means it can test
non-zero and be truncated to zero for division.
Fix this issue by using div64_ul() instead.

Link: http://lkml.kernel.org/r/20200103030248.14516-1-wenyang@linux.alibaba.com

Cc: stable@vger.kernel.org
Fixes: e330b3bcd8319 ("tracing: Show sample std dev in function profiling")
Fixes: 34886c8bc590f ("tracing: add average time in function to function profiler")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -554,8 +554,7 @@ static int function_stat_show(struct seq
 	}
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	avg = rec->time;
-	do_div(avg, rec->counter);
+	avg = div64_ul(rec->time, rec->counter);
 	if (tracing_thresh && (avg < tracing_thresh))
 		goto out;
 #endif
@@ -581,7 +580,8 @@ static int function_stat_show(struct seq
 		 * Divide only 1000 for ns^2 -> us^2 conversion.
 		 * trace_print_graph_duration will divide 1000 again.
 		 */
-		do_div(stddev, rec->counter * (rec->counter - 1) * 1000);
+		stddev = div64_ul(stddev,
+				  rec->counter * (rec->counter - 1) * 1000);
 	}
 
 	trace_seq_init(&s);


