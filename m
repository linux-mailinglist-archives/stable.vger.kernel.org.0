Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92676156A40
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgBIM6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 07:58:22 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51139 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727654AbgBIM6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 07:58:22 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9411221AA4;
        Sun,  9 Feb 2020 07:58:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 07:58:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Uk8GSL
        4PqdcdQu+mK9znCDuFKoYlooP8uqu6alYYXtg=; b=JiG7+7H0pRY7Fg4Cugf7jN
        DGFkN8bpyosnMKOX9ZKbXi7VOmy0XA7pZW1YQM/YYnrIfz4iiRvDHHTnS79MivMm
        pxVbFnRSEDxCtDG0bLJod4sI8j0UKhfImAciaz+sUHsW9hyd+BHG+9Kb/qh46NmR
        6mgtadtUJBQ2m6v4sMYgjtNY/53Xrjz8MRwCSOuZhyz4iH3gffAPXTGeI9MCI1sl
        NzFO2KrWQ0cVHshDPshETHqat79ThQk5AAE2P1pGq4NajoOlLSLlrxQZYws2B5WI
        0GYLW85bvz32US5hrmYLuHLaxmBWxTkoKyLZCT0rFKAOhNEctG1tWwd43mFiCu+Q
        ==
X-ME-Sender: <xms:7QFAXk1ZylqQ_jqHemmjcTTghVurOrr1JWVWsVxWL5-d7uW-AmsiYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeefkedrleekrdefjedrud
    efheenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7QFAXtgwImFxhGPkPbhceH5lvKepN58a-2lVdzpownFceRaABCOEoA>
    <xmx:7QFAXvpmRodvLftBgvizHXo9NjC71XyCR2CJZOziO0XByvAT1bs54Q>
    <xmx:7QFAXio6betC0oGKkOAirKjoxJpREAy3m_bWmNxeoeWQhyBjxhrcEA>
    <xmx:7QFAXvYU9q3tRvEQbm872uNhfcSd8CEZyQy8--1Apna0Zpm9-Zdp_Q>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2A89B328005E;
        Sun,  9 Feb 2020 07:58:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: fix deadlock allocating crypto bounce page from mempool" failed to apply to 4.14-stable tree
To:     ebiggers@google.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:25:59 +0100
Message-ID: <1581247559159216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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
 

