Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A27BD9EF2
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438472AbfJPV7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438461AbfJPV7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:18 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEC55218DE;
        Wed, 16 Oct 2019 21:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263157;
        bh=+z+39EK4lI4JE1/tBx7E6JtZIILC2csIKnEB6iWYPFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLYmQYtt1ult0WPYr1ZK/P1FhNl5t9c2/yQO+22ySc1mP4HYxMicvIMEftrr6v2IC
         vxzyQf/69ufxP7Wm1TPdNyJZXUgqk/996tU3okqreGBct5vAwTfyGjg9amQLhdB7A2
         IxQ3CMUXWjs1YxRo5YSeE0PPQv6w2Uj8AR1BWu/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 086/112] Btrfs: fix memory leak due to concurrent append writes with fiemap
Date:   Wed, 16 Oct 2019 14:51:18 -0700
Message-Id: <20191016214905.047723990@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit c67d970f0ea8dcc423e112137d34334fa0abb8ec upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1591,7 +1591,6 @@ static noinline ssize_t btrfs_buffered_w
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct page **pages = NULL;
-	struct extent_state *cached_state = NULL;
 	struct extent_changeset *data_reserved = NULL;
 	u64 release_bytes = 0;
 	u64 lockstart;
@@ -1611,6 +1610,7 @@ static noinline ssize_t btrfs_buffered_w
 		return -ENOMEM;
 
 	while (iov_iter_count(i) > 0) {
+		struct extent_state *cached_state = NULL;
 		size_t offset = offset_in_page(pos);
 		size_t sector_offset;
 		size_t write_bytes = min(iov_iter_count(i),
@@ -1758,9 +1758,20 @@ again:
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


