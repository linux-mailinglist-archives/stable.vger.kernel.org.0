Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A53FD2325
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387926AbfJJIjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387917AbfJJIjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA0CC2196E;
        Thu, 10 Oct 2019 08:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696778;
        bh=kXRkOfBAkQq2qSRWaYK/tWRsdccPsnNMDtyWyCDnW3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I4jktegz18/1QO8eDyBNL6kVjborOoCmYU2Sun9IYFFMrsdS1P362z9WLfxuzPrIr
         IVQ4vtlV99HFcyHD7GTUMkAmTUdjzr2GZ9uiJlucyLmExZ+1ha1Bl/x4JtLp5l0K6L
         zXVwQVEcpIWBZf4mIGdTiDni+WdsEDXZALoT/xUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Tom Zanussi <zanussi@kernel.org>
Subject: [PATCH 5.3 050/148] tracing: Make sure variable reference alias has correct var_ref_idx
Date:   Thu, 10 Oct 2019 10:35:11 +0200
Message-Id: <20191010083614.182158465@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

commit 17f8607a1658a8e70415eef67909f990d13017b5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events_hist.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2785,6 +2785,8 @@ static struct hist_field *create_alias(s
 		return NULL;
 	}
 
+	alias->var_ref_idx = var_ref->var_ref_idx;
+
 	return alias;
 }
 


