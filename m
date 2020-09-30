Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CE627E81F
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 14:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgI3MB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 08:01:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:39872 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3MB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Sep 2020 08:01:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601467315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jozmM+hNEH8oWzuTZ05D0Fsx8dNN4/wjJwbxkYov7Ns=;
        b=J/uwSEAHSLHia6XW6kLSBUo2q84icMjkn+r1/xxxas8zjiVDbNrRo45/3C7MuCMdF1nEV4
        pmH++Gk6gzVXv3RiEuHZxqexE4unwsGil7WrqKbdYqKiSxRORLECC89CUihmM/EagF1sf0
        K8GgpTtqc9B9gaMwsat7E4i4qNOPcZU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4D65AAD39;
        Wed, 30 Sep 2020 12:01:55 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: workaround the over-confident over-commit available space calculation
Date:   Wed, 30 Sep 2020 20:01:51 +0800
Message-Id: <20200930120151.121203-1-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[BUG]
There are quite some bug reports of btrfs falling into a ENOSPC trap,
where btrfs can't even start a transaction to add new devices.

[CAUSE]
Most of the reports are utilize multi-device profiles, like
RAID1/RAID10/RAID5/RAID6, and the involved disks have very unbalanced
sizes.

It turns out that, the overcommit calculation in btrfs_can_overcommit()
is just a factor based calculation, which can't check if devices can
really fulfill the requirement for the desired profile.

This makes btrfs_can_overcommit() to be always over-confident about
usable space, and when we can't allocate any new metadata chunk but
still allow new metadata operations, we fall into the ENOSPC trap and
have no way to exit it.

[WORKAROUND]
The root fix needs a device layout aware, chunk allocator like available
space calculation.

There used to be such patchset submitted to the mail list, but the extra
failure mode is tricky to handle for chunk allocation, thus that
patchset needs more time to mature.

Meanwhile to prevent such problems reaching more users, workaround the
problem by:
- Half the over-commit available space reported
  So that we won't always be that over-confident.
  But this won't really help if we have extremely unbalanced disk size.

- Don't over-commit if the space info is already full
  This may already be too late, but still better than doing nothing and
  believe the over-commit values.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/space-info.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 475968ccbd1d..e8133ec7e34a 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -339,6 +339,18 @@ static u64 calc_available_free_space(struct btrfs_fs_info *fs_info,
 		avail >>= 3;
 	else
 		avail >>= 1;
+	/*
+	 * Since current over-commit calculation is doomed already for
+	 * RAID0/RADI1/RAID10/RAID5/6, we half the availabe space to reduce
+	 * over-commit amount.
+	 *
+	 * This is just a workaround before the device layout aware
+	 * available space calculation arrives.
+	 */
+	if ((BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1_MASK |
+	     BTRFS_BLOCK_GROUP_RAID10 | BTRFS_BLOCK_GROUP_RAID56_MASK) &
+	     profile)
+		avail >>= 1;
 	return avail;
 }
 
@@ -353,6 +365,14 @@ int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
 	if (space_info->flags & BTRFS_BLOCK_GROUP_DATA)
 		return 0;
 
+	/*
+	 * If we can't allocate new space already, no overcommit is allowed.
+	 *
+	 * This check may be already late, but still better than nothing.
+	 */
+	if (space_info->full)
+		return 0;
+
 	used = btrfs_space_info_used(space_info, true);
 	avail = calc_available_free_space(fs_info, space_info, flush);
 
-- 
2.28.0

