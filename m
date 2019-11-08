Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B48BF5872
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfKHUUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 15:20:40 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35340 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbfKHUUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 15:20:40 -0500
Received: by mail-oi1-f193.google.com with SMTP id n16so6403932oig.2
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 12:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2EzdLmKEklbymjVyhz+hrIqUyLYMLNQpvV2eT2eehtc=;
        b=ETew+FxEq01k1TjeZBYAMniyllc933VozBtjxve10KwF5ye+TjstI5FdTu9na8SKji
         q6ai/tCrfcc6tr4q8BWkVPpi4auyHesHYqizyCErOCFmCHY0BxbqcqQu+9l1EWeX2979
         9YSsLDyWlKItu2XfLKSkplWAMSXefQUaybyR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2EzdLmKEklbymjVyhz+hrIqUyLYMLNQpvV2eT2eehtc=;
        b=pG47WAeEv+cPZQRhNNBHfX+7HXiQNSzfuYuoqFTd3BJ1x7yj5pmuXrjzMfTMAX/YgQ
         fDPOW7gCj5mMY4X8v/c1e8S7rZNzI0QjGTZq+05mbtWmqhJeKhIQw/Sw9dqcJUUjMGFJ
         H7o5qffIH5uV+BcI/7RxQBm75nF01qTL0h2JMKTJbCJcRZ+211kgL4Y6Fu3pmk+aahnl
         KZfHchoIsdrC+xgQSRMKIGcAU/BNdHEqgUqjZOYXNFCVK9eRWS67wOVjpdUheunkXFHC
         uDxfu0I+6qzZRuIU0beeu0cN0lCc7HRUXXMdDjcFdEZtqAflCTZ0eNMzpaYmbwNzlxTB
         CN7w==
X-Gm-Message-State: APjAAAV4ZJI1awstrcKhYM0Dpa18xbwQDBizexqeLzJtUhJXZJ1Lk/A8
        DtzWkKeuGqV7oMXQBK0XQQ294g==
X-Google-Smtp-Source: APXvYqyHtYe4LZMfuAYOYV0DQ+t/y/bxFOU1MxU6CzPaYjoqH7d2eu3UsNZMQg9I3UCzIXMFHSzJVg==
X-Received: by 2002:aca:ab15:: with SMTP id u21mr11657473oie.176.1573244437536;
        Fri, 08 Nov 2019 12:20:37 -0800 (PST)
Received: from cando.ausoff.indeed.net ([97.105.47.162])
        by smtp.gmail.com with ESMTPSA id o18sm2251083otj.38.2019.11.08.12.20.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 12:20:37 -0800 (PST)
From:   Dave Chiluk <chiluk+linux@indeed.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Qian Cai <cai@lca.pw>
Subject: [PATCH v4.19.y 2/2] sched/fair: Fix -Wunused-but-set-variable warnings
Date:   Fri,  8 Nov 2019 14:20:08 -0600
Message-Id: <1573244408-31101-3-git-send-email-chiluk+linux@indeed.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573244408-31101-1-git-send-email-chiluk+linux@indeed.com>
References: <20191104110832.GE1945210@kroah.com>
 <1573244408-31101-1-git-send-email-chiluk+linux@indeed.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 763a9ec06c409dcde2a761aac4bb83ff3938e0b3 ]

Commit:

   de53fd7aedb1 ("sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices")

introduced a few compilation warnings:

  kernel/sched/fair.c: In function '__refill_cfs_bandwidth_runtime':
  kernel/sched/fair.c:4365:6: warning: variable 'now' set but not used [-Wunused-but-set-variable]
  kernel/sched/fair.c: In function 'start_cfs_bandwidth':
  kernel/sched/fair.c:4992:6: warning: variable 'overrun' set but not used [-Wunused-but-set-variable]

Also, __refill_cfs_bandwidth_runtime() does no longer update the
expiration time, so fix the comments accordingly.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ben Segall <bsegall@google.com>
Reviewed-by: Dave Chiluk <chiluk+linux@indeed.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: pauld@redhat.com
Fixes: de53fd7aedb1 ("sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices")
Link: https://lkml.kernel.org/r/1566326455-8038-1-git-send-email-cai@lca.pw
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cf0f476..e5e8f67 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4305,21 +4305,16 @@ static inline u64 sched_cfs_bandwidth_slice(void)
 }
 
 /*
- * Replenish runtime according to assigned quota and update expiration time.
- * We use sched_clock_cpu directly instead of rq->clock to avoid adding
- * additional synchronization around rq->lock.
+ * Replenish runtime according to assigned quota. We use sched_clock_cpu
+ * directly instead of rq->clock to avoid adding additional synchronization
+ * around rq->lock.
  *
  * requires cfs_b->lock
  */
 void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 {
-	u64 now;
-
-	if (cfs_b->quota == RUNTIME_INF)
-		return;
-
-	now = sched_clock_cpu(smp_processor_id());
-	cfs_b->runtime = cfs_b->quota;
+	if (cfs_b->quota != RUNTIME_INF)
+		cfs_b->runtime = cfs_b->quota;
 }
 
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
@@ -4924,15 +4919,13 @@ static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 
 void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
-	u64 overrun;
-
 	lockdep_assert_held(&cfs_b->lock);
 
 	if (cfs_b->period_active)
 		return;
 
 	cfs_b->period_active = 1;
-	overrun = hrtimer_forward_now(&cfs_b->period_timer, cfs_b->period);
+	hrtimer_forward_now(&cfs_b->period_timer, cfs_b->period);
 	hrtimer_start_expires(&cfs_b->period_timer, HRTIMER_MODE_ABS_PINNED);
 }
 
-- 
1.8.3.1

