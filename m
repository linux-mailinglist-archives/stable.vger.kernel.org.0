Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407A3519302
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 02:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244769AbiEDAxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 20:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244779AbiEDAxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 20:53:23 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B248340932;
        Tue,  3 May 2022 17:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651625390; x=1683161390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yiKnEhrLwB32uH0TxkjE71vEjFENE1v5C96HCMmf58I=;
  b=amfGKprnY0otDamkFHLPMRSmAskm6KY66S+HliLYYR7YdIU7uRjP3yaW
   3uPivDBcsC+IUo/3vEaOhlQEsopiWkHOfmaWsm2opUuhjZbwQq8Z8xfCD
   QgA1nSQ+4FNHZZfmpefb9PYLs8IwR6PbQ01+n4JCw8b/SlPMmRhVo2no3
   esXHxGmqw7we3j5yE8P//bBLzrbY3Qx2M91In2h0NoooVnyCN9DFXmXXm
   qbDD6zaeulQIfO7uU0c9NURh0A4O+jxXmypZguU2qYzVsv/CW8UCiAjfl
   mQ1TVjmwBVJY4SKm+O8wApQwsg+jAwAFJQkXSLfYS/AzeddFOhnyxydg8
   g==;
X-IronPort-AV: E=Sophos;i="5.91,196,1647273600"; 
   d="scan'208";a="200341894"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 May 2022 08:49:45 +0800
IronPort-SDR: /YUemx7Xp6un2Rm1efKirzj16lrhRu4/o/AxeVBbhQwl6jPjlJciYvRsXPo74DwaUfgumNRmXx
 SVAWHLjUA9EBGhRLpuXTXGpndaX2cWLSS4+yfuj1gWCaNstgpxTz40bYswx659e4P92HkyuaWC
 y459M18Ln1Vv9MZeFhRb/6EeJyhpNNJAHcb14VLcZ+kOvb0joaZy+bpi8l2zy28djvwAOFw/dc
 3LJmgiQT3Mk+O2oWlwoZe8txMtJBLI/vwg2yP5/aOhvWUySWf+/jypGa8vZSRoKjis4eKtJJZ2
 dqnMMYJMdGb+hDstU8+VmOqi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 May 2022 17:19:46 -0700
IronPort-SDR: vb9BDfJGNvlUci4qb6Ru3Soli6Qtp+ndg5/ZxK1PEg0CUE7uHZucWgDVx2kD5KUxVxXjhYTikt
 qG3Dwn3kCtv+nW5+AvpRxnd6FeoKdYbxgLSmqJ3BlNXqSAS1qkpH46++3diV5VylT+00UBfny/
 WsWSoRwStUbgyLQBviaoQ9EXy12kgBG9eSJbKAEni4iH7a2/DgdKBTHBRpJAixEuVCYF0HDoxb
 x5OBtG2cz/hJn1X57Sm2wWIitoBts2aLa1gZHjKBwzd4n+usaa9/XOD4RFVh6JhplqaQJ74J9X
 zWM=
