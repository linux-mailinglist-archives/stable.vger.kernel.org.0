Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748C559B0FE
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 02:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbiHUAIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 20:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbiHUAIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 20:08:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4147912748;
        Sat, 20 Aug 2022 17:08:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81583B80B66;
        Sun, 21 Aug 2022 00:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E382C43140;
        Sun, 21 Aug 2022 00:08:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oPYWD-005Dkz-06;
        Sat, 20 Aug 2022 20:08:45 -0400
Message-ID: <20220821000844.870621395@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 20 Aug 2022 20:07:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Krister Johansen <kjlx@templeofstupid.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [for-linus][PATCH 03/10] tracing/perf: Fix double put of trace event when init fails
References: <20220821000737.328590235@goodmis.org>
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

If in perf_trace_event_init(), the perf_trace_event_open() fails, then it
will call perf_trace_event_unreg() which will not only unregister the perf
trace event, but will also call the put() function of the tp_event.

The problem here is that the trace_event_try_get_ref() is called by the
caller of perf_trace_event_init() and if perf_trace_event_init() returns a
failure, it will then call trace_event_put(). But since the
perf_trace_event_unreg() already called the trace_event_put() function, it
triggers a WARN_ON().

 WARNING: CPU: 1 PID: 30309 at kernel/trace/trace_dynevent.c:46 trace_event_dyn_put_ref+0x15/0x20

If perf_trace_event_reg() does not call the trace_event_try_get_ref() then
the perf_trace_event_unreg() should not be calling trace_event_put(). This
breaks symmetry and causes bugs like these.

Pull out the trace_event_put() from perf_trace_event_unreg() and call it
in the locations that perf_trace_event_unreg() is called. This not only
fixes this bug, but also brings back the proper symmetry of the reg/unreg
vs get/put logic.

Link: https://lore.kernel.org/all/cover.1660347763.git.kjlx@templeofstupid.com/
Link: https://lkml.kernel.org/r/20220816192817.43d5e17f@gandalf.local.home

Cc: stable@vger.kernel.org
Fixes: 1d18538e6a092 ("tracing: Have dynamic events have a ref counter")
Reported-by: Krister Johansen <kjlx@templeofstupid.com>
Reviewed-by: Krister Johansen <kjlx@templeofstupid.com>
Tested-by: Krister Johansen <kjlx@templeofstupid.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_event_perf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index a114549720d6..61e3a2620fa3 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -157,7 +157,7 @@ static void perf_trace_event_unreg(struct perf_event *p_event)
 	int i;
 
 	if (--tp_event->perf_refcount > 0)
-		goto out;
+		return;
 
 	tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER, NULL);
 
@@ -176,8 +176,6 @@ static void perf_trace_event_unreg(struct perf_event *p_event)
 			perf_trace_buf[i] = NULL;
 		}
 	}
-out:
-	trace_event_put_ref(tp_event);
 }
 
 static int perf_trace_event_open(struct perf_event *p_event)
@@ -241,6 +239,7 @@ void perf_trace_destroy(struct perf_event *p_event)
 	mutex_lock(&event_mutex);
 	perf_trace_event_close(p_event);
 	perf_trace_event_unreg(p_event);
+	trace_event_put_ref(p_event->tp_event);
 	mutex_unlock(&event_mutex);
 }
 
@@ -292,6 +291,7 @@ void perf_kprobe_destroy(struct perf_event *p_event)
 	mutex_lock(&event_mutex);
 	perf_trace_event_close(p_event);
 	perf_trace_event_unreg(p_event);
+	trace_event_put_ref(p_event->tp_event);
 	mutex_unlock(&event_mutex);
 
 	destroy_local_trace_kprobe(p_event->tp_event);
@@ -347,6 +347,7 @@ void perf_uprobe_destroy(struct perf_event *p_event)
 	mutex_lock(&event_mutex);
 	perf_trace_event_close(p_event);
 	perf_trace_event_unreg(p_event);
+	trace_event_put_ref(p_event->tp_event);
 	mutex_unlock(&event_mutex);
 	destroy_local_trace_uprobe(p_event->tp_event);
 }
-- 
2.35.1
