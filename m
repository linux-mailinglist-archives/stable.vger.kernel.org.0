Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1938D216FE2
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgGGPLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbgGGPLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:11:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8870B2078A;
        Tue,  7 Jul 2020 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134674;
        bh=pp7LbVfNg0KlEpeRGoaUoP4Ctzj9GX+/9aexR1AWft8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4PpI5CbeGKfz9XcyTe+wV3UjhvLKatIDEsAJRean9GIw5gxwphwAoipUK71WI7Ns
         xzdTD2niQKeoj2BOGm67xBSaC83MBSYptQz43Mrv7ipe1JJI40dbq6j3Gel+V96W0m
         1v3obVIPPTpK5FVmMbl36DgWgXTcnyQWUlzXU7sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shile Zhang <shile.zhang@nokia.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 09/19] sched/rt: Show the sched_rr_timeslice SCHED_RR timeslice tuning knob in milliseconds
Date:   Tue,  7 Jul 2020 17:10:12 +0200
Message-Id: <20200707145747.972946789@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145747.493710555@linuxfoundation.org>
References: <20200707145747.493710555@linuxfoundation.org>
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
index c9e4731cf10b8..7fc36ebc5de33 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -81,6 +81,7 @@ extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 extern unsigned int sysctl_sched_autogroup_enabled;
 #endif
 
+extern int sysctl_sched_rr_timeslice;
 extern int sched_rr_timeslice;
 
 extern int sched_rr_handler(struct ctl_table *table, int write,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 14a87c1f3a3ac..4a0a754f24c87 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8266,8 +8266,9 @@ int sched_rr_handler(struct ctl_table *table, int write,
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
index 801b4ec407023..5ee5740635f36 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -9,6 +9,7 @@
 #include <linux/irq_work.h>
 
 int sched_rr_timeslice = RR_TIMESLICE;
+int sysctl_sched_rr_timeslice = (MSEC_PER_SEC / HZ) * RR_TIMESLICE;
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c2dddd335d064..ecbb1b764a82e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -412,7 +412,7 @@ static struct ctl_table kern_table[] = {
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



