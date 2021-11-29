Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062C14626C6
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236003AbhK2W5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbhK2W5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:57:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79119C03AA3A;
        Mon, 29 Nov 2021 10:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C490FCE13D7;
        Mon, 29 Nov 2021 18:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABBBC53FCD;
        Mon, 29 Nov 2021 18:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210007;
        bh=NCz/p+WVJI3R+wx/mdu+dIy7lV1eBXTYn4mlKNp02vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUDnmW2qFt3mNNRSSN4uEwBnPFtLHArLGaXwnAPUo3PPeUZCl6qIsZyx8hKyRU9ph
         v/I9IE8aCYt0QFKCySml4jRFvt23ur8Ht6yCKUc/bHd68cefYAeBsurxHsVUD+e0u6
         7/GtBRywB5Zl5MhZOmof3BQaRR75adoHVrPRTcIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Dinoff <fdinoff@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 11/69] fuse: fix page stealing
Date:   Mon, 29 Nov 2021 19:17:53 +0100
Message-Id: <20211129181704.031200295@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
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
@@ -905,6 +905,12 @@ static int fuse_try_move_page(struct fus
 		goto out_put_old;
 	}
 
+	/*
+	 * Release while we have extra ref on stolen page.  Otherwise
+	 * anon_pipe_buf_release() might think the page can be reused.
+	 */
+	pipe_buf_release(cs->pipe, buf);
+
 	get_page(newpage);
 
 	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
@@ -2054,8 +2060,12 @@ static ssize_t fuse_dev_splice_write(str
 
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


