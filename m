Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D563C328945
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbhCARxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:53:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238206AbhCARrM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:47:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6114764F60;
        Mon,  1 Mar 2021 16:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617951;
        bh=5PIqYZ3A+kb+gSGh9ZnmiIWLzKmvO+n5qp/8RetotqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fr3evRQ/t7VN4Wwc8cWUejqhyQEXE3eQJ7SNgjW0+7O4mr3rSi/l1pAhf81jArMoK
         GthQO3LJTq34q6somCRTFmDuQcFCt/9F/LLPMKe4+jYL5FcxdxF6cZlz8RZKUuMw4b
         hYZKVehu1YDfEtJMsGynOfrAOxaDLs8XOprpEbM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Kai Krakow <kai@kaishome.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 254/340] Revert "bcache: Kill btree_io_wq"
Date:   Mon,  1 Mar 2021 17:13:18 +0100
Message-Id: <20210301161100.796726479@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
@@ -1027,5 +1027,7 @@ void bch_debug_exit(void);
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
 
 /*
@@ -366,7 +368,7 @@ static void __btree_node_write_done(stru
 	btree_complete_write(b, w);
 
 	if (btree_node_dirty(b))
-		schedule_delayed_work(&b->work, 30 * HZ);
+		queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);
 
 	closure_return_with_destructor(cl, btree_node_write_unlock);
 }
@@ -539,7 +541,7 @@ static void bch_btree_leaf_dirty(struct
 	BUG_ON(!i->keys);
 
 	if (!btree_node_dirty(b))
-		schedule_delayed_work(&b->work, 30 * HZ);
+		queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);
 
 	set_btree_node_dirty(b);
 
@@ -2659,3 +2661,18 @@ void bch_keybuf_init(struct keybuf *buf)
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
@@ -2652,6 +2652,7 @@ static void bcache_exit(void)
 		destroy_workqueue(bcache_wq);
 	if (bch_journal_wq)
 		destroy_workqueue(bch_journal_wq);
+	bch_btree_exit();
 
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
@@ -2707,6 +2708,9 @@ static int __init bcache_init(void)
 		return bcache_major;
 	}
 
+	if (bch_btree_init())
+		goto err;
+
 	bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0);
 	if (!bcache_wq)
 		goto err;


