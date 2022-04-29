Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37EDC514751
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357791AbiD2Ksv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358053AbiD2KsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:48:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0362C84B2;
        Fri, 29 Apr 2022 03:43:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBF4660BA5;
        Fri, 29 Apr 2022 10:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EB5C385A4;
        Fri, 29 Apr 2022 10:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651229014;
        bh=nnfvOnNGka4zh7w46LWvpE0PKWh++xKrwUJFuEWuuec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3YqYmI+SQvQtdPXSRP1bwaQ3jr4XDFDK6nBXSmH6GMGwG8lsV56klQCvDCLF+ztH
         lonv5vdViyJ1VSzdmfALydgEjbz7BhRkb5avdLm6DMf5OfJhjDBmKUtNonwwWUMNxZ
         +B15swDAc6kzBSpXoanH++8GOiLy1k7H+DwC/+uQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.15 30/33] btrfs: fix deadlock due to page faults during direct IO reads and writes
Date:   Fri, 29 Apr 2022 12:42:17 +0200
Message-Id: <20220429104053.211404458@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
References: <20220429104052.345760505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 51bd9563b6783de8315f38f7baed949e77c42311 upstream

If we do a direct IO read or write when the buffer given by the user is
memory mapped to the file range we are going to do IO, we end up ending
in a deadlock. This is triggered by the new test case generic/647 from
fstests.

For a direct IO read we get a trace like this:

  [967.872718] INFO: task mmap-rw-fault:12176 blocked for more than 120 seconds.
  [967.874161]       Not tainted 5.14.0-rc7-btrfs-next-95 #1
  [967.874909] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [967.875983] task:mmap-rw-fault   state:D stack:    0 pid:12176 ppid: 11884 flags:0x00000000
  [967.875992] Call Trace:
  [967.875999]  __schedule+0x3ca/0xe10
  [967.876015]  schedule+0x43/0xe0
  [967.876020]  wait_extent_bit.constprop.0+0x1eb/0x260 [btrfs]
  [967.876109]  ? do_wait_intr_irq+0xb0/0xb0
  [967.876118]  lock_extent_bits+0x37/0x90 [btrfs]
  [967.876150]  btrfs_lock_and_flush_ordered_range+0xa9/0x120 [btrfs]
  [967.876184]  ? extent_readahead+0xa7/0x530 [btrfs]
  [967.876214]  extent_readahead+0x32d/0x530 [btrfs]
  [967.876253]  ? lru_cache_add+0x104/0x220
  [967.876255]  ? kvm_sched_clock_read+0x14/0x40
  [967.876258]  ? sched_clock_cpu+0xd/0x110
  [967.876263]  ? lock_release+0x155/0x4a0
  [967.876271]  read_pages+0x86/0x270
  [967.876274]  ? lru_cache_add+0x125/0x220
  [967.876281]  page_cache_ra_unbounded+0x1a3/0x220
  [967.876291]  filemap_fault+0x626/0xa20
  [967.876303]  __do_fault+0x36/0xf0
  [967.876308]  __handle_mm_fault+0x83f/0x15f0
  [967.876322]  handle_mm_fault+0x9e/0x260
  [967.876327]  __get_user_pages+0x204/0x620
  [967.876332]  ? get_user_pages_unlocked+0x69/0x340
  [967.876340]  get_user_pages_unlocked+0xd3/0x340
  [967.876349]  internal_get_user_pages_fast+0xbca/0xdc0
  [967.876366]  iov_iter_get_pages+0x8d/0x3a0
  [967.876374]  bio_iov_iter_get_pages+0x82/0x4a0
  [967.876379]  ? lock_release+0x155/0x4a0
  [967.876387]  iomap_dio_bio_actor+0x232/0x410
  [967.876396]  iomap_apply+0x12a/0x4a0
  [967.876398]  ? iomap_dio_rw+0x30/0x30
  [967.876414]  __iomap_dio_rw+0x29f/0x5e0
  [967.876415]  ? iomap_dio_rw+0x30/0x30
  [967.876420]  ? lock_acquired+0xf3/0x420
  [967.876429]  iomap_dio_rw+0xa/0x30
  [967.876431]  btrfs_file_read_iter+0x10b/0x140 [btrfs]
  [967.876460]  new_sync_read+0x118/0x1a0
  [967.876472]  vfs_read+0x128/0x1b0
  [967.876477]  __x64_sys_pread64+0x90/0xc0
  [967.876483]  do_syscall_64+0x3b/0xc0
  [967.876487]  entry_SYSCALL_64_after_hwframe+0x44/0xae
  [967.876490] RIP: 0033:0x7fb6f2c038d6
  [967.876493] RSP: 002b:00007fffddf586b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
  [967.876496] RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007fb6f2c038d6
  [967.876498] RDX: 0000000000001000 RSI: 00007fb6f2c17000 RDI: 0000000000000003
  [967.876499] RBP: 0000000000001000 R08: 0000000000000003 R09: 0000000000000000
  [967.876501] R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000003
  [967.876502] R13: 0000000000000000 R14: 00007fb6f2c17000 R15: 0000000000000000

