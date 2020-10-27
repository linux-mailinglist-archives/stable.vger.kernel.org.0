Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DD929B937
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802261AbgJ0PqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760006AbgJ0P1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:27:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42085206E9;
        Tue, 27 Oct 2020 15:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812443;
        bh=f0y/VXUJXSi2GOwd61eMCeOh94Gf7KBLyXas/cRr5jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aR40sJ9yn6MiL4XVu4GHZHXWaaEzlEt2O5E+43iGMtV5SJBp9pzSdzoyVnOgwuNep
         Zd4Dlx4hiSjdi0VemdBpiRbJuwL8dakXogxrY1QDyZP9/f8EKkj+3uo8ZL5Ja4fw4N
         Av1YAkN9a7uQgU5sYONzAZYb6TlQDwvR4NbVOK1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 181/757] btrfs: add owner and fs_info to alloc_state io_tree
Date:   Tue, 27 Oct 2020 14:47:11 +0100
Message-Id: <20201027135459.083139734@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 219a09a2b7340..250b8cbaaf97a 100644
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
index 1997a7d67f22f..e61c298ce2b42 100644
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
@@ -6529,7 +6530,7 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 	if (WARN_ON(!devid && !fs_info))
 		return ERR_PTR(-EINVAL);
 
-	dev = __alloc_device();
+	dev = __alloc_device(fs_info);
 	if (IS_ERR(dev))
 		return dev;
 
-- 
2.25.1



