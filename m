Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D875156A3C
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 13:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgBIM6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 07:58:01 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49727 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727710AbgBIM6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 07:58:01 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C376721C1C;
        Sun,  9 Feb 2020 07:57:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 07:57:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lJRUt0
        GvLSCb1jChjldK5+42MgMIm1sieOvxDu8DZHA=; b=fmUs8vGvVHsvXv/grlaDOa
        sei357p6+soBRFKVE9JIw44y5SSrv7jHL8eJFEr04d1DqM5N9wCegGL/UDk+UncC
        1dCL3xG0I7GTPo2Tj/FGIPZJ35AcZi2DQw3MuLIQ/QawD6B/CM9t8PZAg12MhDkq
        mgeIyEMCIjOTuU2OkHbLjxxtd800byzw+yqwHdNomIIUqT3bEI3i7TZxVNb7kpF+
        Khk1un6gdn4WQbn9HuA7kFNaGeKpkTbYVASKCXrbfSJaleS1ABzeLBlZlIQ7Nvuo
        HrldfIItJFuke1lJKc438Li4WicmMDGWLWWg/2YfMevJ8fBn4kx03bMGUlOruOTQ
        ==
X-ME-Sender: <xms:1wFAXkKa2wcTdnMwztahajL2yf91_4h4S3hFWmgG1dsf5PO5fdBLNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeefkedrleekrdefjedrud
    efheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1wFAXmDXRP44hIhuQEYSrAp8QaVKv3IaJbh4vsdSTiXMQ-XZzfr3tw>
    <xmx:1wFAXuH5dEgkYA4InTNNgZ29sixRfx_eYrO2ixyNy6NlrfJd8aximQ>
    <xmx:1wFAXq5iVzSzrfhNCSKyhrF4zGUHjmKxnyc8rN8B8od_AWhE2qaFuw>
    <xmx:1wFAXr6qCG_uZBjM-v9aTR27GWP1T_Jv9SjG2eqJQusAfRGBY6zIwA>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 94D54328005A;
        Sun,  9 Feb 2020 07:57:58 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: fix deadlock allocating crypto bounce page from mempool" failed to apply to 4.4-stable tree
To:     ebiggers@google.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:25:55 +0100
Message-ID: <1581247555171234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 547c556f4db7c09447ecf5f833ab6aaae0c5ab58 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 31 Dec 2019 12:11:49 -0600
Subject: [PATCH] ext4: fix deadlock allocating crypto bounce page from mempool

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

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 24aeedb8fc75..68b39e75446a 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -512,17 +512,26 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 		gfp_t gfp_flags = GFP_NOFS;
 		unsigned int enc_bytes = round_up(len, i_blocksize(inode));
 
+		/*
+		 * Since bounce page allocation uses a mempool, we can only use
+		 * a waiting mask (i.e. request guaranteed allocation) on the
+		 * first page of the bio.  Otherwise it can deadlock.
+		 */
+		if (io->io_bio)
+			gfp_flags = GFP_NOWAIT | __GFP_NOWARN;
 	retry_encrypt:
 		bounce_page = fscrypt_encrypt_pagecache_blocks(page, enc_bytes,
 							       0, gfp_flags);
 		if (IS_ERR(bounce_page)) {
 			ret = PTR_ERR(bounce_page);
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
 

