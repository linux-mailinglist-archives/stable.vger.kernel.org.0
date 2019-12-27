Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 916CE12B840
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfL0Rye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:54:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbfL0Rmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF3D32173E;
        Fri, 27 Dec 2019 17:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468570;
        bh=mm4956ygG+jablg48bigObr7P6aCT2lVITov/2olgyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+1sFqnT+Iu8XXP7PuyNOkTG6nLe/LnoNWHIlWnw9Awu0o8JEyEPbevv20fSgOhO6
         5+lW2G1G/KHHJYyFbVsxfq271y/Ud+Tpmio0U43ygCe1gVPCXrU+BFe2uAwhT0YqVh
         xRWUY/QZRoGX9Wx1vhH3BDt5k0lxu/D5AzOVE/M8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 095/187] Btrfs: fix cloning range with a hole when using the NO_HOLES feature
Date:   Fri, 27 Dec 2019 12:39:23 -0500
Message-Id: <20191227174055.4923-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit fcb970581dd900675c4371c2b688a57924a8368c ]

When using the NO_HOLES feature if we clone a range that contains a hole
and a temporary ENOSPC happens while dropping extents from the target
inode's range, we can end up failing and aborting the transaction with
-EEXIST or with a corrupt file extent item, that has a length greater
than it should and overlaps with other extents. For example when cloning
the following range from inode A to inode B:

  Inode A:

    extent A1                                          extent A2
  [ ----------- ]  [ hole, implicit, 4MB length ]  [ ------------- ]
  0            1MB                                 5MB            6MB

  Range to clone: [1MB, 6MB)

  Inode B:

    extent B1       extent B2        extent B3         extent B4
  [ ---------- ]  [ --------- ]    [ ---------- ]    [ ---------- ]
  0           1MB 1MB        2MB   2MB        5MB    5MB         6MB

  Target range: [1MB, 6MB) (same as source, to make it easier to explain)

The following can happen:

1) btrfs_punch_hole_range() gets -ENOSPC from __btrfs_drop_extents();

2) At that point, 'cur_offset' is set to 1MB and __btrfs_drop_extents()
   set 'drop_end' to 2MB, meaning it was able to drop only extent B2;

3) We then compute 'clone_len' as 'drop_end' - 'cur_offset' = 2MB - 1MB =
   1MB;

4) We then attempt to insert a file extent item at inode B with a file
   offset of 5MB, which is the value of clone_info->file_offset. This
   fails with error -EEXIST because there's already an extent at that
   offset (extent B4);

5) We abort the current transaction with -EEXIST and return that error
   to user space as well.

Another example, for extent corruption:

  Inode A:

    extent A1                                           extent A2
  [ ----------- ]   [ hole, implicit, 10MB length ]  [ ------------- ]
  0            1MB                                  11MB            12MB

  Inode B:

    extent B1         extent B2
  [ ----------- ]   [ --------- ]    [ ----------------------------- ]
  0            1MB 1MB         5MB  5MB                             12MB

  Target range: [1MB, 12MB) (same as source, to make it easier to explain)

1) btrfs_punch_hole_range() gets -ENOSPC from __btrfs_drop_extents();

2) At that point, 'cur_offset' is set to 1MB and __btrfs_drop_extents()
   set 'drop_end' to 5MB, meaning it was able to drop only extent B2;

3) We then compute 'clone_len' as 'drop_end' - 'cur_offset' = 5MB - 1MB =
   4MB;

4) We then insert a file extent item at inode B with a file offset of 11MB
   which is the value of clone_info->file_offset, and a length of 4MB (the
   value of 'clone_len'). So we get 2 extents items with ranges that
   overlap and an extent length of 4MB, larger then the extent A2 from
   inode A (1MB length);

5) After that we end the transaction, balance the btree dirty pages and
   then start another or join the previous transaction. It might happen
   that the transaction which inserted the incorrect extent was committed
   by another task so we end up with extent corruption if a power failure
   happens.

So fix this by making sure we attempt to insert the extent to clone at
the destination inode only if we are past dropping the sub-range that
corresponds to a hole.

Fixes: 690a5dbfc51315 ("Btrfs: fix ENOSPC errors, leading to transaction aborts, when cloning extents")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c332968f9056..eaafd00f93d4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2601,8 +2601,8 @@ int btrfs_punch_hole_range(struct inode *inode, struct btrfs_path *path,
 			}
 		}
 
-		if (clone_info) {
-			u64 clone_len = drop_end - cur_offset;
+		if (clone_info && drop_end > clone_info->file_offset) {
+			u64 clone_len = drop_end - clone_info->file_offset;
 
 			ret = btrfs_insert_clone_extent(trans, inode, path,
 							clone_info, clone_len);
-- 
2.20.1

