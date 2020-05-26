Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E4B1E2C1B
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404129AbgEZTMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391420AbgEZTMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:12:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7324620776;
        Tue, 26 May 2020 19:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520333;
        bh=kRGGgjOgo1DcPwnCKmyH1WLigFc+jT/yp6endMImLxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EibK8wy8J9KPbOZmHNknu1VHnyMAhaXo43pZDLwB12s8S4AWjJbpPDTyLBgrJFlJ+
         KvyUAKBU/hiu8xHgARiRAZC75c11EYKGCdOT9KJbV+84oOtMy5Dp0CMmtih1/9JNLn
         sVHqOBGELWwNnmaUNlk87sNGgq3ty+w31u/cX9uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 039/126] ftrace/selftest: make unresolved cases cause failure if --fail-unresolved set
Date:   Tue, 26 May 2020 20:52:56 +0200
Message-Id: <20200526183941.220520904@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 144308a757b7..19e9236dec5e 100755
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
2.25.1



