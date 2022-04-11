Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700D74FB55F
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237440AbiDKHzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiDKHzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:55:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1110427CDA
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 00:53:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A20F16144C
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 07:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A721CC385AC;
        Mon, 11 Apr 2022 07:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649663581;
        bh=7Tx0DCW3sqpiJ/Si664a/b40uXqCffiC6r+ybF2Dk/M=;
        h=Subject:To:Cc:From:Date:From;
        b=ZQJjbXoSx0TEOgM0ELOG2WdMps8Sf1M4wZX/Y21uuHtp5ivSLSyuFeKY0TwiYOjZB
         HYMETR8DGEJkVu8U4CP0yd8mIzwJEqUmur+cMHc3aUqvuva6TFsges/U4askBpZDVY
         5vL0ElODqoy9h6srHjxiFppYq1LG87+/kE1Y71XQ=
Subject: FAILED: patch "[PATCH] btrfs: prevent subvol with swapfile from being deleted" failed to apply to 5.4-stable tree
To:     kevinhu@synology.com, dsterba@suse.com, fdmanana@suse.com,
        robbieko@synology.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 09:52:58 +0200
Message-ID: <164966357846155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 60021bd754c6ca0addc6817994f20290a321d8d6 Mon Sep 17 00:00:00 2001
From: Kaiwen Hu <kevinhu@synology.com>
Date: Wed, 23 Mar 2022 15:10:32 +0800
Subject: [PATCH] btrfs: prevent subvol with swapfile from being deleted

A subvolume with an active swapfile must not be deleted otherwise it
would not be possible to deactivate it.

After the subvolume is deleted, we cannot swapoff the swapfile in this
deleted subvolume because the path is unreachable.  The swapfile is
still active and holding references, the filesystem cannot be unmounted.

The test looks like this:

  mkfs.btrfs -f $dev > /dev/null
  mount $dev $mnt

  btrfs sub create $mnt/subvol
  touch $mnt/subvol/swapfile
  chmod 600 $mnt/subvol/swapfile
  chattr +C $mnt/subvol/swapfile
  dd if=/dev/zero of=$mnt/subvol/swapfile bs=1K count=4096
  mkswap $mnt/subvol/swapfile
  swapon $mnt/subvol/swapfile

  btrfs sub delete $mnt/subvol
  swapoff $mnt/subvol/swapfile  # failed: No such file or directory
  swapoff --all

  unmount $mnt                  # target is busy.

To prevent above issue, we simply check that whether the subvolume
contains any active swapfile, and stop the deleting process.  This
behavior is like snapshot ioctl dealing with a swapfile.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Robbie Ko <robbieko@synology.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Kaiwen Hu <kevinhu@synology.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b976f757571f..5aab6af88349 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4487,6 +4487,13 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 			   dest->root_key.objectid);
 		return -EPERM;
 	}
+	if (atomic_read(&dest->nr_swapfiles)) {
+		spin_unlock(&dest->root_item_lock);
+		btrfs_warn(fs_info,
+			   "attempt to delete subvolume %llu with active swapfile",
+			   root->root_key.objectid);
+		return -EPERM;
+	}
 	root_flags = btrfs_root_flags(&dest->root_item);
 	btrfs_set_root_flags(&dest->root_item,
 			     root_flags | BTRFS_ROOT_SUBVOL_DEAD);
@@ -11110,8 +11117,23 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	 * set. We use this counter to prevent snapshots. We must increment it
 	 * before walking the extents because we don't want a concurrent
 	 * snapshot to run after we've already checked the extents.
+	 *
+	 * It is possible that subvolume is marked for deletion but still not
+	 * removed yet. To prevent this race, we check the root status before
+	 * activating the swapfile.
 	 */
+	spin_lock(&root->root_item_lock);
+	if (btrfs_root_dead(root)) {
+		spin_unlock(&root->root_item_lock);
+
+		btrfs_exclop_finish(fs_info);
+		btrfs_warn(fs_info,
+		"cannot activate swapfile because subvolume %llu is being deleted",
+			root->root_key.objectid);
+		return -EPERM;
+	}
 	atomic_inc(&root->nr_swapfiles);
+	spin_unlock(&root->root_item_lock);
 
 	isize = ALIGN_DOWN(inode->i_size, fs_info->sectorsize);
 

