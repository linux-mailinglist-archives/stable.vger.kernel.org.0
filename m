Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA7745BA47
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242084AbhKXMJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:09:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:32848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236476AbhKXMHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:07:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E20CC6104F;
        Wed, 24 Nov 2021 12:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755477;
        bh=Ku/iJtrE2wJUnabMvwR/1aM9s3/YHVZntm0KfJjgbE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZBlJFeuq4c12KSD8C26vMWIUuBZPSFbgSqxTzZReXeuHJ5XCI+AlKdyWfvJ7kL7i
         0//0UzPXLtom3BEPwVfIoIEniiJw/PdFTfTILEUPUDEzRW/OsBQlAmEYrlv64jHfLa
         hXDgES7Z0wgymxRAZdzf7aZDKkOx+L5O2D5PN/yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Dinoff <fdinoff@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.4 109/162] fuse: fix page stealing
Date:   Wed, 24 Nov 2021 12:56:52 +0100
Message-Id: <20211124115701.855204038@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 712a951025c0667ff00b25afc360f74e639dfabe upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dev.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -922,6 +922,13 @@ static int fuse_try_move_page(struct fus
 		return err;
 	}
 
+	/*
+	 * Release while we have extra ref on stolen page.  Otherwise
+	 * anon_pipe_buf_release() might think the page can be reused.
+	 */
+	buf->ops->release(cs->pipe, buf);
+	buf->ops = NULL;
+
 	page_cache_get(newpage);
 
 	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
@@ -2090,7 +2097,8 @@ static ssize_t fuse_dev_splice_write(str
 out_free:
 	for (idx = 0; idx < nbuf; idx++) {
 		struct pipe_buffer *buf = &bufs[idx];
-		buf->ops->release(pipe, buf);
+		if (buf->ops)
+			buf->ops->release(pipe, buf);
 	}
 	pipe_unlock(pipe);
 


