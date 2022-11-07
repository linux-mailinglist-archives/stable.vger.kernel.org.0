Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425D761F79B
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbiKGP17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiKGP16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:27:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7A8A1B3
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:27:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B481A6118A
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 15:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AEFC433C1;
        Mon,  7 Nov 2022 15:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667834876;
        bh=aRgu/ygm7TyTqqHXVqcQwaZ6stBhpmHE9NgGToyL3ok=;
        h=Subject:To:Cc:From:Date:From;
        b=DDnGiqWx+EXHRGO7DgPW1LclcZctvE5W6OJsu8xNZP9TGKpOscERe3GoI0fUlgt1f
         VHTH0BqTG6DSVT6E82zXH+83smLKNg1JM5xREnJXrYo9dcxiWIIeGYzmYEfRZzQfo2
         bP9tNlcA4IGCY1rHhVJoFmHSY3HSCnl1W6wSq7Bs=
Subject: FAILED: patch "[PATCH] fuse: fix readdir cache race" failed to apply to 5.4-stable tree
To:     mszeredi@redhat.com, fsorenso@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 16:27:42 +0100
Message-ID: <166783486240147@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

9fa248c65bdb ("fuse: fix readdir cache race")
5fe0fc9f1de6 ("fuse: use kmap_local_page()")
9ac29fd3f87f ("fuse: move ioctl to separate source file")
5d069dbe8aaf ("fuse: fix bad inode")
fcee216beb9c ("fuse: split fuse_mount off of fuse_conn")
8f622e9497bb ("fuse: drop fuse_conn parameter where possible")
24754db2728a ("fuse: store fuse_conn in fuse_req")
9a752d18c85a ("virtiofs: add logic to free up a memory range")
d0cfb9dcbca6 ("virtiofs: maintain a list of busy elements")
6ae330cad6ef ("virtiofs: serialize truncate/punch_hole and dax fault path")
2a9a609a0c4a ("virtiofs: add DAX mmap support")
c2d0ad00d948 ("virtiofs: implement dax read/write operations")
ceec02d4354a ("virtiofs: introduce setupmapping/removemapping commands")
fd1a1dc6f5aa ("virtiofs: implement FUSE_INIT map_alignment field")
45f2348eceb6 ("virtiofs: keep a list of free dax memory ranges")
1dd539577c42 ("virtiofs: add a mount option to enable dax")
f4fd4ae354ba ("virtiofs: get rid of no_mount_options")
31070f6ccec0 ("fuse: Fix parameter for FS_IOC_{GET,SET}FLAGS")
69a6487ac0ea ("fuse: move rb_erase() before tree_insert()")
5b14671be58d ("Merge tag 'fuse-update-5.8' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse")

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

