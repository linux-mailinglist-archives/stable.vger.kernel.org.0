Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E4B3ED60B
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbhHPNQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240281AbhHPNPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 229A5632D5;
        Mon, 16 Aug 2021 13:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119536;
        bh=DqdcKThS0O2SfOIg5rkGez4CmfO1I2FXgYtf6tpH4PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0JxR9zur6IkV8uN1u1VL1ZA4NmODiy+MO3tfHu3csXWtzwjs1oEm3K0XEiZa9pRPU
         sbBaM0Wp2j48fdHai1irFY2ux9V6/P1snYhTZXu8fTqsAPM5thmgL/qjaqRBs8iP/G
         MN5cVu/hZdHQ9yLbpx0AEFlnJDVoq1+UC5cLp2yY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Rik van Riel <riel@surriel.com>
Subject: [PATCH 5.13 021/151] cgroup: rstat: fix A-A deadlock on 32bit around u64_stats_sync
Date:   Mon, 16 Aug 2021 15:00:51 +0200
Message-Id: <20210816125444.769562704@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit c3df5fb57fe8756d67fd56ed29da65cdfde839f9 upstream.

0fa294fb1985 ("cgroup: Replace cgroup_rstat_mutex with a spinlock") added
cgroup_rstat_flush_irqsafe() allowing flushing to happen from the irq
context. However, rstat paths use u64_stats_sync to synchronize access to
64bit stat counters on 32bit machines. u64_stats_sync is implemented using
seq_lock and trying to read from an irq context can lead to A-A deadlock if
the irq happens to interrupt the stat update.

Fix it by using the irqsafe variants - u64_stats_update_begin_irqsave() and
u64_stats_update_end_irqrestore() - in the update paths. Note that none of
this matters on 64bit machines. All these are just for 32bit SMP setups.

