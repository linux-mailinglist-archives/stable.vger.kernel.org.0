Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBD01D84E7
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732186AbgERSAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729203AbgERSAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:00:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3A41207C4;
        Mon, 18 May 2020 18:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824819;
        bh=e923IeQUkDFGtCFMSIPljVav9gG9Zf2cBBiEpAXaqGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tfd3R4RfB/T9KKtlfBwcA6qa9C3b6ggeFaQ0lswTZt17aIJkJbpsUfP9u8H/Pk0qd
         G7xhlfcuI1msDuCo6tkfsBy6QUNUUGCLzw5wyRE4i8QNZDXPWDcx4QMtj4HGas6LzW
         6R/BTgBgYoF2oXYZyvRTOguCQm2jK1thGWQ71rGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 017/194] ftrace/selftests: workaround cgroup RT scheduling issues
Date:   Mon, 18 May 2020 19:35:07 +0200
Message-Id: <20200518173533.020302238@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 57c4cfd4a2eef8f94052bd7c0fce0981f74fb213 ]

wakeup_rt.tc and wakeup.tc tests in tracers/ subdirectory
fail due to the chrt command returning:

 chrt: failed to set pid 0's policy: Operation not permitted.

To work around this, temporarily disable grout RT scheduling
during ftracetest execution.  Restore original value on
test run completion.  With these changes in place, both
tests consistently pass.

Fixes: c575dea2c1a5 ("selftests/ftrace: Add wakeup_rt tracer testcase")
Fixes: c1edd060b413 ("selftests/ftrace: Add wakeup tracer testcase")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/ftracetest | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index 063ecb290a5a3..144308a757b70 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -29,8 +29,25 @@ err_ret=1
 # kselftest skip code is 4
 err_skip=4
 
+# cgroup RT scheduling prevents chrt commands from succeeding, which
+# induces failures in test wakeup tests.  Disable for the duration of
+# the tests.
+
+readonly sched_rt_runtime=/proc/sys/kernel/sched_rt_runtime_us
+
+sched_rt_runtime_orig=$(cat $sched_rt_runtime)
+
+setup() {
+  echo -1 > $sched_rt_runtime
+}
+
+cleanup() {
+  echo $sched_rt_runtime_orig > $sched_rt_runtime
+}
+
 errexit() { # message
   echo "Error: $1" 1>&2
+  cleanup
   exit $err_ret
 }
 
@@ -39,6 +56,8 @@ if [ `id -u` -ne 0 ]; then
   errexit "this must be run by root user"
 fi
 
+setup
+
 # Utilities
 absdir() { # file_path
   (cd `dirname $1`; pwd)
@@ -235,6 +254,7 @@ TOTAL_RESULT=0
 
 INSTANCE=
 CASENO=0
+
 testcase() { # testfile
   CASENO=$((CASENO+1))
   desc=`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
@@ -406,5 +426,7 @@ prlog "# of unsupported: " `echo $UNSUPPORTED_CASES | wc -w`
 prlog "# of xfailed: " `echo $XFAILED_CASES | wc -w`
 prlog "# of undefined(test bug): " `echo $UNDEFINED_CASES | wc -w`
 
+cleanup
+
 # if no error, return 0
 exit $TOTAL_RESULT
-- 
2.20.1



