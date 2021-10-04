Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33982420880
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 11:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhJDJmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 05:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230270AbhJDJmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 05:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C9E1610A8;
        Mon,  4 Oct 2021 09:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633340423;
        bh=kl7wXD7t4F1PkDPFQEExTDFV6HebLdgufM0QNg+ugZ0=;
        h=Subject:To:Cc:From:Date:From;
        b=1JqFkDQTgOqva+AYgJyIZMkiWsyXS2J/zDTkrmNifpzUFdmwF9zCd3V6sP/OnJHtp
         28I/TwLfU38UDuh3cHHnPeDOpGMJEvpUGXbVXzN3ODT1NTZ3td/X9M2JYo7l3ZPb35
         S+rKyh7jEEOcDIYauzPbSzlxnlzbhNQTKIMgLCHM=
Subject: FAILED: patch "[PATCH] ext4: fix loff_t overflow in ext4_max_bitmap_size()" failed to apply to 4.14-stable tree
To:     riteshh@linux.ibm.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Oct 2021 11:40:11 +0200
Message-ID: <1633340411169114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 75ca6ad408f459f00b09a64f04c774559848c097 Mon Sep 17 00:00:00 2001
From: Ritesh Harjani <riteshh@linux.ibm.com>
Date: Sat, 5 Jun 2021 10:39:32 +0530
Subject: [PATCH] ext4: fix loff_t overflow in ext4_max_bitmap_size()

We should use unsigned long long rather than loff_t to avoid
overflow in ext4_max_bitmap_size() for comparison before returning.
w/o this patch sbi->s_bitmap_maxbytes was becoming a negative
value due to overflow of upper_limit (with has_huge_files as true)

Below is a quick test to trigger it on a 64KB pagesize system.

sudo mkfs.ext4 -b 65536 -O ^has_extents,^64bit /dev/loop2
sudo mount /dev/loop2 /mnt
sudo echo "hello" > /mnt/hello 	-> This will error out with
				"echo: write error: File too large"

Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/594f409e2c543e90fd836b78188dfa5c575065ba.1622867594.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a52f1572daa5..9b5b2f63b470 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3030,17 +3030,17 @@ static loff_t ext4_max_size(int blkbits, int has_huge_files)
  */
 static loff_t ext4_max_bitmap_size(int bits, int has_huge_files)
 {
-	loff_t res = EXT4_NDIR_BLOCKS;
+	unsigned long long upper_limit, res = EXT4_NDIR_BLOCKS;
 	int meta_blocks;
-	loff_t upper_limit;
-	/* This is calculated to be the largest file size for a dense, block
+
+	/*
+	 * This is calculated to be the largest file size for a dense, block
 	 * mapped file such that the file's total number of 512-byte sectors,
 	 * including data and all indirect blocks, does not exceed (2^48 - 1).
 	 *
 	 * __u32 i_blocks_lo and _u16 i_blocks_high represent the total
 	 * number of 512-byte sectors of the file.
 	 */
-
 	if (!has_huge_files) {
 		/*
 		 * !has_huge_files or implies that the inode i_block field
@@ -3083,7 +3083,7 @@ static loff_t ext4_max_bitmap_size(int bits, int has_huge_files)
 	if (res > MAX_LFS_FILESIZE)
 		res = MAX_LFS_FILESIZE;
 
-	return res;
+	return (loff_t)res;
 }
 
 static ext4_fsblk_t descriptor_loc(struct super_block *sb,

