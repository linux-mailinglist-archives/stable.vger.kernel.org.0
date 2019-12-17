Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC67122003
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfLQAv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:51:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34454 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbfLQAv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:29 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15D-0003IN-Mx; Tue, 17 Dec 2019 00:51:27 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15C-0005RK-Sk; Tue, 17 Dec 2019 00:51:26 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Viresh Kumar" <viresh.kumar@linaro.org>
Date:   Tue, 17 Dec 2019 00:45:35 +0000
Message-ID: <lsq.1576543535.245186895@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 001/136] hrtimer: Store cpu-number in struct
 hrtimer_cpu_base
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

commit cddd02489f52ccf635ed65931214729a23b93cd6 upstream.

In lowres mode, hrtimers are serviced by the tick instead of a clock
event. Now it works well as long as the tick stays periodic but we
must also make sure that the hrtimers are serviced in dynticks mode.

Part of that job consist in kicking a dynticks hrtimer target in order
to make it reconsider the next tick to schedule to correctly handle the
hrtimer's expiring time. And that part isn't handled by the hrtimers
subsystem.

To prepare for fixing this, we need __hrtimer_start_range_ns() to be
able to resolve the CPU target associated to a hrtimer's object
'cpu_base' so that the kick can be centralized there.

So lets store it in the 'struct hrtimer_cpu_base' to resolve the CPU
without overhead. It is set once at CPU's online notification.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1403393357-2070-4-git-send-email-fweisbec@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 3.16 as dependency of commit b9023b91dd02
 "tick: broadcast-hrtimer: Fix a race in bc_set_next":
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/hrtimer.h | 2 ++
 kernel/hrtimer.c        | 1 +
 2 files changed, 3 insertions(+)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -165,6 +165,7 @@ enum  hrtimer_base_type {
  * struct hrtimer_cpu_base - the per cpu clock bases
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
+ * @cpu:		cpu number
  * @active_bases:	Bitfield to mark bases with active timers
  * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
@@ -179,6 +180,7 @@ enum  hrtimer_base_type {
  */
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
+	unsigned int			cpu;
 	unsigned int			active_bases;
 	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1687,6 +1687,7 @@ static void init_hrtimers_cpu(int cpu)
 	}
 
 	cpu_base->active_bases = 0;
+	cpu_base->cpu = cpu;
 	hrtimer_init_hres(cpu_base);
 }
 

