Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA5262375A
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388864AbfETMYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388137AbfETMYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:24:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80CAE20645;
        Mon, 20 May 2019 12:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355074;
        bh=VpgFCPF+VQV+9StQj8r5gpwZ4Ry5MHG0rcvGOeYFJvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytd3YYQfyxup3OQxZ8JPU0ii97wDWT0ZRVz7Lb3IWr20wMFILNsFdxSFdmLZJs2Fd
         Ks8OYbD0//zpLOWgcqNmGNBx2yu5N8aO3xHti2HLSJhR1N/7X1+19nj6oTKcSnzgkn
         CfwvBW5tD29qWH6r0hkgxYCYv2PvsPXS4FEmJOxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sriram Rajagopalan <sriramr@arista.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.19 085/105] ext4: zero out the unused memory region in the extent tree block
Date:   Mon, 20 May 2019 14:14:31 +0200
Message-Id: <20190520115253.137578627@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriram Rajagopalan <sriramr@arista.com>

commit 592acbf16821288ecdc4192c47e3774a4c48bb64 upstream.

This commit zeroes out the unused memory region in the buffer_head
corresponding to the extent metablock after writing the extent header
and the corresponding extent node entries.

This is done to prevent random uninitialized data from getting into
the filesystem when the extent block is synced.

This fixes CVE-2019-11833.

Signed-off-by: Sriram Rajagopalan <sriramr@arista.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1035,6 +1035,7 @@ static int ext4_ext_split(handle_t *hand
 	__le32 border;
 	ext4_fsblk_t *ablocks = NULL; /* array of allocated blocks */
 	int err = 0;
+	size_t ext_size = 0;
 
 	/* make decision: where to split? */
 	/* FIXME: now decision is simplest: at current extent */
@@ -1126,6 +1127,10 @@ static int ext4_ext_split(handle_t *hand
 		le16_add_cpu(&neh->eh_entries, m);
 	}
 
+	/* zero out unused area in the extent block */
+	ext_size = sizeof(struct ext4_extent_header) +
+		sizeof(struct ext4_extent) * le16_to_cpu(neh->eh_entries);
+	memset(bh->b_data + ext_size, 0, inode->i_sb->s_blocksize - ext_size);
 	ext4_extent_block_csum_set(inode, neh);
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
@@ -1205,6 +1210,11 @@ static int ext4_ext_split(handle_t *hand
 				sizeof(struct ext4_extent_idx) * m);
 			le16_add_cpu(&neh->eh_entries, m);
 		}
+		/* zero out unused area in the extent block */
+		ext_size = sizeof(struct ext4_extent_header) +
+		   (sizeof(struct ext4_extent) * le16_to_cpu(neh->eh_entries));
+		memset(bh->b_data + ext_size, 0,
+			inode->i_sb->s_blocksize - ext_size);
 		ext4_extent_block_csum_set(inode, neh);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
@@ -1270,6 +1280,7 @@ static int ext4_ext_grow_indepth(handle_
 	ext4_fsblk_t newblock, goal = 0;
 	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
 	int err = 0;
+	size_t ext_size = 0;
 
 	/* Try to prepend new index to old one */
 	if (ext_depth(inode))
@@ -1295,9 +1306,11 @@ static int ext4_ext_grow_indepth(handle_
 		goto out;
 	}
 
+	ext_size = sizeof(EXT4_I(inode)->i_data);
 	/* move top-level index/leaf into new block */
-	memmove(bh->b_data, EXT4_I(inode)->i_data,
-		sizeof(EXT4_I(inode)->i_data));
+	memmove(bh->b_data, EXT4_I(inode)->i_data, ext_size);
+	/* zero out unused area in the extent block */
+	memset(bh->b_data + ext_size, 0, inode->i_sb->s_blocksize - ext_size);
 
 	/* set size of new block */
 	neh = ext_block_hdr(bh);


