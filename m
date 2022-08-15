Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB845941C6
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345384AbiHOUq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345464AbiHOUn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:43:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887FCB5E67;
        Mon, 15 Aug 2022 12:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EBF3B8107A;
        Mon, 15 Aug 2022 19:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28F5C433C1;
        Mon, 15 Aug 2022 19:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590491;
        bh=rbSoHySHO4jMvEXKq37KUby7dmBgoSKFMYmjaT4M5W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvmdbwP5THZqeziZMQAPDFHtUTkWTBNctBiD0sxagHJaSykEYDB/OXe8tGfUPSznI
         TQBA28XOMQSF7rQBWXFV6fDE7PAHaG1K0KBLX23/LHAQ9H2X5UOydrQTanDVdr0hO+
         Q6VANwE8tO+L1NSSoPhhsa4bbBZJk7Yhf8GiYAPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0277/1095] dm writecache: count number of blocks written, not number of write bios
Date:   Mon, 15 Aug 2022 19:54:36 +0200
Message-Id: <20220815180441.230632036@linuxfoundation.org>
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

[ Upstream commit b2676e1482af89714af6988ce5d31a84692e2530 ]

Change dm-writecache, so that it counts the number of blocks written
instead of the number of write bios. Bios can be split and requeued
using the dm_accept_partial_bio function, so counting bios caused
inaccurate results.

Fixes: e3a35d03407c ("dm writecache: add event counters")
Reported-by: Yu Kuai <yukuai1@huaweicloud.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/device-mapper/writecache.rst         | 10 +++++-----
 drivers/md/dm-writecache.c                           | 12 +++++++++---
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/writecache.rst b/Documentation/admin-guide/device-mapper/writecache.rst
index 7bead3b52690..6c9a2c74df8a 100644
--- a/Documentation/admin-guide/device-mapper/writecache.rst
+++ b/Documentation/admin-guide/device-mapper/writecache.rst
@@ -80,11 +80,11 @@ Status:
 4. the number of blocks under writeback
 5. the number of read blocks
 6. the number of read blocks that hit the cache
-7. the number of write requests
-8. the number of write requests that hit uncommitted block
-9. the number of write requests that hit committed block
-10. the number of write requests that bypass the cache
-11. the number of write requests that are allocated in the cache
+7. the number of write blocks
+8. the number of write blocks that hit uncommitted block
+9. the number of write blocks that hit committed block
+10. the number of write blocks that bypass the cache
+11. the number of write blocks that are allocated in the cache
 12. the number of write requests that are blocked on the freelist
 13. the number of flush requests
 14. the number of discard requests
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 3bec493cccb2..98df6327990a 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1412,6 +1412,9 @@ static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
 	bio->bi_iter.bi_sector = start_cache_sec;
 	dm_accept_partial_bio(bio, bio_size >> SECTOR_SHIFT);
 
+	wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
+	wc->stats.writes_allocate += (bio->bi_iter.bi_size - wc->block_size) >> wc->block_size_bits;
+
 	if (unlikely(wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		wc->uncommitted_blocks = 0;
 		queue_work(wc->writeback_wq, &wc->flush_work);
@@ -1427,9 +1430,10 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 	do {
 		bool found_entry = false;
 		bool search_used = false;
-		wc->stats.writes++;
-		if (writecache_has_error(wc))
+		if (writecache_has_error(wc)) {
+			wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
 			return WC_MAP_ERROR;
+		}
 		e = writecache_find_entry(wc, bio->bi_iter.bi_sector, 0);
 		if (e) {
 			if (!writecache_entry_is_committed(wc, e)) {
@@ -1453,9 +1457,10 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 		if (unlikely(!e)) {
 			if (!WC_MODE_PMEM(wc) && !found_entry) {
 direct_write:
-				wc->stats.writes_around++;
 				e = writecache_find_entry(wc, bio->bi_iter.bi_sector, WFE_RETURN_FOLLOWING);
 				writecache_map_remap_origin(wc, bio, e);
+				wc->stats.writes_around += bio->bi_iter.bi_size >> wc->block_size_bits;
+				wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
 				return WC_MAP_REMAP_ORIGIN;
 			}
 			wc->stats.writes_blocked_on_freelist++;
@@ -1469,6 +1474,7 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 bio_copy:
 		if (WC_MODE_PMEM(wc)) {
 			bio_copy_block(wc, bio, memory_data(wc, e));
+			wc->stats.writes++;
 		} else {
 			writecache_bio_copy_ssd(wc, bio, e, search_used);
 			return WC_MAP_REMAP;
-- 
2.35.1



