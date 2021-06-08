Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998B33A0162
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbhFHSvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235889AbhFHSt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:49:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10CFE61465;
        Tue,  8 Jun 2021 18:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177536;
        bh=PK/gH9mxgzJ5E6JSk09mtqXMEqNscMTe5NAqxnRVaTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBnv7IJf6dEXHIyfhiVjQsORZTHFhmV50Z/IKHVg8oPkCNrQUMDLvjNj61DlqEDvt
         uLTkDKzUAXhl7pxnDsc37L8YygjZ2NSQDIggUDK59yESC+vQ21FX1qeo7AzwzrxyI0
         3rezObfWLB/xMZPLFsCbQ81xSxUeVZszov6pz+eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Tuomas=20L=C3=A4hdekorpi?= <tuomas.lahdekorpi@gmail.com>,
        Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/137] btrfs: tree-checker: do not error out if extent ref hash doesnt match
Date:   Tue,  8 Jun 2021 20:25:41 +0200
Message-Id: <20210608175942.429608302@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 40845428b739..d4a3a56726aa 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1440,22 +1440,14 @@ static int check_extent_data_ref(struct extent_buffer *leaf,
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
2.30.2



