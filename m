Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE37138019
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgAKKZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:25:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbgAKKZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:25:51 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D72B205F4;
        Sat, 11 Jan 2020 10:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738350;
        bh=JnENt95K+w08kWQTXHyJ6+4jxa4P7bY6b/46UFKPQbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tig5/hDSEYFO2YPS4C4pNnc46O4QinR6aHjh0sFReVJOdJ7uhRQtizmvFJaCOO/Qw
         99NNyim/0NZ0oYeNYRbZ5WtCf0gJ68dFRxTg6pe6aWrr1djti8e2BfSFKzIHQzV7yE
         c9izvdk5d1xQJFwhYPQLwO8L4u9yP/oTx9HXHvdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/165] Btrfs: fix hole extent items with a zero size after range cloning
Date:   Sat, 11 Jan 2020 10:49:57 +0100
Message-Id: <20200111094927.716053977@linuxfoundation.org>
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

[ Upstream commit 147271e35ba267506dde6550f58ccf8d287db3ef ]

Normally when cloning a file range if we find an implicit hole at the end
of the range we assume it is because the NO_HOLES feature is enabled.
However that is not always the case. One well known case [1] is when we
have a power failure after mixing buffered and direct IO writes against
the same file.

In such cases we need to punch a hole in the destination file, and if
the NO_HOLES feature is not enabled, we need to insert explicit file
extent items to represent the hole. After commit 690a5dbfc51315
("Btrfs: fix ENOSPC errors, leading to transaction aborts, when cloning
extents"), we started to insert file extent items representing the hole
with an item size of 0, which is invalid and should be 53 bytes (the size
of a btrfs_file_extent_item structure), resulting in all sorts of
corruptions and invalid memory accesses. This is detected by the tree
checker when we attempt to write a leaf to disk.

The problem can be sporadically triggered by test case generic/561 from
fstests. That test case does not exercise power failure and creates a new
filesystem when it starts, so it does not use a filesystem created by any
previous test that tests power failure. However the test does both
buffered and direct IO writes (through fsstress) and it's precisely that
which is creating the implicit holes in files. That happens even before
the commit mentioned earlier. I need to investigate why we get those
implicit holes to check if there is a real problem or not. For now this
change fixes the regression of introducing file extent items with an item
size of 0 bytes.

Fix the issue by calling btrfs_punch_hole_range() without passing a
btrfs_clone_extent_info structure, which ensures file extent items are
inserted to represent the hole with a correct item size. We were passing
a btrfs_clone_extent_info with a value of 0 for its 'item_size' field,
which was causing the insertion of file extent items with an item size
of 0.

[1] https://www.spinics.net/lists/linux-btrfs/msg75350.html

Reported-by: David Sterba <dsterba@suse.com>
Fixes: 690a5dbfc51315 ("Btrfs: fix ENOSPC errors, leading to transaction aborts, when cloning extents")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a56dcc0c9c2a..5720e450a46f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3727,24 +3727,18 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 	ret = 0;
 
 	if (last_dest_end < destoff + len) {
-		struct btrfs_clone_extent_info clone_info = { 0 };
 		/*
-		 * We have an implicit hole (NO_HOLES feature is enabled) that
-		 * fully or partially overlaps our cloning range at its end.
+		 * We have an implicit hole that fully or partially overlaps our
+		 * cloning range at its end. This means that we either have the
+		 * NO_HOLES feature enabled or the implicit hole happened due to
+		 * mixing buffered and direct IO writes against this file.
 		 */
 		btrfs_release_path(path);
 		path->leave_spinning = 0;
 
-		/*
-		 * We are dealing with a hole and our clone_info already has a
-		 * disk_offset of 0, we only need to fill the data length and
-		 * file offset.
-		 */
-		clone_info.data_len = destoff + len - last_dest_end;
-		clone_info.file_offset = last_dest_end;
 		ret = btrfs_punch_hole_range(inode, path,
 					     last_dest_end, destoff + len - 1,
-					     &clone_info, &trans);
+					     NULL, &trans);
 		if (ret)
 			goto out;
 
-- 
2.20.1



