Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908133BD123
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbhGFLi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236221AbhGFLew (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:34:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15A8061E11;
        Tue,  6 Jul 2021 11:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570594;
        bh=hCPSu8p7pceVz9fAYM2PPrVbeh790qzdSqp/vBd+zGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbXi8PaNEllC2uNi80JjcZ2LEQtJRhrPmGI08I77WPX2Wpf0UHWDFYMTR1x6lWoIg
         2y2rpTRTmgTAhvziD0LcZYtPGBb15OMmV6rBc/TZIoDXgWEPdoOJLsm/O/8RkkQhLJ
         h49LmYgFsf6M//BVFCrOMFh2ezT/miLI0T+XuGTlICgBUaLerVNn7UCZR00WPHrowK
         78wvqJ8Y4Ri+1kWp8K8FZjSbsxFaMXewVpal+nL8ZqsBTWgE/RJiq+FKk1Y+hwWxjf
         4Ps+4pqBTYdhbpvSeeE5vezuvvEi9m2Bt+jdwbdnqtzqmJvjDNouE2zCX/1KMusuvI
         vgoQIY+peCk3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 055/137] dm writecache: don't split bios when overwriting contiguous cache content
Date:   Tue,  6 Jul 2021 07:20:41 -0400
Message-Id: <20210706112203.2062605-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 8628c4aa2e85..64c2980aaa54 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1360,14 +1360,18 @@ static int writecache_map(struct dm_target *ti, struct bio *bio)
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
@@ -1404,13 +1408,31 @@ static int writecache_map(struct dm_target *ti, struct bio *bio)
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

