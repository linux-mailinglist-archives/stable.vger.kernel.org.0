Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34E1329054
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241413AbhCAUGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:06:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242627AbhCATyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E86A265363;
        Mon,  1 Mar 2021 17:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621246;
        bh=BZ+59cz0G/FJDTov8lOoYT8F7N3HGL/cTj4rCPAqPW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTyphj+0x1fPWA5Gz7jJs/cf7TRZXisYbto0nqXqRdJ8YDX/nkBBQqCbvltU/Kr1X
         sVWxLyQP8ggAhpxKwgFMPpMpdsWJoxFc+9/br4IrtaEue/buDGEMUQfJiDLFxCT9/K
         wP1OhlIqs3AM14FThFhf4XiO5eVgi3p21RfsthHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 447/775] selftests/ftrace: Update synthetic event syntax errors
Date:   Mon,  1 Mar 2021 17:10:15 +0100
Message-Id: <20210301161223.634067894@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

[ Upstream commit b5734e997e1117afb479ffda500e36fa91aea3e8 ]

Some of the synthetic event errors and positions have changed in the
code - update those and add several more tests.

Also add a runtime check to ensure that the kernel supports dynamic
strings in synthetic events, which these tests require.

Link: https://lkml.kernel.org/r/51402656433455baead34f068c6e9466b64df9c0.1612208610.git.zanussi@kernel.org

Fixes: 81ff92a93d95 (selftests/ftrace: Add test case for synthetic event syntax errors)
Reported-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../trigger-synthetic_event_syntax_errors.tc  | 35 ++++++++++++++-----
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
index ada594fe16cb3..955e3ceea44b5 100644
--- a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
@@ -1,19 +1,38 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: event trigger - test synthetic_events syntax parser errors
-# requires: synthetic_events error_log
+# requires: synthetic_events error_log "char name[]' >> synthetic_events":README
 
 check_error() { # command-with-error-pos-by-^
     ftrace_errlog_check 'synthetic_events' "$1" 'synthetic_events'
 }
 
+check_dyn_error() { # command-with-error-pos-by-^
+    ftrace_errlog_check 'synthetic_events' "$1" 'dynamic_events'
+}
+
 check_error 'myevent ^chr arg'			# INVALID_TYPE
-check_error 'myevent ^char str[];; int v'	# INVALID_TYPE
-check_error 'myevent char ^str]; int v'		# INVALID_NAME
-check_error 'myevent char ^str;[]'		# INVALID_NAME
-check_error 'myevent ^char str[; int v'		# INVALID_TYPE
-check_error '^mye;vent char str[]'		# BAD_NAME
-check_error 'myevent char str[]; ^int'		# INVALID_FIELD
-check_error '^myevent'				# INCOMPLETE_CMD
+check_error 'myevent ^unsigned arg'		# INCOMPLETE_TYPE
+
+check_error 'myevent char ^str]; int v'		# BAD_NAME
+check_error '^mye-vent char str[]'		# BAD_NAME
+check_error 'myevent char ^st-r[]'		# BAD_NAME
+
+check_error 'myevent char str;^[]'		# INVALID_FIELD
+check_error 'myevent char str; ^int'		# INVALID_FIELD
+
+check_error 'myevent char ^str[; int v'		# INVALID_ARRAY_SPEC
+check_error 'myevent char ^str[kdjdk]'		# INVALID_ARRAY_SPEC
+check_error 'myevent char ^str[257]'		# INVALID_ARRAY_SPEC
+
+check_error '^mye;vent char str[]'		# INVALID_CMD
+check_error '^myevent ; char str[]'		# INVALID_CMD
+check_error '^myevent; char str[]'		# INVALID_CMD
+check_error '^myevent ;char str[]'		# INVALID_CMD
+check_error '^; char str[]'			# INVALID_CMD
+check_error '^;myevent char str[]'		# INVALID_CMD
+check_error '^myevent'				# INVALID_CMD
+
+check_dyn_error '^s:junk/myevent char str['	# INVALID_DYN_CMD
 
 exit 0
-- 
2.27.0



