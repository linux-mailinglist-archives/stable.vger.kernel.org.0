Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276A111F75F
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 12:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfLOLK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 06:10:27 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:46749 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbfLOLK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 06:10:27 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6CE15670;
        Sun, 15 Dec 2019 06:10:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 06:10:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=G8zIEH
        Bl2BZFaNjYC9nXRtzCu1uYPe1Pl5OobY0X8Kg=; b=ByCJbqstQCAb4tzPZzNLju
        OZrv+zArIb969Q9bxNuUhiPYZNSpwh0ffoO7/g7sSg55W6aHXnckp2phVNSlCV1Z
        /6YE+UP8r1C9ARhC+pH+lJWcbpS6//LFOKPdBu5B7+ViXBlLssnOm3XO5OoyAybp
        lsUFUTFMKZhY9xHkNXKDhXBZJO6WxWum6vIcis4P/YW4CTr3p5dWg1wUYS1f3eoQ
        g/gW3IgUeI11rN2WPQgKvgPXVHPkozW8F/j8REb32mbgWjK4w/YrTyeOZEpLlkOd
        uLOs11zOFoQcqHjKXp678t2RJneVx3Nk6dHUlQGmCem+RH//EWMzhJvnYjb3hlJg
        ==
X-ME-Sender: <xms:ohT2XR6n1h6gmxZjvoSPPhDOi84xP6PqJc2P69KHI8Qj5GSctDlmwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgephe
X-ME-Proxy: <xmx:ohT2Xfrqp3XxafYLml6BjLU4UCfpTMssyWuPuvkSsD6yVvO_D9aRwA>
    <xmx:ohT2XUnHQ-_vmRF1ic_ulw7aPDvqcqQtLf8hqJcN3bt6MPWuk9ODkg>
    <xmx:ohT2XbPmO9g8jtqRCxq1MqFAigKXGZpBWbW4nYDkcoZvwIkfZkQ2fQ>
    <xmx:ohT2Xfgczl7gmLelGQKfZoJbDcXwme6Q9S4DJ0jjk6ChUdM7gUoKUw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7E41480059;
        Sun, 15 Dec 2019 06:10:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] Btrfs: fix negative subv_writers counter and data space leak" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 12:10:23 +0100
Message-ID: <1576408223251148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a0e248bb502d5165b3314ac3819e888fdcdf7d9f Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Fri, 11 Oct 2019 16:41:20 +0100
Subject: [PATCH] Btrfs: fix negative subv_writers counter and data space leak
 after buffered write

When doing a buffered write it's possible to leave the subv_writers
counter of the root, used for synchronization between buffered nocow
writers and snapshotting. This happens in an exceptional case like the
following:

1) We fail to allocate data space for the write, since there's not
   enough available data space nor enough unallocated space for allocating
   a new data block group;

2) Because of that failure, we try to go to NOCOW mode, which succeeds
   and therefore we set the local variable 'only_release_metadata' to true
   and set the root's sub_writers counter to 1 through the call to
   btrfs_start_write_no_snapshotting() made by check_can_nocow();

3) The call to btrfs_copy_from_user() returns zero, which is very unlikely
   to happen but not impossible;

4) No pages are copied because btrfs_copy_from_user() returned zero;

5) We call btrfs_end_write_no_snapshotting() which decrements the root's
   subv_writers counter to 0;

6) We don't set 'only_release_metadata' back to 'false' because we do
   it only if 'copied', the value returned by btrfs_copy_from_user(), is
   greater than zero;

7) On the next iteration of the while loop, which processes the same
   page range, we are now able to allocate data space for the write (we
   got enough data space released in the meanwhile);

8) After this if we fail at btrfs_delalloc_reserve_metadata(), because
   now there isn't enough free metadata space, or in some other place
   further below (prepare_pages(), lock_and_cleanup_extent_if_need(),
   btrfs_dirty_pages()), we break out of the while loop with
   'only_release_metadata' having a value of 'true';

9) Because 'only_release_metadata' is 'true' we end up decrementing the
   root's subv_writers counter to -1 (through a call to
   btrfs_end_write_no_snapshotting()), and we also end up not releasing the
   data space previously reserved through btrfs_check_data_free_space().
   As a consequence the mechanism for synchronizing NOCOW buffered writes
   with snapshotting gets broken.

Fix this by always setting 'only_release_metadata' to false at the start
of each iteration.

Fixes: 8257b2dc3c1a ("Btrfs: introduce btrfs_{start, end}_nocow_write() for each subvolume")
Fixes: 7ee9e4405f26 ("Btrfs: check if we can nocow if we don't have data space")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f9434fa3e387..91c98a6d1408 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1636,6 +1636,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 			break;
 		}
 
+		only_release_metadata = false;
 		sector_offset = pos & (fs_info->sectorsize - 1);
 		reserve_bytes = round_up(write_bytes + sector_offset,
 				fs_info->sectorsize);
@@ -1791,7 +1792,6 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 			set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 				       lockend, EXTENT_NORESERVE, NULL,
 				       NULL, GFP_NOFS);
-			only_release_metadata = false;
 		}
 
 		btrfs_drop_pages(pages, num_pages);

