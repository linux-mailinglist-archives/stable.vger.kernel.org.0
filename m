Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47678129932
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfLWRPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:15:14 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50695 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfLWRPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:15:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7DDC221EE9;
        Mon, 23 Dec 2019 12:15:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 23 Dec 2019 12:15:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5NcbxD
        F5jxF2Uf1Uz766zKiaOuK8opkNWeqWs5mHg2E=; b=xkLb+Z383ICG6xFS+bBVSU
        26NMMlfLX7qyooqp+jvLZ8J9vpNSHCcFohLm2tXHdEPoGArrKFxpQN8jTp2vSH50
        Frn3bnRfC+K7n7TMhiLyY+XIXG0o2wXpJRYIwc4lVevoaelk1WrsbBkIoiaAlJ9g
        VVbPp6c8Us80iL5el+gT/ipUP+pruQAefgGb6Zq7x4/Wm/QuhKjB7p6UV5Hvwl8P
        hO/95lol8sOhrLnRgmhAamEFtdnkdSAxOuBPnmUj5OLsi5ov+QBvh6ucsc7YkUle
        7APvRLXmF8MEAU2Os53lXopzCPhlcGHIlC1CZvvNUqizG1UVpy9aBbcgwljry2Gg
        ==
X-ME-Sender: <xms:IfYAXjqRlSbNRjqP0VGv4AaIqkX_FkqAoPrpOPRBlvsTh61jcagIvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeduleekrdekledrieegrddvgeelnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeel
X-ME-Proxy: <xmx:IfYAXjCdKe7e7TbIKUqVffRqLdS25K7pl3wcmh8FcSXszZxJnR-Atg>
    <xmx:IfYAXj2Ihsz0Qq2QqJnaMLSDGgEknCGDXr6s8tXQZG74BwGwY-ikmw>
    <xmx:IfYAXmxJy7pbJwh_A-WUgmVsHVdautbQI1qDekRZAmEESpK0pE0BRA>
    <xmx:IfYAXncDtJZHWDZy_NBYeM3f5gowJTtEDTzDobHdvBtyb7Qn_fKwAg>
Received: from localhost (unknown [198.89.64.249])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C3C380059;
        Mon, 23 Dec 2019 12:15:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: abort transaction after failed inode updates in" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com,
        jthumshirn@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Dec 2019 12:15:00 -0500
Message-ID: <1577121300137140@kroah.com>
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