This happens because at btrfs_dio_iomap_begin() we lock the extent range
and return with it locked - we only unlock in the endio callback, at
end_bio_extent_readpage() -> endio_readpage_release_extent(). Then after
iomap called the btrfs_dio_iomap_begin() callback, it triggers the page
faults that resulting in reading the pages, through the readahead callback
btrfs_readahead(), and through there we end to attempt to lock again the
same extent range (or a subrange of what we locked before), resulting in
the deadlock.

For a direct IO write, the scenario is a bit different, and it results in
trace like this:

  [1132.442520] run fstests generic/647 at 2021-08-31 18:53:35
  [1330.349355] INFO: task mmap-rw-fault:184017 blocked for more than 120 seconds.
  [1330.350540]       Not tainted 5.14.0-rc7-btrfs-next-95 #1
  [1330.351158] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [1330.351900] task:mmap-rw-fault   state:D stack:    0 pid:184017 ppid:183725 flags:0x00000000
  [1330.351906] Call Trace:
  [1330.351913]  __schedule+0x3ca/0xe10
  [1330.351930]  schedule+0x43/0xe0
  [1330.351935]  btrfs_start_ordered_extent+0x108/0x1c0 [btrfs]
  [1330.352020]  ? do_wait_intr_irq+0xb0/0xb0
  [1330.352028]  btrfs_lock_and_flush_ordered_range+0x8c/0x120 [btrfs]
  [1330.352064]  ? extent_readahead+0xa7/0x530 [btrfs]
  [1330.352094]  extent_readahead+0x32d/0x530 [btrfs]
  [1330.352133]  ? lru_cache_add+0x104/0x220
  [1330.352135]  ? kvm_sched_clock_read+0x14/0x40
  [1330.352138]  ? sched_clock_cpu+0xd/0x110
  [1330.352143]  ? lock_release+0x155/0x4a0
  [1330.352151]  read_pages+0x86/0x270
  [1330.352155]  ? lru_cache_add+0x125/0x220
  [1330.352162]  page_cache_ra_unbounded+0x1a3/0x220
  [1330.352172]  filemap_fault+0x626/0xa20
  [1330.352176]  ? filemap_map_pages+0x18b/0x660
  [1330.352184]  __do_fault+0x36/0xf0
  [1330.352189]  __handle_mm_fault+0x1253/0x15f0
  [1330.352203]  handle_mm_fault+0x9e/0x260
  [1330.352208]  __get_user_pages+0x204/0x620
  [1330.352212]  ? get_user_pages_unlocked+0x69/0x340
  [1330.352220]  get_user_pages_unlocked+0xd3/0x340
  [1330.352229]  internal_get_user_pages_fast+0xbca/0xdc0
  [1330.352246]  iov_iter_get_pages+0x8d/0x3a0
  [1330.352254]  bio_iov_iter_get_pages+0x82/0x4a0
  [1330.352259]  ? lock_release+0x155/0x4a0
  [1330.352266]  iomap_dio_bio_actor+0x232/0x410
  [1330.352275]  iomap_apply+0x12a/0x4a0
  [1330.352278]  ? iomap_dio_rw+0x30/0x30
  [1330.352292]  __iomap_dio_rw+0x29f/0x5e0
  [1330.352294]  ? iomap_dio_rw+0x30/0x30
  [1330.352306]  btrfs_file_write_iter+0x238/0x480 [btrfs]
  [1330.352339]  new_sync_write+0x11f/0x1b0
  [1330.352344]  ? NF_HOOK_LIST.constprop.0.cold+0x31/0x3e
  [1330.352354]  vfs_write+0x292/0x3c0
  [1330.352359]  __x64_sys_pwrite64+0x90/0xc0
  [1330.352365]  do_syscall_64+0x3b/0xc0
  [1330.352369]  entry_SYSCALL_64_after_hwframe+0x44/0xae
  [1330.352372] RIP: 0033:0x7f4b0a580986
  [1330.352379] RSP: 002b:00007ffd34d75418 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
  [1330.352382] RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f4b0a580986
  [1330.352383] RDX: 0000000000001000 RSI: 00007f4b0a3a4000 RDI: 0000000000000003
  [1330.352385] RBP: 00007f4b0a3a4000 R08: 0000000000000003 R09: 0000000000000000
  [1330.352386] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
  [1330.352387] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Unlike for reads, at btrfs_dio_iomap_begin() we return with the extent
