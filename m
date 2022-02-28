Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0294C7727
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239887AbiB1SLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240642AbiB1SJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5343B5E76B;
        Mon, 28 Feb 2022 09:48:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A73860909;
        Mon, 28 Feb 2022 17:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B00C340E7;
        Mon, 28 Feb 2022 17:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070527;
        bh=Ld3mo65E0/KE6WkoUpUGYPKrTJ2wuyv9AoP0+dIK3uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgMIFp0kd/C9EHZyMqDnv/UGSujzmye9vKg2DGryvxJhA6kO45qy4fwDsgY0XrBF1
         JNGUCmYJckv4sAzDWI5ryCB+3OqN/0a7y5kwL1rKK2gOpBh9K01un81IGEMEY1J7MF
         xlIT/FGBRJzG3MwkI+KiNENV5+DljzL7DSs6oRG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 139/164] btrfs: defrag: dont defrag extents which are already at max capacity
Date:   Mon, 28 Feb 2022 18:25:01 +0100
Message-Id: <20220228172412.565652216@linuxfoundation.org>
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

commit 979b25c300dbcbcb750e88715018e04e854de6c6 upstream.

[BUG]
For compressed extents, defrag ioctl will always try to defrag any
compressed extents, wasting not only IO but also CPU time to
compress/decompress:

   mkfs.btrfs -f $DEV
   mount -o compress $DEV $MNT
   xfs_io -f -c "pwrite -S 0xab 0 128K" $MNT/foobar
   sync
   xfs_io -f -c "pwrite -S 0xcd 128K 128K" $MNT/foobar
   sync
   echo "=== before ==="
   xfs_io -c "fiemap -v" $MNT/foobar
   btrfs filesystem defrag $MNT/foobar
   sync
   echo "=== after ==="
   xfs_io -c "fiemap -v" $MNT/foobar

Then it shows the 2 128K extents just get COW for no extra benefit, with
extra IO/CPU spent:

    === before ===
    /mnt/btrfs/file1:
     EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
       0: [0..255]:        26624..26879       256   0x8
       1: [256..511]:      26632..26887       256   0x9
    === after ===
    /mnt/btrfs/file1:
     EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
       0: [0..255]:        26640..26895       256   0x8
       1: [256..511]:      26648..26903       256   0x9

This affects not only v5.16 (after the defrag rework), but also v5.15
(before the defrag rework).

[CAUSE]
>From the very beginning, btrfs defrag never checks if one extent is
already at its max capacity (128K for compressed extents, 128M
otherwise).

And the default extent size threshold is 256K, which is already beyond
the compressed extent max size.

This means, by default btrfs defrag ioctl will mark all compressed
extent which is not adjacent to a hole/preallocated range for defrag.

[FIX]
Introduce a helper to grab the maximum extent size, and then in
defrag_collect_targets() and defrag_check_next_extent(), reject extents
which are already at their max capacity.

Reported-by: Filipe Manana <fdmanana@suse.com>
CC: stable@vger.kernel.org # 5.16
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1020,6 +1020,13 @@ static struct extent_map *defrag_lookup_
 	return em;
 }
 
+static u32 get_extent_max_capacity(const struct extent_map *em)
+{
+	if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
+		return BTRFS_MAX_COMPRESSED;
+	return BTRFS_MAX_EXTENT_SIZE;
+}
+
 static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em,
 				     bool locked)
 {
@@ -1036,6 +1043,12 @@ static bool defrag_check_next_extent(str
 		goto out;
 	if (test_bit(EXTENT_FLAG_PREALLOC, &next->flags))
 		goto out;
+	/*
+	 * If the next extent is at its max capacity, defragging current extent
+	 * makes no sense, as the total number of extents won't change.
+	 */
+	if (next->len >= get_extent_max_capacity(em))
+		goto out;
 	/* Physically adjacent and large enough */
 	if ((em->block_start + em->block_len == next->block_start) &&
 	    (em->block_len > SZ_128K && next->block_len > SZ_128K))
@@ -1233,6 +1246,13 @@ static int defrag_collect_targets(struct
 		if (range_len >= extent_thresh)
 			goto next;
 
+		/*
+		 * Skip extents already at its max capacity, this is mostly for
+		 * compressed extents, which max cap is only 128K.
+		 */
+		if (em->len >= get_extent_max_capacity(em))
+			goto next;
+
 		next_mergeable = defrag_check_next_extent(&inode->vfs_inode, em,
 							  locked);
 		if (!next_mergeable) {


