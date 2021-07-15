Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FA73CAA72
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241177AbhGOTNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238211AbhGOTLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1879D613C0;
        Thu, 15 Jul 2021 19:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376089;
        bh=fyCRoHsW4S5bpVs833INRq2BI0dlCcVLFy820FCeVBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqa/o49LFpcGTfX0WMQ/FYMnValLHlFoKusGVabvZMXuT+Rzy5PHR3Zz9WYesoXwp
         7/ctmUhBvjqLyUgapif7kAYYTGo/zU+oHQWWTwiDSYSTluGmE0PiLPZfBaWmmuynWG
         IgeJ277ywSOh7LSOAbEuCtLrQg5dNLvybOAyx4NM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 069/266] dm writecache: dont split bios when overwriting contiguous cache content
Date:   Thu, 15 Jul 2021 20:37:04 +0200
Message-Id: <20210715182626.388119579@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit ee50cc19d80e9b9a8283d1fb517a778faf2f6899 ]

If dm-writecache overwrites existing cached data, it splits the
incoming bio into many block-sized bios. The I/O scheduler does merge
these bios into one large request but this needless splitting and
merging causes performance degradation.

Fix this by avoiding bio splitting if the cache target area that is
being overwritten is contiguous.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index aecc246ade26..a44007297e63 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1360,14 +1360,18 @@ read_next_block:
 	} else {
 		do {
 			bool found_entry = false;
+			bool search_used = false;
 			if (writecache_has_error(wc))
 				goto unlock_error;
 			e = writecache_find_entry(wc, bio->bi_iter.bi_sector, 0);
 			if (e) {
-				if (!writecache_entry_is_committed(wc, e))
+				if (!writecache_entry_is_committed(wc, e)) {
+					search_used = true;
 					goto bio_copy;
+				}
 				if (!WC_MODE_PMEM(wc) && !e->write_in_progress) {
 					wc->overwrote_committed = true;
+					search_used = true;
 					goto bio_copy;
 				}
 				found_entry = true;
@@ -1404,13 +1408,31 @@ bio_copy:
 				sector_t current_cache_sec = start_cache_sec + (bio_size >> SECTOR_SHIFT);
 
 				while (bio_size < bio->bi_iter.bi_size) {
-					struct wc_entry *f = writecache_pop_from_freelist(wc, current_cache_sec);
-					if (!f)
-						break;
-					write_original_sector_seq_count(wc, f, bio->bi_iter.bi_sector +
-									(bio_size >> SECTOR_SHIFT), wc->seq_count);
-					writecache_insert_entry(wc, f);
-					wc->uncommitted_blocks++;
+					if (!search_used) {
+						struct wc_entry *f = writecache_pop_from_freelist(wc, current_cache_sec);
+						if (!f)
+							break;
+						write_original_sector_seq_count(wc, f, bio->bi_iter.bi_sector +
+										(bio_size >> SECTOR_SHIFT), wc->seq_count);
+						writecache_insert_entry(wc, f);
+						wc->uncommitted_blocks++;
+					} else {
+						struct wc_entry *f;
+						struct rb_node *next = rb_next(&e->rb_node);
+						if (!next)
+							break;
+						f = container_of(next, struct wc_entry, rb_node);
+						if (f != e + 1)
+							break;
+						if (read_original_sector(wc, f) !=
+						    read_original_sector(wc, e) + (wc->block_size >> SECTOR_SHIFT))
+							break;
+						if (unlikely(f->write_in_progress))
+							break;
+						if (writecache_entry_is_committed(wc, f))
+							wc->overwrote_committed = true;
+						e = f;
+					}
 					bio_size += wc->block_size;
 					current_cache_sec += wc->block_size >> SECTOR_SHIFT;
 				}
-- 
2.30.2



