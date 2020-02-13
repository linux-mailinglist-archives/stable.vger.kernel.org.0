Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC7115C55D
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbgBMPzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:55:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387488AbgBMPZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:42 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB4192469A;
        Thu, 13 Feb 2020 15:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607541;
        bh=XzVkkxfENQ+u25KE1T0DQ5ICjNeu3/HPCkk9hMjUUFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ix8pCZRH49u/GiyLmxP4Ea0Vi9FgYg+vDdn168CsCNPXueEZoSfQGsahfwge9jyB6
         WOzb8lIMe/ZC3Np8I7PDrxzjAfN/B9IfpoYNu5FFZ/YxqkvTDt84e26J1D60AMdbhk
         /X5GYRf6A5GLwb0zydzxg27aLVxrnI3WrO4iBPrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 118/173] ext4: fix deadlock allocating crypto bounce page from mempool
Date:   Thu, 13 Feb 2020 07:20:21 -0800
Message-Id: <20200213152002.197255199@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 547c556f4db7c09447ecf5f833ab6aaae0c5ab58 ]

ext4_writepages() on an encrypted file has to encrypt the data, but it
can't modify the pagecache pages in-place, so it encrypts the data into
bounce pages and writes those instead.  All bounce pages are allocated
from a mempool using GFP_NOFS.

This is not correct use of a mempool, and it can deadlock.  This is
because GFP_NOFS includes __GFP_DIRECT_RECLAIM, which enables the "never
fail" mode for mempool_alloc() where a failed allocation will fall back
to waiting for one of the preallocated elements in the pool.

But since this mode is used for all a bio's pages and not just the
first, it can deadlock waiting for pages already in the bio to be freed.

This deadlock can be reproduced by patching mempool_alloc() to pretend
that pool->alloc() always fails (so that it always falls back to the
preallocations), and then creating an encrypted file of size > 128 KiB.

Fix it by only using GFP_NOFS for the first page in the bio.  For
subsequent pages just use GFP_NOWAIT, and if any of those fail, just
submit the bio and start a new one.

This will need to be fixed in f2fs too, but that's less straightforward.

Fixes: c9af28fdd449 ("ext4 crypto: don't let data integrity writebacks fail with ENOMEM")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20191231181149.47619-1-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/page-io.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index db7590178dfcf..9cc79b7b0df11 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -481,17 +481,26 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	    nr_to_submit) {
 		gfp_t gfp_flags = GFP_NOFS;
 
+		/*
+		 * Since bounce page allocation uses a mempool, we can only use
+		 * a waiting mask (i.e. request guaranteed allocation) on the
+		 * first page of the bio.  Otherwise it can deadlock.
+		 */
+		if (io->io_bio)
+			gfp_flags = GFP_NOWAIT | __GFP_NOWARN;
 	retry_encrypt:
 		data_page = fscrypt_encrypt_page(inode, page, PAGE_SIZE, 0,
 						page->index, gfp_flags);
 		if (IS_ERR(data_page)) {
 			ret = PTR_ERR(data_page);
-			if (ret == -ENOMEM && wbc->sync_mode == WB_SYNC_ALL) {
-				if (io->io_bio) {
+			if (ret == -ENOMEM &&
+			    (io->io_bio || wbc->sync_mode == WB_SYNC_ALL)) {
+				gfp_flags = GFP_NOFS;
+				if (io->io_bio)
 					ext4_io_submit(io);
-					congestion_wait(BLK_RW_ASYNC, HZ/50);
-				}
-				gfp_flags |= __GFP_NOFAIL;
+				else
+					gfp_flags |= __GFP_NOFAIL;
+				congestion_wait(BLK_RW_ASYNC, HZ/50);
 				goto retry_encrypt;
 			}
 			data_page = NULL;
-- 
2.20.1



