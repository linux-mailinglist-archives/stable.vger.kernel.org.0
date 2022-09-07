Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5E75B09DC
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 18:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiIGQPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 12:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiIGQPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 12:15:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0829B8000D;
        Wed,  7 Sep 2022 09:15:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52BB5619DA;
        Wed,  7 Sep 2022 16:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FF9C433D7;
        Wed,  7 Sep 2022 16:15:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oVxik-00CsXA-1S;
        Wed, 07 Sep 2022 12:16:10 -0400
Message-ID: <20220907161610.282974054@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 07 Sep 2022 12:15:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [for-linus][PATCH 6/7] tracing: Fix to check event_mutex is held while accessing trigger
 list
References: <20220907161511.694486342@goodmis.org>
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

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

Since the check_user_trigger() is called outside of RCU
read lock, this list_for_each_entry_rcu() caused a suspicious
RCU usage warning.

 # echo hist:keys=pid > events/sched/sched_stat_runtime/trigger
 # cat events/sched/sched_stat_runtime/trigger
[   43.167032]
[   43.167418] =============================
[   43.167992] WARNING: suspicious RCU usage
[   43.168567] 5.19.0-rc5-00029-g19ebe4651abf #59 Not tainted
[   43.169283] -----------------------------
[   43.169863] kernel/trace/trace_events_trigger.c:145 RCU-list traversed in non-reader section!!
...

However, this file->triggers list is safe when it is accessed
under event_mutex is held.
To fix this warning, adds a lockdep_is_held check to the
list_for_each_entry_rcu().

Link: https://lkml.kernel.org/r/166226474977.223837.1992182913048377113.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_trigger.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index cb866c3141af..918730d74932 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -142,7 +142,8 @@ static bool check_user_trigger(struct trace_event_file *file)
 {
 	struct event_trigger_data *data;
 
-	list_for_each_entry_rcu(data, &file->triggers, list) {
+	list_for_each_entry_rcu(data, &file->triggers, list,
+				lockdep_is_held(&event_mutex)) {
 		if (data->flags & EVENT_TRIGGER_FL_PROBE)
 			continue;
 		return true;
-- 
2.35.1
