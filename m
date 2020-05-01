Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DA71C14DE
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbgEANnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731642AbgEANni (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C22220757;
        Fri,  1 May 2020 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340617;
        bh=r0+dkasYLcoUZBILv3W7IOkelCzd5PwNPf5GSTGG628=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0FTRz5mNay0ENPS9BNKXF64jfOpIrm0JAfDi9cgB9Vk90nhz5hBxFemwdVVHkoro
         lpZpuFn3p3D0NusWexBSyu83WbPS3/kBKWIlUqGZLyQEUouj6UrzyOw7a3okueUtFY
         mhtGJzE80vpqI1di0l7O1AhJSPfq3o6x5reDP8c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1f9dc49e8de2582d90c2@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.6 067/106] xfs: clear PF_MEMALLOC before exiting xfsaild thread
Date:   Fri,  1 May 2020 15:23:40 +0200
Message-Id: <20200501131552.409413979@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 10a98cb16d80be3595fdb165fad898bb28b8b6d2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_trans_ail.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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
 


