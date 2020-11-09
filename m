Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694762ABB7E
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgKINI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731761AbgKINI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:08:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A64D221F1;
        Mon,  9 Nov 2020 13:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927335;
        bh=5+CQ+9gu2ZIyGQoSS6i1n8vXSVsi7lG/NeXmXbNhYR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lHZGYQkFizwlf59RUE7oxLgjLAw1vhI08K9XdyNTqop+F8LQkSOsFrFFm5mAVlpwS
         pUvDGVNinjdrvW6vq+XkShjvYxUaKRGjNJpHOgBRX13380QVluaChfkCQD9U9riD61
         JrXsoI6xMe+yOuiBlOPafzIIzJ+W7GvdmZ7EKtMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 24/71] btrfs: tree-checker: Make btrfs_check_chunk_valid() return EUCLEAN instead of EIO
Date:   Mon,  9 Nov 2020 13:55:18 +0100
Message-Id: <20201109125021.042397566@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit bf871c3b43b1dcc3f2a076ff39a8f1ce7959d958 upstream.

To follow the standard behavior of tree-checker.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Cherry-picked for 4.19 to ease backporting later fixes]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -496,7 +496,7 @@ static void chunk_err(const struct btrfs
 /*
  * The common chunk check which could also work on super block sys chunk array.
  *
- * Return -EIO if anything is corrupted.
+ * Return -EUCLEAN if anything is corrupted.
  * Return 0 if everything is OK.
  */
 int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
@@ -520,31 +520,31 @@ int btrfs_check_chunk_valid(struct btrfs
 	if (!num_stripes) {
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "invalid chunk num_stripes, have %u", num_stripes);
-		return -EIO;
+		return -EUCLEAN;
 	}
 	if (!IS_ALIGNED(logical, fs_info->sectorsize)) {
 		chunk_err(fs_info, leaf, chunk, logical,
 		"invalid chunk logical, have %llu should aligned to %u",
 			  logical, fs_info->sectorsize);
-		return -EIO;
+		return -EUCLEAN;
 	}
 	if (btrfs_chunk_sector_size(leaf, chunk) != fs_info->sectorsize) {
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "invalid chunk sectorsize, have %u expect %u",
 			  btrfs_chunk_sector_size(leaf, chunk),
 			  fs_info->sectorsize);
-		return -EIO;
+		return -EUCLEAN;
 	}
 	if (!length || !IS_ALIGNED(length, fs_info->sectorsize)) {
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "invalid chunk length, have %llu", length);
-		return -EIO;
+		return -EUCLEAN;
 	}
 	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "invalid chunk stripe length: %llu",
 			  stripe_len);
-		return -EIO;
+		return -EUCLEAN;
 	}
 	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
 	    type) {
@@ -553,14 +553,14 @@ int btrfs_check_chunk_valid(struct btrfs
 			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
 			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
 			  btrfs_chunk_type(leaf, chunk));
-		return -EIO;
+		return -EUCLEAN;
 	}
 
 	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
 		chunk_err(fs_info, leaf, chunk, logical,
 	"missing chunk type flag, have 0x%llx one bit must be set in 0x%llx",
 			  type, BTRFS_BLOCK_GROUP_TYPE_MASK);
-		return -EIO;
+		return -EUCLEAN;
 	}
 
 	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
@@ -568,7 +568,7 @@ int btrfs_check_chunk_valid(struct btrfs
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "system chunk with data or metadata type: 0x%llx",
 			  type);
-		return -EIO;
+		return -EUCLEAN;
 	}
 
 	features = btrfs_super_incompat_flags(fs_info->super_copy);
@@ -580,7 +580,7 @@ int btrfs_check_chunk_valid(struct btrfs
 		    (type & BTRFS_BLOCK_GROUP_DATA)) {
 			chunk_err(fs_info, leaf, chunk, logical,
 			"mixed chunk type in non-mixed mode: 0x%llx", type);
-			return -EIO;
+			return -EUCLEAN;
 		}
 	}
 
@@ -594,7 +594,7 @@ int btrfs_check_chunk_valid(struct btrfs
 			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
 			num_stripes, sub_stripes,
 			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
-		return -EIO;
+		return -EUCLEAN;
 	}
 
 	return 0;


