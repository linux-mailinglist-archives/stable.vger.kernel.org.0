Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B296B126C72
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfLSSrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:47:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729534AbfLSSrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:47:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF2BB24679;
        Thu, 19 Dec 2019 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781272;
        bh=EexjbrWnS2zxrUD5rtbgHfHZ9fzzU2c7Wcnr9c0M9uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7U9lMMIL9f01xmEHPz6aU6FuOTx2ZEju0yRyW8hnnlwKvSrrYNrktGqieMfY+6Dd
         gBEIxQeTVE0yuI1elIonkgTscnpoghKxDsCWiphztLXx/ZzDNIVO2uvJImVNtjLdUn
         4iKWwAIjDqWloVwySGP6Jez2zKcUpaF4kHr07iv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 152/199] Btrfs: fix negative subv_writers counter and data space leak after buffered write
Date:   Thu, 19 Dec 2019 19:33:54 +0100
Message-Id: <20191219183223.703970854@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a0e248bb502d5165b3314ac3819e888fdcdf7d9f ]

When doing a buffered write it's possible to leave the subv_writers
counter of the root, used for synchronization between buffered nocow
writers and snapshotting. This happens in an exceptional case like the
following:

1) We fail to allocate data space for the write, since there's not
   enough available data space nor enough unallocated space for allocating
   a new data block group;

2) Because of that failure, we try to go to NOCOW mode, which succeeds
   and therefore we set the local variable 'only_release_metadata' to true
   and set the root's sub_writers counter to 1 through the call to
   btrfs_start_write_no_snapshotting() made by check_can_nocow();

3) The call to btrfs_copy_from_user() returns zero, which is very unlikely
   to happen but not impossible;

4) No pages are copied because btrfs_copy_from_user() returned zero;

5) We call btrfs_end_write_no_snapshotting() which decrements the root's
   subv_writers counter to 0;

6) We don't set 'only_release_metadata' back to 'false' because we do
   it only if 'copied', the value returned by btrfs_copy_from_user(), is
   greater than zero;

7) On the next iteration of the while loop, which processes the same
   page range, we are now able to allocate data space for the write (we
   got enough data space released in the meanwhile);

8) After this if we fail at btrfs_delalloc_reserve_metadata(), because
   now there isn't enough free metadata space, or in some other place
   further below (prepare_pages(), lock_and_cleanup_extent_if_need(),
   btrfs_dirty_pages()), we break out of the while loop with
   'only_release_metadata' having a value of 'true';

9) Because 'only_release_metadata' is 'true' we end up decrementing the
   root's subv_writers counter to -1 (through a call to
   btrfs_end_write_no_snapshotting()), and we also end up not releasing the
   data space previously reserved through btrfs_check_data_free_space().
   As a consequence the mechanism for synchronizing NOCOW buffered writes
   with snapshotting gets broken.

Fix this by always setting 'only_release_metadata' to false at the start
of each iteration.

Fixes: 8257b2dc3c1a ("Btrfs: introduce btrfs_{start, end}_nocow_write() for each subvolume")
Fixes: 7ee9e4405f26 ("Btrfs: check if we can nocow if we don't have data space")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 6cdf27325576b..03661b744eaf0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1555,6 +1555,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			break;
 		}
 
+		only_release_metadata = false;
 		sector_offset = pos & (root->sectorsize - 1);
 		reserve_bytes = round_up(write_bytes + sector_offset,
 				root->sectorsize);
@@ -1704,7 +1705,6 @@ again:
 			set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 				       lockend, EXTENT_NORESERVE, NULL,
 				       NULL, GFP_NOFS);
-			only_release_metadata = false;
 		}
 
 		btrfs_drop_pages(pages, num_pages);
-- 
2.20.1



