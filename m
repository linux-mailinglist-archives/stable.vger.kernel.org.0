Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080E321A5D
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 17:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfEQPOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 11:14:35 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:53761 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729164AbfEQPOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 11:14:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 66D944AF;
        Fri, 17 May 2019 11:14:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 11:14:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KGt/Pi
        s46negSLF4xk7UaSW/Ys1XYvlwC+gFuiudHzE=; b=sTLbI7oMm0KBVHVkSInUSx
        1DY1B0xnFgr2r5QwpcVALsCXrISrwO8GuL8ZPKyFg2+4sz+gDDwtfTo8rUvGazva
        ieve6NxjPY/RMu31VSTgOTUAYji9IEh28wiCg0sFsyX6z/sX0c6J4yLSG8ZgZqM3
        +2G6TMWWfuPR7P0v4l/5PVfjSCizSM9tpE9HPVBb/e+8OPTo317fzNBnYYA1qp/3
        iqF5gmAmn2SZac4gRbbO2nt94HCsDLDLYoWTq9y2gfcwsQFzEhC/OaeLia9szA6w
        wdY7VSZn+0jvXFN+GWeuJI0hsYWeYN3MOUFyG60Mlyxvv8yCTmX6dV6cHniGrmLA
        ==
X-ME-Sender: <xms:2c_eXAux6AGLySlEu44NJ_YrMDrCjMdE6K4E1nKLO_fmyhzK2EEBJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:2c_eXE0JnNjqVMjmzNCTr9NJhwA82YS6vofomycOQZ62irvbb-cfmg>
    <xmx:2c_eXHxxNjZ8VZ_E0f7iFaWFNd6WQLwtZxrrAny_BxQ4hXaC24LZNA>
    <xmx:2c_eXM1O-RipeuLyBAkAOma83MdPx51q-SoUlj68fQPkWLPKkB261w>
    <xmx:2s_eXCrC7xvCtn3iGnvD-W93MIO-JmsLKYo3AVjYzFmNZNdQBfA5Xg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7E3C380060;
        Fri, 17 May 2019 11:14:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: Correctly free extent buffer in case" failed to apply to 4.4-stable tree
To:     nborisov@suse.com, dsterba@suse.com, jungyeon@gatech.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 17:14:30 +0200
Message-ID: <155810607086152@kroah.com>
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

From 537f38f019fa0b762dbb4c0fc95d7fcce9db8e2d Mon Sep 17 00:00:00 2001
From: Nikolay Borisov <nborisov@suse.com>
Date: Thu, 14 Mar 2019 09:52:35 +0200
Subject: [PATCH] btrfs: Correctly free extent buffer in case
 btree_read_extent_buffer_pages fails

If a an eb fails to be read for whatever reason - it's corrupted on disk
and parent transid/key validations fail or IO for eb pages fail then
this buffer must be removed from the buffer cache. Currently the code
calls free_extent_buffer if an error occurs. Unfortunately this doesn't
achieve the desired behavior since btrfs_find_create_tree_block returns
with eb->refs == 2.

On the other hand free_extent_buffer will only decrement the refs once
leaving it added to the buffer cache radix tree.  This enables later
code to look up the buffer from the cache and utilize it potentially
leading to a crash.

The correct way to free the buffer is call free_extent_buffer_stale.
This function will correctly call atomic_dec explicitly for the buffer
and subsequently call release_extent_buffer which will decrement the
final reference thus correctly remove the invalid buffer from buffer
cache. This change affects only newly allocated buffers since they have
eb->refs == 2.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=202755
Reported-by: Jungyeon <jungyeon@gatech.edu>
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 46b368d84aa3..ea44cf136131 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1021,13 +1021,18 @@ void readahead_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr)
 {
 	struct extent_buffer *buf = NULL;
 	struct inode *btree_inode = fs_info->btree_inode;
+	int ret;
 
 	buf = btrfs_find_create_tree_block(fs_info, bytenr);
 	if (IS_ERR(buf))
 		return;
-	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
-				 buf, WAIT_NONE, 0);
-	free_extent_buffer(buf);
+
+	ret = read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree, buf,
+			WAIT_NONE, 0);
+	if (ret < 0)
+		free_extent_buffer_stale(buf);
+	else
+		free_extent_buffer(buf);
 }
 
 int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
@@ -1047,12 +1052,12 @@ int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
 	ret = read_extent_buffer_pages(io_tree, buf, WAIT_PAGE_LOCK,
 				       mirror_num);
 	if (ret) {
-		free_extent_buffer(buf);
+		free_extent_buffer_stale(buf);
 		return ret;
 	}
 
 	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags)) {
-		free_extent_buffer(buf);
+		free_extent_buffer_stale(buf);
 		return -EIO;
 	} else if (extent_buffer_uptodate(buf)) {
 		*eb = buf;
@@ -1106,7 +1111,7 @@ struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 	ret = btree_read_extent_buffer_pages(fs_info, buf, parent_transid,
 					     level, first_key);
 	if (ret) {
-		free_extent_buffer(buf);
+		free_extent_buffer_stale(buf);
 		return ERR_PTR(ret);
 	}
 	return buf;

