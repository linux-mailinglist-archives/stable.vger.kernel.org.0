Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7761328A45
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbhCASOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:14:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239375AbhCASIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25B7B65247;
        Mon,  1 Mar 2021 17:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619590;
        bh=a0ZdU/Z3Td2sBmD22wWF9W0sf6E9aJas/CgBtjEisxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qra6x4U/IJqEMzL7OzZVdczvCmfJrW9BAGO1u54+ZpJCS/SzsHCRpat4zaLzxNA8I
         G5LLzNPfbbO0l2f1zgxmu/T6u5HKhHUtbuweA42iC49p2idwer/yLhPPYl166oYbZV
         oqmCu0lk/6WpG8bwKGgs8qWaFLZttftykklkoxjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Kai Krakow <kai@kaishome.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 509/663] Revert "bcache: Kill btree_io_wq"
Date:   Mon,  1 Mar 2021 17:12:37 +0100
Message-Id: <20210301161207.028176866@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Krakow <kai@kaishome.de>

commit 9f233ffe02e5cef611100cd8c5bcf4de26ca7bef upstream.

This reverts commit 56b30770b27d54d68ad51eccc6d888282b568cee.

With the btree using the `system_wq`, I seem to see a lot more desktop
latency than I should.

After some more investigation, it looks like the original assumption
of 56b3077 no longer is true, and bcache has a very high potential of
congesting the `system_wq`. In turn, this introduces laggy desktop
performance, IO stalls (at least with btrfs), and input events may be
delayed.

So let's revert this. It's important to note that the semantics of
using `system_wq` previously mean that `btree_io_wq` should be created
before and destroyed after other bcache wqs to keep the same
assumptions.

Cc: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Kai Krakow <kai@kaishome.de>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/bcache.h |    2 ++
 drivers/md/bcache/btree.c  |   21 +++++++++++++++++++--
 drivers/md/bcache/super.c  |    4 ++++
 3 files changed, 25 insertions(+), 2 deletions(-)

--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1042,5 +1042,7 @@ void bch_debug_exit(void);
 void bch_debug_init(void);
 void bch_request_exit(void);
 int bch_request_init(void);
+void bch_btree_exit(void);
+int bch_btree_init(void);
 
 #endif /* _BCACHE_H */
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -99,6 +99,8 @@
 #define PTR_HASH(c, k)							\
 	(((k)->ptr[0] >> c->bucket_bits) | PTR_GEN(k, 0))
 
+static struct workqueue_struct *btree_io_wq;
+
 #define insert_lock(s, b)	((b)->level <= (s)->lock)
 
 
@@ -308,7 +310,7 @@ static void __btree_node_write_done(stru
 	btree_complete_write(b, w);
 
 	if (btree_node_dirty(b))
-		schedule_delayed_work(&b->work, 30 * HZ);
+		queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);
 
 	closure_return_with_destructor(cl, btree_node_write_unlock);
 }
@@ -481,7 +483,7 @@ static void bch_btree_leaf_dirty(struct
 	BUG_ON(!i->keys);
 
 	if (!btree_node_dirty(b))
-		schedule_delayed_work(&b->work, 30 * HZ);
+		queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);
 
 	set_btree_node_dirty(b);
 
@@ -2764,3 +2766,18 @@ void bch_keybuf_init(struct keybuf *buf)
 	spin_lock_init(&buf->lock);
 	array_allocator_init(&buf->freelist);
 }
+
+void bch_btree_exit(void)
+{
+	if (btree_io_wq)
+		destroy_workqueue(btree_io_wq);
+}
+
+int __init bch_btree_init(void)
+{
+	btree_io_wq = create_singlethread_workqueue("bch_btree_io");
+	if (!btree_io_wq)
+		return -ENOMEM;
+
+	return 0;
+}
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2833,6 +2833,7 @@ static void bcache_exit(void)
 		destroy_workqueue(bcache_wq);
 	if (bch_journal_wq)
 		destroy_workqueue(bch_journal_wq);
+	bch_btree_exit();
 
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
@@ -2888,6 +2889,9 @@ static int __init bcache_init(void)
 		return bcache_major;
 	}
 
+	if (bch_btree_init())
+		goto err;
+
 	bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0);
 	if (!bcache_wq)
 		goto err;


