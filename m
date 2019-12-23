Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 046B8129918
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfLWRLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:11:19 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50731 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726754AbfLWRLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:11:18 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 80CE821B74;
        Mon, 23 Dec 2019 12:11:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 23 Dec 2019 12:11:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eIdFt/
        zgDTK8H2Ji3APChxT2tKV8SQ2JHF4BemXZ4aI=; b=tVVxgKSlxoG64jD64DxESq
        SBd+0fri8ommI6z20BcgjV4doxx3IZdoZlJzwcIZf7mYImM73nl7Gwb67QaXHouF
        Y3ICQKtLeSFZdidgiIEIVht4j2S9cgMEAMMMAZ5zHjdG2kldT6OYN/9FzPgb6q0R
        MnxLeg8fhYgs2Ts7OUoi0tWg7JWpnZYllfagO4sUlwA58mc7YirStpCDBCrqpsV6
        EgFkEfcDt4yPdX+gpiSnMLMUhe5Dy/Pz2lgGU5BTKwSc9W2quovmGds9pL57zS08
        ndcfZUhqPhr1kPgeq3MiJZI/UQtiqpg7JtoYDMoiPUE7BINfDB/CfMcSwf1fFiKA
        ==
X-ME-Sender: <xms:NfUAXl4jgeXEAjGSv-0byDbp8GeXnBT88V-AyWtm2ihbZxKPgdKcDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeduleekrdekledrieegrddvgeelnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:NfUAXn9RbMlMI_-ngb--B1MG7B81PE0b1KjFvQEP4-FShXmswVq1Ew>
    <xmx:NfUAXpcSkUK2EwHSQkZLqLAGIIFNwjCSFBXSzDTrVRKqP1ikKsi01g>
    <xmx:NfUAXr012zhSL_ylzQCKRNV4-JBfalzZVFSoAnIVTKK5ZM_HXx4lZg>
    <xmx:NfUAXu3xTvwx-Y76e6ImnATqnJwfO1ZWgyvQExnM_xCiDEbOOyCU8Q>
Received: from localhost (unknown [198.89.64.249])
        by mail.messagingengine.com (Postfix) with ESMTPA id 08D453060845;
        Mon, 23 Dec 2019 12:11:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: don't double lock the subvol_sem for rename exchange" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Dec 2019 12:11:14 -0500
Message-ID: <1577121074171148@kroah.com>
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

From 943eb3bf25f4a7b745dd799e031be276aa104d82 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 19 Nov 2019 13:59:20 -0500
Subject: [PATCH] btrfs: don't double lock the subvol_sem for rename exchange

If we're rename exchanging two subvols we'll try to lock this lock
twice, which is bad.  Just lock once if either of the ino's are subvols.

Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5766c2d19896..e3c76645cad7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9554,9 +9554,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	btrfs_init_log_ctx(&ctx_dest, new_inode);
 
 	/* close the race window with snapshot create/destroy ioctl */
-	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
-		down_read(&fs_info->subvol_sem);
-	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (old_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    new_ino == BTRFS_FIRST_FREE_OBJECTID)
 		down_read(&fs_info->subvol_sem);
 
 	/*
@@ -9790,9 +9789,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		ret = ret ? ret : ret2;
 	}
 out_notrans:
-	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
-		up_read(&fs_info->subvol_sem);
-	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (new_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&fs_info->subvol_sem);
 
 	ASSERT(list_empty(&ctx_root.list));

