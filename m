Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E201364CBBE
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 15:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238174AbiLNOCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 09:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238522AbiLNOCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 09:02:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6A1EE28;
        Wed, 14 Dec 2022 06:02:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4308561A8B;
        Wed, 14 Dec 2022 14:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC10C433F1;
        Wed, 14 Dec 2022 14:02:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1p5SKm-000gsr-2G;
        Wed, 14 Dec 2022 09:02:08 -0500
Message-ID: <20221214140208.571914729@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 14 Dec 2022 09:01:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Yang Jihong <yangjihong1@huawei.com>
Subject: [for-next][PATCH 1/8] tracing: Fix infinite loop in tracing_read_pipe on overflowed
 print_trace_line
References: <20221214140133.608431204@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Jihong <yangjihong1@huawei.com>

print_trace_line may overflow seq_file buffer. If the event is not
consumed, the while loop keeps peeking this event, causing a infinite loop.

Link: https://lkml.kernel.org/r/20221129113009.182425-1-yangjihong1@huawei.com

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 088b1e427dbba ("ftrace: pipe fixes")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 664619b3f1e1..548890c7c0f5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6802,7 +6802,20 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 		ret = print_trace_line(iter);
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
-			/* don't print partial lines */
+			/*
+			 * If one print_trace_line() fills entire trace_seq in one shot,
+			 * trace_seq_to_user() will returns -EBUSY because save_len == 0,
+			 * In this case, we need to consume it, otherwise, loop will peek
+			 * this event next time, resulting in an infinite loop.
+			 */
+			if (save_len == 0) {
+				iter->seq.full = 0;
+				trace_seq_puts(&iter->seq, "[LINE TOO BIG]\n");
+				trace_consume(iter);
+				break;
+			}
+
+			/* In other cases, don't print partial lines */
 			iter->seq.seq.len = save_len;
 			break;
 		}
-- 
2.35.1


