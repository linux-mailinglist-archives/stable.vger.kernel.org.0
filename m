Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 832C7157BBE
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgBJMfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:35:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbgBJMfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:51 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42EDC2168B;
        Mon, 10 Feb 2020 12:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338150;
        bh=MwYhGUE+jYWpjZsa+15g3hupFybA4O768IPBJA8Bcy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hbvv8KwAVH6pTGb3a6LqZpiBI8wEc97kWfNFUSNLy39yLVqS5rNxpOsiVv80oLkSp
         EzfbdHWhNZHTNZPTTtFomP93BzZeqJ1FJ5ZFEfgwtS0/+/TrXUcqxDf+txiZXQzhY4
         bfdvu27lpC2bBuzeJPzzY8VezA7G91TUOK8+HbOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 086/195] dm zoned: support zone sizes smaller than 128MiB
Date:   Mon, 10 Feb 2020 04:32:24 -0800
Message-Id: <20200210122313.863366477@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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
@@ -132,6 +132,7 @@ struct dmz_metadata {
 
 	sector_t		zone_bitmap_size;
 	unsigned int		zone_nr_bitmap_blocks;
+	unsigned int		zone_bits_per_mblk;
 
 	unsigned int		nr_bitmap_blocks;
 	unsigned int		nr_map_blocks;
@@ -1165,7 +1166,10 @@ static int dmz_init_zones(struct dmz_met
 
 	/* Init */
 	zmd->zone_bitmap_size = dev->zone_nr_blocks >> 3;
-	zmd->zone_nr_bitmap_blocks = zmd->zone_bitmap_size >> DMZ_BLOCK_SHIFT;
+	zmd->zone_nr_bitmap_blocks =
+		max_t(sector_t, 1, zmd->zone_bitmap_size >> DMZ_BLOCK_SHIFT);
+	zmd->zone_bits_per_mblk = min_t(sector_t, dev->zone_nr_blocks,
+					DMZ_BLOCK_SIZE_BITS);
 
 	/* Allocate zone array */
 	zmd->zones = kcalloc(dev->nr_zones, sizeof(struct dm_zone), GFP_KERNEL);
@@ -1982,7 +1986,7 @@ int dmz_copy_valid_blocks(struct dmz_met
 		dmz_release_mblock(zmd, to_mblk);
 		dmz_release_mblock(zmd, from_mblk);
 
-		chunk_block += DMZ_BLOCK_SIZE_BITS;
+		chunk_block += zmd->zone_bits_per_mblk;
 	}
 
 	to_zone->weight = from_zone->weight;
@@ -2043,7 +2047,7 @@ int dmz_validate_blocks(struct dmz_metad
 
 		/* Set bits */
 		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
-		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
+		nr_bits = min(nr_blocks, zmd->zone_bits_per_mblk - bit);
 
 		count = dmz_set_bits((unsigned long *)mblk->data, bit, nr_bits);
 		if (count) {
@@ -2122,7 +2126,7 @@ int dmz_invalidate_blocks(struct dmz_met
 
 		/* Clear bits */
 		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
-		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
+		nr_bits = min(nr_blocks, zmd->zone_bits_per_mblk - bit);
 
 		count = dmz_clear_bits((unsigned long *)mblk->data,
 				       bit, nr_bits);
@@ -2182,6 +2186,7 @@ static int dmz_to_next_set_block(struct
 {
 	struct dmz_mblock *mblk;
 	unsigned int bit, set_bit, nr_bits;
+	unsigned int zone_bits = zmd->zone_bits_per_mblk;
 	unsigned long *bitmap;
 	int n = 0;
 
@@ -2196,15 +2201,15 @@ static int dmz_to_next_set_block(struct
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
@@ -2307,7 +2312,7 @@ static void dmz_get_zone_weight(struct d
 		/* Count bits in this block */
 		bitmap = mblk->data;
 		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
-		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
+		nr_bits = min(nr_blocks, zmd->zone_bits_per_mblk - bit);
 		n += dmz_count_bits(bitmap, bit, nr_bits);
 
 		dmz_release_mblock(zmd, mblk);


