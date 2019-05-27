Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCD72B71D
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 16:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfE0OAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 10:00:00 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:57897 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbfE0N77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 09:59:59 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 72D4657C;
        Mon, 27 May 2019 09:59:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 27 May 2019 09:59:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/1t7dd
        x9YDUpJDc3NXBXthhRYG/J7R1gs85J8j8IAMM=; b=rIwF6oT1l02B7nGOfTxfgs
        jfyxVEjrlIMgTU935IW3n3O6SZntGh43OlE0G/AjPeHfNVM8J9AeGGUnANar5lNJ
        hAiqtWU4xdyfDfuCyiBr46bYsA3vtscaLHMG3PotAdSFOtOysVz/+zBJGRpt/C1y
        JlVcW1J+EXPY1DVtgYPY7XvI4uLjUIN5tb951ec2Z0dCc0X4qeRO5GfBqmAlZPz3
        6lHlSbOmWfyMuSFxjfTdcdIFQtp17uzmTgvnAvm3phaukS0Ly9ObB6aJQzrt3chU
        dMAldGcIuL8QgACe5+95LbLlrKb9nd1FA7gclQcBj2K/4cFBafruIEd139CaMKNA
        ==
X-ME-Sender: <xms:Xe3rXF1HNZRQ63wOdNcOyZO9dIBJ1XI-Y6_Yz-40rLallfksODlT5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvvddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Xe3rXC5WqQz6FhRAuSRi4pPImKFBEhPKLuDnDgeExd6VNyJeHUXlIQ>
    <xmx:Xe3rXO2bfLvXgU9d5tfWgQuXOjE7hOU2cutgOwt6M2N0nCKbAjN8jw>
    <xmx:Xe3rXFodoyTfmTaBTXqXZdu4lht1Iewm2R1zB78jnLYtoNoGrNBXVA>
    <xmx:Xu3rXA0qtUv9TJEEVdlsY-OyFzMSDdjj6PWRTH6xHL3GbCSTTlfvUg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 55712380086;
        Mon, 27 May 2019 09:59:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: do not abort transaction at btrfs_update_root() after" failed to apply to 4.4-stable tree
To:     fdmanana@suse.com, anand.jain@oracle.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 May 2019 15:59:55 +0200
Message-ID: <155896559561238@kroah.com>
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

From 72bd2323ec87722c115a5906bc6a1b31d11e8f54 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 29 Apr 2019 13:08:14 +0100
Subject: [PATCH] Btrfs: do not abort transaction at btrfs_update_root() after
 failure to COW path

Currently when we fail to COW a path at btrfs_update_root() we end up
always aborting the transaction. However all the current callers of
btrfs_update_root() are able to deal with errors returned from it, many do
end up aborting the transaction themselves (directly or not, such as the
transaction commit path), other BUG_ON() or just gracefully cancel whatever
they were doing.

When syncing the fsync log, we call btrfs_update_root() through
tree-log.c:update_log_root(), and if it returns an -ENOSPC error, the log
sync code does not abort the transaction, instead it gracefully handles
the error and returns -EAGAIN to the fsync handler, so that it falls back
to a transaction commit. Any other error different from -ENOSPC, makes the
log sync code abort the transaction.

So remove the transaction abort from btrfs_update_log() when we fail to
COW a path to update the root item, so that if an -ENOSPC failure happens
we avoid aborting the current transaction and have a chance of the fsync
succeeding after falling back to a transaction commit.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203413
Fixes: 79787eaab46121 ("btrfs: replace many BUG_ONs with proper error handling")
Cc: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 1b9a5d0de139..22124122728c 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -132,10 +132,8 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		return -ENOMEM;
 
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
-	if (ret < 0) {
-		btrfs_abort_transaction(trans, ret);
+	if (ret < 0)
 		goto out;
-	}
 
 	if (ret > 0) {
 		btrfs_crit(fs_info,

