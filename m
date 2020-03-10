Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AADB17FCAE
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbgCJNBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730232AbgCJNBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:01:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A79052468D;
        Tue, 10 Mar 2020 13:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845271;
        bh=Hdj9Xj4OjgQMShoUBLeSfokjxn4D5YsJdsBsM0BdGsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xY3KD+hhcDib8mF/KJt3WQ+EQOQIVWPcNN77wl1Y8q8PUUL6eOCOioyY2/YZ/hWHX
         rj20lp0PR2YbSkg+oGcDeHd4kPnVzG6VqqBqvmz3/rFspfO3rVDSMrmoD9SXHqbaWy
         VD9shU0XOW3xuUxmytb9v2Xqr8sNeo3g4syA0glc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.5 124/189] dm zoned: Fix reference counter initial value of chunk works
Date:   Tue, 10 Mar 2020 13:39:21 +0100
Message-Id: <20200310123652.305679609@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit ee63634bae02e13c8c0df1209a6a0ca5326f3189 upstream.

Dm-zoned initializes reference counters of new chunk works with zero
value and refcount_inc() is called to increment the counter. However, the
refcount_inc() function handles the addition to zero value as an error
and triggers the warning as follows:

refcount_t: addition on 0; use-after-free.
WARNING: CPU: 7 PID: 1506 at lib/refcount.c:25 refcount_warn_saturate+0x68/0xf0
...
CPU: 7 PID: 1506 Comm: systemd-udevd Not tainted 5.4.0+ #134
...
Call Trace:
 dmz_map+0x2d2/0x350 [dm_zoned]
 __map_bio+0x42/0x1a0
 __split_and_process_non_flush+0x14a/0x1b0
 __split_and_process_bio+0x83/0x240
 ? kmem_cache_alloc+0x165/0x220
 dm_process_bio+0x90/0x230
 ? generic_make_request_checks+0x2e7/0x680
 dm_make_request+0x3e/0xb0
 generic_make_request+0xcf/0x320
 ? memcg_drain_all_list_lrus+0x1c0/0x1c0
 submit_bio+0x3c/0x160
 ? guard_bio_eod+0x2c/0x130
 mpage_readpages+0x182/0x1d0
 ? bdev_evict_inode+0xf0/0xf0
 read_pages+0x6b/0x1b0
 __do_page_cache_readahead+0x1ba/0x1d0
 force_page_cache_readahead+0x93/0x100
 generic_file_read_iter+0x83a/0xe40
 ? __seccomp_filter+0x7b/0x670
 new_sync_read+0x12a/0x1c0
 vfs_read+0x9d/0x150
 ksys_read+0x5f/0xe0
 do_syscall_64+0x5b/0x180
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
...

After this warning, following refcount API calls for the counter all fail
to change the counter value.

Fix this by setting the initial reference counter value not zero but one
for the new chunk works. Instead, do not call refcount_inc() via
dmz_get_chunk_work() for the new chunks works.

The failure was observed with linux version 5.4 with CONFIG_REFCOUNT_FULL
enabled. Refcount rework was merged to linux version 5.5 by the
commit 168829ad09ca ("Merge branch 'locking-core-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip"). After this
commit, CONFIG_REFCOUNT_FULL was removed and the failure was observed
regardless of kernel configuration.

Linux version 4.20 merged the commit 092b5648760a ("dm zoned: target: use
refcount_t for dm zoned reference counters"). Before this commit, dm
zoned used atomic_t APIs which does not check addition to zero, then this
fix is not necessary.

Fixes: 092b5648760a ("dm zoned: target: use refcount_t for dm zoned reference counters")
Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-zoned-target.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -533,8 +533,9 @@ static int dmz_queue_chunk_work(struct d
 
 	/* Get the BIO chunk work. If one is not active yet, create one */
 	cw = radix_tree_lookup(&dmz->chunk_rxtree, chunk);
-	if (!cw) {
-
+	if (cw) {
+		dmz_get_chunk_work(cw);
+	} else {
 		/* Create a new chunk work */
 		cw = kmalloc(sizeof(struct dm_chunk_work), GFP_NOIO);
 		if (unlikely(!cw)) {
@@ -543,7 +544,7 @@ static int dmz_queue_chunk_work(struct d
 		}
 
 		INIT_WORK(&cw->work, dmz_chunk_work);
-		refcount_set(&cw->refcount, 0);
+		refcount_set(&cw->refcount, 1);
 		cw->target = dmz;
 		cw->chunk = chunk;
 		bio_list_init(&cw->bio_list);
@@ -556,7 +557,6 @@ static int dmz_queue_chunk_work(struct d
 	}
 
 	bio_list_add(&cw->bio_list, bio);
-	dmz_get_chunk_work(cw);
 
 	dmz_reclaim_bio_acc(dmz->reclaim);
 	if (queue_work(dmz->chunk_wq, &cw->work))


