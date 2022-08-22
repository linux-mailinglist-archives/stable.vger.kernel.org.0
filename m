Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651BB59C5B6
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 20:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbiHVSGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 14:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236626AbiHVSGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 14:06:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD6246214
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 11:06:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02DB6612A8
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 18:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC999C433D6;
        Mon, 22 Aug 2022 18:06:33 +0000 (UTC)
Date:   Mon, 22 Aug 2022 14:06:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, mhiramat@kernel.org, mingo@kernel.org,
        tz.stoyanov@gmail.com, zanussi@kernel.org, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing/eprobes: Fix reading of string
 fields" failed to apply to 5.15-stable tree
Message-ID: <20220822140650.20c9f5db@gandalf.local.home>
In-Reply-To: <166115387728250@kroah.com>
References: <166115387728250@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the backport to 5.15.

-- Steve



------------------ original commit in Linus's tree ------------------

>From f04dec93466a0481763f3b56cdadf8076e28bfbf Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Sat, 20 Aug 2022 09:43:19 -0400
Subject: [PATCH] tracing/eprobes: Fix reading of string fields

Currently when an event probe (eprobe) hooks to a string field, it does
not display it as a string, but instead as a number. This makes the field
rather useless. Handle the different kinds of strings, dynamic, static,
relational/dynamic etc.

Now when a string field is used, the ":string" type can be used to display
it:

  echo "e:sw sched/sched_switch comm=$next_comm:string" > dynamic_events

Link: https://lkml.kernel.org/r/20220820134400.959640191@goodmis.org

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

---
 kernel/trace/trace_eprobe.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: linux-test.git/kernel/trace/trace_eprobe.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace_eprobe.c	2022-08-22 13:36:56.320863048 -0400
+++ linux-test.git/kernel/trace/trace_eprobe.c	2022-08-22 13:36:56.316863048 -0400
@@ -320,6 +320,24 @@ static unsigned long get_event_field(str
 
 	addr = rec + field->offset;
 
+	if (is_string_field(field)) {
+		switch (field->filter_type) {
+		case FILTER_DYN_STRING:
+			val = (unsigned long)(rec + (*(unsigned int *)addr & 0xffff));
+			break;
+		case FILTER_STATIC_STRING:
+			val = (unsigned long)addr;
+			break;
+		case FILTER_PTR_STRING:
+			val = (unsigned long)(*(char *)addr);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			return 0;
+		}
+		return val;
+	}
+
 	switch (field->size) {
 	case 1:
 		if (field->is_signed)
