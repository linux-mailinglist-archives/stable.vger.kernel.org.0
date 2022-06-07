Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00E2541B6D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381240AbiFGVrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381966AbiFGVpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:45:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B5723524B;
        Tue,  7 Jun 2022 12:07:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A675BB823AE;
        Tue,  7 Jun 2022 19:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19ECAC385A2;
        Tue,  7 Jun 2022 19:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628852;
        bh=4LbOCf92jl4mfacrch4WyVDplyojpAhQ5IeBDU0OlTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luqYirGMxIhzwWLb9aTS8DZbjDvpmZkBNEhnUdsREqODuMXYP8b48XQKtZKNk8S4/
         lmj5zYN9Jezg0DWygtwy24AgA14OH8Bs6z96nzfhalSxa6hq1Hxs2J4Fkimk3knSjQ
         GALCixUi4Tr7SD0BzRhpGQNruBjTO6ipx18xRFSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfgang Bumiller <w.bumiller@proxmox.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 479/879] blk-cgroup: always terminate io.stat lines
Date:   Tue,  7 Jun 2022 18:59:57 +0200
Message-Id: <20220607165016.781356822@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfgang Bumiller <w.bumiller@proxmox.com>

[ Upstream commit 3607849df47822151b05df440759e2dc70160755 ]

With the removal of seq_get_buf in blkcg_print_one_stat, we
cannot make adding the newline conditional on there being
relevant stats because the name was already written out
unconditionally.
Otherwise we may end up with multiple device names in one
line which is confusing and doesn't follow the nested-keyed
file format.

Signed-off-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
Fixes: 252c651a4c85 ("blk-cgroup: stop using seq_get_buf")
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220111083159.42340-1-w.bumiller@proxmox.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c    | 9 ++-------
 block/blk-cgroup.h    | 2 +-
 block/blk-iocost.c    | 5 ++---
 block/blk-iolatency.c | 8 +++-----
 4 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8dfe62786cd5..6f9aeb6a337d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -905,7 +905,6 @@ static void blkcg_print_one_stat(struct blkcg_gq *blkg, struct seq_file *s)
 {
 	struct blkg_iostat_set *bis = &blkg->iostat;
 	u64 rbytes, wbytes, rios, wios, dbytes, dios;
-	bool has_stats = false;
 	const char *dname;
 	unsigned seq;
 	int i;
@@ -931,14 +930,12 @@ static void blkcg_print_one_stat(struct blkcg_gq *blkg, struct seq_file *s)
 	} while (u64_stats_fetch_retry(&bis->sync, seq));
 
 	if (rbytes || wbytes || rios || wios) {
-		has_stats = true;
 		seq_printf(s, "rbytes=%llu wbytes=%llu rios=%llu wios=%llu dbytes=%llu dios=%llu",
 			rbytes, wbytes, rios, wios,
 			dbytes, dios);
 	}
 
 	if (blkcg_debug_stats && atomic_read(&blkg->use_delay)) {
-		has_stats = true;
 		seq_printf(s, " use_delay=%d delay_nsec=%llu",
 			atomic_read(&blkg->use_delay),
 			atomic64_read(&blkg->delay_nsec));
@@ -950,12 +947,10 @@ static void blkcg_print_one_stat(struct blkcg_gq *blkg, struct seq_file *s)
 		if (!blkg->pd[i] || !pol->pd_stat_fn)
 			continue;
 
-		if (pol->pd_stat_fn(blkg->pd[i], s))
-			has_stats = true;
+		pol->pd_stat_fn(blkg->pd[i], s);
 	}
 
-	if (has_stats)
-		seq_printf(s, "\n");
+	seq_puts(s, "\n");
 }
 
 static int blkcg_print_stat(struct seq_file *sf, void *v)
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 47e1e38390c9..b56ba16fb6c5 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -63,7 +63,7 @@ typedef void (blkcg_pol_online_pd_fn)(struct blkg_policy_data *pd);
 typedef void (blkcg_pol_offline_pd_fn)(struct blkg_policy_data *pd);
 typedef void (blkcg_pol_free_pd_fn)(struct blkg_policy_data *pd);
 typedef void (blkcg_pol_reset_pd_stats_fn)(struct blkg_policy_data *pd);
-typedef bool (blkcg_pol_stat_pd_fn)(struct blkg_policy_data *pd,
+typedef void (blkcg_pol_stat_pd_fn)(struct blkg_policy_data *pd,
 				struct seq_file *s);
 
 struct blkcg_policy {
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 9bd670999d0a..16705fbd0699 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3005,13 +3005,13 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 	kfree(iocg);
 }
 
-static bool ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
+static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
 	struct ioc *ioc = iocg->ioc;
 
 	if (!ioc->enabled)
-		return false;
+		return;
 
 	if (iocg->level == 0) {
 		unsigned vp10k = DIV64_U64_ROUND_CLOSEST(
@@ -3027,7 +3027,6 @@ static bool ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
 			iocg->last_stat.wait_us,
 			iocg->last_stat.indebt_us,
 			iocg->last_stat.indelay_us);
-	return true;
 }
 
 static u64 ioc_weight_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 2f33932e72e3..5b676c7cf2b6 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -891,7 +891,7 @@ static int iolatency_print_limit(struct seq_file *sf, void *v)
 	return 0;
 }
 
-static bool iolatency_ssd_stat(struct iolatency_grp *iolat, struct seq_file *s)
+static void iolatency_ssd_stat(struct iolatency_grp *iolat, struct seq_file *s)
 {
 	struct latency_stat stat;
 	int cpu;
@@ -914,17 +914,16 @@ static bool iolatency_ssd_stat(struct iolatency_grp *iolat, struct seq_file *s)
 			(unsigned long long)stat.ps.missed,
 			(unsigned long long)stat.ps.total,
 			iolat->rq_depth.max_depth);
-	return true;
 }
 
-static bool iolatency_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
+static void iolatency_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
 {
 	struct iolatency_grp *iolat = pd_to_lat(pd);
 	unsigned long long avg_lat;
 	unsigned long long cur_win;
 
 	if (!blkcg_debug_stats)
-		return false;
+		return;
 
 	if (iolat->ssd)
 		return iolatency_ssd_stat(iolat, s);
@@ -937,7 +936,6 @@ static bool iolatency_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
 	else
 		seq_printf(s, " depth=%u avg_lat=%llu win=%llu",
 			iolat->rq_depth.max_depth, avg_lat, cur_win);
-	return true;
 }
 
 static struct blkg_policy_data *iolatency_pd_alloc(gfp_t gfp,
-- 
2.35.1



