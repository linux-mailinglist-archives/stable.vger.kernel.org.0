Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F014526DC
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241354AbhKPCLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:40768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239146AbhKORyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:54:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4225632BE;
        Mon, 15 Nov 2021 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997593;
        bh=K7nlG8HgYzu9WQ9jWs0uyzdRTJRrzl3CIfHvUM1TOyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEacw0D9PFMpIDR45YAlHfjfL/oKnvTF3vczykS3UfwK3oeAe5xUs+xQpBBLS/TaE
         8kxibefLg/7njzwrlpOGpF1aWhLQz0Uxw3RsZRrm+zc883tOnsYocapFcQ9vkG6fl+
         KaaJzVxox6cyMViG6203Mlg4CAwLSJbd4kya6ioc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>,
        Josh Don <joshdon@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/575] fs/proc/uptime.c: Fix idle time reporting in /proc/uptime
Date:   Mon, 15 Nov 2021 17:58:49 +0100
Message-Id: <20211115165350.768569909@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Don <joshdon@google.com>

[ Upstream commit a130e8fbc7de796eb6e680724d87f4737a26d0ac ]

/proc/uptime reports idle time by reading the CPUTIME_IDLE field from
the per-cpu kcpustats. However, on NO_HZ systems, idle time is not
continually updated on idle cpus, leading this value to appear
incorrectly small.

/proc/stat performs an accounting update when reading idle time; we
can use the same approach for uptime.

With this patch, /proc/stat and /proc/uptime now agree on idle time.
Additionally, the following shows idle time tick up consistently on an
idle machine:

  (while true; do cat /proc/uptime; sleep 1; done) | awk '{print $2-prev; prev=$2}'

Reported-by: Luigi Rizzo <lrizzo@google.com>
Signed-off-by: Josh Don <joshdon@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lkml.kernel.org/r/20210827165438.3280779-1-joshdon@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/stat.c              |  4 ++--
 fs/proc/uptime.c            | 14 +++++++++-----
 include/linux/kernel_stat.h |  1 +
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 4695b6de31512..3bed48d8228b4 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -23,7 +23,7 @@
 
 #ifdef arch_idle_time
 
-static u64 get_idle_time(struct kernel_cpustat *kcs, int cpu)
+u64 get_idle_time(struct kernel_cpustat *kcs, int cpu)
 {
 	u64 idle;
 
@@ -45,7 +45,7 @@ static u64 get_iowait_time(struct kernel_cpustat *kcs, int cpu)
 
 #else
 
-static u64 get_idle_time(struct kernel_cpustat *kcs, int cpu)
+u64 get_idle_time(struct kernel_cpustat *kcs, int cpu)
 {
 	u64 idle, idle_usecs = -1ULL;
 
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 5a1b228964fb7..deb99bc9b7e6b 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -12,18 +12,22 @@ static int uptime_proc_show(struct seq_file *m, void *v)
 {
 	struct timespec64 uptime;
 	struct timespec64 idle;
-	u64 nsec;
+	u64 idle_nsec;
 	u32 rem;
 	int i;
 
-	nsec = 0;
-	for_each_possible_cpu(i)
-		nsec += (__force u64) kcpustat_cpu(i).cpustat[CPUTIME_IDLE];
+	idle_nsec = 0;
+	for_each_possible_cpu(i) {
+		struct kernel_cpustat kcs;
+
+		kcpustat_cpu_fetch(&kcs, i);
+		idle_nsec += get_idle_time(&kcs, i);
+	}
 
 	ktime_get_boottime_ts64(&uptime);
 	timens_add_boottime(&uptime);
 
-	idle.tv_sec = div_u64_rem(nsec, NSEC_PER_SEC, &rem);
+	idle.tv_sec = div_u64_rem(idle_nsec, NSEC_PER_SEC, &rem);
 	idle.tv_nsec = rem;
 	seq_printf(m, "%lu.%02lu %lu.%02lu\n",
 			(unsigned long) uptime.tv_sec,
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 89f0745c096d4..8fff3500d50ee 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -103,6 +103,7 @@ extern void account_system_index_time(struct task_struct *, u64,
 				      enum cpu_usage_stat);
 extern void account_steal_time(u64);
 extern void account_idle_time(u64);
+extern u64 get_idle_time(struct kernel_cpustat *kcs, int cpu);
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 static inline void account_process_tick(struct task_struct *tsk, int user)
-- 
2.33.0



