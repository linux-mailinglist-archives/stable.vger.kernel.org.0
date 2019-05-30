Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E50C2F40D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbfE3Eea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729424AbfE3DNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:23 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C354524544;
        Thu, 30 May 2019 03:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186002;
        bh=ykv74gBGgCbDRTRYSqxl8fqIgKxpMPPN5tym95YMSAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kDwOoM4WJri2kUgz+ozUE4xjXus0S1nNw1zmMAMaDOfe8V8+sASNkKm34PE0jrwk
         2GZ//z3aULpuwtqYq87PD8eINLtgOHzNi+yUR51o3FHa45ZPYymGB0oekUshCaQoMW
         +mES36lZtrb6CqoZ2oDjfHibG3iTGtNotZdq80P4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.0 019/346] Btrfs: avoid fallback to transaction commit during fsync of files with holes
Date:   Wed, 29 May 2019 20:01:32 -0700
Message-Id: <20190530030541.658740295@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit ebb929060aeb162417b4c1307e63daee47b208d9 upstream.

When we are doing a full fsync (bit BTRFS_INODE_NEEDS_FULL_SYNC set) of a
file that has holes and has file extent items spanning two or more leafs,
we can end up falling to back to a full transaction commit due to a logic
bug that leads to failure to insert a duplicate file extent item that is
meant to represent a hole between the last file extent item of a leaf and
the first file extent item in the next leaf. The failure (EEXIST error)
leads to a transaction commit (as most errors when logging an inode do).

For example, we have the two following leafs:

Leaf N:

  -----------------------------------------------
  | ..., ..., ..., (257, FILE_EXTENT_ITEM, 64K) |
  -----------------------------------------------
  The file extent item at the end of leaf N has a length of 4Kb,
  representing the file range from 64K to 68K - 1.

Leaf N + 1:

  -----------------------------------------------
  | (257, FILE_EXTENT_ITEM, 72K), ..., ..., ... |
  -----------------------------------------------
  The file extent item at the first slot of leaf N + 1 has a length of
  4Kb too, representing the file range from 72K to 76K - 1.

During the full fsync path, when we are at tree-log.c:copy_items() with
leaf N as a parameter, after processing the last file extent item, that
represents the extent at offset 64K, we take a look at the first file
extent item at the next leaf (leaf N + 1), and notice there's a 4K hole
between the two extents, and therefore we insert a file extent item
representing that hole, starting at file offset 68K and ending at offset
72K - 1. However we don't update the value of *last_extent, which is used
to represent the end offset (plus 1, non-inclusive end) of the last file
extent item inserted in the log, so it stays with a value of 68K and not
with a value of 72K.

Then, when copy_items() is called for leaf N + 1, because the value of
*last_extent is smaller then the offset of the first extent item in the
leaf (68K < 72K), we look at the last file extent item in the previous
leaf (leaf N) and see it there's a 4K gap between it and our first file
extent item (again, 68K < 72K), so we decide to insert a file extent item
representing the hole, starting at file offset 68K and ending at offset
72K - 1, this insertion will fail with -EEXIST being returned from
btrfs_insert_file_extent() because we already inserted a file extent item
representing a hole for this offset (68K) in the previous call to
copy_items(), when processing leaf N.

The -EEXIST error gets propagated to the fsync callback, btrfs_sync_file(),
which falls back to a full transaction commit.

Fix this by adjusting *last_extent after inserting a hole when we had to
look at the next leaf.

Fixes: 4ee3fad34a9c ("Btrfs: fix fsync after hole punching when using no-holes feature")
Cc: stable@vger.kernel.org # 4.14+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4106,6 +4106,7 @@ fill_holes:
 							       *last_extent, 0,
 							       0, len, 0, len,
 							       0, 0, 0);
+				*last_extent += len;
 			}
 		}
 	}


