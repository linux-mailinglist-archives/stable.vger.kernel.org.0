Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62AA912991B
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfLWRLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:11:52 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39749 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfLWRLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:11:51 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2B6E221E95;
        Mon, 23 Dec 2019 12:11:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 23 Dec 2019 12:11:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=E7LM3u
        K4z8YrHKjmLZlZdXJATDyTAvQZKeLVnhM/ygM=; b=OCvWD5NDMOAuvcJAVdEDXp
        qS4NxxCJcJT0aPwvCDxe5PJFjjQUd9rHTOHypiT9E8keBs3wMEnmi9JWx145D0lT
        VPdPsFXWE03OKdECIO65ZbZdooCC1h+7s4Pj5qVvikcIwJYNek45Xg4Qwn8YSaCf
        39SbTMk6o5RCosCi+/1IAeE8Jym0imapFZTIcaJIOg52nXpHFeKInrrZCeBjpN5N
        YA5hVPkAhgPoUan0qZadheVI5vo9y2d3EGrF1XOLo5ezUM/a/jP7CfUZPBaEEXSl
        smwyewkz0krvKVsb+x7fs/c9+khsIg54U3JoF1liLR0FJiqxIsLul32X+3ayvF5g
        ==
X-ME-Sender: <xms:V_UAXhKKQR1TrfYtqy54q7H4WHTzTWIy3kmxE53lB1_g4FaSJnGi_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeduleekrdekledrieegrddvgeelnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:V_UAXjJtjhR1cYSq74-zZFOz-2CkWhtHwfYFySAuyfwWhMiJc3RFqA>
    <xmx:V_UAXkjTl1BSb35EcI-VQKwXkXKRtIk071zIaBdJi8dkjnpKlF1QPw>
    <xmx:V_UAXlO2SbER35Mr9DXlipHR5FGoke31Q80iZF6502T-jUAVueC2Dw>
    <xmx:V_UAXnIxYkbGiRs5S1IQdlfxPvXBb0-62ihtenJpwLvDo9NAGueWsw>
Received: from localhost (unknown [198.89.64.249])
        by mail.messagingengine.com (Postfix) with ESMTPA id D6894306098F;
        Mon, 23 Dec 2019 12:11:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: do not call synchronize_srcu() in inode_tree_del" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Dec 2019 12:11:47 -0500
Message-ID: <1577121107178231@kroah.com>
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

From f72ff01df9cf5db25c76674cac16605992d15467 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 19 Nov 2019 13:59:35 -0500
Subject: [PATCH] btrfs: do not call synchronize_srcu() in inode_tree_del

Testing with the new fsstress uncovered a pretty nasty deadlock with
lookup and snapshot deletion.

Process A
unlink
 -> final iput
   -> inode_tree_del
     -> synchronize_srcu(subvol_srcu)

Process B
btrfs_lookup  <- srcu_read_lock() acquired here
  -> btrfs_iget
    -> find inode that has I_FREEING set
      -> __wait_on_freeing_inode()

We're holding the srcu_read_lock() while doing the iget in order to make
sure our fs root doesn't go away, and then we are waiting for the inode
to finish freeing.  However because the free'ing process is doing a
synchronize_srcu() we deadlock.

Fix this by dropping the synchronize_srcu() in inode_tree_del().  We
don't need people to stop accessing the fs root at this point, we're
only adding our empty root to the dead roots list.

A larger much more invasive fix is forthcoming to address how we deal
with fs roots, but this fixes the immediate problem.

Fixes: 76dda93c6ae2 ("Btrfs: add snapshot/subvolume destroy ioctl")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 56032c518b26..5766c2d19896 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5728,7 +5728,6 @@ static void inode_tree_add(struct inode *inode)
 
 static void inode_tree_del(struct inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int empty = 0;
 
@@ -5741,7 +5740,6 @@ static void inode_tree_del(struct inode *inode)
 	spin_unlock(&root->inode_lock);
 
 	if (empty && btrfs_root_refs(&root->root_item) == 0) {
-		synchronize_srcu(&fs_info->subvol_srcu);
 		spin_lock(&root->inode_lock);
 		empty = RB_EMPTY_ROOT(&root->inode_tree);
 		spin_unlock(&root->inode_lock);

