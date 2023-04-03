Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30826D536B
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 23:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbjDCVWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 17:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbjDCVWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 17:22:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34B63A97;
        Mon,  3 Apr 2023 14:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 761E362C28;
        Mon,  3 Apr 2023 21:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB46CC433D2;
        Mon,  3 Apr 2023 21:22:43 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1pjRdS-000FR2-36;
        Mon, 03 Apr 2023 17:22:42 -0400
Message-ID: <20230403212242.777821662@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 03 Apr 2023 17:21:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [for-linus][PATCH 5/6] tracing/osnoise: Fix notify new tracing_max_latency
References: <20230403212125.244064799@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-2.0 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

osnoise/timerlat tracers are reporting new max latency on instances
where the tracing is off, creating inconsistencies between the max
reported values in the trace and in the tracing_max_latency. Thus
only report new tracing_max_latency on active tracing instances.

Link: https://lkml.kernel.org/r/ecd109fde4a0c24ab0f00ba1e9a144ac19a91322.1680104184.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Fixes: dae181349f1e ("tracing/osnoise: Support a list of trace_array *tr")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_osnoise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index e8116094bed8..4496975f2029 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1296,7 +1296,7 @@ static void notify_new_max_latency(u64 latency)
 	rcu_read_lock();
 	list_for_each_entry_rcu(inst, &osnoise_instances, list) {
 		tr = inst->tr;
-		if (tr->max_latency < latency) {
+		if (tracer_tracing_is_on(tr) && tr->max_latency < latency) {
 			tr->max_latency = latency;
 			latency_fsnotify(tr);
 		}
-- 
2.39.2
