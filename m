Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4454C7701
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbiB1SK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240847AbiB1SJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F475FF09;
        Mon, 28 Feb 2022 09:49:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CA5360BBB;
        Mon, 28 Feb 2022 17:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30A1C340E7;
        Mon, 28 Feb 2022 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070522;
        bh=Q8JC4OcwLGjsXfqJrcQWbcSisgO3H+o0nNhmi2ygFr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z45BKJePhzkIoKV6aYtLh2aYTeKhBPPx8cZhxis73YJ0BjaFmoc/1p0F8g+GcwqfQ
         tu30+BX5VjwSTeDCoV8r2M97IzlfWadzAeHGeKMRPxRkBGnx9wzJ1y5rbD2rZluczH
         A25EF8GwJgO75uDprJK1cp+TcRHN9DLBhaN/8q2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 138/164] btrfs: defrag: dont try to merge regular extents with preallocated extents
Date:   Mon, 28 Feb 2022 18:25:00 +0100
Message-Id: <20220228172412.488282193@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 7093f15291e95f16dfb5a93307eda3272bfe1108 upstream.

[BUG]
With older kernels (before v5.16), btrfs will defrag preallocated extents.
While with newer kernels (v5.16 and newer) btrfs will not defrag
preallocated extents, but it will defrag the extent just before the
preallocated extent, even it's just a single sector.

This can be exposed by the following small script:

	mkfs.btrfs -f $dev > /dev/null

	mount $dev $mnt
	xfs_io -f -c "pwrite 0 4k" -c sync -c "falloc 4k 16K" $mnt/file
	xfs_io -c "fiemap -v" $mnt/file
	btrfs fi defrag $mnt/file
	sync
	xfs_io -c "fiemap -v" $mnt/file

The output looks like this on older kernels:

/mnt/btrfs/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..7]:          26624..26631         8   0x0
   1: [8..39]:         26632..26663        32 0x801
/mnt/btrfs/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..39]:         26664..26703        40   0x1

Which defrags the single sector along with the preallocated extent, and
replace them with an regular extent into a new location (caused by data
COW).
This wastes most of the data IO just for the preallocated range.

On the other hand, v5.16 is slightly better:

/mnt/btrfs/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..7]:          26624..26631         8   0x0
   1: [8..39]:         26632..26663        32 0x801
/mnt/btrfs/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..7]:          26664..26671         8   0x0
   1: [8..39]:         26632..26663        32 0x801

The preallocated range is not defragged, but the sector before it still
gets defragged, which has no need for it.

[CAUSE]
One of the function reused by the old and new behavior is
defrag_check_next_extent(), it will determine if we should defrag
current extent by checking the next one.

It only checks if the next extent is a hole or inlined, but it doesn't
check if it's preallocated.

On the other hand, out of the function, both old and new kernel will
reject preallocated extents.

Such inconsistent behavior causes above behavior.

[FIX]
- Also check if next extent is preallocated
  If so, don't defrag current extent.

- Add comments for each branch why we reject the extent

This will reduce the IO caused by defrag ioctl and autodefrag.

CC: stable@vger.kernel.org # 5.16
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1024,19 +1024,24 @@ static bool defrag_check_next_extent(str
 				     bool locked)
 {
 	struct extent_map *next;
-	bool ret = true;
+	bool ret = false;
 
 	/* this is the last extent */
 	if (em->start + em->len >= i_size_read(inode))
 		return false;
 
 	next = defrag_lookup_extent(inode, em->start + em->len, locked);
+	/* No more em or hole */
 	if (!next || next->block_start >= EXTENT_MAP_LAST_BYTE)
-		ret = false;
-	else if ((em->block_start + em->block_len == next->block_start) &&
-		 (em->block_len > SZ_128K && next->block_len > SZ_128K))
-		ret = false;
-
+		goto out;
+	if (test_bit(EXTENT_FLAG_PREALLOC, &next->flags))
+		goto out;
+	/* Physically adjacent and large enough */
+	if ((em->block_start + em->block_len == next->block_start) &&
+	    (em->block_len > SZ_128K && next->block_len > SZ_128K))
+		goto out;
+	ret = true;
+out:
 	free_extent_map(next);
 	return ret;
 }


