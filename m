Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D15E916942F
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgBWCYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:24:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729031AbgBWCYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:24:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE5B42465D;
        Sun, 23 Feb 2020 02:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424648;
        bh=iC3KiavSmh80Y2SIDeaFyRbSocJf6RlacDi9Ii3VjW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QWeSTzw+kOzXLpXR98b3cZf5mSHWucTNvNxEiRT4tnbBRiXyApHNpj14IxH5V41T
         Hmme0UTQiP8TL5HPwIP9rXh1L2y9i8yUQaxVqUnDBrdrF/AQMtKduZb4UVYLYYQEXT
         G5McFVzx9No6qf6JC/TH+8vGFtMmqAhCWHhz2/ZM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/25] bcache: ignore pending signals when creating gc and allocator thread
Date:   Sat, 22 Feb 2020 21:23:38 -0500
Message-Id: <20200223022339.1885-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022339.1885-1-sashal@kernel.org>
References: <20200223022339.1885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 0b96da639a4874311e9b5156405f69ef9fc3bef8 ]

When run a cache set, all the bcache btree node of this cache set will
be checked by bch_btree_check(). If the bcache btree is very large,
iterating all the btree nodes will occupy too much system memory and
the bcache registering process might be selected and killed by system
OOM killer. kthread_run() will fail if current process has pending
signal, therefore the kthread creating in run_cache_set() for gc and
allocator kernel threads are very probably failed for a very large
bcache btree.

Indeed such OOM is safe and the registering process will exit after
the registration done. Therefore this patch flushes pending signals
during the cache set start up, specificly in bch_cache_allocator_start()
and bch_gc_thread_start(), to make sure run_cache_set() won't fail for
large cahced data set.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/alloc.c | 18 ++++++++++++++++--
 drivers/md/bcache/btree.c | 13 +++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 46794cac167e7..2074860cbb16c 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -67,6 +67,7 @@
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/random.h>
+#include <linux/sched/signal.h>
 #include <trace/events/bcache.h>
 
 #define MAX_OPEN_BUCKETS 128
@@ -733,8 +734,21 @@ int bch_open_buckets_alloc(struct cache_set *c)
 
 int bch_cache_allocator_start(struct cache *ca)
 {
-	struct task_struct *k = kthread_run(bch_allocator_thread,
-					    ca, "bcache_allocator");
+	struct task_struct *k;
+
+	/*
+	 * In case previous btree check operation occupies too many
+	 * system memory for bcache btree node cache, and the
+	 * registering process is selected by OOM killer. Here just
+	 * ignore the SIGKILL sent by OOM killer if there is, to
+	 * avoid kthread_run() being failed by pending signals. The
+	 * bcache registering process will exit after the registration
+	 * done.
+	 */
+	if (signal_pending(current))
+		flush_signals(current);
+
+	k = kthread_run(bch_allocator_thread, ca, "bcache_allocator");
 	if (IS_ERR(k))
 		return PTR_ERR(k);
 
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index bb40bd66a10e4..83d6739fd067b 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -34,6 +34,7 @@
 #include <linux/random.h>
 #include <linux/rcupdate.h>
 #include <linux/sched/clock.h>
+#include <linux/sched/signal.h>
 #include <linux/rculist.h>
 #include <linux/delay.h>
 #include <trace/events/bcache.h>
@@ -1898,6 +1899,18 @@ static int bch_gc_thread(void *arg)
 
 int bch_gc_thread_start(struct cache_set *c)
 {
+	/*
+	 * In case previous btree check operation occupies too many
+	 * system memory for bcache btree node cache, and the
+	 * registering process is selected by OOM killer. Here just
+	 * ignore the SIGKILL sent by OOM killer if there is, to
+	 * avoid kthread_run() being failed by pending signals. The
+	 * bcache registering process will exit after the registration
+	 * done.
+	 */
+	if (signal_pending(current))
+		flush_signals(current);
+
 	c->gc_thread = kthread_run(bch_gc_thread, c, "bcache_gc");
 	return PTR_ERR_OR_ZERO(c->gc_thread);
 }
-- 
2.20.1