Note that the interface was introduced way back, its first and currently
only use was recently added by 2d146aa3aa84 ("mm: memcontrol: switch to
rstat"). Stable tagging targets this commit.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Rik van Riel <riel@surriel.com>
Fixes: 2d146aa3aa84 ("mm: memcontrol: switch to rstat")
Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c    |   14 ++++++++------
 kernel/cgroup/rstat.c |   19 +++++++++++--------
 2 files changed, 19 insertions(+), 14 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -774,6 +774,7 @@ static void blkcg_rstat_flush(struct cgr
 		struct blkcg_gq *parent = blkg->parent;
 		struct blkg_iostat_set *bisc = per_cpu_ptr(blkg->iostat_cpu, cpu);
 		struct blkg_iostat cur, delta;
+		unsigned long flags;
 		unsigned int seq;
 
 		/* fetch the current per-cpu values */
@@ -783,21 +784,21 @@ static void blkcg_rstat_flush(struct cgr
 		} while (u64_stats_fetch_retry(&bisc->sync, seq));
 
 		/* propagate percpu delta to global */
-		u64_stats_update_begin(&blkg->iostat.sync);
+		flags = u64_stats_update_begin_irqsave(&blkg->iostat.sync);
 		blkg_iostat_set(&delta, &cur);
 		blkg_iostat_sub(&delta, &bisc->last);
 		blkg_iostat_add(&blkg->iostat.cur, &delta);
 		blkg_iostat_add(&bisc->last, &delta);
-		u64_stats_update_end(&blkg->iostat.sync);
+		u64_stats_update_end_irqrestore(&blkg->iostat.sync, flags);
 
 		/* propagate global delta to parent (unless that's root) */
 		if (parent && parent->parent) {
-			u64_stats_update_begin(&parent->iostat.sync);
+			flags = u64_stats_update_begin_irqsave(&parent->iostat.sync);
 			blkg_iostat_set(&delta, &blkg->iostat.cur);
 			blkg_iostat_sub(&delta, &blkg->iostat.last);
 			blkg_iostat_add(&parent->iostat.cur, &delta);
 			blkg_iostat_add(&blkg->iostat.last, &delta);
-			u64_stats_update_end(&parent->iostat.sync);
+			u64_stats_update_end_irqrestore(&parent->iostat.sync, flags);
 		}
 	}
 
@@ -832,6 +833,7 @@ static void blkcg_fill_root_iostats(void
 		memset(&tmp, 0, sizeof(tmp));
 		for_each_possible_cpu(cpu) {
 			struct disk_stats *cpu_dkstats;
+			unsigned long flags;
 
 			cpu_dkstats = per_cpu_ptr(bdev->bd_stats, cpu);
 			tmp.ios[BLKG_IOSTAT_READ] +=
@@ -848,9 +850,9 @@ static void blkcg_fill_root_iostats(void
 			tmp.bytes[BLKG_IOSTAT_DISCARD] +=
 				cpu_dkstats->sectors[STAT_DISCARD] << 9;
 
-			u64_stats_update_begin(&blkg->iostat.sync);
+			flags = u64_stats_update_begin_irqsave(&blkg->iostat.sync);
 			blkg_iostat_set(&blkg->iostat.cur, &tmp);
-			u64_stats_update_end(&blkg->iostat.sync);
+			u64_stats_update_end_irqrestore(&blkg->iostat.sync, flags);
 		}
 	}
 }
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -347,19 +347,20 @@ static void cgroup_base_stat_flush(struc
 }
 
 static struct cgroup_rstat_cpu *
-cgroup_base_stat_cputime_account_begin(struct cgroup *cgrp)
+cgroup_base_stat_cputime_account_begin(struct cgroup *cgrp, unsigned long *flags)
 {
 	struct cgroup_rstat_cpu *rstatc;
 
 	rstatc = get_cpu_ptr(cgrp->rstat_cpu);
-	u64_stats_update_begin(&rstatc->bsync);
+	*flags = u64_stats_update_begin_irqsave(&rstatc->bsync);
 	return rstatc;
 }
 
 static void cgroup_base_stat_cputime_account_end(struct cgroup *cgrp,
-						 struct cgroup_rstat_cpu *rstatc)
+						 struct cgroup_rstat_cpu *rstatc,
+						 unsigned long flags)
 {
-	u64_stats_update_end(&rstatc->bsync);
+	u64_stats_update_end_irqrestore(&rstatc->bsync, flags);
 	cgroup_rstat_updated(cgrp, smp_processor_id());
 	put_cpu_ptr(rstatc);
 }
@@ -367,18 +368,20 @@ static void cgroup_base_stat_cputime_acc
 void __cgroup_account_cputime(struct cgroup *cgrp, u64 delta_exec)
 {
 	struct cgroup_rstat_cpu *rstatc;
+	unsigned long flags;
 
-	rstatc = cgroup_base_stat_cputime_account_begin(cgrp);
+	rstatc = cgroup_base_stat_cputime_account_begin(cgrp, &flags);
 	rstatc->bstat.cputime.sum_exec_runtime += delta_exec;
-	cgroup_base_stat_cputime_account_end(cgrp, rstatc);
+	cgroup_base_stat_cputime_account_end(cgrp, rstatc, flags);
 }
 
 void __cgroup_account_cputime_field(struct cgroup *cgrp,
 				    enum cpu_usage_stat index, u64 delta_exec)
 {
 	struct cgroup_rstat_cpu *rstatc;
+	unsigned long flags;
 
-	rstatc = cgroup_base_stat_cputime_account_begin(cgrp);
+	rstatc = cgroup_base_stat_cputime_account_begin(cgrp, &flags);
 
 	switch (index) {
 	case CPUTIME_USER:
@@ -394,7 +397,7 @@ void __cgroup_account_cputime_field(stru
 		break;
 	}
 
-	cgroup_base_stat_cputime_account_end(cgrp, rstatc);
+	cgroup_base_stat_cputime_account_end(cgrp, rstatc, flags);
 }
 
 /*


