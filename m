Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E4F11F75C
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 12:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfLOLIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 06:08:51 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:59633 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726094AbfLOLIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 06:08:50 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A4AAF665;
        Sun, 15 Dec 2019 06:08:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 06:08:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=a5xhBk
        PfUntw8Ws4m+qo09sZRPSZV6bzyKzC12E+fjc=; b=SW6H3ZJLwKgdhFryudwP0w
        PBJUtEkw6eHUbV8l1II72wDcekDFRgaWflC6IIioLU17uG1p9zav75KmpI/I6UQK
        yNJfnecTJbN+xq9a17Mq6w24G6TkVzFlNmG6BOQzzIlLEUV8kSO5DJn5e7juZZcC
        gm3PS0wy+xBH3XBRMKF9t1MrZCitr20ymbEynRVpAHAffi9PM+SawLyfpCWmvxRd
        bai33rD+CwzkDPZ76TYSp2p0toI4LGeO3BCIB/u6X7mz9srGWReXQtLXL6VHyMF0
        EH0XsW9Ai2lK3CuU8MX+jeik97KH6iVn2CLdu50i4FDF0C14KDcppahKXIQP2+MA
        ==
X-ME-Sender: <xms:QRT2XaSilgKbFMCRBszMICDYx-j87bltb6b4sqBX5f4d4Pdeegnp_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:QRT2XZR649LpioNiI2FY_c3vrA5idhbVkJr4zzHHIxFGVEgx74Urvg>
    <xmx:QRT2XcFVH7Ztno8ZNCA0RP8K9J-k2sEIFOpbOiCz4T_9hmuKUwvNFg>
    <xmx:QRT2XdkzzIx0rPSXf2wJZs-ypKjAcY3_n0nrYm-K4-FKel4Z-WflkQ>
    <xmx:QRT2XQoRYzfHqTqmcx-bgAWj2bS-cahzFUPra_28CwecWXM5HFqkpg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1A4B30600B1;
        Sun, 15 Dec 2019 06:08:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: use btrfs_block_group_cache_done in update_block_group" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 12:08:47 +0100
Message-ID: <1576408127875@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

