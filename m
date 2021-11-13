Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DA044F34A
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 14:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbhKMNRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 08:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235884AbhKMNRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 08:17:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0135B60FE3;
        Sat, 13 Nov 2021 13:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636809255;
        bh=30HIIXR3R64gjlmgQS1kMaqU2O/fr7hNjowFTzzio2c=;
        h=Subject:To:Cc:From:Date:From;
        b=nOH9jlW6fA8FZv/MHTD16MHFfo491XhfboUdGHC/BY5ePE36r7IHWNQ0kmOvaIQFV
         zbzS56BRe+HQVbhvXyWQxkJ7peLdW+kW9EbxjUB5D3y7fkPBFYJSv+RyEsZgv7WDAP
         ZXQTrJEx9/bqzSgKXsbWpM1Y9/dfo49E1FylZjOc=
Subject: FAILED: patch "[PATCH] fuse: fix page stealing" failed to apply to 4.4-stable tree
To:     mszeredi@redhat.com, fdinoff@google.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 14:14:13 +0100
Message-ID: <16368092531141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 712a951025c0667ff00b25afc360f74e639dfabe Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 2 Nov 2021 11:10:37 +0100
Subject: [PATCH] fuse: fix page stealing

It is possible to trigger a crash by splicing anon pipe bufs to the fuse
device.

The reason for this is that anon_pipe_buf_release() will reuse buf->page if
the refcount is 1, but that page might have already been stolen and its
flags modified (e.g. PG_lru added).

This happens in the unlikely case of fuse_dev_splice_write() getting around
to calling pipe_buf_release() after a page has been stolen, added to the
page cache and removed from the page cache.

Fix by calling pipe_buf_release() right after the page was inserted into
the page cache.  In this case the page has an elevated refcount so any
release function will know that the page isn't reusable.

Reported-by: Frank Dinoff <fdinoff@google.com>
Link: https://lore.kernel.org/r/CAAmZXrsGg2xsP1CK+cbuEMumtrqdvD-NKnWzhNcvn71RV3c1yw@mail.gmail.com/
Fixes: dd3bb14f44a6 ("fuse: support splice() writing to fuse device")
Cc: <stable@vger.kernel.org> # v2.6.35
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 337fa6f5a7c6..79f7eda49e06 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -847,6 +847,12 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 
 	replace_page_cache_page(oldpage, newpage);
 
+	/*
+	 * Release while we have extra ref on stolen page.  Otherwise
+	 * anon_pipe_buf_release() might think the page can be reused.
+	 */
+	pipe_buf_release(cs->pipe, buf);
+
 	get_page(newpage);
 
 	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
@@ -2031,8 +2037,12 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
 
 	pipe_lock(pipe);
 out_free:
-	for (idx = 0; idx < nbuf; idx++)
-		pipe_buf_release(pipe, &bufs[idx]);
+	for (idx = 0; idx < nbuf; idx++) {
+		struct pipe_buffer *buf = &bufs[idx];
+
+		if (buf->ops)
+			pipe_buf_release(pipe, buf);
+	}
 	pipe_unlock(pipe);
 
 	kvfree(bufs);

