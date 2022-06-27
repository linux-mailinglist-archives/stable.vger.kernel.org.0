Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2ACB55D844
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238559AbiF0Lve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238248AbiF0Luk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AA31155;
        Mon, 27 Jun 2022 04:43:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D296061150;
        Mon, 27 Jun 2022 11:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37C2C341C7;
        Mon, 27 Jun 2022 11:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330224;
        bh=BZ1XEHoNQ/7Lshai0UXI47qHKZ4xvOshkxZ2H9A5TBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPIA3ztsNNTa2Xv3Lrrl/4bc7UxGCfqPul0CZBdOIxDuoBtvAECeSi39wSQq5+0c8
         Xu46lzYqetn7GPG/Rxk7Hh03WSumKYbCWH4EXuzqiS11pU6s+IPqLgjwJeWZhvKA2x
         GxnmC+rOrcpDQ0USA1UeycYJERGiBzxCazJt4FNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Burkov <boris@bur.io>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 124/181] btrfs: fix race between reflinking and ordered extent completion
Date:   Mon, 27 Jun 2022 13:21:37 +0200
Message-Id: <20220627111948.288668625@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit d4597898ba7b9d467b94a9aafd65ec408a75041f upstream.

While doing a reflink operation, if an ordered extent for a file range
that does not overlap with the source and destination ranges of the
reflink operation happens, we can end up having a failure in the reflink
operation and return -EINVAL to user space.

The following sequence of steps explains how this can happen:

1) We have the page at file offset 315392 dirty (under delalloc);

2) A reflink operation for this file starts, using the same file as both
   source and destination, the source range is [372736, 409600) (length of
   36864 bytes) and the destination range is [208896, 245760);

3) At btrfs_remap_file_range_prep(), we flush all delalloc in the source
   and destination ranges, and wait for any ordered extents in those range
   to complete;

4) Still at btrfs_remap_file_range_prep(), we then flush all delalloc in
   the inode, but we neither wait for it to complete nor any ordered
   extents to complete. This results in starting delalloc for the page at
   file offset 315392 and creating an ordered extent for that single page
   range;

5) We then move to btrfs_clone() and enter the loop to find file extent
   items to copy from the source range to destination range;

6) In the first iteration we end up at last file extent item stored in
   leaf A:

   (...)
   item 131 key (143616 108 315392) itemoff 5101 itemsize 53
            extent data disk bytenr 1903988736 nr 73728
            extent data offset 12288 nr 61440 ram 73728

   This represents the file range [315392, 376832), which overlaps with
   the source range to clone.

   @datal is set to 61440, key.offset is 315392 and @next_key_min_offset
   is therefore set to 376832 (315392 + 61440).

   @off (372736) is > key.offset (315392), so @new_key.offset is set to
   the value of @destoff (208896).

   @new_key.offset == @last_dest_end (208896) so @drop_start is set to
   208896 (@new_key.offset).

   @datal is adjusted to 4096, as @off is > @key.offset.

   So in this iteration we call btrfs_replace_file_extents() for the range
   [208896, 212991] (a single page, which is
   [@drop_start, @new_key.offset + @datal - 1]).

   @last_dest_end is set to 212992 (@new_key.offset + @datal =
   208896 + 4096 = 212992).

   Before the next iteration of the loop, @key.offset is set to the value
   376832, which is @next_key_min_offset;

7) On the second iteration btrfs_search_slot() leaves us again at leaf A,
   but this time pointing beyond the last slot of leaf A, as that's where
   a key with offset 376832 should be at if it existed. So end up calling
   btrfs_next_leaf();

8) btrfs_next_leaf() releases the path, but before it searches again the
   tree for the next key/leaf, the ordered extent for the single page
   range at file offset 315392 completes. That results in trimming the
   file extent item we processed before, adjusting its key offset from
   315392 to 319488, reducing its length from 61440 to 57344 and inserting
   a new file extent item for that single page range, with a key offset of
   315392 and a length of 4096.

   Leaf A now looks like:

     (...)
     item 132 key (143616 108 315392) itemoff 4995 itemsize 53
              extent data disk bytenr 1801666560 nr 4096
              extent data offset 0 nr 4096 ram 4096
     item 133 key (143616 108 319488) itemoff 4942 itemsize 53
              extent data disk bytenr 1903988736 nr 73728
              extent data offset 16384 nr 57344 ram 73728

9) When btrfs_next_leaf() returns, it gives us a path pointing to leaf A
   at slot 133, since it's the first key that follows what was the last
   key we saw (143616 108 315392). In fact it's the same item we processed
   before, but its key offset was changed, so it counts as a new key;

10) So now we have:

    @key.offset == 319488
    @datal == 57344

    @off (372736) is > key.offset (319488), so @new_key.offset is set to
    208896 (@destoff value).

    @new_key.offset (208896) != @last_dest_end (212992), so @drop_start
    is set to 212992 (@last_dest_end value).

    @datal is adjusted to 4096 because @off > @key.offset.

    So in this iteration we call btrfs_replace_file_extents() for the
    invalid range of [212992, 212991] (which is
    [@drop_start, @new_key.offset + @datal - 1]).

    This range is empty, the end offset is smaller than the start offset
    so btrfs_replace_file_extents() returns -EINVAL, which we end up
    returning to user space and fail the reflink operation.

    This all happens because the range of this file extent item was
    already processed in the previous iteration.

This scenario can be triggered very sporadically by fsx from fstests, for
example with test case generic/522.

So fix this by having btrfs_clone() skip file extent items that cover a
file range that we have already processed.

CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/reflink.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -344,6 +344,7 @@ static int btrfs_clone(struct inode *src
 	int ret;
 	const u64 len = olen_aligned;
 	u64 last_dest_end = destoff;
+	u64 prev_extent_end = off;
 
 	ret = -ENOMEM;
 	buf = kvmalloc(fs_info->nodesize, GFP_KERNEL);
@@ -363,7 +364,6 @@ static int btrfs_clone(struct inode *src
 	key.offset = off;
 
 	while (1) {
-		u64 next_key_min_offset = key.offset + 1;
 		struct btrfs_file_extent_item *extent;
 		u64 extent_gen;
 		int type;
@@ -431,14 +431,21 @@ process_slot:
 		 * The first search might have left us at an extent item that
 		 * ends before our target range's start, can happen if we have
 		 * holes and NO_HOLES feature enabled.
+		 *
+		 * Subsequent searches may leave us on a file range we have
+		 * processed before - this happens due to a race with ordered
+		 * extent completion for a file range that is outside our source
+		 * range, but that range was part of a file extent item that
+		 * also covered a leading part of our source range.
 		 */
-		if (key.offset + datal <= off) {
+		if (key.offset + datal <= prev_extent_end) {
 			path->slots[0]++;
 			goto process_slot;
 		} else if (key.offset >= off + len) {
 			break;
 		}
-		next_key_min_offset = key.offset + datal;
+
+		prev_extent_end = key.offset + datal;
 		size = btrfs_item_size(leaf, slot);
 		read_extent_buffer(leaf, buf, btrfs_item_ptr_offset(leaf, slot),
 				   size);
@@ -550,7 +557,7 @@ process_slot:
 			break;
 
 		btrfs_release_path(path);
-		key.offset = next_key_min_offset;
+		key.offset = prev_extent_end;
 
 		if (fatal_signal_pending(current)) {
 			ret = -EINTR;


