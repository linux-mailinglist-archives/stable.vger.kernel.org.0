Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C590D5418A5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379699AbiFGVNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379880AbiFGVMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:12:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84703154B05;
        Tue,  7 Jun 2022 11:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D6876176D;
        Tue,  7 Jun 2022 18:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A637AC385A2;
        Tue,  7 Jun 2022 18:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628053;
        bh=ycLUjmMHzdDC3CERFJqNRWnivcnpn9dj7vhSjrVVdc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsCXu97R1QNU/O0P3BbB8vYYqJlA7HBImWk5D7Xr9+UbNMKYdCvHJ0iF+JifROh1U
         bqeHC/ul41XPueq8ViuOvZT7EMMeSGXAL5ucMJFbSumMLvzE/98/CWiYXDx8sJ9rGn
         teH3Zi9qUXTZ0YRhbk6iv4Xp94wmseFpvuGzpMiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laibin Qiu <qiulaibin@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 188/879] blk-throttle: Set BIO_THROTTLED when bio has been throttled
Date:   Tue,  7 Jun 2022 18:55:06 +0200
Message-Id: <20220607165008.299214842@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laibin Qiu <qiulaibin@huawei.com>

[ Upstream commit 5a011f889b4832aa80c2a872a5aade5c48d2756f ]

1.In current process, all bio will set the BIO_THROTTLED flag
after __blk_throtl_bio().

2.If bio needs to be throttled, it will start the timer and
stop submit bio directly. Bio will submit in
blk_throtl_dispatch_work_fn() when the timer expires.But in
the current process, if bio is throttled. The BIO_THROTTLED
will be set to bio after timer start. If the bio has been
completed, it may cause use-after-free blow.

BUG: KASAN: use-after-free in blk_throtl_bio+0x12f0/0x2c70
Read of size 2 at addr ffff88801b8902d4 by task fio/26380

 dump_stack+0x9b/0xce
 print_address_description.constprop.6+0x3e/0x60
 kasan_report.cold.9+0x22/0x3a
 blk_throtl_bio+0x12f0/0x2c70
 submit_bio_checks+0x701/0x1550
 submit_bio_noacct+0x83/0xc80
 submit_bio+0xa7/0x330
 mpage_readahead+0x380/0x500
 read_pages+0x1c1/0xbf0
 page_cache_ra_unbounded+0x471/0x6f0
 do_page_cache_ra+0xda/0x110
 ondemand_readahead+0x442/0xae0
 page_cache_async_ra+0x210/0x300
 generic_file_buffered_read+0x4d9/0x2130
 generic_file_read_iter+0x315/0x490
 blkdev_read_iter+0x113/0x1b0
 aio_read+0x2ad/0x450
 io_submit_one+0xc8e/0x1d60
 __se_sys_io_submit+0x125/0x350
 do_syscall_64+0x2d/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Allocated by task 26380:
 kasan_save_stack+0x19/0x40
 __kasan_kmalloc.constprop.2+0xc1/0xd0
 kmem_cache_alloc+0x146/0x440
 mempool_alloc+0x125/0x2f0
 bio_alloc_bioset+0x353/0x590
 mpage_alloc+0x3b/0x240
 do_mpage_readpage+0xddf/0x1ef0
 mpage_readahead+0x264/0x500
 read_pages+0x1c1/0xbf0
 page_cache_ra_unbounded+0x471/0x6f0
 do_page_cache_ra+0xda/0x110
 ondemand_readahead+0x442/0xae0
 page_cache_async_ra+0x210/0x300
 generic_file_buffered_read+0x4d9/0x2130
 generic_file_read_iter+0x315/0x490
 blkdev_read_iter+0x113/0x1b0
 aio_read+0x2ad/0x450
 io_submit_one+0xc8e/0x1d60
 __se_sys_io_submit+0x125/0x350
 do_syscall_64+0x2d/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 0:
 kasan_save_stack+0x19/0x40
 kasan_set_track+0x1c/0x30
 kasan_set_free_info+0x1b/0x30
 __kasan_slab_free+0x111/0x160
 kmem_cache_free+0x94/0x460
 mempool_free+0xd6/0x320
 bio_free+0xe0/0x130
 bio_put+0xab/0xe0
 bio_endio+0x3a6/0x5d0
 blk_update_request+0x590/0x1370
 scsi_end_request+0x7d/0x400
 scsi_io_completion+0x1aa/0xe50
 scsi_softirq_done+0x11b/0x240
 blk_mq_complete_request+0xd4/0x120
 scsi_mq_done+0xf0/0x200
 virtscsi_vq_done+0xbc/0x150
 vring_interrupt+0x179/0x390
 __handle_irq_event_percpu+0xf7/0x490
 handle_irq_event_percpu+0x7b/0x160
 handle_irq_event+0xcc/0x170
 handle_edge_irq+0x215/0xb20
 common_interrupt+0x60/0x120
 asm_common_interrupt+0x1e/0x40

Fix this by move BIO_THROTTLED set into the queue_lock.

Signed-off-by: Laibin Qiu <qiulaibin@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20220301123919.2381579-1-qiulaibin@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 469c483719be..5c5f2741a95f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2189,13 +2189,14 @@ bool __blk_throtl_bio(struct bio *bio)
 	}
 
 out_unlock:
-	spin_unlock_irq(&q->queue_lock);
 	bio_set_flag(bio, BIO_THROTTLED);
 
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
 	if (throttled || !td->track_bio_latency)
 		bio->bi_issue.value |= BIO_ISSUE_THROTL_SKIP_LATENCY;
 #endif
+	spin_unlock_irq(&q->queue_lock);
+
 	rcu_read_unlock();
 	return throttled;
 }
-- 
2.35.1



