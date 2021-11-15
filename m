Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FDA4521E4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376843AbhKPBHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:07:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245311AbhKOTUB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCE0761BFB;
        Mon, 15 Nov 2021 18:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001132;
        bh=RPBPs8txgR4jz+UrYslijAM9hUpYSZhHCUg1VppwI1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWImsEwDHPc4Z8F1DEtDL2s5+TqAN/TJKtLwG65xMnB2Y0HBxuYjPnF94UHuD/x4h
         bAY5rarDP4kAJ+XkmLIWDQ8x7oou7P8rVMaCsdyNJ7VagzkfXdVr0VfWAqm9mUZEi2
         lFVBlwqJgRMh9IsS5kpWZszRRQDVI8g4yMzme+zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Dinoff <fdinoff@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 056/917] fuse: fix page stealing
Date:   Mon, 15 Nov 2021 17:52:31 +0100
Message-Id: <20211115165430.669780058@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
 fs/fuse/dev.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -847,6 +847,12 @@ static int fuse_try_move_page(struct fus
 
 	replace_page_cache_page(oldpage, newpage);
 
+	/*
+	 * Release while we have extra ref on stolen page.  Otherwise
+	 * anon_pipe_buf_release() might think the page can be reused.
+	 */
+	pipe_buf_release(cs->pipe, buf);
+
 	get_page(newpage);
 
 	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
@@ -2031,8 +2037,12 @@ static ssize_t fuse_dev_splice_write(str
 
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


