Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F7629C13F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810982AbgJ0RXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780308AbgJ0Oyf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:54:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79FDC2071A;
        Tue, 27 Oct 2020 14:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810474;
        bh=C1bg0cciOruxIJ/Eufm0mlvebXwinxYTfSht2LQbe8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2yV8YdPRtt+Q+ihuqfM5ttBNomujLqu5QcjI/m+B8W7V34zhFKnWUl79HCkm5NcK
         fXCEm4FDL7PrmZdgxp8Ca7YrOeFq5gGXKVBeVeJ4BHgIdcz6zcLO/JuGPGMlh2gH76
         Z5CVx/jsP2bj4sgTYNv6bb9MkTFUgO/r+CPPfiaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 152/633] btrfs: add owner and fs_info to alloc_state io_tree
Date:   Tue, 27 Oct 2020 14:48:15 +0100
Message-Id: <20201027135529.827667815@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 154f7cb86809a3a796bffbc7a5a7ce0dee585eaa ]

Commit 1c11b63eff2a ("btrfs: replace pending/pinned chunks lists with io
tree") introduced btrfs_device::alloc_state extent io tree, but it
doesn't initialize the fs_info and owner member.

This means the following features are not properly supported:

- Fs owner report for insert_state() error
  Without fs_info initialized, although btrfs_err() won't panic, it
  won't output which fs is causing the error.

- Wrong owner for trace events
  alloc_state will get the owner as pinned extents.

Fix this by assiging proper fs_info and owner for
btrfs_device::alloc_state.

Fixes: 1c11b63eff2a ("btrfs: replace pending/pinned chunks lists with io tree")
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-io-tree.h | 1 +
 fs/btrfs/volumes.c        | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.h b/fs/btrfs/extent-io-tree.h
index 8bbb734f3f514..49384d55a908f 100644
--- a/fs/btrfs/extent-io-tree.h
+++ b/fs/btrfs/extent-io-tree.h
@@ -48,6 +48,7 @@ enum {
 	IO_TREE_INODE_FILE_EXTENT,
 	IO_TREE_LOG_CSUM_RANGE,
 	IO_TREE_SELFTEST,
+	IO_TREE_DEVICE_ALLOC_STATE,
 };
 
 struct extent_io_tree {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 79e9a80bd37a0..f9d8bd3099488 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -406,7 +406,7 @@ void __exit btrfs_cleanup_fs_uuids(void)
  * Returned struct is not linked onto any lists and must be destroyed using
  * btrfs_free_device.
  */
-static struct btrfs_device *__alloc_device(void)
+static struct btrfs_device *__alloc_device(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_device *dev;
 
@@ -433,7 +433,8 @@ static struct btrfs_device *__alloc_device(void)
 	btrfs_device_data_ordered_init(dev);
 	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
-	extent_io_tree_init(NULL, &dev->alloc_state, 0, NULL);
+	extent_io_tree_init(fs_info, &dev->alloc_state,
+			    IO_TREE_DEVICE_ALLOC_STATE, NULL);
 
 	return dev;
 }
@@ -6545,7 +6546,7 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 	if (WARN_ON(!devid && !fs_info))
 		return ERR_PTR(-EINVAL);
 
-	dev = __alloc_device();
+	dev = __alloc_device(fs_info);
 	if (IS_ERR(dev))
 		return dev;
 
-- 
2.25.1



