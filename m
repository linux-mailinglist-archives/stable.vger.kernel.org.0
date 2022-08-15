Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF45593E7B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345463AbiHOUno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347686AbiHOUnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:43:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7CCB56C5;
        Mon, 15 Aug 2022 12:08:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5A98B81062;
        Mon, 15 Aug 2022 19:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8FBC433C1;
        Mon, 15 Aug 2022 19:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590485;
        bh=RJpMtkSYG/vXtAkOfRgXlbOp7ynizIaZM8ijsH0shiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QslqtIYRUkBewZbgB+JBPr1ED1tJPygrOmVuDK13eG0BjbJ/kYBYt0vqumMWzal6i
         AJCylFKoxSZ2u1skNaLy6Trvcn2dZzDcFGqEzGS/vkWq/VxZf9vc6apnO0pkEpmKCo
         rNn9OYdnznEOoPBH5NSY4TXjRv0z/aZQmHGgW6s0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0275/1095] dm writecache: return void from functions
Date:   Mon, 15 Aug 2022 19:54:34 +0200
Message-Id: <20220815180441.138418446@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 9bc0c92e4b82adb017026dbb2aa816b1ac2bef31 ]

The functions writecache_map_remap_origin and writecache_bio_copy_ssd
only return a single value, thus they can be made to return void.

This helps simplify the following IO accounting changes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 5630b470ba42..688b6b3bcd7b 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1328,8 +1328,8 @@ enum wc_map_op {
 	WC_MAP_ERROR,
 };
 
-static enum wc_map_op writecache_map_remap_origin(struct dm_writecache *wc, struct bio *bio,
-						  struct wc_entry *e)
+static void writecache_map_remap_origin(struct dm_writecache *wc, struct bio *bio,
+					struct wc_entry *e)
 {
 	if (e) {
 		sector_t next_boundary =
@@ -1337,8 +1337,6 @@ static enum wc_map_op writecache_map_remap_origin(struct dm_writecache *wc, stru
 		if (next_boundary < bio->bi_iter.bi_size >> SECTOR_SHIFT)
 			dm_accept_partial_bio(bio, next_boundary);
 	}
-
-	return WC_MAP_REMAP_ORIGIN;
 }
 
 static enum wc_map_op writecache_map_read(struct dm_writecache *wc, struct bio *bio)
@@ -1365,14 +1363,15 @@ static enum wc_map_op writecache_map_read(struct dm_writecache *wc, struct bio *
 			map_op = WC_MAP_REMAP;
 		}
 	} else {
-		map_op = writecache_map_remap_origin(wc, bio, e);
+		writecache_map_remap_origin(wc, bio, e);
+		map_op = WC_MAP_REMAP_ORIGIN;
 	}
 
 	return map_op;
 }
 
-static enum wc_map_op writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
-					      struct wc_entry *e, bool search_used)
+static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
+				    struct wc_entry *e, bool search_used)
 {
 	unsigned bio_size = wc->block_size;
 	sector_t start_cache_sec = cache_sector(wc, e);
@@ -1418,8 +1417,6 @@ static enum wc_map_op writecache_bio_copy_ssd(struct dm_writecache *wc, struct b
 	} else {
 		writecache_schedule_autocommit(wc);
 	}
-
-	return WC_MAP_REMAP;
 }
 
 static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio *bio)
@@ -1457,7 +1454,8 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 direct_write:
 				wc->stats.writes_around++;
 				e = writecache_find_entry(wc, bio->bi_iter.bi_sector, WFE_RETURN_FOLLOWING);
-				return writecache_map_remap_origin(wc, bio, e);
+				writecache_map_remap_origin(wc, bio, e);
+				return WC_MAP_REMAP_ORIGIN;
 			}
 			wc->stats.writes_blocked_on_freelist++;
 			writecache_wait_on_freelist(wc);
@@ -1468,10 +1466,12 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 		wc->uncommitted_blocks++;
 		wc->stats.writes_allocate++;
 bio_copy:
-		if (WC_MODE_PMEM(wc))
+		if (WC_MODE_PMEM(wc)) {
 			bio_copy_block(wc, bio, memory_data(wc, e));
-		else
-			return writecache_bio_copy_ssd(wc, bio, e, search_used);
+		} else {
+			writecache_bio_copy_ssd(wc, bio, e, search_used);
+			return WC_MAP_REMAP;
+		}
 	} while (bio->bi_iter.bi_size);
 
 	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks))
-- 
2.35.1



