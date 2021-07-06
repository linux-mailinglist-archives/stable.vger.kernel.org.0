Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259ED3BCC40
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhGFLSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232548AbhGFLSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04A8F61A14;
        Tue,  6 Jul 2021 11:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570152;
        bh=OZVZebsjwdl1JxRsp/zcRmFGerLEwI0om/fVkc0q93U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ez1ij4PznlRxb/a2xK2rPUDkBLSmDt6NNwBGwZ5xmVSA66OBE52s8lH/q8GWECsRP
         cZTupCOWJq9uWPncfodiDTqQ22vU5Igrb6tU+Ee2k7qUpJv4K/Vo9e8aqO0tw+AwP0
         tQUd8NrGwLHY9EA1LHOG0Ni/BRQS6fjVLlPPT8E/MYfyqY5b4TFHVpp6tnBnr5Kf9n
         3uEgEPDEyzuLM+XIKcOho8vGu31Mgce67Z2HtTu0j4hab41Fm84sciftGTW24tC1tJ
         8X8BbI/rHtWUuCcPQmzqaE20RZJ0LEa1Ml2vQWToQ81iczmM5FzWT1CTVu5vzn6BK+
         wz/XqoKlNzqhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.13 075/189] dm writecache: don't split bios when overwriting contiguous cache content
Date:   Tue,  6 Jul 2021 07:12:15 -0400
Message-Id: <20210706111409.2058071-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index aecc246ade26..a44007297e63 100644
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

