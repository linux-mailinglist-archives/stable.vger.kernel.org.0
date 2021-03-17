Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D86933E328
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhCQA4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhCQAzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:55:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6788964F9E;
        Wed, 17 Mar 2021 00:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942552;
        bh=O/0q2JjobzsUmuE+dvnraPV+i669n5v5EMZTYrRvoEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVWbtaKt5AE+9BJ1ke1Oka9+q6I/uxTjwcWERS2Uc2DH9oA4G0bi7CglSVv3W/hl6
         cwjUAyy3LfL7wakL0E3G+XAJq9L2ASbVTP5r98E6hxxxvIulPBQ31vf/YcAMRaW8LB
         95a5+c7mhLjQRrMtd8nZDZfhtX+QOu0MUkUED+sCF9FkI+Pgx/nrCAWLsBm8cR2A5D
         lS78joHpOTD9Be61JOCKmL/MZZdYOKg7ETyroeDBq4mOT6kvZItcOUYLJJvJOsPsOX
         fplf8XW8Pk73G8kCJoqs10PntYojMS/Uh06eTRsxL+nu6z8PV2hcfx0wyMZRZiSUnD
         8YJuJB3ThPk6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 12/61] blk-cgroup: Fix the recursive blkg rwstat
Date:   Tue, 16 Mar 2021 20:54:46 -0400
Message-Id: <20210317005536.724046-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xunlei Pang <xlpang@linux.alibaba.com>

[ Upstream commit 4f44657d74873735e93a50eb25014721a66aac19 ]

The current blkio.throttle.io_service_bytes_recursive doesn't
work correctly.

As an example, for the following blkcg hierarchy:
 (Made 1GB READ in test1, 512MB READ in test2)
     test
    /    \
 test1   test2

$ head -n 1 test/test1/blkio.throttle.io_service_bytes_recursive
8:0 Read 1073684480
$ head -n 1 test/test2/blkio.throttle.io_service_bytes_recursive
8:0 Read 537448448
$ head -n 1 test/blkio.throttle.io_service_bytes_recursive
8:0 Read 537448448

Clearly, above data of "test" reflects "test2" not "test1"+"test2".

Do the correct summary in blkg_rwstat_recursive_sum().

Signed-off-by: Xunlei Pang <xlpang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup-rwstat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup-rwstat.c b/block/blk-cgroup-rwstat.c
index 85d5790ac49b..3304e841df7c 100644
--- a/block/blk-cgroup-rwstat.c
+++ b/block/blk-cgroup-rwstat.c
@@ -109,6 +109,7 @@ void blkg_rwstat_recursive_sum(struct blkcg_gq *blkg, struct blkcg_policy *pol,
 
 	lockdep_assert_held(&blkg->q->queue_lock);
 
+	memset(sum, 0, sizeof(*sum));
 	rcu_read_lock();
 	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
 		struct blkg_rwstat *rwstat;
@@ -122,7 +123,7 @@ void blkg_rwstat_recursive_sum(struct blkcg_gq *blkg, struct blkcg_policy *pol,
 			rwstat = (void *)pos_blkg + off;
 
 		for (i = 0; i < BLKG_RWSTAT_NR; i++)
-			sum->cnt[i] = blkg_rwstat_read_counter(rwstat, i);
+			sum->cnt[i] += blkg_rwstat_read_counter(rwstat, i);
 	}
 	rcu_read_unlock();
 }
-- 
2.30.1

