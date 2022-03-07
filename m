Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA784CF76D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbiCGJqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241022AbiCGJlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CEA6D4CD;
        Mon,  7 Mar 2022 01:39:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9405B810BF;
        Mon,  7 Mar 2022 09:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DE8C340E9;
        Mon,  7 Mar 2022 09:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645654;
        bh=wphUzrErrqEbeBN2h9TcPmD8RjLKdGywGlfWs2dowqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooyDLHPGM2iG7BTitSa15idPqf8SZ1K/8n1mN2DOWC/yDJxt7x4vzwU9PyKwtQUph
         nWLdTbw/OPV5dRjmCo5JdeMRFLYZm3R0fyuWo+cHRhma4rzggu8K284jWC1KRW1vDG
         iQz1zuRA74B7Nsedwyv4TgNd+86uVqGC5FnXx85I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 100/105] tracing/histogram: Fix sorting on old "cpu" value
Date:   Mon,  7 Mar 2022 10:19:43 +0100
Message-Id: <20220307091646.990305497@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 1d1898f65616c4601208963c3376c1d828cbf2c7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1985,9 +1985,9 @@ parse_field(struct hist_trigger_data *hi
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
@@ -4365,7 +4365,7 @@ static int create_tracing_map_fields(str
 
 			if (hist_field->flags & HIST_FIELD_FL_STACKTRACE)
 				cmp_fn = tracing_map_cmp_none;
-			else if (!field)
+			else if (!field || hist_field->flags & HIST_FIELD_FL_CPU)
 				cmp_fn = tracing_map_cmp_num(hist_field->size,
 							     hist_field->is_signed);
 			else if (is_string_field(field))


