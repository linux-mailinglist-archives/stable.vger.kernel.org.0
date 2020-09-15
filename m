Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F2F26B3E5
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgIOXML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727256AbgIOOki (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:40:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF67A22955;
        Tue, 15 Sep 2020 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180221;
        bh=bRtkHKeg9On3+4ZHEZuvrh7x5YWaMaeDHGNKF3D2ji0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3hlPJ4UMxeyLiRJ+aW1ZOgu4dvCvqWrsvPpq4Q3esxy/ARSGLD9afkVsy09IHI1V
         yl2q0GN+9xqL/tbKhMZJ3Pjq1M5YKqzNowH/7Obvy+pcrihIhalr3OM9DHE91fWyME
         V1lPslaUT8Unp/3FW4wcN8fefoyQz0ZEwfz965Lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 126/177] btrfs: require only sector size alignment for parent eb bytenr
Date:   Tue, 15 Sep 2020 16:13:17 +0200
Message-Id: <20200915140659.684024248@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit ea57788eb76dc81f6003245427356a1dcd0ac524 upstream.

[BUG]
A completely sane converted fs will cause kernel warning at balance
time:

  [ 1557.188633] BTRFS info (device sda7): relocating block group 8162107392 flags data
  [ 1563.358078] BTRFS info (device sda7): found 11722 extents
  [ 1563.358277] BTRFS info (device sda7): leaf 7989321728 gen 95 total ptrs 213 free space 3458 owner 2
  [ 1563.358280] 	item 0 key (7984947200 169 0) itemoff 16250 itemsize 33
  [ 1563.358281] 		extent refs 1 gen 90 flags 2
  [ 1563.358282] 		ref#0: tree block backref root 4
  [ 1563.358285] 	item 1 key (7985602560 169 0) itemoff 16217 itemsize 33
  [ 1563.358286] 		extent refs 1 gen 93 flags 258
  [ 1563.358287] 		ref#0: shared block backref parent 7985602560
  [ 1563.358288] 			(parent 7985602560 is NOT ALIGNED to nodesize 16384)
  [ 1563.358290] 	item 2 key (7985635328 169 0) itemoff 16184 itemsize 33
  ...
  [ 1563.358995] BTRFS error (device sda7): eb 7989321728 invalid extent inline ref type 182
  [ 1563.358996] ------------[ cut here ]------------
  [ 1563.359005] WARNING: CPU: 14 PID: 2930 at 0xffffffff9f231766

Then with transaction abort, and obviously failed to balance the fs.

[CAUSE]
That mentioned inline ref type 182 is completely sane, it's
BTRFS_SHARED_BLOCK_REF_KEY, it's some extra check making kernel to
believe it's invalid.

Commit 64ecdb647ddb ("Btrfs: add one more sanity check for shared ref
type") introduced extra checks for backref type.

One of the requirement is, parent bytenr must be aligned to node size,
which is not correct.

One example is like this:

0	1G  1G+4K		2G 2G+4K
	|   |///////////////////|//|  <- A chunk starts at 1G+4K
            |   |	<- A tree block get reserved at bytenr 1G+4K

Then we have a valid tree block at bytenr 1G+4K, but not aligned to
nodesize (16K).

Such chunk is not ideal, but current kernel can handle it pretty well.
We may warn about such tree block in the future, but should not reject
them.

[FIX]
Change the alignment requirement from node size alignment to sector size
alignment.

Also, to make our lives a little easier, also output @iref when
btrfs_get_extent_inline_ref_type() failed, so we can locate the item
easier.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=205475
Fixes: 64ecdb647ddb ("Btrfs: add one more sanity check for shared ref type")
CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
[ update comments and messages ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |   19 +++++++++----------
 fs/btrfs/print-tree.c  |   12 +++++++-----
 2 files changed, 16 insertions(+), 15 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -400,12 +400,11 @@ int btrfs_get_extent_inline_ref_type(con
 			if (type == BTRFS_SHARED_BLOCK_REF_KEY) {
 				ASSERT(eb->fs_info);
 				/*
-				 * Every shared one has parent tree
-				 * block, which must be aligned to
-				 * nodesize.
+				 * Every shared one has parent tree block,
+				 * which must be aligned to sector size.
 				 */
 				if (offset &&
-				    IS_ALIGNED(offset, eb->fs_info->nodesize))
+				    IS_ALIGNED(offset, eb->fs_info->sectorsize))
 					return type;
 			}
 		} else if (is_data == BTRFS_REF_TYPE_DATA) {
@@ -414,12 +413,11 @@ int btrfs_get_extent_inline_ref_type(con
 			if (type == BTRFS_SHARED_DATA_REF_KEY) {
 				ASSERT(eb->fs_info);
 				/*
-				 * Every shared one has parent tree
-				 * block, which must be aligned to
-				 * nodesize.
+				 * Every shared one has parent tree block,
+				 * which must be aligned to sector size.
 				 */
 				if (offset &&
-				    IS_ALIGNED(offset, eb->fs_info->nodesize))
+				    IS_ALIGNED(offset, eb->fs_info->sectorsize))
 					return type;
 			}
 		} else {
@@ -429,8 +427,9 @@ int btrfs_get_extent_inline_ref_type(con
 	}
 
 	btrfs_print_leaf((struct extent_buffer *)eb);
-	btrfs_err(eb->fs_info, "eb %llu invalid extent inline ref type %d",
-		  eb->start, type);
+	btrfs_err(eb->fs_info,
+		  "eb %llu iref 0x%lx invalid extent inline ref type %d",
+		  eb->start, (unsigned long)iref, type);
 	WARN_ON(1);
 
 	return BTRFS_REF_TYPE_INVALID;
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -95,9 +95,10 @@ static void print_extent_item(struct ext
 			 * offset is supposed to be a tree block which
 			 * must be aligned to nodesize.
 			 */
-			if (!IS_ALIGNED(offset, eb->fs_info->nodesize))
-				pr_info("\t\t\t(parent %llu is NOT ALIGNED to nodesize %llu)\n",
-					offset, (unsigned long long)eb->fs_info->nodesize);
+			if (!IS_ALIGNED(offset, eb->fs_info->sectorsize))
+				pr_info(
+			"\t\t\t(parent %llu not aligned to sectorsize %u)\n",
+					offset, eb->fs_info->sectorsize);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY:
 			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
@@ -112,8 +113,9 @@ static void print_extent_item(struct ext
 			 * must be aligned to nodesize.
 			 */
 			if (!IS_ALIGNED(offset, eb->fs_info->nodesize))
-				pr_info("\t\t\t(parent %llu is NOT ALIGNED to nodesize %llu)\n",
-				     offset, (unsigned long long)eb->fs_info->nodesize);
+				pr_info(
+			"\t\t\t(parent %llu not aligned to sectorsize %u)\n",
+				     offset, eb->fs_info->sectorsize);
 			break;
 		default:
 			pr_cont("(extent %llu has INVALID ref type %d)\n",


