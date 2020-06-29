Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F407F20E833
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391819AbgF2WEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgF2SfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BA6A247B3;
        Mon, 29 Jun 2020 15:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444115;
        bh=L/UZd5a6IcXtfLJej821jWf2eMKINcIs7qnt+UN8m3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHzGEEX5U7eFucDSiqKTbxkbLUmuq/X6OFZjQRTpONApPbe2hk6igrdKDEiQenmHz
         wCd5V7ePvN/ZGcaZ2aguVhFvjoljYmLP9OTYtKtGGKIjOfkJpW/aVFEPMc7cjSAOsy
         v+D1DGsH5OX0xejXLkZYo7rM2y9RscuOZvJnLs54=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 227/265] btrfs: fix RWF_NOWAIT write not failling when we need to cow
Date:   Mon, 29 Jun 2020 11:17:40 -0400
Message-Id: <20200629151818.2493727-228-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 260a63395f90f67d6ab89e4266af9e3dc34a77e9 upstream.

If we attempt to do a RWF_NOWAIT write against a file range for which we
can only do NOCOW for a part of it, due to the existence of holes or
shared extents for example, we proceed with the write as if it were
possible to NOCOW the whole range.

Example:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ touch /mnt/sdj/bar
  $ chattr +C /mnt/sdj/bar

  $ xfs_io -d -c "pwrite -S 0xab -b 256K 0 256K" /mnt/bar
  wrote 262144/262144 bytes at offset 0
  256 KiB, 1 ops; 0.0003 sec (694.444 MiB/sec and 2777.7778 ops/sec)

  $ xfs_io -c "fpunch 64K 64K" /mnt/bar
  $ sync

  $ xfs_io -d -c "pwrite -N -V 1 -b 128K -S 0xfe 0 128K" /mnt/bar
  wrote 131072/131072 bytes at offset 0
  128 KiB, 1 ops; 0.0007 sec (160.051 MiB/sec and 1280.4097 ops/sec)

This last write should fail with -EAGAIN since the file range from 64K to
128K is a hole. On xfs it fails, as expected, but on ext4 it currently
succeeds because apparently it is expensive to check if there are extents
allocated for the whole range, but I'll check with the ext4 people.

Fix the issue by checking if check_can_nocow() returns a number of
NOCOW'able bytes smaller then the requested number of bytes, and if it
does return -EAGAIN.

Fixes: edf064e7c6fec3 ("btrfs: nowait aio support")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 484803f8b2290..52d565ff66e2d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1912,18 +1912,29 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	pos = iocb->ki_pos;
 	count = iov_iter_count(from);
 	if (iocb->ki_flags & IOCB_NOWAIT) {
+		size_t nocow_bytes = count;
+
 		/*
 		 * We will allocate space in case nodatacow is not set,
 		 * so bail
 		 */
 		if (!(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 					      BTRFS_INODE_PREALLOC)) ||
-		    check_can_nocow(BTRFS_I(inode), pos, &count) <= 0) {
+		    check_can_nocow(BTRFS_I(inode), pos, &nocow_bytes) <= 0) {
 			inode_unlock(inode);
 			return -EAGAIN;
 		}
 		/* check_can_nocow() locks the snapshot lock on success */
 		btrfs_drew_write_unlock(&root->snapshot_lock);
+		/*
+		 * There are holes in the range or parts of the range that must
+		 * be COWed (shared extents, RO block groups, etc), so just bail
+		 * out.
+		 */
+		if (nocow_bytes < count) {
+			inode_unlock(inode);
+			return -EAGAIN;
+		}
 	}
 
 	current->backing_dev_info = inode_to_bdi(inode);
-- 
2.25.1

