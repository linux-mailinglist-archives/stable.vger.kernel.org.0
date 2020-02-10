Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1AC91577ED
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbgBJNDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:03:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729710AbgBJMkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:21 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5475920838;
        Mon, 10 Feb 2020 12:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338421;
        bh=PhrbytiY53+0EiMjQUczPdl2l9fB9EvIbAgJEEtFM7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFIueBe0HMcSnfaCllfOU+X0RFEkK6pl6bOm7bh4Ve9NVLAuu+8oyAXX3RecUq0BH
         73s7AynCG23Z+UFJq2Bu6yNZj5vppfZjYGW6HWZ75Pp6zPktqQS3Qz8TFN9MZ0EE+R
         /s0c1F4NcYknS2bSdAOCILXsVQM1j8DGn2kDtJks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.5 140/367] dm zoned: support zone sizes smaller than 128MiB
Date:   Mon, 10 Feb 2020 04:30:53 -0800
Message-Id: <20200210122437.779661304@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

commit b39962950339912978484cdac50069258545d753 upstream.

dm-zoned is observed to log failed kernel assertions and not work
correctly when operating against a device with a zone size smaller
than 128MiB (e.g. 32768 bits per 4K block). The reason is that the
bitmap size per zone is calculated as zero with such a small zone
size. Fix this problem and also make the code related to zone bitmap
management be able to handle per zone bitmaps smaller than a single
block.

A dm-zoned-tools patch is required to properly format dm-zoned devices
with zone sizes smaller than 128MiB.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-zoned-metadata.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -134,6 +134,7 @@ struct dmz_metadata {
 
 	sector_t		zone_bitmap_size;
 	unsigned int		zone_nr_bitmap_blocks;
+	unsigned int		zone_bits_per_mblk;
 
 	unsigned int		nr_bitmap_blocks;
 	unsigned int		nr_map_blocks;
@@ -1161,7 +1162,10 @@ static int dmz_init_zones(struct dmz_met
 
 	/* Init */
 	zmd->zone_bitmap_size = dev->zone_nr_blocks >> 3;
-	zmd->zone_nr_bitmap_blocks = zmd->zone_bitmap_size >> DMZ_BLOCK_SHIFT;
+	zmd->zone_nr_bitmap_blocks =
+		max_t(sector_t, 1, zmd->zone_bitmap_size >> DMZ_BLOCK_SHIFT);
+	zmd->zone_bits_per_mblk = min_t(sector_t, dev->zone_nr_blocks,
+					DMZ_BLOCK_SIZE_BITS);
 
 	/* Allocate zone array */
 	zmd->zones = kcalloc(dev->nr_zones, sizeof(struct dm_zone), GFP_KERNEL);
@@ -1956,7 +1960,7 @@ int dmz_copy_valid_blocks(struct dmz_met
 		dmz_release_mblock(zmd, to_mblk);
 		dmz_release_mblock(zmd, from_mblk);
 
-		chunk_block += DMZ_BLOCK_SIZE_BITS;
+		chunk_block += zmd->zone_bits_per_mblk;
 	}
 
 	to_zone->weight = from_zone->weight;
@@ -2017,7 +2021,7 @@ int dmz_validate_blocks(struct dmz_metad
 
 		/* Set bits */
 		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
-		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
+		nr_bits = min(nr_blocks, zmd->zone_bits_per_mblk - bit);
 
 		count = dmz_set_bits((unsigned long *)mblk->data, bit, nr_bits);
 		if (count) {
@@ -2096,7 +2100,7 @@ int dmz_invalidate_blocks(struct dmz_met
 
 		/* Clear bits */
 		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
-		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
+		nr_bits = min(nr_blocks, zmd->zone_bits_per_mblk - bit);
 
 		count = dmz_clear_bits((unsigned long *)mblk->data,
 				       bit, nr_bits);
@@ -2156,6 +2160,7 @@ static int dmz_to_next_set_block(struct
 {
 	struct dmz_mblock *mblk;
 	unsigned int bit, set_bit, nr_bits;
+	unsigned int zone_bits = zmd->zone_bits_per_mblk;
 	unsigned long *bitmap;
 	int n = 0;
 
@@ -2170,15 +2175,15 @@ static int dmz_to_next_set_block(struct
 		/* Get offset */
 		bitmap = (unsigned long *) mblk->data;
 		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
-		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
+		nr_bits = min(nr_blocks, zone_bits - bit);
 		if (set)
-			set_bit = find_next_bit(bitmap, DMZ_BLOCK_SIZE_BITS, bit);
+			set_bit = find_next_bit(bitmap, zone_bits, bit);
 		else
-			set_bit = find_next_zero_bit(bitmap, DMZ_BLOCK_SIZE_BITS, bit);
+			set_bit = find_next_zero_bit(bitmap, zone_bits, bit);
 		dmz_release_mblock(zmd, mblk);
 
 		n += set_bit - bit;
-		if (set_bit < DMZ_BLOCK_SIZE_BITS)
+		if (set_bit < zone_bits)
 			break;
 
 		nr_blocks -= nr_bits;
@@ -2281,7 +2286,7 @@ static void dmz_get_zone_weight(struct d
 		/* Count bits in this block */
 		bitmap = mblk->data;
 		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
-		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
+		nr_bits = min(nr_blocks, zmd->zone_bits_per_mblk - bit);
 		n += dmz_count_bits(bitmap, bit, nr_bits);
 
 		dmz_release_mblock(zmd, mblk);


