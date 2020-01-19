Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77F91141ED0
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 16:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgASPTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 10:19:48 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:57245 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASPTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 10:19:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 5BAA0496;
        Sun, 19 Jan 2020 10:19:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 10:19:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zBjdz3
        scs4yZS47iZhYHH1K8a8QowDYPWSyEsJ8wURE=; b=vs24F0nbLqLUmoAnGg8JHo
        piJBSkds0yrjF+cfbiWxRLOd4LdyXwSPhvHtKH42GJLUXyl1zIrg/STR4Y+MHkCd
        1xpIKn15IwZcO/uTnKkEDZSAKnOwgev1ItSQeICEEwEq1ufLrCrBqqY6ywhdu/hr
        EOYZ9BpwoHl9Ovw/nSEWL7qwJC/9dlPUGRHeMR8t50S/89+VbFqUfkGaO2N0rCRv
        xBOQVhRWGXpccn1U+buJIE1xv8lI2bSFV6Y8A/1Z37voLOJFNueEtdoffwmnXvjT
        SSDBZPVo//GsYwhq92EP4zk1qd9O/7T7augZ0tr8lIsiwL/afvLHV4gdvkae1Phw
        ==
X-ME-Sender: <xms:knMkXo9b9jJdnkpTocYg5VqDJCOqU9hl28JzfUWxqeqqfJ-GvapYrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:knMkXoXR1eZEO3iBEivEMLjWs4suHm11jQ2-OM0pth_MG1Yd8wmt8Q>
    <xmx:knMkXrquTG6AP441tqZL7N8FO2rQGEh17bYwy_KFYoikYbc8KCeRIw>
    <xmx:knMkXik_ps7kYDqcG_TdRrlH2cKvIl7rg9nGTMkbCzmFhvopQsJoWw>
    <xmx:k3MkXuN4ZJvg-WtDy_1Hj4yXk20hZnULe9ob5RyxrDni79mg2cM3dQ>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 718573060ACE;
        Sun, 19 Jan 2020 10:19:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix invalid removal of root ref" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 16:19:44 +0100
Message-ID: <157944718475168@kroah.com>
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

From d49d3287e74ffe55ae7430d1e795e5f9bf7359ea Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Dec 2019 17:20:28 -0500
Subject: [PATCH] btrfs: fix invalid removal of root ref

If we have the following sequence of events

  btrfs sub create A
  btrfs sub create A/B
  btrfs sub snap A C
  mkdir C/foo
  mv A/B C/foo
  rm -rf *

We will end up with a transaction abort.

The reason for this is because we create a root ref for B pointing to A.
When we create a snapshot of C we still have B in our tree, but because
the root ref points to A and not C we will make it appear to be empty.

The problem happens when we move B into C.  This removes the root ref
for B pointing to A and adds a ref of B pointing to C.  When we rmdir C
we'll see that we have a ref to our root and remove the root ref,
despite not actually matching our reference name.

Now btrfs_del_root_ref() allowing this to work is a bug as well, however
we know that this inode does not actually point to a root ref in the
first place, so we shouldn't be calling btrfs_del_root_ref() in the
first place and instead simply look up our dir index for this item and
do the rest of the removal.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 99631030d13c..c70baafb2a39 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4283,13 +4283,16 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	ret = btrfs_del_root_ref(trans, objectid, root->root_key.objectid,
-				 dir_ino, &index, name, name_len);
-	if (ret < 0) {
-		if (ret != -ENOENT) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+	/*
+	 * This is a placeholder inode for a subvolume we didn't have a
+	 * reference to at the time of the snapshot creation.  In the meantime
+	 * we could have renamed the real subvol link into our snapshot, so
+	 * depending on btrfs_del_root_ref to return -ENOENT here is incorret.
+	 * Instead simply lookup the dir_index_item for this entry so we can
+	 * remove it.  Otherwise we know we have a ref to the root and we can
+	 * call btrfs_del_root_ref, and it _shouldn't_ fail.
+	 */
+	if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
 		di = btrfs_search_dir_index_item(root, path, dir_ino,
 						 name, name_len);
 		if (IS_ERR_OR_NULL(di)) {
@@ -4304,8 +4307,16 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 		index = key.offset;
+		btrfs_release_path(path);
+	} else {
+		ret = btrfs_del_root_ref(trans, objectid,
+					 root->root_key.objectid, dir_ino,
+					 &index, name, name_len);
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			goto out;
+		}
 	}
-	btrfs_release_path(path);
 
 	ret = btrfs_delete_delayed_dir_index(trans, BTRFS_I(dir), index);
 	if (ret) {

