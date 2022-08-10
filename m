Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECA758E793
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 09:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiHJHGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 03:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiHJHGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 03:06:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC22F51430;
        Wed, 10 Aug 2022 00:06:11 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 68C2D5C5A8;
        Wed, 10 Aug 2022 07:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660115170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYYdg938pZFGIHomB2WfGo+4YOhGS3k381ReP5/S6hw=;
        b=GzLNNCw9dsfPi7hFV0zS8GFz+Hd7t3vqkztGxn37iFWRd5yCQdnDk5lsCBZvl6qf/HiBP/
        0MAb47yaBXygwa3KSinYagPQlg19295p42BS+ikpAsZU/PfrWJfObPbeYwAQUi9kuxVoua
        4dKGFzsWTyy/thuhF2J3PaAvzFRF+ik=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660115170;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYYdg938pZFGIHomB2WfGo+4YOhGS3k381ReP5/S6hw=;
        b=wGpHg8ugvmIPiFSntIDzRSfkaXF7QqgUdzaIvPVo4TqdHDoF75+dtHvzffsFaibPdkxUsr
        BkuvtLixWRhm2OAQ==
Received: from localhost.localdomain (unknown [10.100.201.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B7EBB2C226;
        Wed, 10 Aug 2022 07:06:09 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, jack@suse.com,
        adilger.kernel@dilger.ca, tytso@mit.edu,
        Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Alexey Romanov <avromanov@sberdevices.ru>,
        Dmitry Rokosov <ddrokosov@sberdevices.ru>,
        Lukas Czerner <lczerner@redhat.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: [PATCH] Revert "zram: remove double compression logic"
Date:   Wed, 10 Aug 2022 09:06:09 +0200
Message-Id: <20220810070609.14402-1-jslaby@suse.cz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <YvJKwCXewHmuWGdh@google.com>
References: <YvJKwCXewHmuWGdh@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit e7be8d1dd983156bbdd22c0319b71119a8fbb697 as it
causes zram failures. It does not revert cleanly, PTR_ERR handling was
introduced in the meantime. This is handled by appropriate IS_ERR.

When under memory pressure, zs_malloc() can fail. Before the above
commit, the allocation was retried with direct reclaim enabled
(GFP_NOIO). After the commit, it is not -- only __GFP_KSWAPD_RECLAIM is
tried.

So when the failure occurs under memory pressure, the overlaying
filesystem such as ext2 (mounted by ext4 module in this case) can emit
failures, making the (file)system unusable:
  EXT4-fs warning (device zram0): ext4_end_bio:343: I/O error 10 writing to inode 16386 starting block 159744)
  Buffer I/O error on device zram0, logical block 159744

With direct reclaim, memory is really reclaimed and allocation succeeds,
eventually. In the worst case, the oom killer is invoked, which is
proper outcome if user sets up zram too large (in comparison to
available RAM).

This very diff doesn't apply to 5.19 (stable) cleanly (see PTR_ERR note
above). Use revert of e7be8d1dd983 directly.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1202203
Fixes: e7be8d1dd983 ("zram: remove double compression logic")
Cc: stable@vger.kernel.org # 5.19
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/zram/zram_drv.c | 42 ++++++++++++++++++++++++++---------
 drivers/block/zram/zram_drv.h |  1 +
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 92cb929a45b7..226ea76cc819 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1146,14 +1146,15 @@ static ssize_t bd_stat_show(struct device *dev,
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
 
@@ -1351,7 +1352,7 @@ static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
 {
 	int ret = 0;
 	unsigned long alloced_pages;
-	unsigned long handle = 0;
+	unsigned long handle = -ENOMEM;
 	unsigned int comp_len = 0;
 	void *src, *dst, *mem;
 	struct zcomp_strm *zstrm;
@@ -1369,6 +1370,7 @@ static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
 	}
 	kunmap_atomic(mem);
 
+compress_again:
 	zstrm = zcomp_stream_get(zram->comp);
 	src = kmap_atomic(page);
 	ret = zcomp_compress(zstrm, src, &comp_len);
@@ -1377,20 +1379,39 @@ static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
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
+	if (IS_ERR((void *)handle))
+		handle = zs_malloc(zram->mem_pool, comp_len,
+				__GFP_KSWAPD_RECLAIM |
+				__GFP_NOWARN |
+				__GFP_HIGHMEM |
+				__GFP_MOVABLE);
 	if (IS_ERR((void *)handle)) {
 		zcomp_stream_put(zram->comp);
+		atomic64_inc(&zram->stats.writestall);
+		handle = zs_malloc(zram->mem_pool, comp_len,
+				GFP_NOIO | __GFP_HIGHMEM |
+				__GFP_MOVABLE);
+		if (!IS_ERR((void *)handle))
+			goto compress_again;
 		return PTR_ERR((void *)handle);
 	}
 
@@ -1948,6 +1969,7 @@ static int zram_add(void)
 	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
 		blk_queue_max_write_zeroes_sectors(zram->disk->queue, UINT_MAX);
 
+	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, zram->disk->queue);
 	ret = device_add_disk(NULL, zram->disk, zram_disk_groups);
 	if (ret)
 		goto out_cleanup_disk;
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 158c91e54850..80c3b43b4828 100644
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
-- 
2.37.1

