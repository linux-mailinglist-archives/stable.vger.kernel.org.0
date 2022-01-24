Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE812499AE4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379085AbiAXVrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:47:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49116 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456018AbiAXVhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26CC5B811A2;
        Mon, 24 Jan 2022 21:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B66BC340E4;
        Mon, 24 Jan 2022 21:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060249;
        bh=H9Cd36ES4vBtIfhbCdjJQJgnY58I/rp/a5KBhpw7fX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8FznQkJ2iND11cPa+TxKhVA4iIJydGXqLOIY64NAgOXh5hm5fCLE4Y/V2dmOPyAJ
         RIrzIQSyuKmuSnq6O80n+WnXwEWsKtEMvh8sL+o93iY/1QjUi2P+7+HuDptovWp8P2
         XyhARHiDOyHbU5iQZ6opBAPtLgIiXMZv+TbGUGL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 0887/1039] btrfs: zoned: fix chunk allocation condition for zoned allocator
Date:   Mon, 24 Jan 2022 19:44:36 +0100
Message-Id: <20220124184155.103243395@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 82187d2ecdfb22ab7ee05f388402a39236d31428 upstream.

The ZNS specification defines a limit on the number of "active"
zones. That limit impose us to limit the number of block groups which
can be used for an allocation at the same time. Not to exceed the
limit, we reuse the existing active block groups as much as possible
when we can't activate any other zones without sacrificing an already
activated block group in commit a85f05e59bc1 ("btrfs: zoned: avoid
chunk allocation if active block group has enough space").

However, the check is wrong in two ways. First, it checks the
condition for every raid index (ffe_ctl->index). Even if it reaches
the condition and "ffe_ctl->max_extent_size >=
ffe_ctl->min_alloc_size" is met, there can be other block groups
having enough space to hold ffe_ctl->num_bytes. (Actually, this won't
happen in the current zoned code as it only supports SINGLE
profile. But, it can happen once it enables other RAID types.)

Second, it checks the active zone availability depending on the
raid index. The raid index is just an index for
space_info->block_groups, so it has nothing to do with chunk allocation.

These mistakes are causing a faulty allocation in a certain
situation. Consider we are running zoned btrfs on a device whose
max_active_zone == 0 (no limit). And, suppose no block group have a
room to fit ffe_ctl->num_bytes but some room to meet
ffe_ctl->min_alloc_size (i.e. max_extent_size > num_bytes >=
min_alloc_size).

In this situation, the following occur:

- With SINGLE raid_index, it reaches the chunk allocation checking
  code
- The check returns true because we can activate a new zone (no limit)
- But, before allocating the chunk, it iterates to the next raid index
  (RAID5)
- Since there are no RAID5 block groups on zoned mode, it again
  reaches the check code
- The check returns false because of btrfs_can_activate_zone()'s "if
  (raid_index != BTRFS_RAID_SINGLE)" part
- That results in returning -ENOSPC without allocating a new chunk

As a result, we end up hitting -ENOSPC too early.

Move the check to the right place in the can_allocate_chunk() hook,
and do the active zone check depending on the allocation flag, not on
the raid index.

CC: stable@vger.kernel.org # 5.16
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |   21 +++++++++------------
 fs/btrfs/zoned.c       |    5 ++---
 fs/btrfs/zoned.h       |    5 ++---
 3 files changed, 13 insertions(+), 18 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3966,6 +3966,15 @@ static bool can_allocate_chunk(struct bt
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		return true;
 	case BTRFS_EXTENT_ALLOC_ZONED:
+		/*
+		 * If we have enough free space left in an already
+		 * active block group and we can't activate any other
+		 * zone now, do not allow allocating a new chunk and
+		 * let find_free_extent() retry with a smaller size.
+		 */
+		if (ffe_ctl->max_extent_size >= ffe_ctl->min_alloc_size &&
+		    !btrfs_can_activate_zone(fs_info->fs_devices, ffe_ctl->flags))
+			return false;
 		return true;
 	default:
 		BUG();
@@ -4012,18 +4021,6 @@ static int find_free_extent_update_loop(
 		return 0;
 	}
 
-	if (ffe_ctl->max_extent_size >= ffe_ctl->min_alloc_size &&
-	    !btrfs_can_activate_zone(fs_info->fs_devices, ffe_ctl->index)) {
-		/*
-		 * If we have enough free space left in an already active block
-		 * group and we can't activate any other zone now, retry the
-		 * active ones with a smaller allocation size.  Returning early
-		 * from here will tell btrfs_reserve_extent() to haven the
-		 * size.
-		 */
-		return -ENOSPC;
-	}
-
 	if (ffe_ctl->loop >= LOOP_CACHING_WAIT && ffe_ctl->have_caching_bg)
 		return 1;
 
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1934,7 +1934,7 @@ int btrfs_zone_finish(struct btrfs_block
 	return ret;
 }
 
-bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, int raid_index)
+bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 {
 	struct btrfs_device *device;
 	bool ret = false;
@@ -1943,8 +1943,7 @@ bool btrfs_can_activate_zone(struct btrf
 		return true;
 
 	/* Non-single profiles are not supported yet */
-	if (raid_index != BTRFS_RAID_SINGLE)
-		return false;
+	ASSERT((flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0);
 
 	/* Check if there is a device with active zones left */
 	mutex_lock(&fs_devices->device_list_mutex);
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -72,8 +72,7 @@ struct btrfs_device *btrfs_zoned_get_dev
 					    u64 logical, u64 length);
 bool btrfs_zone_activate(struct btrfs_block_group *block_group);
 int btrfs_zone_finish(struct btrfs_block_group *block_group);
-bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices,
-			     int raid_index);
+bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags);
 void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical,
 			     u64 length);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
@@ -225,7 +224,7 @@ static inline int btrfs_zone_finish(stru
 }
 
 static inline bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices,
-					   int raid_index)
+					   u64 flags)
 {
 	return true;
 }