WDCIronportException: Internal
Received: from jv0vzd3.ad.shared (HELO naota-x1.wdc.com) ([10.225.48.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 May 2022 17:49:42 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>, stable@vger.kernel.org
Subject: [PATCH v2 4/5] btrfs: zoned: properly finish block group on metadata write
Date:   Tue,  3 May 2022 17:48:53 -0700
Message-Id: <5dfca7a3630ec2fe8c1ae1219cbbea7240f6d6de.1651624820.git.naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651624820.git.naohiro.aota@wdc.com>
References: <cover.1651624820.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit be1a1d7a5d24 ("btrfs: zoned: finish fully written block group")
introduced zone finishing code both for data and metadata end_io path.
However, the metadata side is not working as it should be. First, it
compares logical address (eb->start + eb->len) with offset within a block
group (cache->zone_capacity) in submit_eb_page(). That essentially disabled
zone finishing on metadata end_io path.

Furthermore, fixing the issue above revealed we cannot call
btrfs_zone_finish_endio() in end_extent_buffer_writeback(). We cannot call
btrfs_lookup_block_group() which require spin lock inside end_io context.

This commit introduces btrfs_schedule_zone_finish_bg() to wait for the
extent buffer writeback and do the zone finish IO in a workqueue.

Also, drop EXTENT_BUFFER_ZONE_FINISH as it is no longer used.

Cc: stable@vger.kernel.org # 5.16+
Fixes: be1a1d7a5d24 ("btrfs: zoned: finish fully written block group")
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/block-group.h |  2 ++
 fs/btrfs/extent_io.c   |  6 +-----
 fs/btrfs/extent_io.h   |  1 -
 fs/btrfs/zoned.c       | 34 ++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  5 +++++
 5 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index c9bf01dd10e8..3ac668ace50a 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -212,6 +212,8 @@ struct btrfs_block_group {
 	u64 meta_write_pointer;
 	struct map_lookup *physical_map;
 	struct list_head active_bg_list;
+	struct work_struct zone_finish_work;
+	struct extent_buffer *last_eb;
 };
 
 static inline u64 btrfs_block_group_end(struct btrfs_block_group *block_group)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1b1baeb0d76b..588c7c606a2c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4251,9 +4251,6 @@ void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 
 static void end_extent_buffer_writeback(struct extent_buffer *eb)
 {
-	if (test_bit(EXTENT_BUFFER_ZONE_FINISH, &eb->bflags))
-		btrfs_zone_finish_endio(eb->fs_info, eb->start, eb->len);
-
 	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
 	smp_mb__after_atomic();
 	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
@@ -4843,8 +4840,7 @@ static int submit_eb_page(struct page *page, struct writeback_control *wbc,
 		/*
 		 * Implies write in zoned mode. Mark the last eb in a block group.
 		 */
-		if (cache->seq_zone && eb->start + eb->len == cache->zone_capacity)
-			set_bit(EXTENT_BUFFER_ZONE_FINISH, &eb->bflags);
+		btrfs_schedule_zone_finish_bg(cache, eb);
 		btrfs_put_block_group(cache);
 	}
 	ret = write_one_eb(eb, wbc, epd);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 17674b7e699c..956fa434df43 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -26,7 +26,6 @@ enum {
 	/* write IO error */
 	EXTENT_BUFFER_WRITE_ERR,
 	EXTENT_BUFFER_NO_CHECK,
-	EXTENT_BUFFER_ZONE_FINISH,
 };
 
 /* these are flags for __process_pages_contig */
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 320bb7ba1c49..905ce5498ee0 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2046,6 +2046,40 @@ void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 len
 	btrfs_put_block_group(block_group);
 }
 
+static void btrfs_zone_finish_endio_workfn(struct work_struct *work)
+{
+	struct btrfs_block_group *bg =
+		container_of(work, struct btrfs_block_group, zone_finish_work);
+
+	wait_on_extent_buffer_writeback(bg->last_eb);
+	free_extent_buffer(bg->last_eb);
+	btrfs_zone_finish_endio(bg->fs_info, bg->start, bg->length);
+	btrfs_put_block_group(bg);
+}
+
+void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
+				   struct extent_buffer *eb)
+{
+	if (!bg->seq_zone ||
+	    eb->start + eb->len * 2 <= bg->start + bg->zone_capacity)
+		return;
+
+	if (WARN_ON(bg->zone_finish_work.func ==
+		    btrfs_zone_finish_endio_workfn)) {
+		btrfs_err(bg->fs_info,
+			  "double scheduling of BG %llu zone finishing",
+			  bg->start);
+		return;
+	}
+
+	/* For the work */
+	btrfs_get_block_group(bg);
+	atomic_inc(&eb->refs);
+	bg->last_eb = eb;
+	INIT_WORK(&bg->zone_finish_work, btrfs_zone_finish_endio_workfn);
+	queue_work(system_unbound_wq, &bg->zone_finish_work);
+}
+
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 98f277ed5138..a4126ec6b909 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -72,6 +72,8 @@ int btrfs_zone_finish(struct btrfs_block_group *block_group);
 bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags);
 void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical,
 			     u64 length);
+void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
+				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(struct btrfs_fs_info *fs_info);
@@ -230,6 +232,9 @@ static inline bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices,
 static inline void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info,
 					   u64 logical, u64 length) { }
 
+static inline void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
+						 struct extent_buffer *eb) { }
+
 static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
-- 
2.35.1

