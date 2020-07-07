Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F800216FFF
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgGGPON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:14:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbgGGPOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:14:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E006A2078A;
        Tue,  7 Jul 2020 15:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134851;
        bh=Wu5e8RTd770WFHtprBIGKMBuXhMr5rtbnQ+P5GmbV3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2Da2jcGeCLF1eE6fsuywMH/1q1jr2C0ec0GDihRvIfCXDMhdHkqCFCD09LZJPM5B
         /Ig4PWKuHIA4scCZ2xOdFsLj6C7CyN0n/Zz2ftAGy9z7XmmQuh4T2qBfdRRnYTMY1n
         gjqJoIc0OBOAYYf/585Hqpa8jo7K22zh4tqMIFvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shile Zhang <shile.zhang@nokia.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 12/24] sched/rt: Show the sched_rr_timeslice SCHED_RR timeslice tuning knob in milliseconds
Date:   Tue,  7 Jul 2020 17:13:44 +0200
Message-Id: <20200707145749.567231637@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.952502272@linuxfoundation.org>
References: <20200707145748.952502272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shile Zhang <shile.zhang@nokia.com>

[ Upstream commit 975e155ed8732cb81f55c021c441ae662dd040b5 ]

We added the 'sched_rr_timeslice_ms' SCHED_RR tuning knob in this commit:

  ce0dbbbb30ae ("sched/rt: Add a tuning knob to allow changing SCHED_RR timeslice")

... which name suggests to users that it's in milliseconds, while in reality
it's being set in milliseconds but the result is shown in jiffies.

This is obviously confusing when HZ is not 1000, it makes it appear like the
value set failed, such as HZ=100:

  root# echo 100 > /proc/sys/kernel/sched_rr_timeslice_ms
  root# cat /proc/sys/kernel/sched_rr_timeslice_ms
  10

Fix this to be milliseconds all around.

Signed-off-by: Shile Zhang <shile.zhang@nokia.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1485612049-20923-1-git-send-email-shile.zhang@nokia.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/sysctl.h | 1 +
 kernel/sched/core.c          | 5 +++--
 kernel/sched/rt.c            | 1 +
 kernel/sysctl.c              | 2 +-
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 05e8b6e4edcb6..debcd4bf22956 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -60,6 +60,7 @@ extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 extern unsigned int sysctl_sched_autogroup_enabled;
 #endif
 
+extern int sysctl_sched_rr_timeslice;
 extern int sched_rr_timeslice;
 
 extern int sched_rr_handler(struct ctl_table *table, int write,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 870d802c46f90..c7c7ba8807f83 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8389,8 +8389,9 @@ int sched_rr_handler(struct ctl_table *table, int write,
 	/* make sure that internally we keep jiffies */
 	/* also, writing zero resets timeslice to default */
 	if (!ret && write) {
-		sched_rr_timeslice = sched_rr_timeslice <= 0 ?
-			RR_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
+		sched_rr_timeslice =
+			sysctl_sched_rr_timeslice <= 0 ? RR_TIMESLICE :
+			msecs_to_jiffies(sysctl_sched_rr_timeslice);
 	}
 	mutex_unlock(&mutex);
 	return ret;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 9ab4d73e9cc95..5034c41a53130 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -9,6 +9,7 @@
 #include <linux/irq_work.h>
 
 int sched_rr_timeslice = RR_TIMESLICE;
+int sysctl_sched_rr_timeslice = (MSEC_PER_SEC / HZ) * RR_TIMESLICE;
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34449ec0689d0..513e6da318c47 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -426,7 +426,7 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.procname	= "sched_rr_timeslice_ms",
-		.data		= &sched_rr_timeslice,
+		.data		= &sysctl_sched_rr_timeslice,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= sched_rr_handler,
-- 
2.25.1



