Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2912E28B73F
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388544AbgJLNls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389173AbgJLNlQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:41:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C37862087E;
        Mon, 12 Oct 2020 13:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510075;
        bh=LRlzV4B6/CDiM2Q6SbTtsY107yDMvpn7GXO08as5liU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRyMVlpXwWAVB6DxPC7oQo8DoHY0KURDrQ7I0kR7TNJH5BoEImdm/ltRtaW4xjKTT
         Qg04JMXVms4SZJg87jeQGPlKwnSlAgw9V6lqgohrI4VqQlNv+4ZF5r3VrimpF2KT4d
         6lLgZQeVeuDPo6wywllFLG3d18LDduRBUj8DNKy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 29/85] btrfs: Ensure we trim ranges across block group boundary
Date:   Mon, 12 Oct 2020 15:26:52 +0200
Message-Id: <20201012132634.255502969@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 6b7faadd985c990324b5b5bd18cc4ba5c395eb65 upstream.

[BUG]
When deleting large files (which cross block group boundary) with
discard mount option, we find some btrfs_discard_extent() calls only
trimmed part of its space, not the whole range:

  btrfs_discard_extent: type=0x1 start=19626196992 len=2144530432 trimmed=1073741824 ratio=50%

type:		bbio->map_type, in above case, it's SINGLE DATA.
start:		Logical address of this trim
len:		Logical length of this trim
trimmed:	Physically trimmed bytes
ratio:		trimmed / len

Thus leaving some unused space not discarded.

[CAUSE]
When discard mount option is specified, after a transaction is fully
committed (super block written to disk), we begin to cleanup pinned
extents in the following call chain:

btrfs_commit_transaction()
|- btrfs_finish_extent_commit()
   |- find_first_extent_bit(unpin, 0, &start, &end, EXTENT_DIRTY);
   |- btrfs_discard_extent()

However, pinned extents are recorded in an extent_io_tree, which can
merge adjacent extent states.

When a large file gets deleted and it has adjacent file extents across
block group boundary, we will get a large merged range like this:

      |<---    BG1    --->|<---      BG2     --->|
      |//////|<--   Range to discard   --->|/////|

To discard that range, we have the following calls:

  btrfs_discard_extent()
  |- btrfs_map_block()
  |  Returned bbio will end at BG1's end. As btrfs_map_block()
  |  never returns result across block group boundary.
  |- btrfs_issuse_discard()
     Issue discard for each stripe.

So we will only discard the range in BG1, not the remaining part in BG2.

Furthermore, this bug is not that reliably observed, for above case, if
there is no other extent in BG2, BG2 will be empty and btrfs will trim
all space of BG2, covering up the bug.

[FIX]
- Allow __btrfs_map_block_for_discard() to modify @length parameter
  btrfs_map_block() uses its @length paramter to notify the caller how
  many bytes are mapped in current call.
  With __btrfs_map_block_for_discard() also modifing the @length,
  btrfs_discard_extent() now understands when to do extra trim.

- Call btrfs_map_block() in a loop until we hit the range end Since we
  now know how many bytes are mapped each time, we can iterate through
  each block group boundary and issue correct trim for each range.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Tested-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |   41 +++++++++++++++++++++++++++++++----------
 fs/btrfs/volumes.c     |    6 ++++--
 2 files changed, 35 insertions(+), 12 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1305,8 +1305,10 @@ static int btrfs_issue_discard(struct bl
 int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 			 u64 num_bytes, u64 *actual_bytes)
 {
-	int ret;
+	int ret = 0;
 	u64 discarded_bytes = 0;
+	u64 end = bytenr + num_bytes;
+	u64 cur = bytenr;
 	struct btrfs_bio *bbio = NULL;
 
 
@@ -1315,15 +1317,23 @@ int btrfs_discard_extent(struct btrfs_fs
 	 * associated to its stripes that don't go away while we are discarding.
 	 */
 	btrfs_bio_counter_inc_blocked(fs_info);
-	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(fs_info, BTRFS_MAP_DISCARD, bytenr, &num_bytes,
-			      &bbio, 0);
-	/* Error condition is -ENOMEM */
-	if (!ret) {
-		struct btrfs_bio_stripe *stripe = bbio->stripes;
+	while (cur < end) {
+		struct btrfs_bio_stripe *stripe;
 		int i;
 
+		num_bytes = end - cur;
+		/* Tell the block device(s) that the sectors can be discarded */
+		ret = btrfs_map_block(fs_info, BTRFS_MAP_DISCARD, cur,
+				      &num_bytes, &bbio, 0);
+		/*
+		 * Error can be -ENOMEM, -ENOENT (no such chunk mapping) or
+		 * -EOPNOTSUPP. For any such error, @num_bytes is not updated,
+		 * thus we can't continue anyway.
+		 */
+		if (ret < 0)
+			goto out;
 
+		stripe = bbio->stripes;
 		for (i = 0; i < bbio->num_stripes; i++, stripe++) {
 			u64 bytes;
 			struct request_queue *req_q;
@@ -1340,10 +1350,19 @@ int btrfs_discard_extent(struct btrfs_fs
 						  stripe->physical,
 						  stripe->length,
 						  &bytes);
-			if (!ret)
+			if (!ret) {
 				discarded_bytes += bytes;
-			else if (ret != -EOPNOTSUPP)
-				break; /* Logic errors or -ENOMEM, or -EIO but I don't know how that could happen JDM */
+			} else if (ret != -EOPNOTSUPP) {
+				/*
+				 * Logic errors or -ENOMEM, or -EIO, but
+				 * unlikely to happen.
+				 *
+				 * And since there are two loops, explicitly
+				 * go to out to avoid confusion.
+				 */
+				btrfs_put_bbio(bbio);
+				goto out;
+			}
 
 			/*
 			 * Just in case we get back EOPNOTSUPP for some reason,
@@ -1353,7 +1372,9 @@ int btrfs_discard_extent(struct btrfs_fs
 			ret = 0;
 		}
 		btrfs_put_bbio(bbio);
+		cur += num_bytes;
 	}
+out:
 	btrfs_bio_counter_dec(fs_info);
 
 	if (actual_bytes)
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5676,12 +5676,13 @@ void btrfs_put_bbio(struct btrfs_bio *bb
  * replace.
  */
 static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
-					 u64 logical, u64 length,
+					 u64 logical, u64 *length_ret,
 					 struct btrfs_bio **bbio_ret)
 {
 	struct extent_map *em;
 	struct map_lookup *map;
 	struct btrfs_bio *bbio;
+	u64 length = *length_ret;
 	u64 offset;
 	u64 stripe_nr;
 	u64 stripe_nr_end;
@@ -5715,6 +5716,7 @@ static int __btrfs_map_block_for_discard
 
 	offset = logical - em->start;
 	length = min_t(u64, em->start + em->len - logical, length);
+	*length_ret = length;
 
 	stripe_len = map->stripe_len;
 	/*
@@ -6129,7 +6131,7 @@ static int __btrfs_map_block(struct btrf
 
 	if (op == BTRFS_MAP_DISCARD)
 		return __btrfs_map_block_for_discard(fs_info, logical,
-						     *length, bbio_ret);
+						     length, bbio_ret);
 
 	ret = btrfs_get_io_geometry(fs_info, op, logical, *length, &geom);
 	if (ret < 0)


