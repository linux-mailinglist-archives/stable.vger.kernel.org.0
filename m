Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8065959B0FC
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 02:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbiHUAIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 20:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235684AbiHUAIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 20:08:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCF612ABC;
        Sat, 20 Aug 2022 17:08:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46D21B80B6C;
        Sun, 21 Aug 2022 00:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02301C43148;
        Sun, 21 Aug 2022 00:08:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oPYWD-005DnB-2T;
        Sat, 20 Aug 2022 20:08:45 -0400
Message-ID: <20220821000845.597062173@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 20 Aug 2022 20:07:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [for-linus][PATCH 07/10] tracing/eprobes: Fix reading of string fields
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

Currently when an event probe (eprobe) hooks to a string field, it does
not display it as a string, but instead as a number. This makes the field
rather useless. Handle the different kinds of strings, dynamic, static,
relational/dynamic etc.

Now when a string field is used, the ":string" type can be used to display
it:

  echo "e:sw sched/sched_switch comm=$next_comm:string" > dynamic_events

Cc: stable@vger.kernel.org
Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_eprobe.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index 550671985fd1..a1d3423ab74f 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -311,6 +311,27 @@ static unsigned long get_event_field(struct fetch_insn *code, void *rec)
 
 	addr = rec + field->offset;
 
+	if (is_string_field(field)) {
+		switch (field->filter_type) {
+		case FILTER_DYN_STRING:
+			val = (unsigned long)(rec + (*(unsigned int *)addr & 0xffff));
+			break;
+		case FILTER_RDYN_STRING:
+			val = (unsigned long)(addr + (*(unsigned int *)addr & 0xffff));
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
-- 
2.35.1
