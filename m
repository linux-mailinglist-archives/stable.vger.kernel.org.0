Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B751A584E
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgDKX3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729783AbgDKXLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:11:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B45920708;
        Sat, 11 Apr 2020 23:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646668;
        bh=Fa+sPfwU/NhlYp82gxZdts2D6EbwCQVnTSQvRIzFtA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rt1FfjSJ5mSllBO2X5lEKXmviFHgzj+qciM+Zl4/crX06ZF51Fze15M7KH0MHHYmM
         ord4SUAtYreCi/R0fTfRODZ9cDbdkCAaer3phf6R8IKbCF7SPa39QIIg8XF6aEK+er
         X1QxYR9yVPdBHmoNDfiJN/ERoUCxCE1D3iUM3Zao=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        syzbot+1f9dc49e8de2582d90c2@syzkaller.appspotmail.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 067/108] xfs: clear PF_MEMALLOC before exiting xfsaild thread
Date:   Sat, 11 Apr 2020 19:09:02 -0400
Message-Id: <20200411230943.24951-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 10a98cb16d80be3595fdb165fad898bb28b8b6d2 ]

Leaving PF_MEMALLOC set when exiting a kthread causes it to remain set
during do_exit().  That can confuse things.  In particular, if BSD
process accounting is enabled, then do_exit() writes data to an
accounting file.  If that file has FS_SYNC_FL set, then this write
occurs synchronously and can misbehave if PF_MEMALLOC is set.

For example, if the accounting file is located on an XFS filesystem,
then a WARN_ON_ONCE() in iomap_do_writepage() is triggered and the data
doesn't get written when it should.  Or if the accounting file is
located on an ext4 filesystem without a journal, then a WARN_ON_ONCE()
in ext4_write_inode() is triggered and the inode doesn't get written.

Fix this in xfsaild() by using the helper functions to save and restore
PF_MEMALLOC.

This can be reproduced as follows in the kvm-xfstests test appliance
modified to add the 'acct' Debian package, and with kvm-xfstests's
recommended kconfig modified to add CONFIG_BSD_PROCESS_ACCT=y:

        mkfs.xfs -f /dev/vdb
        mount /vdb
        touch /vdb/file
        chattr +S /vdb/file
        accton /vdb/file
        mkfs.xfs -f /dev/vdc
        mount /vdc
        umount /vdc

It causes:
	WARNING: CPU: 1 PID: 336 at fs/iomap/buffered-io.c:1534
	CPU: 1 PID: 336 Comm: xfsaild/vdc Not tainted 5.6.0-rc5 #3
	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20191223_100556-anatol 04/01/2014
	RIP: 0010:iomap_do_writepage+0x16b/0x1f0 fs/iomap/buffered-io.c:1534
	[...]
	Call Trace:
	 write_cache_pages+0x189/0x4d0 mm/page-writeback.c:2238
	 iomap_writepages+0x1c/0x33 fs/iomap/buffered-io.c:1642
	 xfs_vm_writepages+0x65/0x90 fs/xfs/xfs_aops.c:578
	 do_writepages+0x41/0xe0 mm/page-writeback.c:2344
	 __filemap_fdatawrite_range+0xd2/0x120 mm/filemap.c:421
	 file_write_and_wait_range+0x71/0xc0 mm/filemap.c:760
	 xfs_file_fsync+0x7a/0x2b0 fs/xfs/xfs_file.c:114
	 generic_write_sync include/linux/fs.h:2867 [inline]
	 xfs_file_buffered_aio_write+0x379/0x3b0 fs/xfs/xfs_file.c:691
	 call_write_iter include/linux/fs.h:1901 [inline]
	 new_sync_write+0x130/0x1d0 fs/read_write.c:483
	 __kernel_write+0x54/0xe0 fs/read_write.c:515
	 do_acct_process+0x122/0x170 kernel/acct.c:522
	 slow_acct_process kernel/acct.c:581 [inline]
	 acct_process+0x1d4/0x27c kernel/acct.c:607
	 do_exit+0x83d/0xbc0 kernel/exit.c:791
	 kthread+0xf1/0x140 kernel/kthread.c:257
	 ret_from_fork+0x27/0x50 arch/x86/entry/entry_64.S:352

This bug was originally reported by syzbot at
https://lore.kernel.org/r/0000000000000e7156059f751d7b@google.com.

Reported-by: syzbot+1f9dc49e8de2582d90c2@syzkaller.appspotmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_trans_ail.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 6ccfd75d3c24c..812108f6cc89c 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -529,8 +529,9 @@ xfsaild(
 {
 	struct xfs_ail	*ailp = data;
 	long		tout = 0;	/* milliseconds */
+	unsigned int	noreclaim_flag;
 
-	current->flags |= PF_MEMALLOC;
+	noreclaim_flag = memalloc_noreclaim_save();
 	set_freezable();
 
 	while (1) {
@@ -601,6 +602,7 @@ xfsaild(
 		tout = xfsaild_push(ailp);
 	}
 
+	memalloc_noreclaim_restore(noreclaim_flag);
 	return 0;
 }
 
-- 
2.20.1

