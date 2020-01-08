Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D19134BED
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgAHTsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:48:13 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43718 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730464AbgAHTqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:04 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHE-0006om-2S; Wed, 08 Jan 2020 19:46:00 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-007dp6-Dx; Wed, 08 Jan 2020 19:45:59 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 08 Jan 2020 19:43:56 +0000
Message-ID: <lsq.1578512578.981696343@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 58/63] Revert "sched/fair: Fix bandwidth timer clock
 drift condition"
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit eb29ee5a3873134917a760bf9c416da0a089a0be, which
was commit 512ac999d2755d2b7109e996a76b6fb8b888631d upstream.  This
introduced a regression and doesn't seem to have been suitable for
older stable branches.  (It has been fixed differently upstream.)

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3163,7 +3163,6 @@ void __refill_cfs_bandwidth_runtime(stru
 	now = sched_clock_cpu(smp_processor_id());
 	cfs_b->runtime = cfs_b->quota;
 	cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
-	cfs_b->expires_seq++;
 }
 
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
@@ -3186,7 +3185,6 @@ static int assign_cfs_rq_runtime(struct
 	struct task_group *tg = cfs_rq->tg;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
 	u64 amount = 0, min_amount, expires;
-	int expires_seq;
 
 	/* note: this is a positive sum as runtime_remaining <= 0 */
 	min_amount = sched_cfs_bandwidth_slice() - cfs_rq->runtime_remaining;
@@ -3212,7 +3210,6 @@ static int assign_cfs_rq_runtime(struct
 			cfs_b->idle = 0;
 		}
 	}
-	expires_seq = cfs_b->expires_seq;
 	expires = cfs_b->runtime_expires;
 	raw_spin_unlock(&cfs_b->lock);
 
@@ -3222,10 +3219,8 @@ static int assign_cfs_rq_runtime(struct
 	 * spread between our sched_clock and the one on which runtime was
 	 * issued.
 	 */
-	if (cfs_rq->expires_seq != expires_seq) {
-		cfs_rq->expires_seq = expires_seq;
+	if ((s64)(expires - cfs_rq->runtime_expires) > 0)
 		cfs_rq->runtime_expires = expires;
-	}
 
 	return cfs_rq->runtime_remaining > 0;
 }
@@ -3251,9 +3246,12 @@ static void expire_cfs_rq_runtime(struct
 	 * has not truly expired.
 	 *
 	 * Fortunately we can check determine whether this the case by checking
-	 * whether the global deadline(cfs_b->expires_seq) has advanced.
+	 * whether the global deadline has advanced. It is valid to compare
+	 * cfs_b->runtime_expires without any locks since we only care about
+	 * exact equality, so a partial write will still work.
 	 */
-	if (cfs_rq->expires_seq == cfs_b->expires_seq) {
+
+	if (cfs_rq->runtime_expires != cfs_b->runtime_expires) {
 		/* extend local deadline, drift is bounded above by 2 ticks */
 		cfs_rq->runtime_expires += TICK_NSEC;
 	} else {
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -187,7 +187,6 @@ struct cfs_bandwidth {
 	u64 quota, runtime;
 	s64 hierarchal_quota;
 	u64 runtime_expires;
-	int expires_seq;
 
 	int idle, timer_active;
 	struct hrtimer period_timer, slack_timer;
@@ -377,7 +376,6 @@ struct cfs_rq {
 
 #ifdef CONFIG_CFS_BANDWIDTH
 	int runtime_enabled;
-	int expires_seq;
 	u64 runtime_expires;
 	s64 runtime_remaining;
 

