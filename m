Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C23F126BAB
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbfLSSzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbfLSSzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8AA724679;
        Thu, 19 Dec 2019 18:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781721;
        bh=O/z9uhVuclDXBFM2lZwSMCemty+2fbED2SNQ8D+l2/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07IqoApzklSek6m73nEnA16UqppL0EUi0jwIFmicVAAem0tYgN37NSrviB6b/JIsg
         gSzb7kOYHSzaHf3Bqhq8KPeDLcqznE0KFDWZ11qJ0CQnJCTIzfrfazm/b5905TSloB
         +Q9SF+LLmi51o1U00Iz+oJqrGs0r5H9YLrjtKg88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 53/80] dm clone metadata: Track exact changes per transaction
Date:   Thu, 19 Dec 2019 19:34:45 +0100
Message-Id: <20191219183124.248718718@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit e6a505f3f9fae572fb3ab3bc486e755ac9cef32c upstream.

Extend struct dirty_map with a second bitmap which tracks the exact
regions that were hydrated during the current metadata transaction.

Moreover, fix __flush_dmap() to only commit the metadata of the regions
that were hydrated during the current transaction.

This is required by the following commits to fix a data corruption bug.

Fixes: 7431b7835f55 ("dm: add clone target")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-clone-metadata.c |   90 ++++++++++++++++++++++++++++-------------
 1 file changed, 62 insertions(+), 28 deletions(-)

