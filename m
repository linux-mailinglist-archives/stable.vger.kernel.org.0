Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED2811F758
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 12:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfLOLIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 06:08:42 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:38159 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726094AbfLOLIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 06:08:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0F26F665;
        Sun, 15 Dec 2019 06:08:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 06:08:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uQWqxF
        nWR5Ord3tOBh829Jam+W6zp4c7t7pD5HndByw=; b=NGkd1/rcZSQp1mGfVLXVfU
        AnN2/vPWS9b7uJ/nD4UR0oz048RxHAvE6VrY4WxANQOzrYT4aylcT2+40PGVCx1C
        YIta2yXuYTUSpDsqMMCejoZ1QhrjveqHYLNZLhFFdNsJKtUvQ8Og6cByRCJQnqeb
        ZD7ISJiCOnkzMBxg0ivxqYPL0tTiKpc72WcgMp1vPgD8WCHRJQihlfZUxdlTd/sj
        zMUKqPoOo0r2jW83ypsQ6D9sDZvxW2t1FDciQcIw6WR3YmQl1xv4HudfKYjtU7UM
        4/FICTMzYwjbPcc5Nv3Kf4/anyPYWyDDnWLEuXKr8ecX/RaV9nenNSa8Wz28j1iw
        ==
X-ME-Sender: <xms:OBT2XTOTfXZ49f3T5yFzMew_6tWypuE8fDZHrJ8-RxFTDQxBwJfcJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:OBT2XUTHJMb3DXtZJ4rXDRBXNqBgjO0QW_r6NPO5KUkexPQuYSevmg>
    <xmx:OBT2XYRl7ASAoPeD5EwyLCLIbu5DrhbpAb3TvTn_KOnSKfxIP5QOzQ>
    <xmx:OBT2XVByiOhLCrL9mzC08FIXakJpypXBMRPw7jQBOPrnMg6Wi9d5Kg>
    <xmx:OBT2XdX2Bm0PjmtPF1sLMwWu9Y-TGTT94CU2m7-g55LCQOtqvy7pzw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BECC38005A;
        Sun, 15 Dec 2019 06:08:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: use btrfs_block_group_cache_done in update_block_group" failed to apply to 5.3-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 12:08:38 +0100
Message-ID: <1576408118186153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a60adce85f4bb5c1ef8ffcebadd702cafa2f3696 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 24 Sep 2019 16:50:44 -0400
Subject: [PATCH] btrfs: use btrfs_block_group_cache_done in update_block_group

When free'ing extents in a block group we check to see if the block
group is not cached, and then cache it if we need to.  However we'll
just carry on as long as we're loading the cache.  This is problematic
because we are dirtying the block group here.  If we are fast enough we
could do a transaction commit and clear the free space cache while we're
still loading the space cache in another thread.  This truncates the
free space inode, which will keep it from loading the space cache.

Fix this by using the btrfs_block_group_cache_done helper so that we try
to load the space cache unconditionally here, which will result in the
caller waiting for the fast caching to complete and keep us from
truncating the free space inode.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 384659dc7818..540a7a63601e 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2661,7 +2661,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 		 * is because we need the unpinning stage to actually add the
 		 * space back to the block group, otherwise we will leak space.
 		 */
-		if (!alloc && cache->cached == BTRFS_CACHE_NO)
+		if (!alloc && !btrfs_block_group_cache_done(cache))
 			btrfs_cache_block_group(cache, 1);
 
 		byte_in_group = bytenr - cache->key.objectid;

