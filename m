Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8066C40DEF2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240561AbhIPQFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240533AbhIPQF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:05:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4DE461250;
        Thu, 16 Sep 2021 16:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808248;
        bh=9iClfcn2FvwaNTaQw0Bk6+vBHtIgyJFO+KgfvpvKnfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHM0ZYK0VFfD2hEzfeTOHxHVKderwdgdFaN4IxALXmMoeRGdHRiZd2zPxUO6oToCI
         XshWFx7TwsLWTMEepJLpTQ/fdJCAD5c1s6CkjqJRj9hn8Lgj+kmN8pOy5s9xvV7grN
         ZaprO3LSz6LorPJwWQGVDtwYu0VgpDjvbGwLO5us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 016/306] selftests/ftrace: Fix requirement check of README file
Date:   Thu, 16 Sep 2021 17:56:01 +0200
Message-Id: <20210916155754.482921785@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 210f9df02611cbe641ced3239122b270fd907d86 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/functions |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/ftrace/test.d/functions
+++ b/tools/testing/selftests/ftrace/test.d/functions
@@ -115,7 +115,7 @@ check_requires() { # Check required file
                 echo "Required tracer $t is not configured."
                 exit_unsupported
             fi
-        elif [ $r != $i ]; then
+        elif [ "$r" != "$i" ]; then
             if ! grep -Fq "$r" README ; then
                 echo "Required feature pattern \"$r\" is not in README."
                 exit_unsupported


