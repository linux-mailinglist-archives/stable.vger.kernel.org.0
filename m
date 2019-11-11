Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D58CF7CBB
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbfKKStK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:49:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:42408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728780AbfKKStJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:49:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F63720674;
        Mon, 11 Nov 2019 18:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498147;
        bh=A3UG/NLE7UzB2+sC2aVVUfUlyAS3/SAt7X4msgYQ9WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBGfygufXwDKr3kXL4CW1I2zKgHOOze6Rp3Mv6ox9Uddl9d8UcXZTc2CjN06eHi/S
         0p2JTgzAVj92xkFmS9MrHIeyToqYnK/eib3mxHSmkX75s4A3zdM/w92bSzicpEVY/9
         fJocc/N7FQKKtAuQM0GXHEENHNCJMJ3jDacaUvqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 037/193] btrfs: save i_size to avoid double evaluation of i_size_read in compress_file_range
Date:   Mon, 11 Nov 2019 19:26:59 +0100
Message-Id: <20191111181503.740803361@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit d98da49977f67394db492f06c00b1fb1cc090c05 upstream.

We hit a regression while rolling out 5.2 internally where we were
hitting the following panic

  kernel BUG at mm/page-writeback.c:2659!
  RIP: 0010:clear_page_dirty_for_io+0xe6/0x1f0
  Call Trace:
   __process_pages_contig+0x25a/0x350
   ? extent_clear_unlock_delalloc+0x43/0x70
   submit_compressed_extents+0x359/0x4d0
   normal_work_helper+0x15a/0x330
   process_one_work+0x1f5/0x3f0
   worker_thread+0x2d/0x3d0
   ? rescuer_thread+0x340/0x340
   kthread+0x111/0x130
   ? kthread_create_on_node+0x60/0x60
   ret_from_fork+0x1f/0x30

This is happening because the page is not locked when doing
clear_page_dirty_for_io.  Looking at the core dump it was because our
async_extent had a ram_size of 24576 but our async_chunk range only
spanned 20480, so we had a whole extra page in our ram_size for our
async_extent.

This happened because we try not to compress pages outside of our
i_size, however a cleanup patch changed us to do

actual_end = min_t(u64, i_size_read(inode), end + 1);

which is problematic because i_size_read() can evaluate to different
values in between checking and assigning.  So either an expanding
truncate or a fallocate could increase our i_size while we're doing
writeout and actual_end would end up being past the range we have
locked.

I confirmed this was what was happening by installing a debug kernel
that had

  actual_end = min_t(u64, i_size_read(inode), end + 1);
  if (actual_end > end + 1) {
	  printk(KERN_ERR "KABOOM\n");
	  actual_end = end + 1;
  }

and installing it onto 500 boxes of the tier that had been seeing the
problem regularly.  Last night I got my debug message and no panic,
confirming what I expected.

[ dsterba: the assembly confirms a tiny race window:

    mov    0x20(%rsp),%rax
    cmp    %rax,0x48(%r15)           # read
    movl   $0x0,0x18(%rsp)
    mov    %rax,%r12
    mov    %r14,%rax
    cmovbe 0x48(%r15),%r12           # eval

  Where r15 is inode and 0x48 is offset of i_size.

  The original fix was to revert 62b37622718c that would do an
  intermediate assignment and this would also avoid the doulble
  evaluation but is not future-proof, should the compiler merge the
  stores and call i_size_read anyway.

  There's a patch adding READ_ONCE to i_size_read but that's not being
  applied at the moment and we need to fix the bug. Instead, emulate
  READ_ONCE by two barrier()s that's what effectively happens. The
  assembly confirms single evaluation:

    mov    0x48(%rbp),%rax          # read once
    mov    0x20(%rsp),%rcx
    mov    $0x20,%edx
    cmp    %rax,%rcx
    cmovbe %rcx,%rax
    mov    %rax,(%rsp)
    mov    %rax,%rcx
    mov    %r14,%rax

  Where 0x48(%rbp) is inode->i_size stored to %eax.
]

Fixes: 62b37622718c ("btrfs: Remove isize local variable in compress_file_range")
CC: stable@vger.kernel.org # v5.1+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ changelog updated ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -472,6 +472,7 @@ static noinline void compress_file_range
 	u64 start = async_chunk->start;
 	u64 end = async_chunk->end;
 	u64 actual_end;
+	u64 i_size;
 	int ret = 0;
 	struct page **pages = NULL;
 	unsigned long nr_pages;
@@ -485,7 +486,19 @@ static noinline void compress_file_range
 	inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1,
 			SZ_16K);
 
-	actual_end = min_t(u64, i_size_read(inode), end + 1);
+	/*
+	 * We need to save i_size before now because it could change in between
+	 * us evaluating the size and assigning it.  This is because we lock and
+	 * unlock the page in truncate and fallocate, and then modify the i_size
+	 * later on.
+	 *
+	 * The barriers are to emulate READ_ONCE, remove that once i_size_read
+	 * does that for us.
+	 */
+	barrier();
+	i_size = i_size_read(inode);
+	barrier();
+	actual_end = min_t(u64, i_size, end + 1);
 again:
 	will_compress = 0;
 	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;