--- a/drivers/md/dm-clone-metadata.c
+++ b/drivers/md/dm-clone-metadata.c
@@ -67,23 +67,34 @@ struct superblock_disk {
  * To save constantly doing look ups on disk we keep an in core copy of the
  * on-disk bitmap, the region_map.
  *
- * To further reduce metadata I/O overhead we use a second bitmap, the dmap
- * (dirty bitmap), which tracks the dirty words, i.e. longs, of the region_map.
+ * In order to track which regions are hydrated during a metadata transaction,
+ * we use a second set of bitmaps, the dmap (dirty bitmap), which includes two
+ * bitmaps, namely dirty_regions and dirty_words. The dirty_regions bitmap
+ * tracks the regions that got hydrated during the current metadata
+ * transaction. The dirty_words bitmap tracks the dirty words, i.e. longs, of
+ * the dirty_regions bitmap.
+ *
+ * This allows us to precisely track the regions that were hydrated during the
+ * current metadata transaction and update the metadata accordingly, when we
+ * commit the current transaction. This is important because dm-clone should
+ * only commit the metadata of regions that were properly flushed to the
+ * destination device beforehand. Otherwise, in case of a crash, we could end
+ * up with a corrupted dm-clone device.
  *
  * When a region finishes hydrating dm-clone calls
  * dm_clone_set_region_hydrated(), or for discard requests
  * dm_clone_cond_set_range(), which sets the corresponding bits in region_map
  * and dmap.
  *
- * During a metadata commit we scan the dmap for dirty region_map words (longs)
- * and update accordingly the on-disk metadata. Thus, we don't have to flush to
- * disk the whole region_map. We can just flush the dirty region_map words.
+ * During a metadata commit we scan dmap->dirty_words and dmap->dirty_regions
+ * and update the on-disk metadata accordingly. Thus, we don't have to flush to
+ * disk the whole region_map. We can just flush the dirty region_map bits.
  *
- * We use a dirty bitmap, which is smaller than the original region_map, to
- * reduce the amount of memory accesses during a metadata commit. As dm-bitset
- * accesses the on-disk bitmap in 64-bit word granularity, there is no
- * significant benefit in tracking the dirty region_map bits with a smaller
- * granularity.
+ * We use the helper dmap->dirty_words bitmap, which is smaller than the
+ * original region_map, to reduce the amount of memory accesses during a
+ * metadata commit. Moreover, as dm-bitset also accesses the on-disk bitmap in
+ * 64-bit word granularity, the dirty_words bitmap helps us avoid useless disk
+ * accesses.
  *
  * We could update directly the on-disk bitmap, when dm-clone calls either
  * dm_clone_set_region_hydrated() or dm_clone_cond_set_range(), buts this
@@ -92,12 +103,13 @@ struct superblock_disk {
  * e.g., in a hooked overwrite bio's completion routine, and further reduce the
  * I/O completion latency.
  *
- * We maintain two dirty bitmaps. During a metadata commit we atomically swap
- * the currently used dmap with the unused one. This allows the metadata update
- * functions to run concurrently with an ongoing commit.
+ * We maintain two dirty bitmap sets. During a metadata commit we atomically
+ * swap the currently used dmap with the unused one. This allows the metadata
+ * update functions to run concurrently with an ongoing commit.
  */
 struct dirty_map {
 	unsigned long *dirty_words;
+	unsigned long *dirty_regions;
 	unsigned int changed;
 };
 
@@ -461,22 +473,40 @@ static size_t bitmap_size(unsigned long
 	return BITS_TO_LONGS(nr_bits) * sizeof(long);
 }
 
-static int dirty_map_init(struct dm_clone_metadata *cmd)
+static int __dirty_map_init(struct dirty_map *dmap, unsigned long nr_words,
+			    unsigned long nr_regions)
 {
-	cmd->dmap[0].changed = 0;
-	cmd->dmap[0].dirty_words = kvzalloc(bitmap_size(cmd->nr_words), GFP_KERNEL);
+	dmap->changed = 0;
 
-	if (!cmd->dmap[0].dirty_words) {
-		DMERR("Failed to allocate dirty bitmap");
+	dmap->dirty_words = kvzalloc(bitmap_size(nr_words), GFP_KERNEL);
+	if (!dmap->dirty_words)
+		return -ENOMEM;
+
+	dmap->dirty_regions = kvzalloc(bitmap_size(nr_regions), GFP_KERNEL);
+	if (!dmap->dirty_regions) {
+		kvfree(dmap->dirty_words);
 		return -ENOMEM;
 	}
 
-	cmd->dmap[1].changed = 0;
-	cmd->dmap[1].dirty_words = kvzalloc(bitmap_size(cmd->nr_words), GFP_KERNEL);
+	return 0;
+}
 
-	if (!cmd->dmap[1].dirty_words) {
+static void __dirty_map_exit(struct dirty_map *dmap)
+{
+	kvfree(dmap->dirty_words);
+	kvfree(dmap->dirty_regions);
+}
+
+static int dirty_map_init(struct dm_clone_metadata *cmd)
+{
+	if (__dirty_map_init(&cmd->dmap[0], cmd->nr_words, cmd->nr_regions)) {
 		DMERR("Failed to allocate dirty bitmap");
-		kvfree(cmd->dmap[0].dirty_words);
+		return -ENOMEM;
+	}
+
+	if (__dirty_map_init(&cmd->dmap[1], cmd->nr_words, cmd->nr_regions)) {
+		DMERR("Failed to allocate dirty bitmap");
+		__dirty_map_exit(&cmd->dmap[0]);
 		return -ENOMEM;
 	}
 
@@ -487,8 +517,8 @@ static int dirty_map_init(struct dm_clon
 
 static void dirty_map_exit(struct dm_clone_metadata *cmd)
 {
-	kvfree(cmd->dmap[0].dirty_words);
-	kvfree(cmd->dmap[1].dirty_words);
+	__dirty_map_exit(&cmd->dmap[0]);
+	__dirty_map_exit(&cmd->dmap[1]);
 }
 
 static int __load_bitset_in_core(struct dm_clone_metadata *cmd)
@@ -633,21 +663,23 @@ unsigned long dm_clone_find_next_unhydra
 	return find_next_zero_bit(cmd->region_map, cmd->nr_regions, start);
 }
 
-static int __update_metadata_word(struct dm_clone_metadata *cmd, unsigned long word)
+static int __update_metadata_word(struct dm_clone_metadata *cmd,
+				  unsigned long *dirty_regions,
+				  unsigned long word)
 {
 	int r;
 	unsigned long index = word * BITS_PER_LONG;
 	unsigned long max_index = min(cmd->nr_regions, (word + 1) * BITS_PER_LONG);
 
 	while (index < max_index) {
-		if (test_bit(index, cmd->region_map)) {
+		if (test_bit(index, dirty_regions)) {
 			r = dm_bitset_set_bit(&cmd->bitset_info, cmd->bitset_root,
 					      index, &cmd->bitset_root);
-
 			if (r) {
 				DMERR("dm_bitset_set_bit failed");
 				return r;
 			}
+			__clear_bit(index, dirty_regions);
 		}
 		index++;
 	}
@@ -721,7 +753,7 @@ static int __flush_dmap(struct dm_clone_
 		if (word == cmd->nr_words)
 			break;
 
-		r = __update_metadata_word(cmd, word);
+		r = __update_metadata_word(cmd, dmap->dirty_regions, word);
 
 		if (r)
 			return r;
@@ -803,6 +835,7 @@ int dm_clone_set_region_hydrated(struct
 	dmap = cmd->current_dmap;
 
 	__set_bit(word, dmap->dirty_words);
+	__set_bit(region_nr, dmap->dirty_regions);
 	__set_bit(region_nr, cmd->region_map);
 	dmap->changed = 1;
 
@@ -831,6 +864,7 @@ int dm_clone_cond_set_range(struct dm_cl
 		if (!test_bit(region_nr, cmd->region_map)) {
 			word = region_nr / BITS_PER_LONG;
 			__set_bit(word, dmap->dirty_words);
+			__set_bit(region_nr, dmap->dirty_regions);
 			__set_bit(region_nr, cmd->region_map);
 			dmap->changed = 1;
 		}


