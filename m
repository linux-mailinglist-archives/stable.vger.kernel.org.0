Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7DA676FAE
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjAVPYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjAVPYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:24:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384EB21A2C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:24:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B91AD60C44
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C5CC433D2;
        Sun, 22 Jan 2023 15:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401044;
        bh=NTSWrdcC3YS57YLwkiIwCsyNsW2NGU0Q26RRCfSNGtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zp3GHMPqkRbV+8RR6Yn08wVDjhkcOysZohGu4zxfXPJN7PKCPQA3EkFOFZUKZMRDj
         Z+RezEoAdtb7hT+YtGZDGQ/c36eWB8ZJNc3xxA8a482v+VYg6QcK3V2f9h38rMPkZs
         3G4WiYNRzHZ2XnVEbQhOCRFCU5H4LbRFsq8Uvo1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matthias Schoepfer <matthias.schoepfer@googlemail.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 088/193] btrfs: fix invalid leaf access due to inline extent during lseek
Date:   Sun, 22 Jan 2023 16:03:37 +0100
Message-Id: <20230122150250.410657485@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 1f55ee6d0901d915801618bda0af4e5b937e3db7 upstream.

During lseek, for SEEK_DATA and SEEK_HOLE modes, we access the disk_bytenr
of an extent without checking its type. However inline extents have their
data starting the offset of the disk_bytenr field, so accessing that field
when we have an inline extent can result in either of the following:

1) Interpret the inline extent's data as a disk_bytenr value;

2) In case the inline data is less than 8 bytes, we access part of some
   other item in the leaf, or unused space in the leaf;

3) In case the inline data is less than 8 bytes and the extent item is
   the first item in the leaf, we can access beyond the leaf's limit.

So fix this by not accessing the disk_bytenr field if we have an inline
extent.

Fixes: b6e833567ea1 ("btrfs: make hole and data seeking a lot more efficient")
Reported-by: Matthias Schoepfer <matthias.schoepfer@googlemail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216908
Link: https://lore.kernel.org/linux-btrfs/7f25442f-b121-2a3a-5a3d-22bcaae83cd4@leemhuis.info/
CC: stable@vger.kernel.org # 6.1
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3838,6 +3838,7 @@ static loff_t find_desired_extent(struct
 		struct extent_buffer *leaf = path->nodes[0];
 		struct btrfs_file_extent_item *extent;
 		u64 extent_end;
+		u8 type;
 
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(root, path);
@@ -3892,10 +3893,16 @@ static loff_t find_desired_extent(struct
 
 		extent = btrfs_item_ptr(leaf, path->slots[0],
 					struct btrfs_file_extent_item);
+		type = btrfs_file_extent_type(leaf, extent);
 
-		if (btrfs_file_extent_disk_bytenr(leaf, extent) == 0 ||
-		    btrfs_file_extent_type(leaf, extent) ==
-		    BTRFS_FILE_EXTENT_PREALLOC) {
+		/*
+		 * Can't access the extent's disk_bytenr field if this is an
+		 * inline extent, since at that offset, it's where the extent
+		 * data starts.
+		 */
+		if (type == BTRFS_FILE_EXTENT_PREALLOC ||
+		    (type == BTRFS_FILE_EXTENT_REG &&
+		     btrfs_file_extent_disk_bytenr(leaf, extent) == 0)) {
 			/*
 			 * Explicit hole or prealloc extent, search for delalloc.
 			 * A prealloc extent is treated like a hole.


