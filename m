Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB84244F3A0
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 15:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhKMOX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 09:23:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231672AbhKMOX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 09:23:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 920A8611AE;
        Sat, 13 Nov 2021 14:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636813237;
        bh=Rvy+ay1lCFRPI8hk+PKMauqC5KCfmNkRYNoZmsgPjJU=;
        h=Subject:To:Cc:From:Date:From;
        b=wwvSfiCwgz8QdGer3cjVGgQhWO8D1pmuihEwg0CoY+C5mP2fRcv+Kg5X/tyTnadwC
         nBGholoHSFQe10VQOZa16J/qBgTwV8lcgpZVLAY6Db8ZZ99Grd3w9y5X9sh1qstXzT
         Ixr15BTqoLVl0XrZ98Vwfj4jNulsw8ksZDRkWJRk=
Subject: FAILED: patch "[PATCH] blk-cgroup: blk_cgroup_bio_start() should use irq-safe" failed to apply to 5.15-stable tree
To:     tj@kernel.org, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 15:20:34 +0100
Message-ID: <1636813234180139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3c08b0931eedd04c530040499fadeccab50ed646 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 14 Oct 2021 13:20:22 -1000
Subject: [PATCH] blk-cgroup: blk_cgroup_bio_start() should use irq-safe
 operations on blkg->iostat_cpu

c3df5fb57fe8 ("cgroup: rstat: fix A-A deadlock on 32bit around
u64_stats_sync") made u64_stats updates irq-safe to avoid A-A deadlocks.
Unfortunately, the conversion missed one in blk_cgroup_bio_start(). Fix it.

Fixes: 2d146aa3aa84 ("mm: memcontrol: switch to rstat")
Cc: stable@vger.kernel.org # v5.13+
Reported-by: syzbot+9738c8815b375ce482a1@syzkaller.appspotmail.com
Signed-off-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/YWi7NrQdVlxD6J9W@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 38b9f7684952..9a1c5839dd46 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1897,10 +1897,11 @@ void blk_cgroup_bio_start(struct bio *bio)
 {
 	int rwd = blk_cgroup_io_type(bio), cpu;
 	struct blkg_iostat_set *bis;
+	unsigned long flags;
 
 	cpu = get_cpu();
 	bis = per_cpu_ptr(bio->bi_blkg->iostat_cpu, cpu);
-	u64_stats_update_begin(&bis->sync);
+	flags = u64_stats_update_begin_irqsave(&bis->sync);
 
 	/*
 	 * If the bio is flagged with BIO_CGROUP_ACCT it means this is a split
@@ -1912,7 +1913,7 @@ void blk_cgroup_bio_start(struct bio *bio)
 	}
 	bis->cur.ios[rwd]++;
 
-	u64_stats_update_end(&bis->sync);
+	u64_stats_update_end_irqrestore(&bis->sync, flags);
 	if (cgroup_subsys_on_dfl(io_cgrp_subsys))
 		cgroup_rstat_updated(bio->bi_blkg->blkcg->css.cgroup, cpu);
 	put_cpu();

