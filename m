Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BBD38EFA4
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhEXP6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234527AbhEXP5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 686486138C;
        Mon, 24 May 2021 15:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871024;
        bh=D131zHAiby8X8SHnX+LhTQ0lsA8n00mVrFDGhRW5LDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBa+YopGQ55wB9jp2dx/Tv8NXhYxwB3NqMlMIbkoWFOrAcjnOb+Pb8iYxTNGkeANK
         0Sy/xR3ONQmzxW8MULO4GQRBi7PrOJlD+doFOV2mEpilJEHZOjYfgpEYEY/OPcJr6Z
         DnsF+LIDuvhKCSeodUketvrbMnci9EhkglDmx4zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 037/127] btrfs: zoned: pass start block to btrfs_use_zone_append
Date:   Mon, 24 May 2021 17:25:54 +0200
Message-Id: <20210524152336.106395864@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit e380adfc213a13677993c0e35cb48f5a8e61ebb0 upstream.

btrfs_use_zone_append only needs the passed in extent_map's block_start
member, so there's no need to pass in the full extent map.

This also enables the use of btrfs_use_zone_append in places where we only
have a start byte but no extent_map.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    2 +-
 fs/btrfs/inode.c     |    2 +-
 fs/btrfs/zoned.c     |    4 ++--
 fs/btrfs/zoned.h     |    5 ++---
 4 files changed, 6 insertions(+), 7 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3762,7 +3762,7 @@ static noinline_for_stack int __extent_w
 		/* Note that em_end from extent_map_end() is exclusive */
 		iosize = min(em_end, end + 1) - cur;
 
-		if (btrfs_use_zone_append(inode, em))
+		if (btrfs_use_zone_append(inode, em->block_start))
 			opf = REQ_OP_ZONE_APPEND;
 
 		free_extent_map(em);
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7782,7 +7782,7 @@ static int btrfs_dio_iomap_begin(struct
 	iomap->bdev = fs_info->fs_devices->latest_bdev;
 	iomap->length = len;
 
-	if (write && btrfs_use_zone_append(BTRFS_I(inode), em))
+	if (write && btrfs_use_zone_append(BTRFS_I(inode), em->block_start))
 		iomap->flags |= IOMAP_F_ZONE_APPEND;
 
 	free_extent_map(em);
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1278,7 +1278,7 @@ void btrfs_free_redirty_list(struct btrf
 	spin_unlock(&trans->releasing_ebs_lock);
 }
 
-bool btrfs_use_zone_append(struct btrfs_inode *inode, struct extent_map *em)
+bool btrfs_use_zone_append(struct btrfs_inode *inode, u64 start)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_block_group *cache;
@@ -1293,7 +1293,7 @@ bool btrfs_use_zone_append(struct btrfs_
 	if (!is_data_inode(&inode->vfs_inode))
 		return false;
 
-	cache = btrfs_lookup_block_group(fs_info, em->block_start);
+	cache = btrfs_lookup_block_group(fs_info, start);
 	ASSERT(cache);
 	if (!cache)
 		return false;
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -47,7 +47,7 @@ void btrfs_calc_zone_unusable(struct btr
 void btrfs_redirty_list_add(struct btrfs_transaction *trans,
 			    struct extent_buffer *eb);
 void btrfs_free_redirty_list(struct btrfs_transaction *trans);
-bool btrfs_use_zone_append(struct btrfs_inode *inode, struct extent_map *em);
+bool btrfs_use_zone_append(struct btrfs_inode *inode, u64 start);
 void btrfs_record_physical_zoned(struct inode *inode, u64 file_offset,
 				 struct bio *bio);
 void btrfs_rewrite_logical_zoned(struct btrfs_ordered_extent *ordered);
@@ -146,8 +146,7 @@ static inline void btrfs_redirty_list_ad
 					  struct extent_buffer *eb) { }
 static inline void btrfs_free_redirty_list(struct btrfs_transaction *trans) { }
 
-static inline bool btrfs_use_zone_append(struct btrfs_inode *inode,
-					 struct extent_map *em)
+static inline bool btrfs_use_zone_append(struct btrfs_inode *inode, u64 start)
 {
 	return false;
 }


