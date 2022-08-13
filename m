Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B78C590E9E
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 12:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbiHLKD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 06:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiHLKDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 06:03:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9A3AA4E3;
        Fri, 12 Aug 2022 03:03:53 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M3zg318qszXdVQ;
        Fri, 12 Aug 2022 17:59:43 +0800 (CST)
Received: from huawei.com (10.67.174.191) by canpemm500009.china.huawei.com
 (7.192.105.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 12 Aug
 2022 18:03:50 +0800
From:   Li Hua <hucool.lihua@huawei.com>
To:     <mingo@redhat.com>, <peterz@infradead.org>,
        <juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
        <dietmar.eggemann@arm.com>, <rostedt@goodmis.org>,
        <bsegall@google.com>, <mgorman@suse.de>, <bristot@redhat.com>,
        <vschneid@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH -next] sched/cputime: Fix the bug of reading time backward from /proc/stat
Date:   Sat, 13 Aug 2022 08:01:02 +0800
Message-ID: <20220813000102.42051-1-hucool.lihua@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.174.191]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The problem that the statistical time goes backward, the value read first is 319, and the value read again is 318. As follows：
first：
cat /proc/stat |  grep cpu1
cpu1    319    0    496    41665    0    0    0    0    0    0
then：
cat /proc/stat |  grep cpu1
cpu1    318    0    497    41674    0    0    0    0    0    0

Time goes back, which is counterintuitive.

After debug this, The problem is caused by the implementation of kcpustat_cpu_fetch_vtime. As follows：

                              CPU0                                                                          CPU1
First:
show_stat():
    ->kcpustat_cpu_fetch()
        ->kcpustat_cpu_fetch_vtime()
            ->cpustat[CPUTIME_USER] = kcpustat_cpu(cpu) + vtime->utime + delta;              rq->curr is in user mod
             ---> When CPU1 rq->curr running on userspace, need add utime and delta
                                                                                             --->  rq->curr->vtime->utime is less than 1 tick
Then:
show_stat():
    ->kcpustat_cpu_fetch()
        ->kcpustat_cpu_fetch_vtime()
            ->cpustat[CPUTIME_USER] = kcpustat_cpu(cpu);                                     rq->curr is in kernel mod
            ---> When CPU1 rq->curr running on kernel space, just got kcpustat

Fixes: 74722bb223d0 ("sched/vtime: Bring up complete kcpustat accessor")
Signed-off-by: Li Hua <hucool.lihua@huawei.com>
---
 kernel/sched/core.c    |  1 +
 kernel/sched/cputime.c | 33 ++++++++++++++++++++++++++++++++-
 kernel/sched/sched.h   |  6 ++++++
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 189999007f32..c542b61cab54 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9753,6 +9753,7 @@ void __init sched_init(void)
 
 		rq->core_cookie = 0UL;
 #endif
+		cputime_cpu_init(i);
 	}
 
 	set_load_weight(&init_task, false);
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 95fc77853743..ba3bcb40795e 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -1060,6 +1060,19 @@ static int kcpustat_cpu_fetch_vtime(struct kernel_cpustat *dst,
 	return 0;
 }
 
+/*
+ * Stores the time of the last acquisition, which is used to handle the case of
+ * time backwards.
+ */
+static DEFINE_PER_CPU(struct kernel_cpustat, cpustat_prev);
+static DEFINE_PER_CPU(raw_spinlock_t, cpustat_prev_lock);
+
+void cputime_cpu_init(int cpu)
+{
+	raw_spin_lock_init(per_cpu_ptr(&cpustat_prev_lock, cpu));
+}
+
+
 void kcpustat_cpu_fetch(struct kernel_cpustat *dst, int cpu)
 {
 	const struct kernel_cpustat *src = &kcpustat_cpu(cpu);
@@ -1087,8 +1100,26 @@ void kcpustat_cpu_fetch(struct kernel_cpustat *dst, int cpu)
 		err = kcpustat_cpu_fetch_vtime(dst, src, curr, cpu);
 		rcu_read_unlock();
 
-		if (!err)
+		if (!err) {
+			int i;
+			int map[5] = {CPUTIME_USER, CPUTIME_SYSTEM, CPUTIME_NICE,
+				CPUTIME_GUEST, CPUTIME_GUEST_NICE};
+			struct kernel_cpustat *prev = &per_cpu(cpustat_prev, cpu);
+			raw_spinlock_t *cpustat_lock = &per_cpu(cpustat_prev_lock, cpu);
+			u64 *dst_stat = dst->cpustat;
+			u64 *prev_stat = prev->cpustat;
+
+			raw_spin_lock(cpustat_lock);
+			for (i = 0; i < 5; i++) {
+				int idx = map[i];
+
+				if (dst_stat[idx] < prev_stat[idx])
+					dst_stat[idx] = prev_stat[idx];
+			}
+			*prev = *dst;
+			raw_spin_unlock(cpustat_lock);
 			return;
+		}
 
 		cpu_relax();
 	}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a6f071b2acac..cbe09795a394 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3156,4 +3156,10 @@ extern int sched_dynamic_mode(const char *str);
 extern void sched_dynamic_update(int mode);
 #endif
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+extern void cputime_cpu_init(int cpu);
+#else
+static inline void cputime_cpu_init(int cpu) {}
+#endif
+
 #endif /* _KERNEL_SCHED_SCHED_H */
-- 
2.17.1

