Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486CC26EC88
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgIRCMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbgIRCMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC283235F9;
        Fri, 18 Sep 2020 02:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395157;
        bh=v9e5EIZg8+POtQz8j/8Qec6+wWcqAFirIwIHnPU3ILg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vU9N+fkUcRQlAM5w5akyjVwhAVhSIyTlx/ZimbEa9hdbAS2ks0Fe7+XTXC+PjBbCE
         0x4uTavToDzOmgfONbpWJ7zVv/leSlPR8dT3fPR5rICBnmnJfvHxUrHSNPZ/uTKUz3
         tLTsDRWc8s8/Jjtorw2PKsi/HQ1cDBmi8F5byqKE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guoju Fang <fangguoju@gmail.com>, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 015/127] bcache: fix a lost wake-up problem caused by mca_cannibalize_lock
Date:   Thu, 17 Sep 2020 22:10:28 -0400
Message-Id: <20200918021220.2066485-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoju Fang <fangguoju@gmail.com>

[ Upstream commit 34cf78bf34d48dddddfeeadb44f9841d7864997a ]

This patch fix a lost wake-up problem caused by the race between
mca_cannibalize_lock and bch_cannibalize_unlock.

Consider two processes, A and B. Process A is executing
mca_cannibalize_lock, while process B takes c->btree_cache_alloc_lock
and is executing bch_cannibalize_unlock. The problem happens that after
process A executes cmpxchg and will execute prepare_to_wait. In this
timeslice process B executes wake_up, but after that process A executes
prepare_to_wait and set the state to TASK_INTERRUPTIBLE. Then process A
goes to sleep but no one will wake up it. This problem may cause bcache
device to dead.

Signed-off-by: Guoju Fang <fangguoju@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/btree.c  | 12 ++++++++----
 drivers/md/bcache/super.c  |  1 +
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index e4a3f692057b8..a3763d664a67a 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -548,6 +548,7 @@ struct cache_set {
 	 */
 	wait_queue_head_t	btree_cache_wait;
 	struct task_struct	*btree_cache_alloc_lock;
+	spinlock_t		btree_cannibalize_lock;
 
 	/*
 	 * When we free a btree node, we increment the gen of the bucket the
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 9fca837d0b41e..fba0fff8040d6 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -840,15 +840,17 @@ out:
 
 static int mca_cannibalize_lock(struct cache_set *c, struct btree_op *op)
 {
-	struct task_struct *old;
-
-	old = cmpxchg(&c->btree_cache_alloc_lock, NULL, current);
-	if (old && old != current) {
+	spin_lock(&c->btree_cannibalize_lock);
+	if (likely(c->btree_cache_alloc_lock == NULL)) {
+		c->btree_cache_alloc_lock = current;
+	} else if (c->btree_cache_alloc_lock != current) {
 		if (op)
 			prepare_to_wait(&c->btree_cache_wait, &op->wait,
 					TASK_UNINTERRUPTIBLE);
+		spin_unlock(&c->btree_cannibalize_lock);
 		return -EINTR;
 	}
+	spin_unlock(&c->btree_cannibalize_lock);
 
 	return 0;
 }
@@ -883,10 +885,12 @@ static struct btree *mca_cannibalize(struct cache_set *c, struct btree_op *op,
  */
 static void bch_cannibalize_unlock(struct cache_set *c)
 {
+	spin_lock(&c->btree_cannibalize_lock);
 	if (c->btree_cache_alloc_lock == current) {
 		c->btree_cache_alloc_lock = NULL;
 		wake_up(&c->btree_cache_wait);
 	}
+	spin_unlock(&c->btree_cannibalize_lock);
 }
 
 static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 7fcc1ba12bc01..6bf1559a1f0db 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1510,6 +1510,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	sema_init(&c->sb_write_mutex, 1);
 	mutex_init(&c->bucket_lock);
 	init_waitqueue_head(&c->btree_cache_wait);
+	spin_lock_init(&c->btree_cannibalize_lock);
 	init_waitqueue_head(&c->bucket_wait);
 	init_waitqueue_head(&c->gc_wait);
 	sema_init(&c->uuid_write_mutex, 1);
-- 
2.25.1

