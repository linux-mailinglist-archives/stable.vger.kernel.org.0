Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E77541782
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378795AbiFGVDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379374AbiFGVCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F65939B1;
        Tue,  7 Jun 2022 11:47:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F329FB822C0;
        Tue,  7 Jun 2022 18:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6C8C3411C;
        Tue,  7 Jun 2022 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627671;
        bh=dYbzWcMta5duF/c1xbo26S7UogoDY6dI5zgmiYq/jpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxmJXpnUZHSUMLNfkKk74dtyNz1VM9Hz+6Up16RMxAY5u8Wgs8XZK9fi21xsQHA8l
         tIkSUUvnCdDGaOw7WuUWicBmcN++/UMggzqFawPgrFE3pCXju00bTSQ/ADqffVwXXq
         JhKoHurMeFALp6B7Hy/Mi03ovpUOK+/ZpNLVS+EQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 050/879] btrfs: zoned: properly finish block group on metadata write
Date:   Tue,  7 Jun 2022 18:52:48 +0200
Message-Id: <20220607165004.138065755@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 56fbb0a4e8b3e929e41cc846e6ef89eb01152201 upstream.

Commit be1a1d7a5d24 ("btrfs: zoned: finish fully written block group")
introduced zone finishing code both for data and metadata end_io path.
However, the metadata side is not working as it should. First, it
compares logical address (eb->start + eb->len) with offset within a
block group (cache->zone_capacity) in submit_eb_page(). That essentially
disabled zone finishing on metadata end_io path.

Furthermore, fixing the issue above revealed we cannot call
btrfs_zone_finish_endio() in end_extent_buffer_writeback(). We cannot
call btrfs_lookup_block_group() which require spin lock inside end_io
context.

Introduce btrfs_schedule_zone_finish_bg() to wait for the extent buffer
writeback and do the zone finish IO in a workqueue.

Also, drop EXTENT_BUFFER_ZONE_FINISH as it is no longer used.

Fixes: be1a1d7a5d24 ("btrfs: zoned: finish fully written block group")
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.h |    2 ++
 fs/btrfs/extent_io.c   |    6 +-----
 fs/btrfs/extent_io.h   |    1 -
 fs/btrfs/zoned.c       |   31 +++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |    5 +++++
 5 files changed, 39 insertions(+), 6 deletions(-)

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
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4196,9 +4196,6 @@ void wait_on_extent_buffer_writeback(str
 
 static void end_extent_buffer_writeback(struct extent_buffer *eb)
 {
-	if (test_bit(EXTENT_BUFFER_ZONE_FINISH, &eb->bflags))
-		btrfs_zone_finish_endio(eb->fs_info, eb->start, eb->len);
-
 	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
 	smp_mb__after_atomic();
 	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
@@ -4818,8 +4815,7 @@ static int submit_eb_page(struct page *p
 		/*
 		 * Implies write in zoned mode. Mark the last eb in a block group.
 		 */
-		if (cache->seq_zone && eb->start + eb->len == cache->zone_capacity)
-			set_bit(EXTENT_BUFFER_ZONE_FINISH, &eb->bflags);
+		btrfs_schedule_zone_finish_bg(cache, eb);
 		btrfs_put_block_group(cache);
 	}
 	ret = write_one_eb(eb, wbc, epd);
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -32,7 +32,6 @@ enum {
 	/* write IO error */
 	EXTENT_BUFFER_WRITE_ERR,
 	EXTENT_BUFFER_NO_CHECK,
-	EXTENT_BUFFER_ZONE_FINISH,
 };
 
 /* these are flags for __process_pages_contig */
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2046,6 +2046,37 @@ out:
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
+	if (!bg->seq_zone || eb->start + eb->len * 2 <= bg->start + bg->zone_capacity)
+		return;
+
+	if (WARN_ON(bg->zone_finish_work.func == btrfs_zone_finish_endio_workfn)) {
+		btrfs_err(bg->fs_info, "double scheduling of bg %llu zone finishing",
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
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -76,6 +76,8 @@ int btrfs_zone_finish(struct btrfs_block
 bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags);
 void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical,
 			     u64 length);
+void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
+				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 #else /* CONFIG_BLK_DEV_ZONED */
@@ -233,6 +235,9 @@ static inline bool btrfs_can_activate_zo
 static inline void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info,
 					   u64 logical, u64 length) { }
 
+static inline void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
+						 struct extent_buffer *eb) { }
+
 static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }


