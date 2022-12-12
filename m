Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58668649FA0
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiLLNNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiLLNM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:12:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D125BF9
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:12:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D670C61043
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FA5C433F0;
        Mon, 12 Dec 2022 13:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850761;
        bh=63jcb79OZCqmZ6G4sBFSNNUkr9xSSzIbvnThpBAEVgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iG7ee3ZmnfOhPYOu8sCTU1sJ7nlIjMz2pzEmFT/sz8/ei833tea+O6CvkvzuDtlm0
         NPFejQJVSzZ1yMVxP39fDabKy34dDzMmo514nBWSolGG0GlOpAx/M9OQlCHgimkuXz
         q+NfgGw/l8Hdjc2sYpu4s3FiIXUD4M2lXtJip+f4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Boris Burkov <boris@bur.io>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/106] btrfs: send: avoid unaligned encoded writes when attempting to clone range
Date:   Mon, 12 Dec 2022 14:09:23 +0100
Message-Id: <20221212130925.746820821@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a11452a3709e217492798cf3686ac2cc8eb3fb51 ]

When trying to see if we can clone a file range, there are cases where we
end up sending two write operations in case the inode from the source root
has an i_size that is not sector size aligned and the length from the
current offset to its i_size is less than the remaining length we are
trying to clone.

Issuing two write operations when we could instead issue a single write
operation is not incorrect. However it is not optimal, specially if the
extents are compressed and the flag BTRFS_SEND_FLAG_COMPRESSED was passed
to the send ioctl. In that case we can end up sending an encoded write
with an offset that is not sector size aligned, which makes the receiver
fallback to decompressing the data and writing it using regular buffered
IO (so re-compressing the data in case the fs is mounted with compression
enabled), because encoded writes fail with -EINVAL when an offset is not
sector size aligned.

The following example, which triggered a bug in the receiver code for the
fallback logic of decompressing + regular buffer IO and is fixed by the
patchset referred in a Link at the bottom of this changelog, is an example
where we have the non-optimal behaviour due to an unaligned encoded write:

   $ cat test.sh
   #!/bin/bash

   DEV=/dev/sdj
   MNT=/mnt/sdj

   mkfs.btrfs -f $DEV > /dev/null
   mount -o compress $DEV $MNT

   # File foo has a size of 33K, not aligned to the sector size.
   xfs_io -f -c "pwrite -S 0xab 0 33K" $MNT/foo

   xfs_io -f -c "pwrite -S 0xcd 0 64K" $MNT/bar

   # Now clone the first 32K of file bar into foo at offset 0.
   xfs_io -c "reflink $MNT/bar 0 0 32K" $MNT/foo

   # Snapshot the default subvolume and create a full send stream (v2).
   btrfs subvolume snapshot -r $MNT $MNT/snap

   btrfs send --compressed-data -f /tmp/test.send $MNT/snap

   echo -e "\nFile bar in the original filesystem:"
   od -A d -t x1 $MNT/snap/bar

   umount $MNT
   mkfs.btrfs -f $DEV > /dev/null
   mount $DEV $MNT

   echo -e "\nReceiving stream in a new filesystem..."
   btrfs receive -f /tmp/test.send $MNT

   echo -e "\nFile bar in the new filesystem:"
   od -A d -t x1 $MNT/snap/bar

   umount $MNT

Before this patch, the send stream included one regular write and one
encoded write for file 'bar', with the later being not sector size aligned
and causing the receiver to fallback to decompression + buffered writes.
The output of the btrfs receive command in verbose mode (-vvv):

   (...)
   mkfile o258-7-0
   rename o258-7-0 -> bar
   utimes
   clone bar - source=foo source offset=0 offset=0 length=32768
   write bar - offset=32768 length=1024
   encoded_write bar - offset=33792, len=4096, unencoded_offset=33792, unencoded_file_len=31744, unencoded_len=65536, compression=1, encryption=0
   encoded_write bar - falling back to decompress and write due to errno 22 ("Invalid argument")
   (...)

This patch avoids the regular write followed by an unaligned encoded write
so that we end up sending a single encoded write that is aligned. So after
this patch the stream content is (output of btrfs receive -vvv):

   (...)
   mkfile o258-7-0
   rename o258-7-0 -> bar
   utimes
   clone bar - source=foo source offset=0 offset=0 length=32768
   encoded_write bar - offset=32768, len=4096, unencoded_offset=32768, unencoded_file_len=32768, unencoded_len=65536, compression=1, encryption=0
   (...)

So we get more optimal behaviour and avoid the silent data loss bug in
versions of btrfs-progs affected by the bug referred by the Link tag
below (btrfs-progs v5.19, v5.19.1, v6.0 and v6.0.1).

Link: https://lore.kernel.org/linux-btrfs/cover.1668529099.git.fdmanana@suse.com/
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6b80dee17f49..4a6ba0997e39 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5398,6 +5398,7 @@ static int clone_range(struct send_ctx *sctx,
 		u64 ext_len;
 		u64 clone_len;
 		u64 clone_data_offset;
+		bool crossed_src_i_size = false;
 
 		if (slot >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(clone_root->root, path);
@@ -5454,8 +5455,10 @@ static int clone_range(struct send_ctx *sctx,
 		if (key.offset >= clone_src_i_size)
 			break;
 
-		if (key.offset + ext_len > clone_src_i_size)
+		if (key.offset + ext_len > clone_src_i_size) {
 			ext_len = clone_src_i_size - key.offset;
+			crossed_src_i_size = true;
+		}
 
 		clone_data_offset = btrfs_file_extent_offset(leaf, ei);
 		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte) {
@@ -5515,6 +5518,25 @@ static int clone_range(struct send_ctx *sctx,
 				ret = send_clone(sctx, offset, clone_len,
 						 clone_root);
 			}
+		} else if (crossed_src_i_size && clone_len < len) {
+			/*
+			 * If we are at i_size of the clone source inode and we
+			 * can not clone from it, terminate the loop. This is
+			 * to avoid sending two write operations, one with a
+			 * length matching clone_len and the final one after
+			 * this loop with a length of len - clone_len.
+			 *
+			 * When using encoded writes (BTRFS_SEND_FLAG_COMPRESSED
+			 * was passed to the send ioctl), this helps avoid
+			 * sending an encoded write for an offset that is not
+			 * sector size aligned, in case the i_size of the source
+			 * inode is not sector size aligned. That will make the
+			 * receiver fallback to decompression of the data and
+			 * writing it using regular buffered IO, therefore while
+			 * not incorrect, it's not optimal due decompression and
+			 * possible re-compression at the receiver.
+			 */
+			break;
 		} else {
 			ret = send_extent_data(sctx, offset, clone_len);
 		}
-- 
2.35.1



