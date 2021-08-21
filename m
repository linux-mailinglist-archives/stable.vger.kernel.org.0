Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5A53F3B01
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 16:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhHUOaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Aug 2021 10:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231598AbhHUOav (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Aug 2021 10:30:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C08761252;
        Sat, 21 Aug 2021 14:30:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mHS0h-004wo6-CO; Sat, 21 Aug 2021 10:30:11 -0400
Message-ID: <20210821143011.215062963@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 21 Aug 2021 10:29:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-next][PATCH 3/6] selftests/ftrace: Fix requirement check of README file
References: <20210821142904.655644298@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The selftest for ftrace checks some features by checking if the README has
text that states the feature is supported by that kernel. Unfortunately,
this check gives false positives because it many not be checked if there's
spaces in the string to check. This is due to the compare between the
required variable with the ":README" string stripped, because neither has
quotes around them.

Link: https://lkml.kernel.org/r/20210820204742.087177341@goodmis.org

Cc: "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-kselftest@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: 1b8eec510ba64 ("selftests/ftrace: Support ":README" suffix for requires")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/testing/selftests/ftrace/test.d/functions | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/functions b/tools/testing/selftests/ftrace/test.d/functions
index f68d336b961b..000fd05e84b1 100644
--- a/tools/testing/selftests/ftrace/test.d/functions
+++ b/tools/testing/selftests/ftrace/test.d/functions
@@ -137,7 +137,7 @@ check_requires() { # Check required files and tracers
                 echo "Required tracer $t is not configured."
                 exit_unsupported
             fi
-        elif [ $r != $i ]; then
+        elif [ "$r" != "$i" ]; then
             if ! grep -Fq "$r" README ; then
                 echo "Required feature pattern \"$r\" is not in README."
                 exit_unsupported
-- 
2.30.2
