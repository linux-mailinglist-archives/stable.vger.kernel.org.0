Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C676215B6
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbiKHOO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiKHOOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:14:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD7559FC2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:14:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB5C1615B2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B87C433C1;
        Tue,  8 Nov 2022 14:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916860;
        bh=jG1EYzMswtq908jgt1WDPenUVQrqH9BzQUVAZzCS2G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCmB/UGtK52iLaVuF0cs4oeeQL4pxmeafk+W0GQQ4UYooH4kRNggBvZQyxDBMnDpg
         WeEEZTQaB/2RsT1lYhPMqA69XKkiT5JOUAHdISxfOFTaR6llSpr2A2CTzdrxRZN+7+
         z7dEG1EuxUP0CdpiJ+N1PdFD7BUriBzd2etzSoFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=D0=9C=D0=B0=D1=80=D0=BA=20=D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3?= 
        <socketpair@gmail.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 127/197] btrfs: fix lost file sync on direct IO write with nowait and dsync iocb
Date:   Tue,  8 Nov 2022 14:39:25 +0100
Message-Id: <20221108133400.745299867@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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
 fs/btrfs/ctree.h |    5 ++++-
 fs/btrfs/file.c  |   22 ++++++++++++++++------
 fs/btrfs/inode.c |   14 +++++++++++---
 3 files changed, 31 insertions(+), 10 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3407,7 +3407,10 @@ ssize_t btrfs_encoded_read(struct kiocb
 ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 			     const struct btrfs_ioctl_encoded_io_args *encoded);
 
-ssize_t btrfs_dio_rw(struct kiocb *iocb, struct iov_iter *iter, size_t done_before);
+ssize_t btrfs_dio_read(struct kiocb *iocb, struct iov_iter *iter,
+		       size_t done_before);
+struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *iter,
+				  size_t done_before);
 
 extern const struct dentry_operations btrfs_dentry_operations;
 
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1889,6 +1889,7 @@ static ssize_t btrfs_direct_write(struct
 	loff_t endbyte;
 	ssize_t err;
 	unsigned int ilock_flags = 0;
+	struct iomap_dio *dio;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		ilock_flags |= BTRFS_ILOCK_TRY;
@@ -1949,11 +1950,22 @@ relock:
 	 * So here we disable page faults in the iov_iter and then retry if we
 	 * got -EFAULT, faulting in the pages before the retry.
 	 */
-again:
 	from->nofault = true;
-	err = btrfs_dio_rw(iocb, from, written);
+	dio = btrfs_dio_write(iocb, from, written);
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
@@ -1979,12 +1991,10 @@ again:
 		} else {
 			fault_in_iov_iter_readable(from, left);
 			prev_left = left;
-			goto again;
+			goto relock;
 		}
 	}
 
-	btrfs_inode_unlock(inode, ilock_flags);
-
 	/*
 	 * If 'err' is -ENOTBLK or we have not written all data, then it means
 	 * we must fallback to buffered IO.
@@ -3787,7 +3797,7 @@ again:
 	 */
 	pagefault_disable();
 	to->nofault = true;
-	ret = btrfs_dio_rw(iocb, to, read);
+	ret = btrfs_dio_read(iocb, to, read);
 	to->nofault = false;
 	pagefault_enable();
 
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8241,13 +8241,21 @@ static const struct iomap_dio_ops btrfs_
 	.bio_set		= &btrfs_dio_bioset,
 };
 
-ssize_t btrfs_dio_rw(struct kiocb *iocb, struct iov_iter *iter, size_t done_before)
+ssize_t btrfs_dio_read(struct kiocb *iocb, struct iov_iter *iter, size_t done_before)
 {
 	struct btrfs_dio_data data;
 
 	return iomap_dio_rw(iocb, iter, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			    IOMAP_DIO_PARTIAL | IOMAP_DIO_NOSYNC,
-			    &data, done_before);
+			    IOMAP_DIO_PARTIAL, &data, done_before);
+}
+
+struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *iter,
+				  size_t done_before)
+{
+	struct btrfs_dio_data data;
+
+	return __iomap_dio_rw(iocb, iter, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
+			    IOMAP_DIO_PARTIAL, &data, done_before);
 }
 
 static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,


