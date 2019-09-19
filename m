Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43FBCB8802
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 01:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405797AbfISXYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 19:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405474AbfISXYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 19:24:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0FF6217D6;
        Thu, 19 Sep 2019 23:24:00 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iB5mJ-0000g7-UD; Thu, 19 Sep 2019 19:23:59 -0400
Message-Id: <20190919232359.825502403@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 19 Sep 2019 19:23:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>
Subject: [for-next][PATCH 3/8] tracing: Make sure variable reference alias has correct var_ref_idx
References: <20190919232313.198902049@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

Original changelog from Steve Rostedt (except last sentence which
explains the problem, and the Fixes: tag):

I performed a three way histogram with the following commands:

echo 'irq_lat u64 lat pid_t pid' > synthetic_events
echo 'wake_lat u64 lat u64 irqlat pid_t pid' >> synthetic_events
echo 'hist:keys=common_pid:irqts=common_timestamp.usecs if function == 0xffffffff81200580' > events/timer/hrtimer_start/trigger
echo 'hist:keys=common_pid:lat=common_timestamp.usecs-$irqts:onmatch(timer.hrtimer_start).irq_lat($lat,pid) if common_flags & 1' > events/sched/sched_waking/trigger
echo 'hist:keys=pid:wakets=common_timestamp.usecs,irqlat=lat' > events/synthetic/irq_lat/trigger
echo 'hist:keys=next_pid:lat=common_timestamp.usecs-$wakets,irqlat=$irqlat:onmatch(synthetic.irq_lat).wake_lat($lat,$irqlat,next_pid)' > events/sched/sched_switch/trigger
echo 1 > events/synthetic/wake_lat/enable

Basically I wanted to see:

 hrtimer_start (calling function tick_sched_timer)

Note:

  # grep tick_sched_timer /proc/kallsyms
ffffffff81200580 t tick_sched_timer

And save the time of that, and then record sched_waking if it is called
in interrupt context and with the same pid as the hrtimer_start, it
will record the latency between that and the waking event.

I then look at when the task that is woken is scheduled in, and record
the latency between the wakeup and the task running.

At the end, the wake_lat synthetic event will show the wakeup to
scheduled latency, as well as the irq latency in from hritmer_start to
the wakeup. The problem is that I found this:

          <idle>-0     [007] d...   190.485261: wake_lat: lat=27 irqlat=190485230 pid=698
          <idle>-0     [005] d...   190.485283: wake_lat: lat=40 irqlat=190485239 pid=10
          <idle>-0     [002] d...   190.488327: wake_lat: lat=56 irqlat=190488266 pid=335
          <idle>-0     [005] d...   190.489330: wake_lat: lat=64 irqlat=190489262 pid=10
          <idle>-0     [003] d...   190.490312: wake_lat: lat=43 irqlat=190490265 pid=77
          <idle>-0     [005] d...   190.493322: wake_lat: lat=54 irqlat=190493262 pid=10
          <idle>-0     [005] d...   190.497305: wake_lat: lat=35 irqlat=190497267 pid=10
          <idle>-0     [005] d...   190.501319: wake_lat: lat=50 irqlat=190501264 pid=10

The irqlat seemed quite large! Investigating this further, if I had
enabled the irq_lat synthetic event, I noticed this:

          <idle>-0     [002] d.s.   249.429308: irq_lat: lat=164968 pid=335
          <idle>-0     [002] d...   249.429369: wake_lat: lat=55 irqlat=249429308 pid=335

Notice that the timestamp of the irq_lat "249.429308" is awfully
similar to the reported irqlat variable. In fact, all instances were
like this. It appeared that:

  irqlat=$irqlat

Wasn't assigning the old $irqlat to the new irqlat variable, but
instead was assigning the $irqts to it.

The issue is that assigning the old $irqlat to the new irqlat variable
creates a variable reference alias, but the alias creation code
forgets to make sure the alias uses the same var_ref_idx to access the
reference.

Link: http://lkml.kernel.org/r/1567375321.5282.12.camel@kernel.org

Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: stable@vger.kernel.org
Fixes: 7e8b88a30b085 ("tracing: Add hist trigger support for variable reference aliases")
Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 3a6e42aa08e6..9468bd8d44a2 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2804,6 +2804,8 @@ static struct hist_field *create_alias(struct hist_trigger_data *hist_data,
 		return NULL;
 	}
 
+	alias->var_ref_idx = var_ref->var_ref_idx;
+
 	return alias;
 }
 
-- 
2.20.1


