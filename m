Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1DA29C256
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1819959AbgJ0Rbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760958AbgJ0OhO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:37:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B44B1223B0;
        Tue, 27 Oct 2020 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809434;
        bh=fmzIGfAlmxA5UW7j9+y7Oh768fnkxykn31ZUG9EwbDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRI26PrEEmNgmp4V+owaanJ+a1B6oAUgwVI/Rr0Y2ttv731YujJo1kfUtvxP303iq
         882X11hfzN9g76pugBo7VrQcciifWXmSVFWNGh7XywV/MXXd/Vl3q1FAIDPe5QG4nq
         VAEg9OnffUPyI9yRca0Sikqm+F34FcRZpTiIBj5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 195/408] selftests/ftrace: Change synthetic event name for inter-event-combined test
Date:   Tue, 27 Oct 2020 14:52:13 +0100
Message-Id: <20201027135504.139977444@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

[ Upstream commit 96378b2088faea68f1fb05ea6b9a566fc569a44c ]

This test uses waking+wakeup_latency as an event name, which doesn't
make sense since it includes an operator.  Illegal names are now
detected by the synthetic event command parsing, which causes this
test to fail.  Change the name to 'waking_plus_wakeup_latency' to
prevent this.

Link: https://lkml.kernel.org/r/a1ee2f76ff28ef7166fb788ca8be968887808920.1602598160.git.zanussi@kernel.org

Fixes: f06eec4d0f2c (selftests: ftrace: Add inter-event hist triggers testcases)
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../inter-event/trigger-inter-event-combined-hist.tc      | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-inter-event-combined-hist.tc b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-inter-event-combined-hist.tc
index f3eb8aacec0e7..a2b0e4eb1fe4c 100644
--- a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-inter-event-combined-hist.tc
+++ b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-inter-event-combined-hist.tc
@@ -34,12 +34,12 @@ echo 'wakeup_latency u64 lat pid_t pid' >> synthetic_events
 echo 'hist:keys=pid:ts1=common_timestamp.usecs if comm=="ping"' >> events/sched/sched_wakeup/trigger
 echo 'hist:keys=next_pid:wakeup_lat=common_timestamp.usecs-$ts1:onmatch(sched.sched_wakeup).wakeup_latency($wakeup_lat,next_pid) if next_comm=="ping"' > events/sched/sched_switch/trigger
 
-echo 'waking+wakeup_latency u64 lat; pid_t pid' >> synthetic_events
-echo 'hist:keys=pid,lat:sort=pid,lat:ww_lat=$waking_lat+$wakeup_lat:onmatch(synthetic.wakeup_latency).waking+wakeup_latency($ww_lat,pid)' >> events/synthetic/wakeup_latency/trigger
-echo 'hist:keys=pid,lat:sort=pid,lat' >> events/synthetic/waking+wakeup_latency/trigger
+echo 'waking_plus_wakeup_latency u64 lat; pid_t pid' >> synthetic_events
+echo 'hist:keys=pid,lat:sort=pid,lat:ww_lat=$waking_lat+$wakeup_lat:onmatch(synthetic.wakeup_latency).waking_plus_wakeup_latency($ww_lat,pid)' >> events/synthetic/wakeup_latency/trigger
+echo 'hist:keys=pid,lat:sort=pid,lat' >> events/synthetic/waking_plus_wakeup_latency/trigger
 
 ping $LOCALHOST -c 3
-if ! grep -q "pid:" events/synthetic/waking+wakeup_latency/hist; then
+if ! grep -q "pid:" events/synthetic/waking_plus_wakeup_latency/hist; then
     fail "Failed to create combined histogram"
 fi
 
-- 
2.25.1



