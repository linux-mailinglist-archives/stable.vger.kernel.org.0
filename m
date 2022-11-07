Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F8261F799
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiKGP1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiKGP1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:27:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8BFBC93
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:27:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADD1061184
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 15:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F55C433D6;
        Mon,  7 Nov 2022 15:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667834863;
        bh=E45v4ZKZiaYetyt3/MrddEkM1WL1ZaQ3D5/AGzX9SaU=;
        h=Subject:To:Cc:From:Date:From;
        b=kY0nDZJyYdbPLskT2pykdzrkLInzDG6SvKn9TiwcF3OU8ISKAavYZGsmzz5IZldYQ
         gN/jdYoq8cPZS9vY0cN8LPW0b3bVA3/1ir1nd+TKmXdutKTB5eetO2nY/IqQmdWaCg
         UwnQtkMVOufvEnTY+Q6Lu80t2rIrEL8LZ35msqVU=
Subject: FAILED: patch "[PATCH] fuse: fix readdir cache race" failed to apply to 5.15-stable tree
To:     mszeredi@redhat.com, fsorenso@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 16:27:40 +0100
Message-ID: <166783486020864@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

9fa248c65bdb ("fuse: fix readdir cache race")
5fe0fc9f1de6 ("fuse: use kmap_local_page()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9fa248c65bdbf5af0a2f74dd38575acfc8dfd2bf Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 20 Oct 2022 17:18:58 +0200
Subject: [PATCH] fuse: fix readdir cache race

There's a race in fuse's readdir cache that can result in an uninitilized
page being read.  The page lock is supposed to prevent this from happening
but in the following case it doesn't:

Two fuse_add_dirent_to_cache() start out and get the same parameters
(size=0,offset=0).  One of them wins the race to create and lock the page,
after which it fills in data, sets rdc.size and unlocks the page.

In the meantime the page gets evicted from the cache before the other
instance gets to run.  That one also creates the page, but finds the
size to be mismatched, bails out and leaves the uninitialized page in the
cache.

Fix by marking a filled page uptodate and ignoring non-uptodate pages.

Reported-by: Frank Sorenson <fsorenso@redhat.com>
Fixes: 5d7bc7e8680c ("fuse: allow using readdir cache")
Cc: <stable@vger.kernel.org> # v4.20
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index b4e565711045..e8deaacf1832 100644
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -77,8 +77,10 @@ static void fuse_add_dirent_to_cache(struct file *file,
 		goto unlock;
 
 	addr = kmap_local_page(page);
-	if (!offset)
+	if (!offset) {
 		clear_page(addr);
+		SetPageUptodate(page);
+	}
 	memcpy(addr + offset, dirent, reclen);
 	kunmap_local(addr);
 	fi->rdc.size = (index << PAGE_SHIFT) + offset + reclen;
@@ -516,6 +518,12 @@ static int fuse_readdir_cached(struct file *file, struct dir_context *ctx)
 
 	page = find_get_page_flags(file->f_mapping, index,
 				   FGP_ACCESSED | FGP_LOCK);
+	/* Page gone missing, then re-added to cache, but not initialized? */
+	if (page && !PageUptodate(page)) {
+		unlock_page(page);
+		put_page(page);
+		page = NULL;
+	}
 	spin_lock(&fi->rdc.lock);
 	if (!page) {
 		/*

