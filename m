Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38566420EA8
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhJDN1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236463AbhJDNZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:25:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E793F61B49;
        Mon,  4 Oct 2021 13:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353066;
        bh=s+VblqxESXi1q9YmfX5UPY2NPuymmZHIQn6mqKg7YG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAVBymQLAo6ajWYpMpucAHhef9lWJf+1EHmMwREx/cbD7pGBK6cKgMepOxapUCUQe
         /CBF9JZPSGETkx4uilBRy8Y6V9GDbtaLCnKeAdjxP56V9qY96M/8/1Y6ivw1yrgQC4
         Tr9pUU9ayRzLJ93ATsxy6VLkOYFxBUK2GcV/Bw2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.10 76/93] ext4: fix loff_t overflow in ext4_max_bitmap_size()
Date:   Mon,  4 Oct 2021 14:53:14 +0200
Message-Id: <20211004125037.100927373@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit 75ca6ad408f459f00b09a64f04c774559848c097 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3194,17 +3194,17 @@ static loff_t ext4_max_size(int blkbits,
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
@@ -3247,7 +3247,7 @@ static loff_t ext4_max_bitmap_size(int b
 	if (res > MAX_LFS_FILESIZE)
 		res = MAX_LFS_FILESIZE;
 
-	return res;
+	return (loff_t)res;
 }
 
 static ext4_fsblk_t descriptor_loc(struct super_block *sb,


