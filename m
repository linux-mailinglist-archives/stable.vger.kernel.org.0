Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA1A129931
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfLWRPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:15:11 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50547 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfLWRPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:15:11 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 69A8E21F82;
        Mon, 23 Dec 2019 12:15:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 23 Dec 2019 12:15:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9MTFfO
        yktEbmCFoeporpK3uqlU/H3dVr4rWyfO7TXd8=; b=ozr7OZlDu6Yh59RMM1S/aw
        DE8HIannAGLi5yGurcfGjCaCzgwEC84tzKEFmaRZYNM1vSeJDufnvbG8MBbVgbI4
        kNYjnOKHDkS+HWdGj5K3nOyZv1jbC5CZEgrGHVXq4eVVv1jMpZab81bkUhN3oFzP
        kKUE5NnTbHU9I99VMWhcR0zxyTDG9XIV+6103VH2plwvkChGDTQ8sVJ6xIjVZLKO
        IgV3pQ5ZCPBlkUc4KBkp12j0TTQW279y7yGBfHKJKXRX+YcAD6MjDYGdn+SHoBwu
        O2tV+EOULKx923BfYyO5qrbJH3elztNCzSgsBog3zN3Yix8Vx3cKHrq8P/6aSSdQ
        ==
X-ME-Sender: <xms:HvYAXs3izUyGdhL_IK7EYIlmlFCdXJNxzFNRGWH6INk6TNLCt31Wjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeduleekrdekledrieegrddvgeelnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeek
X-ME-Proxy: <xmx:HvYAXkQWop7ZdLt7po9SYCqBkfzORUnHwsNs-eXGJkOJA6T6XwX6bQ>
    <xmx:HvYAXpYLbKEq-OZaZBWTyFv0p44h_o79SdIqfCt3hnkMDJZPhmKynQ>
    <xmx:HvYAXiC6eqXnqOQC-SBOHQkezIkdM6xba5KVzxkm8Br9VH8SS_Xm3A>
    <xmx:HvYAXso3csq09Nz3b-Rk0ilRqD5S7y92Wuga9LQ-e7ExJTCW7vGwFw>
Received: from localhost (unknown [198.89.64.249])
        by mail.messagingengine.com (Postfix) with ESMTPA id 10A723060802;
        Mon, 23 Dec 2019 12:15:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: abort transaction after failed inode updates in" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com,
        jthumshirn@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Dec 2019 12:14:59 -0500
Message-ID: <1577121299231108@kroah.com>
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

