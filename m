Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 997DC17814F
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387634AbgCCSBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:01:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388048AbgCCSBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:01:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27DE220656;
        Tue,  3 Mar 2020 18:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258504;
        bh=iC3KiavSmh80Y2SIDeaFyRbSocJf6RlacDi9Ii3VjW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PsevW7h4SaacUGRa6W3SkxfHvxy2WiT5wvTb27iC0F3ToY/eAvSUp2qbXtvR2mYf9
         fX+I01QaXMiSV672zTbHwXIiaJzVSuLgXyhqeh32JoYhU8t0aN0/cUqUDLatsCbmkJ
         bfdMsqo67X2ZfQatNoAw8sY+Pi6NkfH04jo9lO6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/87] bcache: ignore pending signals when creating gc and allocator thread
Date:   Tue,  3 Mar 2020 18:43:16 +0100
Message-Id: <20200303174352.755051667@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



