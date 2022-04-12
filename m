Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDCA4FDA9F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377537AbiDLHuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359388AbiDLHnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A042CC9C;
        Tue, 12 Apr 2022 00:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 331E5B81B58;
        Tue, 12 Apr 2022 07:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C85FC385A1;
        Tue, 12 Apr 2022 07:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748121;
        bh=PkpEYYaFN+mCmc24zaHnpXLxoDbtM4+leHpEARJnT48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnohntWgJjGw6GQWdMXRUXj6mdMz840X2pqv+HtRWNbkmM6GlQ83SqDT4ZYKgfJ+Q
         wTfrGnms2/zACNZZpFYyyk249pl92OCm+V2kPau/NJNmlM34nrOJXkjfv4nmdY5wEw
         icxBw37e8m/IP8teemGtub6zNWykJbDq4w6lj4Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robbie Ko <robbieko@synology.com>,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Kaiwen Hu <kevinhu@synology.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 287/343] btrfs: prevent subvol with swapfile from being deleted
Date:   Tue, 12 Apr 2022 08:31:45 +0200
Message-Id: <20220412062959.611109442@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
@@ -4466,6 +4466,13 @@ int btrfs_delete_subvolume(struct inode
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
@@ -10424,8 +10431,23 @@ static int btrfs_swap_activate(struct sw
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
 


