Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5C533E3EC
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhCQA5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231129AbhCQA5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D06464FAE;
        Wed, 17 Mar 2021 00:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942629;
        bh=O/0q2JjobzsUmuE+dvnraPV+i669n5v5EMZTYrRvoEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Smtc452d+GYzlUC/pP+JcQUO6VtVK7zv1T6MczjKNrBIQWhgdnj4Y4cmr7zJqGnez
         HMBmtqLuifXNB7PXCQ6FsnIxmZJG1OPrvclQcSnlko3ULM8cSGH/rOzLT6U6S9Eg4x
         lDflwE1e61IHUT1TRQmwNb++whU27VPKeXkAeWRojDuKCP7NpSY6DxhCoI1Pb5bM99
         2ZemzGPSMAP1pS5f5+1Lw9rEQmzqZlunlivrZC/nmvg6Xi4o4LASaJVwE6aAj86hlx
         D52dlIM6kyqFJDGRhqCPoHXUD6PCVE06Flq6eihIF6Y1GwWKKB2PDD1gJNtEYsgd7s
         HoiympzF+gt6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/54] blk-cgroup: Fix the recursive blkg rwstat
Date:   Tue, 16 Mar 2021 20:56:10 -0400
Message-Id: <20210317005654.724862-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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

