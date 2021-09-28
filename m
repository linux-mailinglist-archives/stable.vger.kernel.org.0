Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C366341A77C
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbhI1F5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238887AbhI1F5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB8FB611EF;
        Tue, 28 Sep 2021 05:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808527;
        bh=EC4o/+itJCzaJfm6aSUdAN6lSrMpWZxRr4Ei4e4UMNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffielaYKyO0qfEEvEXqQdYHyvtbQ4HPUHdjPA9APHad6Bdfxx7mA2rj5kyHRPnKoj
         PSArI/O8ajhSkLWX7xrnP/zqF58Qiymg+XA3neJDo2kEhbjrjLs9QP2+h7nPBzbQdf
         XmetUBqNTyMCWn5NJRbxHs9Bff7zomqPuo/Ba3OacjgkOs36ECUmvzFwUSotjkKwKD
         p7iZfKI5153KJjC2eScm2BSRgc1+DMhAeoJtWS8q10D/AoGmg9vogKgwVCED7WJ+w2
         CKrGJbQHkA7Mixcbjy7PcTq0E2aWrkN3OHsYslqYPBPNMkOBRKWwFnn2qQQByqi/Qc
         rXhjynfdXl2tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 06/40] btrfs: replace BUG_ON() in btrfs_csum_one_bio() with proper error handling
Date:   Tue, 28 Sep 2021 01:54:50 -0400
Message-Id: <20210928055524.172051-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit bbc9a6eb5eec03dcafee266b19f56295e3b2aa8f ]

There is a BUG_ON() in btrfs_csum_one_bio() to catch code logic error.
It has indeed caught several bugs during subpage development.
But the BUG_ON() itself will bring down the whole system which is
an overkill.

Replace it with a WARN() and exit gracefully, so that it won't crash the
whole system while we can still catch the code logic error.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file-item.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index df6631eefc65..5e8a56113b23 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -666,7 +666,18 @@ blk_status_t btrfs_csum_one_bio(struct btrfs_inode *inode, struct bio *bio,
 
 		if (!ordered) {
 			ordered = btrfs_lookup_ordered_extent(inode, offset);
-			BUG_ON(!ordered); /* Logic error */
+			/*
+			 * The bio range is not covered by any ordered extent,
+			 * must be a code logic error.
+			 */
+			if (unlikely(!ordered)) {
+				WARN(1, KERN_WARNING
+			"no ordered extent for root %llu ino %llu offset %llu\n",
+				     inode->root->root_key.objectid,
+				     btrfs_ino(inode), offset);
+				kvfree(sums);
+				return BLK_STS_IOERR;
+			}
 		}
 
 		nr_sectors = BTRFS_BYTES_TO_BLKS(fs_info,
-- 
2.33.0

