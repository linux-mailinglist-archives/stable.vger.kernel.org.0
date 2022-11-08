Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154426214AF
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbiKHOED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235002AbiKHOEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:04:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E17065E7F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:04:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E3C8B81B00
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7C7C433D7;
        Tue,  8 Nov 2022 14:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916237;
        bh=7guEXqoSESA4isc1M1kWZKDX6HffnmCOrMpjspt1RRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuABSXoGXF0n4EONVbJ2QWvLz5wh9g5XEt6OVxSa1gbnQ4aPtUciLv2PVOnnibJet
         l5EDClcPmHgRTELGkC7BiQ5UeoamjULt5bZEpxbadE9JV610rAk8u2nv6jxp+R/3Tm
         2LqNNNZ87J7RPtHxAN9Zu2z6D18KBEqjTaiwm+fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=D0=9C=D0=B0=D1=80=D0=BA=20=D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3?= 
        <socketpair@gmail.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 102/144] btrfs: fix lost file sync on direct IO write with nowait and dsync iocb
Date:   Tue,  8 Nov 2022 14:39:39 +0100
Message-Id: <20221108133349.616406557@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 8184620ae21213d51eaf2e0bd4186baacb928172 upstream.

When doing a direct IO write using a iocb with nowait and dsync set, we
end up not syncing the file once the write completes.

This is because we tell iomap to not call generic_write_sync(), which
would result in calling btrfs_sync_file(), in order to avoid a deadlock
since iomap can call it while we are holding the inode's lock and
btrfs_sync_file() needs to acquire the inode's lock. The deadlock happens
only if the write happens synchronously, when iomap_dio_rw() calls
iomap_dio_complete() before it returns. Instead we do the sync ourselves
at btrfs_do_write_iter().

For a nowait write however we can end up not doing the sync ourselves at
at btrfs_do_write_iter() because the write could have been queued, and
therefore we get -EIOCBQUEUED returned from iomap in such case. That makes
us skip the sync call at btrfs_do_write_iter(), as we don't do it for
any error returned from btrfs_direct_write(). We can't simply do the call
even if -EIOCBQUEUED is returned, since that would block the task waiting
for IO, both for the data since there are bios still in progress as well
as potentially blocking when joining a log transaction and when syncing
the log (writing log trees, super blocks, etc).

So let iomap do the sync call itself and in order to avoid deadlocks for
the case of synchronous writes (without nowait), use __iomap_dio_rw() and
have ourselves call iomap_dio_complete() after unlocking the inode.

A test case will later be sent for fstests, after this is fixed in Linus'
tree.

Fixes: 51bd9563b678 ("btrfs: fix deadlock due to page faults during direct IO reads and writes")
Reported-by: Марк Коренберг <socketpair@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAEmTpZGRKbzc16fWPvxbr6AfFsQoLmz-Lcg-7OgJOZDboJ+SGQ@mail.gmail.com/
CC: stable@vger.kernel.org # 6.0+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |   39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1906,7 +1906,6 @@ static ssize_t check_direct_IO(struct bt
 
 static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 {
-	const bool is_sync_write = (iocb->ki_flags & IOCB_DSYNC);
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -1917,6 +1916,7 @@ static ssize_t btrfs_direct_write(struct
 	loff_t endbyte;
 	ssize_t err;
 	unsigned int ilock_flags = 0;
+	struct iomap_dio *dio;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		ilock_flags |= BTRFS_ILOCK_TRY;
@@ -1960,15 +1960,6 @@ relock:
 	}
 
 	/*
-	 * We remove IOCB_DSYNC so that we don't deadlock when iomap_dio_rw()
-	 * calls generic_write_sync() (through iomap_dio_complete()), because
-	 * that results in calling fsync (btrfs_sync_file()) which will try to
-	 * lock the inode in exclusive/write mode.
-	 */
-	if (is_sync_write)
-		iocb->ki_flags &= ~IOCB_DSYNC;
-
-	/*
 	 * The iov_iter can be mapped to the same file range we are writing to.
 	 * If that's the case, then we will deadlock in the iomap code, because
 	 * it first calls our callback btrfs_dio_iomap_begin(), which will create
@@ -1986,12 +1977,23 @@ relock:
 	 * So here we disable page faults in the iov_iter and then retry if we
 	 * got -EFAULT, faulting in the pages before the retry.
 	 */
-again:
 	from->nofault = true;
-	err = iomap_dio_rw(iocb, from, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			   IOMAP_DIO_PARTIAL, written);
+	dio = __iomap_dio_rw(iocb, from, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
+			     IOMAP_DIO_PARTIAL, written);
 	from->nofault = false;
 
+	/*
+	 * iomap_dio_complete() will call btrfs_sync_file() if we have a dsync
+	 * iocb, and that needs to lock the inode. So unlock it before calling
+	 * iomap_dio_complete() to avoid a deadlock.
+	 */
+	btrfs_inode_unlock(inode, ilock_flags);
+
+	if (IS_ERR_OR_NULL(dio))
+		err = PTR_ERR_OR_ZERO(dio);
+	else
+		err = iomap_dio_complete(dio);
+
 	/* No increment (+=) because iomap returns a cumulative value. */
 	if (err > 0)
 		written = err;
@@ -2017,19 +2019,10 @@ again:
 		} else {
 			fault_in_iov_iter_readable(from, left);
 			prev_left = left;
-			goto again;
+			goto relock;
 		}
 	}
 
-	btrfs_inode_unlock(inode, ilock_flags);
-
-	/*
-	 * Add back IOCB_DSYNC. Our caller, btrfs_file_write_iter(), will do
-	 * the fsync (call generic_write_sync()).
-	 */
-	if (is_sync_write)
-		iocb->ki_flags |= IOCB_DSYNC;
-
 	/* If 'err' is -ENOTBLK then it means we must fallback to buffered IO. */
 	if ((err < 0 && err != -ENOTBLK) || !iov_iter_count(from))
 		goto out;


