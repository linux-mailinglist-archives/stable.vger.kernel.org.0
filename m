Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E32718104
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 22:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbfEHUZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 16:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728806AbfEHUYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 16:24:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E8D22183E;
        Wed,  8 May 2019 20:24:53 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hOT7U-0007hI-Pg; Wed, 08 May 2019 16:24:52 -0400
Message-Id: <20190508202452.686677049@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 08 May 2019 16:24:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Ziegler <andreas.ziegler@fau.de>,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-next][PATCH 06/13] tracing: probeevent: Fix to make the type of $comm string
References: <20190508202427.252736423@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

Fix to make the type of $comm "string".  If we set the other type to $comm
argument, it shows meaningless value or wrong data. Currently probe events
allow us to set string array type (e.g. ":string[2]"), or other digit types
like x8 on $comm. But since clearly $comm is just a string data, it should
not be fetched by other types including array.

Link: http://lkml.kernel.org/r/155723736241.9149.14582064184468574539.stgit@devnote2

Cc: Andreas Ziegler <andreas.ziegler@fau.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_probe.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 4cc2d467d34c..e0d1d5353464 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -533,13 +533,14 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
 			}
 		}
 	}
-	/*
-	 * The default type of $comm should be "string", and it can't be
-	 * dereferenced.
-	 */
-	if (!t && strcmp(arg, "$comm") == 0)
+
+	/* Since $comm can not be dereferred, we can find $comm by strcmp */
+	if (strcmp(arg, "$comm") == 0) {
+		/* The type of $comm must be "string", and not an array. */
+		if (parg->count || (t && strcmp(t, "string")))
+			return -EINVAL;
 		parg->type = find_fetch_type("string");
-	else
+	} else
 		parg->type = find_fetch_type(t);
 	if (!parg->type) {
 		trace_probe_log_err(offset + (t ? (t - arg) : 0), BAD_TYPE);
-- 
2.20.1


