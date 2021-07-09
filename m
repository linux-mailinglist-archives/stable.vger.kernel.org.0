Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70383C2405
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhGINN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhGINN1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:13:27 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3875A611B0;
        Fri,  9 Jul 2021 13:10:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1m1qHC-00097E-Up; Fri, 09 Jul 2021 09:10:42 -0400
Message-ID: <20210709131042.787880276@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 09 Jul 2021 09:09:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>
Subject: [for-linus][PATCH 1/3] tracing/histograms: Fix parsing of "sym-offset" modifier
References: <20210709130949.717206727@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

With the addition of simple mathematical operations (plus and minus), the
parsing of the "sym-offset" modifier broke, as it took the '-' part of the
"sym-offset" as a minus, and tried to break it up into a mathematical
operation of "field.sym - offset", in which case it failed to parse
(unless the event had a field called "offset").

Both .sym and .sym-offset modifiers should not be entered into
mathematical calculations anyway. If ".sym-offset" is found in the
modifier, then simply make it not an operation that can be calculated on.

Link: https://lkml.kernel.org/r/20210707110821.188ae255@oasis.local.home

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 100719dcef447 ("tracing: Add simple expression support to hist triggers")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index ba03b7d84fc2..0207aeed31e6 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1555,6 +1555,13 @@ static int contains_operator(char *str)
 
 	switch (*op) {
 	case '-':
+		/*
+		 * Unfortunately, the modifier ".sym-offset"
+		 * can confuse things.
+		 */
+		if (op - str >= 4 && !strncmp(op - 4, ".sym-offset", 11))
+			return FIELD_OP_NONE;
+
 		if (*str == '-')
 			field_op = FIELD_OP_UNARY_MINUS;
 		else
-- 
2.30.2
