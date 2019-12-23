Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9428129930
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfLWRPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:15:03 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39261 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfLWRPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:15:03 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 02927217FC;
        Mon, 23 Dec 2019 12:15:02 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 23 Dec 2019 12:15:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KgAAab
        nhl0aGAnGFD1vMSXn4Gqz6AFNWKpEB9M1zLJc=; b=Qu8GlQ5qWkYGygEEKOlJQa
        ODVQSsr/kslVpO46PXA7JSncEVNYmkfmWkmbaEvOx3zQ2QIyJij9er0NI7Any/DJ
        3esv9KgZqMbSg0CAijkZb/3BBO/vfj+7eucQC+DOLLMB6WitDJUObMTi5Fkzt5RH
        qmvDEUyoeSZR5IUTykdBtJLnVLAg36/GkOxczXkF9cZm9ACe8Dbe/0w7ZFBeEPtU
        DUeT4vn4TV3TXEk0uLq4NmI4gK5cishUym7ZL1OwvD2eSRBEKDUsasFWLsBOOggr
        ci0Ve/TkFNH+oX8sN+ul61z/sjMqXvNkX3uUtidb7YO/Xaa/KFwqGyXybmsm8ZhQ
        ==
X-ME-Sender: <xms:FfYAXr90NeNbKBqax8AQkL8Ch9XrNGhbPoGsWUobUjmR_BcOaTUmew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeduleekrdekledrieegrddvgeelnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeej
X-ME-Proxy: <xmx:FfYAXs9YuRWtlj8dHmALv-l19MOMVwr2SkEmtN0Fq5_qlqXCGtgvpA>
    <xmx:FfYAXqtpHP9Tfbjj5HN-uZVeaJWjzNV3WKRGfk-I1p3-g4EWoZrGgg>
    <xmx:FfYAXvqV9Q09Zl4PkvUJFX81k1vmvSPPfWiIKLoEQuo530dFo36GEg>
    <xmx:FfYAXsi4NRC68qTyK318-GdZ5DMHvAd9_8VwSBNYgYyiSH3gSWDjXw>
Received: from localhost (unknown [198.89.64.249])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52AD580062;
        Mon, 23 Dec 2019 12:15:01 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: abort transaction after failed inode updates in" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com,
        jthumshirn@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Dec 2019 12:14:58 -0500
Message-ID: <15771212987252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c7e54b5102bf3614cadb9ca32d7be73bad6cecf0 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 6 Dec 2019 09:37:15 -0500
Subject: [PATCH] btrfs: abort transaction after failed inode updates in
 create_subvol

We can just abort the transaction here, and in fact do that for every
other failure in this function except these two cases.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3418decb9e61..18e328ce4b54 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -704,11 +704,17 @@ static noinline int create_subvol(struct inode *dir,
 
 	btrfs_i_size_write(BTRFS_I(dir), dir->i_size + namelen * 2);
 	ret = btrfs_update_inode(trans, root, dir);
-	BUG_ON(ret);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto fail;
+	}
 
 	ret = btrfs_add_root_ref(trans, objectid, root->root_key.objectid,
 				 btrfs_ino(BTRFS_I(dir)), index, name, namelen);
-	BUG_ON(ret);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto fail;
+	}
 
 	ret = btrfs_uuid_tree_add(trans, root_item->uuid,
 				  BTRFS_UUID_KEY_SUBVOL, objectid);

