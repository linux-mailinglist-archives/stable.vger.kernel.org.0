Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA6C3301A1
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhCGN6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhCGN5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:57:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E56365101;
        Sun,  7 Mar 2021 13:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125470;
        bh=alm5r9O23zdfQLHfaaaVdJD273MugY1G/Og2YNg5Ln4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcZd9ly0eCknK3qatUXrSznqYeAFa1i+8ZAleDJIUZMLj80aiio3sCd19ZaKkhmuM
         asDO8IdnNM6WX/zc6OUbU9IWn1RrbTyulqfwtYq3fIV1ptUciQJVLlJ1KzqWR2p3XH
         1RCPcsLrTBbKGBWF3Bi6BefNKavfUFgGv+XkbWPwguMacDfTd91V6ZWI0QBWGYLOzy
         0WjwPVcGM8Lmk9/IaBq+x9G0RTxNFIV7gtA0GAXdk42ZnrQzIIOY9BTDWQYxWpg1t8
         GrWoOnFJIRbsPmz0YHCJDyovCzI30sF3KCHWlHQnSXFsPbg6TE7NHotvYlJ/dTN7Fv
         HgxU6q2CbQ1nA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 03/12] btrfs: subpage: fix the false data csum mismatch error
Date:   Sun,  7 Mar 2021 08:57:37 -0500
Message-Id: <20210307135746.967418-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135746.967418-1-sashal@kernel.org>
References: <20210307135746.967418-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit c28ea613fafad910d08f67efe76ae552b1434e44 ]

[BUG]
When running fstresss, we can hit strange data csum mismatch where the
on-disk data is in fact correct (passes scrub).

With some extra debug info added, we have the following traces:

  0482us: btrfs_do_readpage: root=5 ino=284 offset=393216, submit force=0 pgoff=0 iosize=8192
  0494us: btrfs_do_readpage: root=5 ino=284 offset=401408, submit force=0 pgoff=8192 iosize=4096
  0498us: btrfs_submit_data_bio: root=5 ino=284 bio first bvec=393216 len=8192
  0591us: btrfs_do_readpage: root=5 ino=284 offset=405504, submit force=0 pgoff=12288 iosize=36864
  0594us: btrfs_submit_data_bio: root=5 ino=284 bio first bvec=401408 len=4096
  0863us: btrfs_submit_data_bio: root=5 ino=284 bio first bvec=405504 len=36864
  0933us: btrfs_verify_data_csum: root=5 ino=284 offset=393216 len=8192
  0967us: btrfs_do_readpage: root=5 ino=284 offset=442368, skip beyond isize pgoff=49152 iosize=16384
  1047us: btrfs_verify_data_csum: root=5 ino=284 offset=401408 len=4096
  1163us: btrfs_verify_data_csum: root=5 ino=284 offset=405504 len=36864
  1290us: check_data_csum: !!! root=5 ino=284 offset=438272 pg_off=45056 !!!
  7387us: end_bio_extent_readpage: root=5 ino=284 before pending_read_bios=0

[CAUSE]
Normally we expect all submitted bio reads to only touch the range we
specified, and under subpage context, it means we should only touch the
range specified in each bvec.

But in data read path, inside end_bio_extent_readpage(), we have page
zeroing which only takes regular page size into consideration.

This means for subpage if we have an inode whose content looks like below:

  0       16K     32K     48K     64K
  |///////|       |///////|       |

  |//| = data needs to be read from disk
  |  | = hole

And i_size is 64K initially.

Then the following race can happen:

		T1		|		T2
--------------------------------+--------------------------------
btrfs_do_readpage()		|
|- isize = 64K;			|
|  At this time, the isize is 	|
|  64K				|
|				|
|- submit_extent_page()		|
|  submit previous assembled bio|
|  assemble bio for [0, 16K)	|
|				|
|- submit_extent_page()		|
   submit read bio for [0, 16K) |
   assemble read bio for	|
   [32K, 48K)			|
 				|
				| btrfs_setsize()
				| |- i_size_write(, 16K);
				|    Now i_size is only 16K
end_io() for [0K, 16K)		|
|- end_bio_extent_readpage()	|
   |- btrfs_verify_data_csum()  |
   |  No csum error		|
   |- i_size = 16K;		|
   |- zero_user_segment(16K,	|
      PAGE_SIZE);		|
      !!! We zeroed range	|
      !!! [32K, 48K)		|
				| end_io for [32K, 48K)
				| |- end_bio_extent_readpage()
				|    |- btrfs_verify_data_csum()
				|       ! CSUM MISMATCH !
				|       ! As the range is zeroed now !

[FIX]
To fix the problem, make end_bio_extent_readpage() to only zero the
range of bvec.

The bug only affects subpage read-write support, as for full read-only
mount we can't change i_size thus won't hit the race condition.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c9cee458e001..ff1a0f97ba84 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2972,12 +2972,23 @@ static void end_bio_extent_readpage(struct bio *bio)
 		if (likely(uptodate)) {
 			loff_t i_size = i_size_read(inode);
 			pgoff_t end_index = i_size >> PAGE_SHIFT;
-			unsigned off;
 
-			/* Zero out the end if this page straddles i_size */
-			off = offset_in_page(i_size);
-			if (page->index == end_index && off)
-				zero_user_segment(page, off, PAGE_SIZE);
+			/*
+			 * Zero out the remaining part if this range straddles
+			 * i_size.
+			 *
+			 * Here we should only zero the range inside the bvec,
+			 * not touch anything else.
+			 *
+			 * NOTE: i_size is exclusive while end is inclusive.
+			 */
+			if (page->index == end_index && i_size <= end) {
+				u32 zero_start = max(offset_in_page(i_size),
+						     offset_in_page(end));
+
+				zero_user_segment(page, zero_start,
+						  offset_in_page(end) + 1);
+			}
 		}
 		ASSERT(bio_offset + len > bio_offset);
 		bio_offset += len;
-- 
2.30.1

