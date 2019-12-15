Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5901111F75B
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 12:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfLOLIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 06:08:49 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:50935 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726094AbfLOLIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 06:08:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A89A266B;
        Sun, 15 Dec 2019 06:08:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 06:08:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dsV8p5
        0zJiReHLpn3gqYP8gg22HCLBMxYzhEhOqX+ew=; b=fGqlZPtt5Sl+dqD3hpv4r/
        8t7zvnTY1pcCMrWwD2Dd73yv7PuVxsqghsA2ZijPmB1OtsSIHYm3vTuBTE8aa+Zf
        S+tXfA+84ShRL11XzDOl832qnLe4kD+W5fw064nzilgMwQ7RMgayEqheB31PJpXV
        PYhq+qaYQLNd1hLJKhD6U/m+wcOvBmBg7VHpHwD+uZ2H11L32rdYMvxOWUD5i+gW
        mY4M/k/K2GyNbhwS007b9vArQ9BG0PTzHeFn636HlKToME2DwOpB8pbJ1z59eAhf
        bC/3HYnh5de6YELB3+HSLR1Grcn8tv6dd+1w7mdWW3oBLk49WwfQsi3RKELd+ERw
        ==
X-ME-Sender: <xms:PxT2XSWhiag1pAedp3ldmnxJmMDWXEr7Eht0eiFoDxlAgyiwMYvamw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:PxT2XZfkT3sJ11Lh7aBmCHsxZL1bp01_bSMfvSbURR6iyUMaI4rzgQ>
    <xmx:PxT2XeO-xlhNFdRR4gLJZUA0zUyFH590qpD2m6oZAKz6c8Q4yWLXyA>
    <xmx:PxT2XXhGTZ0zkEZRRbZ8WsCXBnYqI_-hw4ZQKxwJTnPGvQGwtzaRgw>
    <xmx:PxT2XcOMfXDbYUz36QY85gAjHq66_14LXa5vWWMqvzk4ZYlZx6B9eg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E697830600AB;
        Sun, 15 Dec 2019 06:08:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: use btrfs_block_group_cache_done in update_block_group" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 12:08:45 +0100
Message-ID: <15764081255064@kroah.com>
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

