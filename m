Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D62426954
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241901AbhJHLgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241764AbhJHLeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:34:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF48160F21;
        Fri,  8 Oct 2021 11:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692695;
        bh=H8gT73qWs9QvZDEwxm1QJLZLlOdawtOYwPH/pJwvbgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5zR8ImkOohBYkea4fQQJ/0Jjxx9TLFCKntZhOMAP2n7MFO5aeuAA/6Dlj/2TaMko
         QpjzM8YS6pDLBYT9pT+fzcpLKxK8y2x3qpRwypEcoRSnbanGeOjQOQwLgZCNtxKnyO
         d+7edAttUrSjBvpYFABEAG12bRfRlF870ns+/KCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/29] btrfs: replace BUG_ON() in btrfs_csum_one_bio() with proper error handling
Date:   Fri,  8 Oct 2021 13:27:52 +0200
Message-Id: <20211008112717.102361205@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 48a2ea6d7092..2de1d8247494 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -568,7 +568,18 @@ blk_status_t btrfs_csum_one_bio(struct btrfs_inode *inode, struct bio *bio,
 
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



