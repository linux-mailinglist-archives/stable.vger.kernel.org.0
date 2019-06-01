Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD2C31EA9
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbfFANiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728545AbfFANVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FBE5272E7;
        Sat,  1 Jun 2019 13:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395292;
        bh=FtvJm9fu6aj7T1gZCNpgvX9YigZ/+6wWTXenqwkTZXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiOukflbtSTNfBmVe9azHkMRu/5/tDZV+FRmBcjYaxi2PQHXljvGsZBvbZcHWZwzN
         9aGYgwyNZfhScyv1kRc1ACn50JJrO5PcAr5trFFe5oIVRcT26VnHiR1j0vXsOXrl0O
         rOPxfDZnA3mbdHjeGjzo8D6cTETzqVjLNhqXKQYU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andreas Ziegler <andreas.ziegler@fau.de>,
        Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 055/173] tracing: probeevent: Fix to make the type of $comm string
Date:   Sat,  1 Jun 2019 09:17:27 -0400
Message-Id: <20190601131934.25053-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 3dd1f7f24f8ceec00bbbc364c2ac3c893f0fdc4c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 9962cb5da8acd..44f078cda0ac8 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -405,13 +405,14 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
 				return -E2BIG;
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
 		pr_info("Unsupported type: %s\n", t);
-- 
2.20.1

