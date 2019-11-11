Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB049F7E57
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfKKSrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:47:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730078AbfKKSrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:47:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B772020659;
        Mon, 11 Nov 2019 18:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498031;
        bh=3zmmWrkhVixF8ktXxPXABX3RrKfAi2nvAkczyrrvkv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlTs3b4U3+RHP3+Ork6FqsffxY84QzyvOsHUp4T9zA9Lgnr6Ea2X32HrcR7j+PjA7
         RdKCIhHJjIplHj9KV3M+9nCNFnzh3cgUj+cmaQ50MxHV4X3pU0nFPjbDt1oEk6D5H8
         Ekwh27zn4CvKg/hiIpyfjSgCRZjV95bpCuZYi5TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>, Josef Bacik <jbacik@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/125] blkcg: make blkcg_print_stat() print stats only for online blkgs
Date:   Mon, 11 Nov 2019 19:29:20 +0100
Message-Id: <20191111181455.889495503@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit b0814361a25cba73a224548843ed92d8ea78715a ]

blkcg_print_stat() iterates blkgs under RCU and doesn't test whether
the blkg is online.  This can call into pd_stat_fn() on a pd which is
still being initialized leading to an oops.

The heaviest operation - recursively summing up rwstat counters - is
already done while holding the queue_lock.  Expand queue_lock to cover
the other operations and skip the blkg if it isn't online yet.  The
online state is protected by both blkcg and queue locks, so this
guarantees that only online blkgs are processed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Roman Gushchin <guro@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Fixes: 903d23f0a354 ("blk-cgroup: allow controllers to output their own stats")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 5275241346930..a06547fe6f6b4 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -955,9 +955,14 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 		int i;
 		bool has_stats = false;
 
+		spin_lock_irq(blkg->q->queue_lock);
+
+		if (!blkg->online)
+			goto skip;
+
 		dname = blkg_dev_name(blkg);
 		if (!dname)
-			continue;
+			goto skip;
 
 		/*
 		 * Hooray string manipulation, count is the size written NOT
@@ -967,8 +972,6 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 		 */
 		off += scnprintf(buf+off, size-off, "%s ", dname);
 
-		spin_lock_irq(blkg->q->queue_lock);
-
 		rwstat = blkg_rwstat_recursive_sum(blkg, NULL,
 					offsetof(struct blkcg_gq, stat_bytes));
 		rbytes = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_READ]);
@@ -981,8 +984,6 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 		wios = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_WRITE]);
 		dios = atomic64_read(&rwstat.aux_cnt[BLKG_RWSTAT_DISCARD]);
 
-		spin_unlock_irq(blkg->q->queue_lock);
-
 		if (rbytes || wbytes || rios || wios) {
 			has_stats = true;
 			off += scnprintf(buf+off, size-off,
@@ -1023,6 +1024,8 @@ next:
 				seq_commit(sf, -1);
 			}
 		}
+	skip:
+		spin_unlock_irq(blkg->q->queue_lock);
 	}
 
 	rcu_read_unlock();
-- 
2.20.1



