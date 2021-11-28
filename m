Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF00A4605EF
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 12:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhK1Lq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 06:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbhK1Lo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 06:44:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E670C061574
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 03:40:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8D73B80CC9
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 11:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96E8C004E1;
        Sun, 28 Nov 2021 11:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638099642;
        bh=r676s6o5BUe+fDoVj4yN6ri06m2o/mvoYNvK+H0rZK8=;
        h=Subject:To:Cc:From:Date:From;
        b=E6YxabiCcRIMRJDcvlTe4dZ0PU1A1lqaMp3VwI3Vlws7Xe5H+gKOkN2Fuv5zYZYv6
         cxbDE2X1yvwEamyGLuA/DYJ8UjRHvcbMxcb59Kb8bOimRGx/dhJyyvOZWXGnClb+d7
         AtzJs9ZxTJcOp/EZ7RvmzPNPJfJQhFgr7w6EJpC4=
Subject: FAILED: patch "[PATCH] NFSv42: Fix pagecache invalidation after COPY/CLONE" failed to apply to 4.9-stable tree
To:     bcodding@redhat.com, stable@vger.kernel.org,
        trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Nov 2021 12:40:39 +0100
Message-ID: <1638099639215173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3f015d89a47cd8855cd92f71fff770095bd885a1 Mon Sep 17 00:00:00 2001
From: Benjamin Coddington <bcodding@redhat.com>
Date: Tue, 16 Nov 2021 10:48:13 -0500
Subject: [PATCH] NFSv42: Fix pagecache invalidation after COPY/CLONE

The mechanism in use to allow the client to see the results of COPY/CLONE
is to drop those pages from the pagecache.  This forces the client to read
those pages once more from the server.  However, truncate_pagecache_range()
zeros out partial pages instead of dropping them.  Let us instead use
invalidate_inode_pages2_range() with full-page offsets to ensure the client
properly sees the results of COPY/CLONE operations.

Cc: <stable@vger.kernel.org> # v4.7+
Fixes: 2e72448b07dc ("NFS: Add COPY nfs operation")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 08355b66e7cb..8b21ff1be717 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -289,7 +289,9 @@ static void nfs42_copy_dest_done(struct inode *inode, loff_t pos, loff_t len)
 	loff_t newsize = pos + len;
 	loff_t end = newsize - 1;
 
-	truncate_pagecache_range(inode, pos, end);
+	WARN_ON_ONCE(invalidate_inode_pages2_range(inode->i_mapping,
+				pos >> PAGE_SHIFT, end >> PAGE_SHIFT));
+
 	spin_lock(&inode->i_lock);
 	if (newsize > i_size_read(inode))
 		i_size_write(inode, newsize);

