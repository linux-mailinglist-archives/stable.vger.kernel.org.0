Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CAA261823
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgIHRtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731607AbgIHQN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:13:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 291F6248CE;
        Tue,  8 Sep 2020 15:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580362;
        bh=DHGVj0WnE/Y7vRO8rn1wQCKkH4+RJGGfZKkBZ3YBJ5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0LmVk5fDLAZYA3iq1ynsVeZXYpTagzZuYa3nUWGVt3VEMEYJNgvjBHgVQrBp31vf
         j2pSTfNQXXsNq5GJGNzevX7ZVYWc6d+a8/3EMOckh8KxI41OW5PDULoHiw+LTmRnAw
         yyPDD9aIzmmYw1TDwQtdQKxEc2/H0o8GrvJCxozo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 44/65] btrfs: fix potential deadlock in the search ioctl
Date:   Tue,  8 Sep 2020 17:26:29 +0200
Message-Id: <20200908152219.316437880@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit a48b73eca4ceb9b8a4b97f290a065335dbcd8a04 ]

With the conversion of the tree locks to rwsem I got the following
lockdep splat:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.8.0-rc7-00165-g04ec4da5f45f-dirty #922 Not tainted
  ------------------------------------------------------
  compsize/11122 is trying to acquire lock:
  ffff889fabca8768 (&mm->mmap_lock#2){++++}-{3:3}, at: __might_fault+0x3e/0x90

  but task is already holding lock:
  ffff889fe720fe40 (btrfs-fs-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x39/0x180

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #2 (btrfs-fs-00){++++}-{3:3}:
	 down_write_nested+0x3b/0x70
	 __btrfs_tree_lock+0x24/0x120
	 btrfs_search_slot+0x756/0x990
	 btrfs_lookup_inode+0x3a/0xb4
	 __btrfs_update_delayed_inode+0x93/0x270
	 btrfs_async_run_delayed_root+0x168/0x230
	 btrfs_work_helper+0xd4/0x570
	 process_one_work+0x2ad/0x5f0
	 worker_thread+0x3a/0x3d0
	 kthread+0x133/0x150
	 ret_from_fork+0x1f/0x30

  -> #1 (&delayed_node->mutex){+.+.}-{3:3}:
	 __mutex_lock+0x9f/0x930
	 btrfs_delayed_update_inode+0x50/0x440
	 btrfs_update_inode+0x8a/0xf0
	 btrfs_dirty_inode+0x5b/0xd0
	 touch_atime+0xa1/0xd0
	 btrfs_file_mmap+0x3f/0x60
	 mmap_region+0x3a4/0x640
	 do_mmap+0x376/0x580
	 vm_mmap_pgoff+0xd5/0x120
	 ksys_mmap_pgoff+0x193/0x230
	 do_syscall_64+0x50/0x90
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #0 (&mm->mmap_lock#2){++++}-{3:3}:
	 __lock_acquire+0x1272/0x2310
	 lock_acquire+0x9e/0x360
	 __might_fault+0x68/0x90
	 _copy_to_user+0x1e/0x80
	 copy_to_sk.isra.32+0x121/0x300
	 search_ioctl+0x106/0x200
	 btrfs_ioctl_tree_search_v2+0x7b/0xf0
	 btrfs_ioctl+0x106f/0x30a0
	 ksys_ioctl+0x83/0xc0
	 __x64_sys_ioctl+0x16/0x20
	 do_syscall_64+0x50/0x90
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  other info that might help us debug this:

  Chain exists of:
    &mm->mmap_lock#2 --> &delayed_node->mutex --> btrfs-fs-00

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(btrfs-fs-00);
				 lock(&delayed_node->mutex);
				 lock(btrfs-fs-00);
    lock(&mm->mmap_lock#2);

   *** DEADLOCK ***

  1 lock held by compsize/11122:
   #0: ffff889fe720fe40 (btrfs-fs-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x39/0x180

  stack backtrace:
  CPU: 17 PID: 11122 Comm: compsize Kdump: loaded Not tainted 5.8.0-rc7-00165-g04ec4da5f45f-dirty #922
  Hardware name: Quanta Tioga Pass Single Side 01-0030993006/Tioga Pass Single Side, BIOS F08_3A18 12/20/2018
  Call Trace:
   dump_stack+0x78/0xa0
   check_noncircular+0x165/0x180
   __lock_acquire+0x1272/0x2310
   lock_acquire+0x9e/0x360
   ? __might_fault+0x3e/0x90
   ? find_held_lock+0x72/0x90
   __might_fault+0x68/0x90
   ? __might_fault+0x3e/0x90
   _copy_to_user+0x1e/0x80
   copy_to_sk.isra.32+0x121/0x300
   ? btrfs_search_forward+0x2a6/0x360
   search_ioctl+0x106/0x200
   btrfs_ioctl_tree_search_v2+0x7b/0xf0
   btrfs_ioctl+0x106f/0x30a0
   ? __do_sys_newfstat+0x5a/0x70
   ? ksys_ioctl+0x83/0xc0
   ksys_ioctl+0x83/0xc0
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x50/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

The problem is we're doing a copy_to_user() while holding tree locks,
which can deadlock if we have to do a page fault for the copy_to_user().
This exists even without my locking changes, so it needs to be fixed.
Rework the search ioctl to do the pre-fault and then
copy_to_user_nofault for the copying.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c |  8 ++++----
 fs/btrfs/extent_io.h |  6 +++---
 fs/btrfs/ioctl.c     | 27 ++++++++++++++++++++-------
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ef1fd6a09d8e5..0ba338cffa937 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5448,9 +5448,9 @@ void read_extent_buffer(const struct extent_buffer *eb, void *dstv,
 	}
 }
 
-int read_extent_buffer_to_user(const struct extent_buffer *eb,
-			       void __user *dstv,
-			       unsigned long start, unsigned long len)
+int read_extent_buffer_to_user_nofault(const struct extent_buffer *eb,
+				       void __user *dstv,
+				       unsigned long start, unsigned long len)
 {
 	size_t cur;
 	size_t offset;
@@ -5471,7 +5471,7 @@ int read_extent_buffer_to_user(const struct extent_buffer *eb,
 
 		cur = min(len, (PAGE_SIZE - offset));
 		kaddr = page_address(page);
-		if (copy_to_user(dst, kaddr + offset, cur)) {
+		if (probe_user_write(dst, kaddr + offset, cur)) {
 			ret = -EFAULT;
 			break;
 		}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index e5535bbe69537..90c5095ae97ee 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -455,9 +455,9 @@ int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
 void read_extent_buffer(const struct extent_buffer *eb, void *dst,
 			unsigned long start,
 			unsigned long len);
-int read_extent_buffer_to_user(const struct extent_buffer *eb,
-			       void __user *dst, unsigned long start,
-			       unsigned long len);
+int read_extent_buffer_to_user_nofault(const struct extent_buffer *eb,
+				       void __user *dst, unsigned long start,
+				       unsigned long len);
 void write_extent_buffer_fsid(struct extent_buffer *eb, const void *src);
 void write_extent_buffer_chunk_tree_uuid(struct extent_buffer *eb,
 		const void *src);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e82b4f3f490c1..7b3e41987d072 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2021,9 +2021,14 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 		sh.len = item_len;
 		sh.transid = found_transid;
 
-		/* copy search result header */
-		if (copy_to_user(ubuf + *sk_offset, &sh, sizeof(sh))) {
-			ret = -EFAULT;
+		/*
+		 * Copy search result header. If we fault then loop again so we
+		 * can fault in the pages and -EFAULT there if there's a
+		 * problem. Otherwise we'll fault and then copy the buffer in
+		 * properly this next time through
+		 */
+		if (probe_user_write(ubuf + *sk_offset, &sh, sizeof(sh))) {
+			ret = 0;
 			goto out;
 		}
 
@@ -2031,10 +2036,14 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 
 		if (item_len) {
 			char __user *up = ubuf + *sk_offset;
-			/* copy the item */
-			if (read_extent_buffer_to_user(leaf, up,
-						       item_off, item_len)) {
-				ret = -EFAULT;
+			/*
+			 * Copy the item, same behavior as above, but reset the
+			 * * sk_offset so we copy the full thing again.
+			 */
+			if (read_extent_buffer_to_user_nofault(leaf, up,
+						item_off, item_len)) {
+				ret = 0;
+				*sk_offset -= sizeof(sh);
 				goto out;
 			}
 
@@ -2122,6 +2131,10 @@ static noinline int search_ioctl(struct inode *inode,
 	key.offset = sk->min_offset;
 
 	while (1) {
+		ret = fault_in_pages_writeable(ubuf, *buf_size - sk_offset);
+		if (ret)
+			break;
+
 		ret = btrfs_search_forward(root, &key, path, sk->min_transid);
 		if (ret != 0) {
 			if (ret > 0)
-- 
2.25.1



