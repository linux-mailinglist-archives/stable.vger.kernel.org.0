Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63C3212B8A4
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfL0R5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:57:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727615AbfL0Rlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D63A221927;
        Fri, 27 Dec 2019 17:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468509;
        bh=jvIKsNNS0M5HdCCq0no463cJMVXdRbq/EAGpse4yLuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkzcQGwR/rxvyPfVP0zuqwt4743iWfMdOAvB8P8gcQfAanua9wbQuOpnh0mEZqGY+
         YYA+TExtFgM8TuRmbOkLiXnax99DA/P0/XS0icpNkyMlmtRvhmOln5jRLSvrz9CJA0
         pFOrnvRX+Og/BCHGbOcRCXYXIZL/IAXs0KQw562Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 042/187] selftests/ftrace: Do not to use absolute debugfs path
Date:   Fri, 27 Dec 2019 12:38:30 -0500
Message-Id: <20191227174055.4923-42-sashal@kernel.org>
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

[ Upstream commit ba1b9c5048e43716921abe3a1db19cebebf4a5f5 ]

Use relative path to trigger file instead of absolute debugfs path,
because if the user uses tracefs instead of debugfs, it can be
mounted at /sys/kernel/tracing.
Anyway, since the ftracetest is designed to be run at the tracing
directory, user doesn't need to use absolute path.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../test.d/trigger/inter-event/trigger-action-hist-xfail.tc   | 4 ++--
 .../trigger/inter-event/trigger-onchange-action-hist.tc       | 2 +-
 .../trigger/inter-event/trigger-snapshot-action-hist.tc       | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-action-hist-xfail.tc b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-action-hist-xfail.tc
index 1221240f8cf6..3f2aee115f6e 100644
--- a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-action-hist-xfail.tc
+++ b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-action-hist-xfail.tc
@@ -21,10 +21,10 @@ grep -q "snapshot()" README || exit_unsupported # version issue
 
 echo "Test expected snapshot action failure"
 
-echo 'hist:keys=comm:onmatch(sched.sched_wakeup).snapshot()' >> /sys/kernel/debug/tracing/events/sched/sched_waking/trigger && exit_fail
+echo 'hist:keys=comm:onmatch(sched.sched_wakeup).snapshot()' >> events/sched/sched_waking/trigger && exit_fail
 
 echo "Test expected save action failure"
 
-echo 'hist:keys=comm:onmatch(sched.sched_wakeup).save(comm,prio)' >> /sys/kernel/debug/tracing/events/sched/sched_waking/trigger && exit_fail
+echo 'hist:keys=comm:onmatch(sched.sched_wakeup).save(comm,prio)' >> events/sched/sched_waking/trigger && exit_fail
 
 exit_xfail
diff --git a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-onchange-action-hist.tc b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-onchange-action-hist.tc
index 064a284e4e75..c80007aa9f86 100644
--- a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-onchange-action-hist.tc
+++ b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-onchange-action-hist.tc
@@ -16,7 +16,7 @@ grep -q "onchange(var)" README || exit_unsupported # version issue
 
 echo "Test onchange action"
 
-echo 'hist:keys=comm:newprio=prio:onchange($newprio).save(comm,prio) if comm=="ping"' >> /sys/kernel/debug/tracing/events/sched/sched_waking/trigger
+echo 'hist:keys=comm:newprio=prio:onchange($newprio).save(comm,prio) if comm=="ping"' >> events/sched/sched_waking/trigger
 
 ping $LOCALHOST -c 3
 nice -n 1 ping $LOCALHOST -c 3
diff --git a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-snapshot-action-hist.tc b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-snapshot-action-hist.tc
index 18fff69fc433..f546c1b66a9b 100644
--- a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-snapshot-action-hist.tc
+++ b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-snapshot-action-hist.tc
@@ -23,9 +23,9 @@ grep -q "snapshot()" README || exit_unsupported # version issue
 
 echo "Test snapshot action"
 
-echo 1 > /sys/kernel/debug/tracing/events/sched/enable
+echo 1 > events/sched/enable
 
-echo 'hist:keys=comm:newprio=prio:onchange($newprio).save(comm,prio):onchange($newprio).snapshot() if comm=="ping"' >> /sys/kernel/debug/tracing/events/sched/sched_waking/trigger
+echo 'hist:keys=comm:newprio=prio:onchange($newprio).save(comm,prio):onchange($newprio).snapshot() if comm=="ping"' >> events/sched/sched_waking/trigger
 
 ping $LOCALHOST -c 3
 nice -n 1 ping $LOCALHOST -c 3
-- 
2.20.1

