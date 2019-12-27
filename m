Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6D7A12B8A5
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfL0Rls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:41:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727605AbfL0Rlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A9EA2173E;
        Fri, 27 Dec 2019 17:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468507;
        bh=GmOtnR2Eu61QLEuSN3v9F9H3Vw8HY9Qr0TfA7waih40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CR8G4ot0B1AVQctA4kF2Kbnuxi50B8uNSELE/WBitEq6O3cVYy0wf6egtRAfGvjp3
         k1HPsVlc4Gs8qjXR8kF8sOTV8L9BNzR5JqDilu9XSgwiJwOGkIVQ4vpxaXxEsJy4CH
         CYfbaEv79MjKcqUJ76JWe9CB22159W6xViJS1VjA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 040/187] selftests/ftrace: Fix to check the existence of set_ftrace_filter
Date:   Fri, 27 Dec 2019 12:38:28 -0500
Message-Id: <20191227174055.4923-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit fd1baf6ca2ea3550ea47f2bb0bdcf34ec764a779 ]

If we run ftracetest on the kernel with CONFIG_DYNAMIC_FTRACE=n,
there is no set_ftrace_filter and all test cases are failed, because
reset_ftrace_filter() returns an error.
Let's check whether set_ftrace_filter exists in reset_ftrace_filter()
and clean up only set_ftrace_notrace in initialize_ftrace().

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/test.d/functions | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/functions b/tools/testing/selftests/ftrace/test.d/functions
index 86986c4bba54..5d4550591ff9 100644
--- a/tools/testing/selftests/ftrace/test.d/functions
+++ b/tools/testing/selftests/ftrace/test.d/functions
@@ -46,6 +46,9 @@ reset_events_filter() { # reset all current setting filters
 }
 
 reset_ftrace_filter() { # reset all triggers in set_ftrace_filter
+    if [ ! -f set_ftrace_filter ]; then
+      return 0
+    fi
     echo > set_ftrace_filter
     grep -v '^#' set_ftrace_filter | while read t; do
 	tr=`echo $t | cut -d: -f2`
@@ -93,7 +96,7 @@ initialize_ftrace() { # Reset ftrace to initial-state
     disable_events
     [ -f set_event_pid ] && echo > set_event_pid
     [ -f set_ftrace_pid ] && echo > set_ftrace_pid
-    [ -f set_ftrace_filter ] && echo | tee set_ftrace_*
+    [ -f set_ftrace_notrace ] && echo > set_ftrace_notrace
     [ -f set_graph_function ] && echo | tee set_graph_*
     [ -f stack_trace_filter ] && echo > stack_trace_filter
     [ -f kprobe_events ] && echo > kprobe_events
-- 
2.20.1

