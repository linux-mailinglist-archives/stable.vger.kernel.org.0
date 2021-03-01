Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856FC329134
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbhCAUVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:21:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236505AbhCAUNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 892CD6524D;
        Mon,  1 Mar 2021 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621693;
        bh=oihLs2AOUTlx62J++4LQN7xASD7nfmTw1EvwxZjZ4RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOSqkwnXxqVLjbVaCcsNi+uE5I3zRUVHPjOLMk0fQXEIkN4qgRfl2Y0F8nHr1LN/i
         e4ATFblk2ejh/eJ6GyZ14jZKpc+OwqVJ152kcJeZ5Gx6Xi5ZrCLmYXsG3ig9pTxSZz
         6CITquafGIfILF+b+VOhxQ4c9ryBNJvs2tklSjnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Kai Krakow <kai@kaishome.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.11 610/775] bcache: Move journal work to new flush wq
Date:   Mon,  1 Mar 2021 17:12:58 +0100
Message-Id: <20210301161231.560558187@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Krakow <kai@kaishome.de>

commit afe78ab46f638ecdf80a35b122ffc92c20d9ae5d upstream.

This is potentially long running and not latency sensitive, let's get
it out of the way of other latency sensitive events.

As observed in the previous commit, the `system_wq` comes easily
congested by bcache, and this fixes a few more stalls I was observing
every once in a while.

Let's not make this `WQ_MEM_RECLAIM` as it showed to reduce performance
of boot and file system operations in my tests. Also, without
`WQ_MEM_RECLAIM`, I no longer see desktop stalls. This matches the
previous behavior as `system_wq` also does no memory reclaim:

> // workqueue.c:
> system_wq = alloc_workqueue("events", 0, 0);

Cc: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Kai Krakow <kai@kaishome.de>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/bcache.h  |    1 +
 drivers/md/bcache/journal.c |    4 ++--
 drivers/md/bcache/super.c   |   16 ++++++++++++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1001,6 +1001,7 @@ void bch_write_bdev_super(struct cached_
 
 extern struct workqueue_struct *bcache_wq;
 extern struct workqueue_struct *bch_journal_wq;
+extern struct workqueue_struct *bch_flush_wq;
 extern struct mutex bch_register_lock;
 extern struct list_head bch_cache_sets;
 
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -932,8 +932,8 @@ atomic_t *bch_journal(struct cache_set *
 		journal_try_write(c);
 	} else if (!w->dirty) {
 		w->dirty = true;
-		schedule_delayed_work(&c->journal.work,
-				      msecs_to_jiffies(c->journal_delay_ms));
+		queue_delayed_work(bch_flush_wq, &c->journal.work,
+				   msecs_to_jiffies(c->journal_delay_ms));
 		spin_unlock(&c->journal.lock);
 	} else {
 		spin_unlock(&c->journal.lock);
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -49,6 +49,7 @@ static int bcache_major;
 static DEFINE_IDA(bcache_device_idx);
 static wait_queue_head_t unregister_wait;
 struct workqueue_struct *bcache_wq;
+struct workqueue_struct *bch_flush_wq;
 struct workqueue_struct *bch_journal_wq;
 
 
@@ -2821,6 +2822,8 @@ static void bcache_exit(void)
 		destroy_workqueue(bcache_wq);
 	if (bch_journal_wq)
 		destroy_workqueue(bch_journal_wq);
+	if (bch_flush_wq)
+		destroy_workqueue(bch_flush_wq);
 	bch_btree_exit();
 
 	if (bcache_major)
@@ -2884,6 +2887,19 @@ static int __init bcache_init(void)
 	if (!bcache_wq)
 		goto err;
 
+	/*
+	 * Let's not make this `WQ_MEM_RECLAIM` for the following reasons:
+	 *
+	 * 1. It used `system_wq` before which also does no memory reclaim.
+	 * 2. With `WQ_MEM_RECLAIM` desktop stalls, increased boot times, and
+	 *    reduced throughput can be observed.
+	 *
+	 * We still want to user our own queue to not congest the `system_wq`.
+	 */
+	bch_flush_wq = alloc_workqueue("bch_flush", 0, 0);
+	if (!bch_flush_wq)
+		goto err;
+
 	bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
 	if (!bch_journal_wq)
 		goto err;


