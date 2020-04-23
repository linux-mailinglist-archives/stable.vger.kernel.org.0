Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0921B6987
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgDWXG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:06:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48164 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727968AbgDWXG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004Zf-Ev; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-00E6fK-Rr; Fri, 24 Apr 2020 00:06:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jan Kara" <jack@suse.com>, "Theodore Ts'o" <tytso@mit.edu>
Date:   Fri, 24 Apr 2020 00:04:02 +0100
Message-ID: <lsq.1587683028.757479552@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 015/245] ext4: move unlocked dio protection from
 ext4_alloc_file_blocks()
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

From: Jan Kara <jack@suse.com>

commit 17048e8a083fec7ad841d88ef0812707fbc7e39f upstream.

Currently ext4_alloc_file_blocks() was handling protection against
unlocked DIO. However we now need to sometimes call it under i_mmap_sem
and sometimes not and DIO protection ranks above it (although strictly
speaking this cannot currently create any deadlocks). Also
ext4_zero_range() was actually getting & releasing unlocked DIO
protection twice in some cases. Luckily it didn't introduce any real bug
but it was a land mine waiting to be stepped on.  So move DIO protection
out from ext4_alloc_file_blocks() into the two callsites.

Signed-off-by: Jan Kara <jack@suse.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/extents.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4707,10 +4707,6 @@ static int ext4_alloc_file_blocks(struct
 	if (len <= EXT_UNWRITTEN_MAX_LEN)
 		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
 
-	/* Wait all existing dio workers, newcomers will block on i_mutex */
-	ext4_inode_block_unlocked_dio(inode);
-	inode_dio_wait(inode);
-
 	/*
 	 * credits to insert 1 extent into extent tree
 	 */
@@ -4760,8 +4756,6 @@ retry:
 		goto retry;
 	}
 
-	ext4_inode_resume_unlocked_dio(inode);
-
 	return ret > 0 ? ret2 : ret;
 }
 
@@ -4836,6 +4830,10 @@ static long ext4_zero_range(struct file
 	if (mode & FALLOC_FL_KEEP_SIZE)
 		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
 
+	/* Wait all existing dio workers, newcomers will block on i_mutex */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
+
 	/* Preallocate the range including the unaligned edges */
 	if (partial_begin || partial_end) {
 		ret = ext4_alloc_file_blocks(file,
@@ -4844,7 +4842,7 @@ static long ext4_zero_range(struct file
 				 round_down(offset, 1 << blkbits)) >> blkbits,
 				new_size, flags, mode);
 		if (ret)
-			goto out_mutex;
+			goto out_dio;
 
 	}
 
@@ -4853,10 +4851,6 @@ static long ext4_zero_range(struct file
 		flags |= (EXT4_GET_BLOCKS_CONVERT_UNWRITTEN |
 			  EXT4_EX_NOCACHE);
 
-		/* Wait all existing dio workers, newcomers will block on i_mutex */
-		ext4_inode_block_unlocked_dio(inode);
-		inode_dio_wait(inode);
-
 		/*
 		 * Prevent page faults from reinstantiating pages we have
 		 * released from page cache.
@@ -4985,8 +4979,13 @@ long ext4_fallocate(struct file *file, i
 			goto out;
 	}
 
+	/* Wait all existing dio workers, newcomers will block on i_mutex */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
+
 	ret = ext4_alloc_file_blocks(file, lblk, max_blocks, new_size,
 				     flags, mode);
+	ext4_inode_resume_unlocked_dio(inode);
 	if (ret)
 		goto out;
 

