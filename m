Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E611D5A4BEC
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiH2McY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiH2Mbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:31:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB9D95E4E;
        Mon, 29 Aug 2022 05:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8E41B80FB5;
        Mon, 29 Aug 2022 11:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32977C433D6;
        Mon, 29 Aug 2022 11:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771890;
        bh=701hHLjnpW1sUVTpgwsdV5nUmBXdiBX3LO0FlFL55uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eChfRDQ7ho9Hg3a7K3wXYDO2hJRmfZ9wAcq1kYW+Y3H35/pqXH+mKqDSuhDl62N4/
         Dq0y8RgHNwCHuNOaqava7fsGjdL70saqUjH8WVUrP7NFcEyehRvlU6y5YwBxrg1U+p
         /eouXTEiNk8cLr1HxFOtsUCAlgmMp+RRgx4LQjPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Alexey Romanov <avromanov@sberdevices.ru>,
        Dmitry Rokosov <ddrokosov@sberdevices.ru>,
        Lukas Czerner <lczerner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 132/158] Revert "zram: remove double compression logic"
Date:   Mon, 29 Aug 2022 12:59:42 +0200
Message-Id: <20220829105814.629688221@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 37887783b3fef877bf34b8992c9199864da4afcb upstream.

This reverts commit e7be8d1dd983156b ("zram: remove double compression
logic") as it causes zram failures.  It does not revert cleanly, PTR_ERR
handling was introduced in the meantime.  This is handled by appropriate
IS_ERR.

When under memory pressure, zs_malloc() can fail.  Before the above
commit, the allocation was retried with direct reclaim enabled (GFP_NOIO).
After the commit, it is not -- only __GFP_KSWAPD_RECLAIM is tried.

So when the failure occurs under memory pressure, the overlaying
filesystem such as ext2 (mounted by ext4 module in this case) can emit
failures, making the (file)system unusable:
  EXT4-fs warning (device zram0): ext4_end_bio:343: I/O error 10 writing to inode 16386 starting block 159744)
  Buffer I/O error on device zram0, logical block 159744

With direct reclaim, memory is really reclaimed and allocation succeeds,
eventually.  In the worst case, the oom killer is invoked, which is proper
outcome if user sets up zram too large (in comparison to available RAM).

This very diff doesn't apply to 5.19 (stable) cleanly (see PTR_ERR note
above). Use revert of e7be8d1dd983 directly.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1202203
Link: https://lkml.kernel.org/r/20220810070609.14402-1-jslaby@suse.cz
Fixes: e7be8d1dd983 ("zram: remove double compression logic")
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: <stable@vger.kernel.org>	[5.19]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |   42 ++++++++++++++++++++++++++++++++----------
 drivers/block/zram/zram_drv.h |    1 +
 2 files changed, 33 insertions(+), 10 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1144,14 +1144,15 @@ static ssize_t bd_stat_show(struct devic
 static ssize_t debug_stat_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	int version = 2;
+	int version = 1;
 	struct zram *zram = dev_to_zram(dev);
 	ssize_t ret;
 
 	down_read(&zram->init_lock);
 	ret = scnprintf(buf, PAGE_SIZE,
-			"version: %d\n%8llu\n",
+			"version: %d\n%8llu %8llu\n",
 			version,
+			(u64)atomic64_read(&zram->stats.writestall),
 			(u64)atomic64_read(&zram->stats.miss_free));
 	up_read(&zram->init_lock);
 
@@ -1367,6 +1368,7 @@ static int __zram_bvec_write(struct zram
 	}
 	kunmap_atomic(mem);
 
+compress_again:
 	zstrm = zcomp_stream_get(zram->comp);
 	src = kmap_atomic(page);
 	ret = zcomp_compress(zstrm, src, &comp_len);
@@ -1375,20 +1377,39 @@ static int __zram_bvec_write(struct zram
 	if (unlikely(ret)) {
 		zcomp_stream_put(zram->comp);
 		pr_err("Compression failed! err=%d\n", ret);
+		zs_free(zram->mem_pool, handle);
 		return ret;
 	}
 
 	if (comp_len >= huge_class_size)
 		comp_len = PAGE_SIZE;
-
-	handle = zs_malloc(zram->mem_pool, comp_len,
-			__GFP_KSWAPD_RECLAIM |
-			__GFP_NOWARN |
-			__GFP_HIGHMEM |
-			__GFP_MOVABLE);
-
-	if (unlikely(!handle)) {
+	/*
+	 * handle allocation has 2 paths:
+	 * a) fast path is executed with preemption disabled (for
+	 *  per-cpu streams) and has __GFP_DIRECT_RECLAIM bit clear,
+	 *  since we can't sleep;
+	 * b) slow path enables preemption and attempts to allocate
+	 *  the page with __GFP_DIRECT_RECLAIM bit set. we have to
+	 *  put per-cpu compression stream and, thus, to re-do
+	 *  the compression once handle is allocated.
+	 *
+	 * if we have a 'non-null' handle here then we are coming
+	 * from the slow path and handle has already been allocated.
+	 */
+	if (!handle)
+		handle = zs_malloc(zram->mem_pool, comp_len,
+				__GFP_KSWAPD_RECLAIM |
+				__GFP_NOWARN |
+				__GFP_HIGHMEM |
+				__GFP_MOVABLE);
+	if (!handle) {
 		zcomp_stream_put(zram->comp);
+		atomic64_inc(&zram->stats.writestall);
+		handle = zs_malloc(zram->mem_pool, comp_len,
+				GFP_NOIO | __GFP_HIGHMEM |
+				__GFP_MOVABLE);
+		if (handle)
+			goto compress_again;
 		return -ENOMEM;
 	}
 
@@ -1946,6 +1967,7 @@ static int zram_add(void)
 	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
 		blk_queue_max_write_zeroes_sectors(zram->disk->queue, UINT_MAX);
 
+	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, zram->disk->queue);
 	ret = device_add_disk(NULL, zram->disk, zram_disk_groups);
 	if (ret)
 		goto out_cleanup_disk;
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -81,6 +81,7 @@ struct zram_stats {
 	atomic64_t huge_pages_since;	/* no. of huge pages since zram set up */
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
+	atomic64_t writestall;		/* no. of write slow paths */
 	atomic64_t miss_free;		/* no. of missed free */
 #ifdef	CONFIG_ZRAM_WRITEBACK
 	atomic64_t bd_count;		/* no. of pages in backing device */


