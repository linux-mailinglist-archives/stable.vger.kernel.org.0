Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AC5137FDB
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgAKKXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:23:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728833AbgAKKXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:23:42 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D90520880;
        Sat, 11 Jan 2020 10:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738221;
        bh=jvIKsNNS0M5HdCCq0no463cJMVXdRbq/EAGpse4yLuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXqclM7C8ciHEHp0Se5Ox4YaaFGdA4QPPWuHuC171d/vnmpK1soJlHt4L2dUrMeug
         Et/CcZ0sMZGpYU7Qm87nkW5W3Kk/cuUHCCLWBHjdqxk8OH5xRtPJ45dPvMDAztkPLv
         Ti4EMs9m8mhUZ3f8NEahD/4VkQbNDktIqJsilCuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/165] selftests/ftrace: Do not to use absolute debugfs path
Date:   Sat, 11 Jan 2020 10:49:15 +0100
Message-Id: <20200111094924.138112623@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



