Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461E159AA8C
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 03:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240904AbiHTBs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 21:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbiHTBs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 21:48:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE9D14D0D;
        Fri, 19 Aug 2022 18:48:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7842961946;
        Sat, 20 Aug 2022 01:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E45C43142;
        Sat, 20 Aug 2022 01:48:19 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oPDbF-004uVD-0d;
        Fri, 19 Aug 2022 21:48:33 -0400
Message-ID: <20220820014833.035925907@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 19 Aug 2022 21:40:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/4] tracing/eprobes: Do not hardcode $comm as a string
References: <20220820014035.531145719@goodmis.org>
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

The variable $comm is hard coded as a string, which is true for both
kprobes and uprobes, but for event probes (eprobes) it is a field name. In
most cases the "comm" field would be a string, but there's no guarantee of
that fact.

Do not assume that comm is a string. Not to mention, it currently forces
comm fields to fault, as string processing for event probes is currently
broken.

Cc: stable@vger.kernel.org
Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_probe.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index dec657af363c..23dcd52ad45c 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -622,9 +622,10 @@ static int traceprobe_parse_probe_arg_body(const char *argv, ssize_t *size,
 
 	/*
 	 * Since $comm and immediate string can not be dereferenced,
-	 * we can find those by strcmp.
+	 * we can find those by strcmp. But ignore for eprobes.
 	 */
-	if (strcmp(arg, "$comm") == 0 || strncmp(arg, "\\\"", 2) == 0) {
+	if (!(flags & TPARG_FL_TPOINT) &&
+	    strcmp(arg, "$comm") == 0 || strncmp(arg, "\\\"", 2) == 0) {
 		/* The type of $comm must be "string", and not an array. */
 		if (parg->count || (t && strcmp(t, "string")))
 			goto out;
-- 
2.35.1
