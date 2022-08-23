Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0380B59D7C6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242125AbiHWJmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352441AbiHWJlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:41:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A612D99252;
        Tue, 23 Aug 2022 01:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A386B81C53;
        Tue, 23 Aug 2022 08:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BC9C433D6;
        Tue, 23 Aug 2022 08:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244099;
        bh=s5578OVZR8KPzzrSrJ5oP9AEyfEJlKV7QfcOdlwYxjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvCuOAWEmmoBACiuXQOqvgTS55PXiLHmiEuzmd2Jhixr0b87CFIzx1dbPHMAUcGg+
         t2Jv3nECNVWCxWto8DeneA2S8SVN/kzzLnkvGWk0RlbTXAUL7LFNRmI/uWSRRXH4nQ
         eSjK6HXtsrggXxgXrpADpgwO+a59AbHsEuhdocXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krister Johansen <kjlx@templeofstupid.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 019/244] tracing/perf: Fix double put of trace event when init fails
Date:   Tue, 23 Aug 2022 10:22:58 +0200
Message-Id: <20220823080059.711002766@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 7249921d94ff64f67b733eca0b68853a62032b3d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.37.2



