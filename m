Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07FF4699B7
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 15:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345000AbhLFPC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:02:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35908 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345012AbhLFPCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:02:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FD1CB8111D;
        Mon,  6 Dec 2021 14:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35421C341D5;
        Mon,  6 Dec 2021 14:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802754;
        bh=Ku/iJtrE2wJUnabMvwR/1aM9s3/YHVZntm0KfJjgbE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2VOcnuOSKz1bEzbkgXwrBbmXR87RlsqUNksspk5mJxpnf0tirCgKfz1xw7WpZfil
         zIIEF6VWa6Yifff1tIrQRtVHzMpHxx5dAudpSHW2xBrDWAORPBc7sYetRswtvG+5S3
         MCtDKbZt4Tx/l+vBKrs3apTlbzrWk2xEw9AWCg+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Dinoff <fdinoff@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.4 22/52] fuse: fix page stealing
Date:   Mon,  6 Dec 2021 15:56:06 +0100
Message-Id: <20211206145548.644251087@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
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
 


