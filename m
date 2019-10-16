Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62073D9254
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 15:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388141AbfJPNVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 09:21:50 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52585 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729306AbfJPNVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 09:21:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6552A21B4C;
        Wed, 16 Oct 2019 09:21:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 16 Oct 2019 09:21:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=AwECeG
        E1S8pTUp26BEnG9jkbAZ0RmAPLqKvuROQVImA=; b=FKC5hkPPSf+c7g5KJnFqru
        Y9GYqogCEWGDHtgh27ScLllG+8ALvV5+boBDzTL+tvlMOYroHrM/+OrFf8DZTUIw
        uMpcNMS4YcJU86JPjI5CTo+kXOEh7nzpGnAA0nCV2amjuXX1e5Pv3h1NIaxrKWGL
        DIaHaowaAJzlV7yyXkDi7ZHQAG+PQg3EdGD7pHHM6+mFnl/52PtPtAbElI5lPeQ/
        NIzQQ0xMWyT+C/kmRmRovcsZRwPw3N4Pgx6FDpHVcRRdaImilHmjGgRLlgW79Qnu
        JVXH4vuR9iUEzwLIoYp3GhHu65jvvv+0J7L7PGb/yRwE/+Efj2jrtmWNK5zINNCA
        ==
X-ME-Sender: <xms:bRmnXZmtvxrCwSkmz2ZGFdy9aVIjizv4OvfQYJHxpPaTH-ZO9TuZnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeehgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepvddtledrudefiedrvdefiedrleegnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:bRmnXVQWQmIFPEHi8wI8BdVMSwP3dsyXt-ToseliWuQef1ulN8l30w>
    <xmx:bRmnXQX2qWxNDf95WZ0F7febDZwmlnxhoi_lRGyxzyxSwdzdY5gpMA>
    <xmx:bRmnXRIlzpEIJzkoyjKMw5oNlieuEPdU9m6_4eN37YxDm-6uktyvDA>
    <xmx:bRmnXYARmxaSLGjGde9Zv4iSlITxmIc7KL4b8psL7HC5afQCpkI-cA>
Received: from localhost (unknown [209.136.236.94])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4CDC780061;
        Wed, 16 Oct 2019 09:21:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: fix memory leak due to concurrent append writes with" failed to apply to 4.19-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Oct 2019 06:21:47 -0700
Message-ID: <1571232107144137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c67d970f0ea8dcc423e112137d34334fa0abb8ec Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 30 Sep 2019 10:20:25 +0100
Subject: [PATCH] Btrfs: fix memory leak due to concurrent append writes with
 fiemap

When we have a buffered write that starts at an offset greater than or
equals to the file's size happening concurrently with a full ranged
fiemap, we can end up leaking an extent state structure.

Suppose we have a file with a size of 1Mb, and before the buffered write
and fiemap are performed, it has a single extent state in its io tree
representing the range from 0 to 1Mb, with the EXTENT_DELALLOC bit set.

The following sequence diagram shows how the memory leak happens if a
fiemap a buffered write, starting at offset 1Mb and with a length of
4Kb, are performed concurrently.

          CPU 1                                                  CPU 2

  extent_fiemap()
    --> it's a full ranged fiemap
        range from 0 to LLONG_MAX - 1
        (9223372036854775807)

    --> locks range in the inode's
        io tree
      --> after this we have 2 extent
          states in the io tree:
          --> 1 for range [0, 1Mb[ with
              the bits EXTENT_LOCKED and
              EXTENT_DELALLOC_BITS set
          --> 1 for the range
              [1Mb, LLONG_MAX[ with
              the EXTENT_LOCKED bit set

                                                  --> start buffered write at offset
                                                      1Mb with a length of 4Kb

                                                  btrfs_file_write_iter()

                                                    btrfs_buffered_write()
                                                      --> cached_state is NULL

                                                      lock_and_cleanup_extent_if_need()
                                                        --> returns 0 and does not lock
                                                            range because it starts
                                                            at current i_size / eof

                                                      --> cached_state remains NULL

                                                      btrfs_dirty_pages()
                                                        btrfs_set_extent_delalloc()
                                                          (...)
                                                          __set_extent_bit()

                                                            --> splits extent state for range
                                                                [1Mb, LLONG_MAX[ and now we
                                                                have 2 extent states:

                                                                --> one for the range
                                                                    [1Mb, 1Mb + 4Kb[ with
                                                                    EXTENT_LOCKED set
                                                                --> another one for the range
                                                                    [1Mb + 4Kb, LLONG_MAX[ with
                                                                    EXTENT_LOCKED set as well

                                                            --> sets EXTENT_DELALLOC on the
                                                                extent state for the range
                                                                [1Mb, 1Mb + 4Kb[
                                                            --> caches extent state
                                                                [1Mb, 1Mb + 4Kb[ into
                                                                @cached_state because it has
                                                                the bit EXTENT_LOCKED set

                                                    --> btrfs_buffered_write() ends up
                                                        with a non-NULL cached_state and
                                                        never calls anything to release its
                                                        reference on it, resulting in a
                                                        memory leak

Fix this by calling free_extent_state() on cached_state if the range was
not locked by lock_and_cleanup_extent_if_need().

The same issue can happen if anything else other than fiemap locks a range
that covers eof and beyond.

This could be triggered, sporadically, by test case generic/561 from the
fstests suite, which makes duperemove run concurrently with fsstress, and
duperemove does plenty of calls to fiemap. When CONFIG_BTRFS_DEBUG is set
the leak is reported in dmesg/syslog when removing the btrfs module with
a message like the following:

  [77100.039461] BTRFS: state leak: start 6574080 end 6582271 state 16402 in tree 0 refs 1

Otherwise (CONFIG_BTRFS_DEBUG not set) detectable with kmemleak.

CC: stable@vger.kernel.org # 4.16+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8fe4eb7e5045..27e5b269e729 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1591,7 +1591,6 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct page **pages = NULL;
-	struct extent_state *cached_state = NULL;
 	struct extent_changeset *data_reserved = NULL;
 	u64 release_bytes = 0;
 	u64 lockstart;
@@ -1611,6 +1610,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 		return -ENOMEM;
 
 	while (iov_iter_count(i) > 0) {
+		struct extent_state *cached_state = NULL;
 		size_t offset = offset_in_page(pos);
 		size_t sector_offset;
 		size_t write_bytes = min(iov_iter_count(i),
@@ -1758,9 +1758,20 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 		if (copied > 0)
 			ret = btrfs_dirty_pages(inode, pages, dirty_pages,
 						pos, copied, &cached_state);
+
+		/*
+		 * If we have not locked the extent range, because the range's
+		 * start offset is >= i_size, we might still have a non-NULL
+		 * cached extent state, acquired while marking the extent range
+		 * as delalloc through btrfs_dirty_pages(). Therefore free any
+		 * possible cached extent state to avoid a memory leak.
+		 */
 		if (extents_locked)
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     lockstart, lockend, &cached_state);
+		else
+			free_extent_state(cached_state);
+
 		btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes,
 					       true);
 		if (ret) {

