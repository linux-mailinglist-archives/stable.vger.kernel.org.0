Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A945B1FFEF8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 01:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgFRX4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 19:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728227AbgFRX4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 19:56:41 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C9AF21532;
        Thu, 18 Jun 2020 23:56:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jm4Oe-003lPl-EY; Thu, 18 Jun 2020 19:56:40 -0400
Message-ID: <20200618235640.338463687@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 18 Jun 2020 19:56:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Divya Indi <divya.indi@oracle.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [for-linus][PATCH 08/17] sample-trace-array: Remove trace_array sample-instance
References: <20200618235556.451120786@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

Remove trace_array 'sample-instance' if kthread_run fails
in sample_trace_array_init().

Link: https://lkml.kernel.org/r/20200609135200.2206726-1-wangkefeng.wang@huawei.com

Cc: stable@vger.kernel.org
Fixes: 89ed42495ef4a ("tracing: Sample module to demonstrate kernel access to Ftrace instances.")
Reviewed-by: Divya Indi <divya.indi@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 samples/ftrace/sample-trace-array.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/samples/ftrace/sample-trace-array.c b/samples/ftrace/sample-trace-array.c
index 9e437f930280..6aba02a31c96 100644
--- a/samples/ftrace/sample-trace-array.c
+++ b/samples/ftrace/sample-trace-array.c
@@ -115,8 +115,12 @@ static int __init sample_trace_array_init(void)
 	trace_printk_init_buffers();
 
 	simple_tsk = kthread_run(simple_thread, NULL, "sample-instance");
-	if (IS_ERR(simple_tsk))
+	if (IS_ERR(simple_tsk)) {
+		trace_array_put(tr);
+		trace_array_destroy(tr);
 		return -1;
+	}
+
 	return 0;
 }
 
-- 
2.26.2


