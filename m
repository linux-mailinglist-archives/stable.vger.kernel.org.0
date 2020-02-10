Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16991579B3
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgBJNRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:17:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgBJMiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:02 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A36D02080C;
        Mon, 10 Feb 2020 12:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338281;
        bh=2c58iirCVWPNkIRsOWjCMrVIiKisXrSJg7VfU5aiNPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VavkH+ED4TwAZHpQ/MKwCs30jSLS/3mK9bhqSq9M8AbR8SpEpCxJBcjP/q9CcfBli
         X87cfZgWkLBIIY/FqztbQ01WShB1NbVHNcAOgJkA9UUEV/GLdFN2NTve/9igZs8xoM
         gdSmgDJgLjUL4OfXl9VDjZ9r/pD2YuvsrJU4SbKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 172/309] Btrfs: make deduplication with range including the last block work
Date:   Mon, 10 Feb 2020 04:32:08 -0800
Message-Id: <20200210122422.912517070@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 831d2fa25ab8e27592b1b0268dae6f2dfaf7cc43 upstream.

Since btrfs was migrated to use the generic VFS helpers for clone and
deduplication, it stopped allowing for the last block of a file to be
deduplicated when the source file size is not sector size aligned (when
eof is somewhere in the middle of the last block). There are two reasons
for that:

1) The generic code always rounds down, to a multiple of the block size,
   the range's length for deduplications. This means we end up never
   deduplicating the last block when the eof is not block size aligned,
   even for the safe case where the destination range's end offset matches
   the destination file's size. That rounding down operation is done at
   generic_remap_check_len();

2) Because of that, the btrfs specific code does not expect anymore any
   non-aligned range length's for deduplication and therefore does not
   work if such nona-aligned length is given.

This patch addresses that second part, and it depends on a patch that
fixes generic_remap_check_len(), in the VFS, which was submitted ealier
and has the following subject:

  "fs: allow deduplication of eof block into the end of the destination file"

These two patches address reports from users that started seeing lower
deduplication rates due to the last block never being deduplicated when
the file size is not aligned to the filesystem's block size.

Link: https://lore.kernel.org/linux-btrfs/2019-1576167349.500456@svIo.N5dq.dFFD/
CC: stable@vger.kernel.org # 5.1+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3244,6 +3244,7 @@ static void btrfs_double_extent_lock(str
 static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 len,
 				   struct inode *dst, u64 dst_loff)
 {
+	const u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
 	int ret;
 
 	/*
@@ -3251,7 +3252,7 @@ static int btrfs_extent_same_range(struc
 	 * source range to serialize with relocation.
 	 */
 	btrfs_double_extent_lock(src, loff, dst, dst_loff, len);
-	ret = btrfs_clone(src, dst, loff, len, len, dst_loff, 1);
+	ret = btrfs_clone(src, dst, loff, len, ALIGN(len, bs), dst_loff, 1);
 	btrfs_double_extent_unlock(src, loff, dst, dst_loff, len);
 
 	return ret;


