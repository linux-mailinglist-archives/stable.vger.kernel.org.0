Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3621B6983
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgDWXYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:24:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48296 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728141AbgDWXG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:29 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-0004a7-6H; Fri, 24 Apr 2020 00:06:25 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6g7-A4; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Chris Mason" <clm@fb.com>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Qu Wenruo" <quwenruo@cn.fujitsu.com>,
        "Vegard Nossum" <vegard.nossum@oracle.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Fri, 24 Apr 2020 00:04:12 +0100
Message-ID: <lsq.1587683028.808298705@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 025/245] btrfs: Enhance chunk validation check
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

commit f04b772bfc17f502703794f4d100d12155c1a1a9 upstream.

Enhance chunk validation:
1) Num_stripes
   We already have such check but it's only in super block sys chunk
   array.
   Now check all on-disk chunks.

2) Chunk logical
   It should be aligned to sector size.
   This behavior should be *DOUBLE CHECKED* for 64K sector size like
   PPC64 or AArch64.
   Maybe we can found some hidden bugs.

3) Chunk length
   Same as chunk logical, should be aligned to sector size.

4) Stripe length
   It should be power of 2.

5) Chunk type
   Any bit out of TYPE_MAS | PROFILE_MASK is invalid.

With all these much restrict rules, several fuzzed image reported in
mail list should no longer cause kernel panic.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/volumes.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5814,6 +5814,7 @@ static int read_one_chunk(struct btrfs_r
 	struct extent_map *em;
 	u64 logical;
 	u64 length;
+	u64 stripe_len;
 	u64 devid;
 	u8 uuid[BTRFS_UUID_SIZE];
 	int num_stripes;
@@ -5822,6 +5823,37 @@ static int read_one_chunk(struct btrfs_r
 
 	logical = key->offset;
 	length = btrfs_chunk_length(leaf, chunk);
+	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
+	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+	/* Validation check */
+	if (!num_stripes) {
+		btrfs_err(root->fs_info, "invalid chunk num_stripes: %u",
+			  num_stripes);
+		return -EIO;
+	}
+	if (!IS_ALIGNED(logical, root->sectorsize)) {
+		btrfs_err(root->fs_info,
+			  "invalid chunk logical %llu", logical);
+		return -EIO;
+	}
+	if (!length || !IS_ALIGNED(length, root->sectorsize)) {
+		btrfs_err(root->fs_info,
+			"invalid chunk length %llu", length);
+		return -EIO;
+	}
+	if (!is_power_of_2(stripe_len)) {
+		btrfs_err(root->fs_info, "invalid chunk stripe length: %llu",
+			  stripe_len);
+		return -EIO;
+	}
+	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+	    btrfs_chunk_type(leaf, chunk)) {
+		btrfs_err(root->fs_info, "unrecognized chunk type: %llu",
+			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
+			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+			  btrfs_chunk_type(leaf, chunk));
+		return -EIO;
+	}
 
 	read_lock(&map_tree->map_tree.lock);
 	em = lookup_extent_mapping(&map_tree->map_tree, logical, 1);
@@ -5838,7 +5870,6 @@ static int read_one_chunk(struct btrfs_r
 	em = alloc_extent_map();
 	if (!em)
 		return -ENOMEM;
-	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
 	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
 	if (!map) {
 		free_extent_map(em);

