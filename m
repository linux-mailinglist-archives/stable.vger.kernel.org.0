Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF33239BC54
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 17:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhFDP5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 11:57:33 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57232 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhFDP5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 11:57:33 -0400
Received: from relay2.suse.de (unknown [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7C73721A2E;
        Fri,  4 Jun 2021 15:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622822146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DxEOun4b3dCDaaddtIL+0L9dOMnTzbfns1wfq53mRiw=;
        b=eXU7nNoprZVReG3aACD9HSbkQdvvv5UAyhDlH0UAP5Pm3O8giXRXr4nGwA6ubYzS/zu3OB
        XKRHuwRhhxGNOn2WUx/45XQEdBvQoB0XCuP749qzBxf0sg7bGQzXqKsVMMBkeLeOxKQWap
        N+p3xRpIxx6W49Jkt7m5FVYt6I7P8bM=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id AFA03A3B81;
        Fri,  4 Jun 2021 15:55:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BBA76DB228; Fri,  4 Jun 2021 17:53:04 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5.4, 5.10] btrfs: tree-checker: do not error out if extent ref hash doesn't match
Date:   Fri,  4 Jun 2021 17:53:04 +0200
Message-Id: <20210604155304.24315-1-dsterba@suse.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 1119a72e223f3073a604f8fccb3a470ccd8a4416 upstream.

The tree checker checks the extent ref hash at read and write time to
make sure we do not corrupt the file system.  Generally extent
references go inline, but if we have enough of them we need to make an
item, which looks like

key.objectid	= <bytenr>
key.type	= <BTRFS_EXTENT_DATA_REF_KEY|BTRFS_TREE_BLOCK_REF_KEY>
key.offset	= hash(tree, owner, offset)

However if key.offset collide with an unrelated extent reference we'll
simply key.offset++ until we get something that doesn't collide.
Obviously this doesn't match at tree checker time, and thus we error
while writing out the transaction.  This is relatively easy to
reproduce, simply do something like the following

  xfs_io -f -c "pwrite 0 1M" file
  offset=2

  for i in {0..10000}
  do
	  xfs_io -c "reflink file 0 ${offset}M 1M" file
	  offset=$(( offset + 2 ))
  done

  xfs_io -c "reflink file 0 17999258914816 1M" file
  xfs_io -c "reflink file 0 35998517829632 1M" file
  xfs_io -c "reflink file 0 53752752058368 1M" file

  btrfs filesystem sync

And the sync will error out because we'll abort the transaction.  The
magic values above are used because they generate hash collisions with
the first file in the main subvol.

The fix for this is to remove the hash value check from tree checker, as
we have no idea which offset ours should belong to.

Reported-by: Tuomas Lähdekorpi <tuomas.lahdekorpi@gmail.com>
Fixes: 0785a9aacf9d ("btrfs: tree-checker: Add EXTENT_DATA_REF check")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add comment]
Signed-off-by: David Sterba <dsterba@suse.com>
---

Generated on 5.4 where it applies cleanly and on 5.10 with line offset
but otherwise clean.

 fs/btrfs/tree-checker.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 7d06842a3d74..368c43c6cbd0 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1285,22 +1285,14 @@ static int check_extent_data_ref(struct extent_buffer *leaf,
 		return -EUCLEAN;
 	}
 	for (; ptr < end; ptr += sizeof(*dref)) {
-		u64 root_objectid;
-		u64 owner;
 		u64 offset;
-		u64 hash;
 
+		/*
+		 * We cannot check the extent_data_ref hash due to possible
+		 * overflow from the leaf due to hash collisions.
+		 */
 		dref = (struct btrfs_extent_data_ref *)ptr;
-		root_objectid = btrfs_extent_data_ref_root(leaf, dref);
-		owner = btrfs_extent_data_ref_objectid(leaf, dref);
 		offset = btrfs_extent_data_ref_offset(leaf, dref);
-		hash = hash_extent_data_ref(root_objectid, owner, offset);
-		if (hash != key->offset) {
-			extent_err(leaf, slot,
-	"invalid extent data ref hash, item has 0x%016llx key has 0x%016llx",
-				   hash, key->offset);
-			return -EUCLEAN;
-		}
 		if (!IS_ALIGNED(offset, leaf->fs_info->sectorsize)) {
 			extent_err(leaf, slot,
 	"invalid extent data backref offset, have %llu expect aligned to %u",
-- 
2.31.1

