Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CF84FDA88
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353174AbiDLHhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353806AbiDLHZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C0F9FD8;
        Tue, 12 Apr 2022 00:04:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1766C60B65;
        Tue, 12 Apr 2022 07:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209CEC385A1;
        Tue, 12 Apr 2022 07:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747080;
        bh=3URoS/TUJZ3MsAy6YxJ1sR6pRPkgsVOwX30cNz/8tWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xe8Z/L13oCYhAToa/YttnnlDsRG8ATbUnKdmgLv5Evrr92DZnbN2uXDwiN/3q3JAs
         cNl6Wn0ybSYMLp1LhpId1WYn8OWyhZbBs2famfp4nHZQlgO/3c79WICUg5kgWsAKP5
         6jvdGOVOzjYjqoiAWU38MwYYPh+njb0/sx78MBtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robbie Ko <robbieko@synology.com>,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Kaiwen Hu <kevinhu@synology.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 235/285] btrfs: prevent subvol with swapfile from being deleted
Date:   Tue, 12 Apr 2022 08:31:32 +0200
Message-Id: <20220412062950.444603043@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Kaiwen Hu <kevinhu@synology.com>

commit 60021bd754c6ca0addc6817994f20290a321d8d6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4462,6 +4462,13 @@ int btrfs_delete_subvolume(struct inode
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
@@ -10764,8 +10771,23 @@ static int btrfs_swap_activate(struct sw
 	 * set. We use this counter to prevent snapshots. We must increment it
 	 * before walking the extents because we don't want a concurrent
 	 * snapshot to run after we've already checked the extents.
-	 */
+	 *
+	 * It is possible that subvolume is marked for deletion but still not
+	 * removed yet. To prevent this race, we check the root status before
+	 * activating the swapfile.
+	 */
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
 


