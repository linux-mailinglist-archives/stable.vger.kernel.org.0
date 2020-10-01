Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6520C27F93E
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 07:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbgJAF61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 01:58:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:40478 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgJAF61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 01:58:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601531905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CE0QbbqCiaFjmC03hr/KHSUo6dSgKvB0XDN8BwggmHI=;
        b=o9CH+hmhB1+7qXthR/SnnGdlEAUcoocv/wj7r2Pk9ppqa4tK0d7Bgz3aKQoA48gqX2EXfA
        f0r9YL5iWcoBe74tUvvO4Bs03LwdOdRrAqg49cBhSI5gTKpfOaWggVUIdyUdCNVqjrP1Gd
        TVf1+qZjHT7UIhAf1juYE26rrFnHVds=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 79304B328;
        Thu,  1 Oct 2020 05:58:25 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org, Marc Lehmann <schmorp@schmorp.de>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 9 11/12] btrfs: space-info: Use per-profile available space in can_overcommit()
Date:   Thu,  1 Oct 2020 13:57:43 +0800
Message-Id: <20201001055744.103261-12-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001055744.103261-1-wqu@suse.com>
References: <20201001055744.103261-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For the following disk layout, can_overcommit() can cause false
confidence in available space:

  devid 1 unallocated:	1T
  devid 2 unallocated:	10T
  metadata type:	RAID1

As can_overcommit() simply uses unallocated space with factor to
calculate the allocatable metadata chunk size.

can_overcommit() believes we still have 5.5T for metadata chunks, while
the truth is, we only have 1T available for metadata chunks.
This can lead to ENOSPC at run_delalloc_range() and cause transaction
abort.

Since factor based calculation can't distinguish RAID1/RAID10 and DUP at
all, we need proper chunk-allocator level awareness to do such estimation.

Thankfully, we have per-profile available space already calculated, just
use that facility to avoid such false confidence.

CC: stable@vger.kernel.org # 5.4+
Reported-by: Marc Lehmann <schmorp@schmorp.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/space-info.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 64b6e1d44f47..4bb4e3c3531f 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -336,25 +336,21 @@ static u64 calc_available_free_space(struct btrfs_fs_info *fs_info,
 			  struct btrfs_space_info *space_info,
 			  enum btrfs_reserve_flush_enum flush)
 {
+	enum btrfs_raid_types index;
 	u64 profile;
 	u64 avail;
-	int factor;
 
 	if (space_info->flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		profile = btrfs_system_alloc_profile(fs_info);
 	else
 		profile = btrfs_metadata_alloc_profile(fs_info);
 
-	avail = atomic64_read(&fs_info->free_chunk_space);
-
 	/*
-	 * If we have dup, raid1 or raid10 then only half of the free
-	 * space is actually usable.  For raid56, the space info used
-	 * doesn't include the parity drive, so we don't have to
-	 * change the math
+	 * Grab avail space from per-profile array which should be as accurate
+	 * as chunk allocator.
 	 */
-	factor = btrfs_bg_type_to_factor(profile);
-	avail = div_u64(avail, factor);
+	index = btrfs_bg_flags_to_raid_index(profile);
+	avail = atomic64_read(&fs_info->fs_devices->per_profile_avail[index]);
 
 	/*
 	 * If we aren't flushing all things, let us overcommit up to
-- 
2.28.0

