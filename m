Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBBB4CE2AD
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 06:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiCEFLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 00:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiCEFLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 00:11:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46F05A585;
        Fri,  4 Mar 2022 21:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2D0CACE2BF2;
        Sat,  5 Mar 2022 05:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C986C340EE;
        Sat,  5 Mar 2022 05:10:10 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1nQMgD-00Egty-O6;
        Sat, 05 Mar 2022 00:10:09 -0500
Message-ID: <20220305051009.544395003@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 05 Mar 2022 00:09:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [for-linus][PATCH 1/2] tracing/histogram: Fix sorting on old "cpu" value
References: <20220305050948.857222764@goodmis.org>
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

When trying to add a histogram against an event with the "cpu" field, it
was impossible due to "cpu" being a keyword to key off of the running CPU.
So to fix this, it was changed to "common_cpu" to match the other generic
fields (like "common_pid"). But since some scripts used "cpu" for keying
off of the CPU (for events that did not have "cpu" as a field, which is
most of them), a backward compatibility trick was added such that if "cpu"
was used as a key, and the event did not have "cpu" as a field name, then
it would fallback and switch over to "common_cpu".

This fix has a couple of subtle bugs. One was that when switching over to
"common_cpu", it did not change the field name, it just set a flag. But
the code still found a "cpu" field. The "cpu" field is used for filtering
and is returned when the event does not have a "cpu" field.

This was found by:

  # cd /sys/kernel/tracing
  # echo hist:key=cpu,pid:sort=cpu > events/sched/sched_wakeup/trigger
  # cat events/sched/sched_wakeup/hist

Which showed the histogram unsorted:

{ cpu:         19, pid:       1175 } hitcount:          1
{ cpu:          6, pid:        239 } hitcount:          2
{ cpu:         23, pid:       1186 } hitcount:         14
{ cpu:         12, pid:        249 } hitcount:          2
{ cpu:          3, pid:        994 } hitcount:          5

Instead of hard coding the "cpu" checks, take advantage of the fact that
trace_event_field_field() returns a special field for "cpu" and "CPU" if
the event does not have "cpu" as a field. This special field has the
"filter_type" of "FILTER_CPU". Check that to test if the returned field is
of the CPU type instead of doing the string compare.

Also, fix the sorting bug by testing for the hist_field flag of
HIST_FIELD_FL_CPU when setting up the sort routine. Otherwise it will use
the special CPU field to know what compare routine to use, and since that
special field does not have a size, it returns tracing_map_cmp_none.

Cc: stable@vger.kernel.org
Fixes: 1e3bac71c505 ("tracing/histogram: Rename "cpu" to "common_cpu"")
Reported-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index ada87bfb5bb8..dc7f733b4cb3 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2289,9 +2289,9 @@ parse_field(struct hist_trigger_data *hist_data, struct trace_event_file *file,
 			/*
 			 * For backward compatibility, if field_name
 			 * was "cpu", then we treat this the same as
-			 * common_cpu.
+			 * common_cpu. This also works for "CPU".
 			 */
-			if (strcmp(field_name, "cpu") == 0) {
+			if (field && field->filter_type == FILTER_CPU) {
 				*flags |= HIST_FIELD_FL_CPU;
 			} else {
 				hist_err(tr, HIST_ERR_FIELD_NOT_FOUND,
@@ -4832,7 +4832,7 @@ static int create_tracing_map_fields(struct hist_trigger_data *hist_data)
 
 			if (hist_field->flags & HIST_FIELD_FL_STACKTRACE)
 				cmp_fn = tracing_map_cmp_none;
-			else if (!field)
+			else if (!field || hist_field->flags & HIST_FIELD_FL_CPU)
 				cmp_fn = tracing_map_cmp_num(hist_field->size,
 							     hist_field->is_signed);
 			else if (is_string_field(field))
-- 
2.34.1