range unlocked, but later when the page faults are triggered and we try
to read the extents, we end up btrfs_lock_and_flush_ordered_range() where
we find the ordered extent for our write, created by the iomap callback
btrfs_dio_iomap_begin(), and we wait for it to complete, which makes us
deadlock since we can't complete the ordered extent without reading the
pages (the iomap code only submits the bio after the pages are faulted
in).

Fix this by setting the nofault attribute of the given iov_iter and retry
the direct IO read/write if we get an -EFAULT error returned from iomap.
For reads, also disable page faults completely, this is because when we
read from a hole or a prealloc extent, we can still trigger page faults
due to the call to iov_iter_zero() done by iomap - at the moment, it is
oblivious to the value of the ->nofault attribute of an iov_iter.
We also need to keep track of the number of bytes written or read, and
pass it to iomap_dio_rw(), as well as use the new flag IOMAP_DIO_PARTIAL.

This depends on the iov_iter and iomap changes introduced in commit
c03098d4b9ad ("Merge tag 'gfs2-v5.15-rc5-mmap-fault' of
git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2").

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |  139 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 123 insertions(+), 16 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1903,16 +1903,17 @@ static ssize_t check_direct_IO(struct bt
 
 static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 {
+	const bool is_sync_write = (iocb->ki_flags & IOCB_DSYNC);
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	loff_t pos;
 	ssize_t written = 0;
 	ssize_t written_buffered;
+	size_t prev_left = 0;
 	loff_t endbyte;
 	ssize_t err;
 	unsigned int ilock_flags = 0;
-	struct iomap_dio *dio = NULL;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		ilock_flags |= BTRFS_ILOCK_TRY;
@@ -1955,23 +1956,80 @@ relock:
 		goto buffered;
 	}
 
-	dio = __iomap_dio_rw(iocb, from, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			     0, 0);
+	/*
+	 * We remove IOCB_DSYNC so that we don't deadlock when iomap_dio_rw()
+	 * calls generic_write_sync() (through iomap_dio_complete()), because
+	 * that results in calling fsync (btrfs_sync_file()) which will try to
+	 * lock the inode in exclusive/write mode.
+	 */
+	if (is_sync_write)
+		iocb->ki_flags &= ~IOCB_DSYNC;
+
+	/*
+	 * The iov_iter can be mapped to the same file range we are writing to.
+	 * If that's the case, then we will deadlock in the iomap code, because
+	 * it first calls our callback btrfs_dio_iomap_begin(), which will create
+	 * an ordered extent, and after that it will fault in the pages that the
+	 * iov_iter refers to. During the fault in we end up in the readahead
+	 * pages code (starting at btrfs_readahead()), which will lock the range,
+	 * find that ordered extent and then wait for it to complete (at
+	 * btrfs_lock_and_flush_ordered_range()), resulting in a deadlock since
+	 * obviously the ordered extent can never complete as we didn't submit
+	 * yet the respective bio(s). This always happens when the buffer is
+	 * memory mapped to the same file range, since the iomap DIO code always
+	 * invalidates pages in the target file range (after starting and waiting
+	 * for any writeback).
+	 *
+	 * So here we disable page faults in the iov_iter and then retry if we
+	 * got -EFAULT, faulting in the pages before the retry.
+	 */
+again:
+	from->nofault = true;
+	err = iomap_dio_rw(iocb, from, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
+			   IOMAP_DIO_PARTIAL, written);
+	from->nofault = false;
+
+	/* No increment (+=) because iomap returns a cumulative value. */
+	if (err > 0)
+		written = err;
+
+	if (iov_iter_count(from) > 0 && (err == -EFAULT || err > 0)) {
+		const size_t left = iov_iter_count(from);
+		/*
+		 * We have more data left to write. Try to fault in as many as
+		 * possible of the remainder pages and retry. We do this without
+		 * releasing and locking again the inode, to prevent races with
+		 * truncate.
+		 *
+		 * Also, in case the iov refers to pages in the file range of the
+		 * file we want to write to (due to a mmap), we could enter an
+		 * infinite loop if we retry after faulting the pages in, since
+		 * iomap will invalidate any pages in the range early on, before
+		 * it tries to fault in the pages of the iov. So we keep track of
+		 * how much was left of iov in the previous EFAULT and fallback
+		 * to buffered IO in case we haven't made any progress.
+		 */
+		if (left == prev_left) {
+			err = -ENOTBLK;
+		} else {
+			fault_in_iov_iter_readable(from, left);
+			prev_left = left;
+			goto again;
+		}
+	}
 
 	btrfs_inode_unlock(inode, ilock_flags);
 
-	if (IS_ERR_OR_NULL(dio)) {
-		err = PTR_ERR_OR_ZERO(dio);
-		if (err < 0 && err != -ENOTBLK)
-			goto out;
-	} else {
-		written = iomap_dio_complete(dio);
-	}
+	/*
+	 * Add back IOCB_DSYNC. Our caller, btrfs_file_write_iter(), will do
+	 * the fsync (call generic_write_sync()).
+	 */
+	if (is_sync_write)
+		iocb->ki_flags |= IOCB_DSYNC;
 
-	if (written < 0 || !iov_iter_count(from)) {
-		err = written;
+	/* If 'err' is -ENOTBLK then it means we must fallback to buffered IO. */
+	if ((err < 0 && err != -ENOTBLK) || !iov_iter_count(from))
 		goto out;
-	}
 
 buffered:
 	pos = iocb->ki_pos;
@@ -1996,7 +2054,7 @@ buffered:
 	invalidate_mapping_pages(file->f_mapping, pos >> PAGE_SHIFT,
 				 endbyte >> PAGE_SHIFT);
 out:
-	return written ? written : err;
+	return err < 0 ? err : written;
 }
 
 static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
@@ -3659,6 +3717,8 @@ static int check_direct_read(struct btrf
 static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
+	size_t prev_left = 0;
+	ssize_t read = 0;
 	ssize_t ret;
 
 	if (fsverity_active(inode))
@@ -3668,10 +3728,57 @@ static ssize_t btrfs_direct_read(struct
 		return 0;
 
 	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);
+again:
+	/*
+	 * This is similar to what we do for direct IO writes, see the comment
+	 * at btrfs_direct_write(), but we also disable page faults in addition
+	 * to disabling them only at the iov_iter level. This is because when
+	 * reading from a hole or prealloc extent, iomap calls iov_iter_zero(),
+	 * which can still trigger page fault ins despite having set ->nofault
+	 * to true of our 'to' iov_iter.
+	 *
+	 * The difference to direct IO writes is that we deadlock when trying
+	 * to lock the extent range in the inode's tree during he page reads
+	 * triggered by the fault in (while for writes it is due to waiting for
+	 * our own ordered extent). This is because for direct IO reads,
+	 * btrfs_dio_iomap_begin() returns with the extent range locked, which
+	 * is only unlocked in the endio callback (end_bio_extent_readpage()).
+	 */
+	pagefault_disable();
+	to->nofault = true;
 	ret = iomap_dio_rw(iocb, to, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			   0, 0);
+			   IOMAP_DIO_PARTIAL, read);
+	to->nofault = false;
+	pagefault_enable();
+
+	/* No increment (+=) because iomap returns a cumulative value. */
+	if (ret > 0)
+		read = ret;
+
+	if (iov_iter_count(to) > 0 && (ret == -EFAULT || ret > 0)) {
+		const size_t left = iov_iter_count(to);
+
+		if (left == prev_left) {
+			/*
+			 * We didn't make any progress since the last attempt,
+			 * fallback to a buffered read for the remainder of the
+			 * range. This is just to avoid any possibility of looping
+			 * for too long.
+			 */
+			ret = read;
+		} else {
+			/*
+			 * We made some progress since the last retry or this is
+			 * the first time we are retrying. Fault in as many pages
+			 * as possible and retry.
+			 */
+			fault_in_iov_iter_writeable(to, left);
+			prev_left = left;
+			goto again;
+		}
+	}
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
-	return ret;
+	return ret < 0 ? ret : read;
 }
 
 static ssize_t btrfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)


