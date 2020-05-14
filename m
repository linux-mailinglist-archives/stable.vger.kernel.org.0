Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB7F1D3C00
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgENTGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbgENSxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:53:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACB6B207C3;
        Thu, 14 May 2020 18:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482423;
        bh=X5J/cOekaw0vJkG0Lx9XCnZIakgENEiU8hA54KZohQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ktk3WVfzi9HlG1BEh0+/mp+AvefgJBmc/IWmTcV+O/4xu8/K3YK+pzoJVJKChccVn
         7qPT3d2r4GEBfxN5FTcmeLUFIYA7ROx/2MEdjsL3yDX2lrjM8NHO/HW1IsXDpJsVbh
         f3ReWoVSgTrpeK2UxjHJ0G5nbImSGmzKJ3CtO2IY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 26/49] ftrace/selftest: make unresolved cases cause failure if --fail-unresolved set
Date:   Thu, 14 May 2020 14:52:47 -0400
Message-Id: <20200514185311.20294-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185311.20294-1-sashal@kernel.org>
References: <20200514185311.20294-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit b730d668138cb3dd9ce78f8003986d1adae5523a ]

Currently, ftracetest will return 1 (failure) if any unresolved cases
are encountered.  The unresolved status results from modules and
programs not being available, and as such does not indicate any
issues with ftrace itself.  As such, change the behaviour of
ftracetest in line with unsupported cases; if unsupported cases
happen, ftracetest still returns 0 unless --fail-unsupported.  Here
--fail-unresolved is added and the default is to return 0 if
unresolved results occur.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/ftracetest | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index 144308a757b70..19e9236dec5e2 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -17,6 +17,7 @@ echo "		-v|--verbose Increase verbosity of test messages"
 echo "		-vv        Alias of -v -v (Show all results in stdout)"
 echo "		-vvv       Alias of -v -v -v (Show all commands immediately)"
 echo "		--fail-unsupported Treat UNSUPPORTED as a failure"
+echo "		--fail-unresolved Treat UNRESOLVED as a failure"
 echo "		-d|--debug Debug mode (trace all shell commands)"
 echo "		-l|--logdir <dir> Save logs on the <dir>"
 echo "		            If <dir> is -, all logs output in console only"
@@ -112,6 +113,10 @@ parse_opts() { # opts
       UNSUPPORTED_RESULT=1
       shift 1
     ;;
+    --fail-unresolved)
+      UNRESOLVED_RESULT=1
+      shift 1
+    ;;
     --logdir|-l)
       LOG_DIR=$2
       shift 2
@@ -176,6 +181,7 @@ KEEP_LOG=0
 DEBUG=0
 VERBOSE=0
 UNSUPPORTED_RESULT=0
+UNRESOLVED_RESULT=0
 STOP_FAILURE=0
 # Parse command-line options
 parse_opts $*
@@ -280,7 +286,7 @@ eval_result() { # sigval
     $UNRESOLVED)
       prlog "	[${color_blue}UNRESOLVED${color_reset}]"
       UNRESOLVED_CASES="$UNRESOLVED_CASES $CASENO"
-      return 1 # this is a kind of bug.. something happened.
+      return $UNRESOLVED_RESULT # depends on use case
     ;;
     $UNTESTED)
       prlog "	[${color_blue}UNTESTED${color_reset}]"
-- 
2.20.1

