Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDAA138038
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbgAKK1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:27:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729122AbgAKK1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:27:06 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DBD320842;
        Sat, 11 Jan 2020 10:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738425;
        bh=mm4956ygG+jablg48bigObr7P6aCT2lVITov/2olgyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpMaJPZfXOj1rsT+Gy1uSB4jKyiscnrdTo3TBsyjvGDq5Er2t21BKJS0AbGb0qBLU
         tl9k3Q2RKWfcZrqND6pdfVAT4fQvwyr8UUqAq8PvJDMbcRFMQZc8F1CLeRcDdKOeP6
         HS2Iabk5/i/eJcduMaMv7AJiKhI8XdKU04C9x88s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/165] Btrfs: fix cloning range with a hole when using the NO_HOLES feature
Date:   Sat, 11 Jan 2020 10:49:53 +0100
Message-Id: <20200111094927.367746025@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



