Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF642A15AE
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbgJaLhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbgJaLhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:37:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F97A20719;
        Sat, 31 Oct 2020 11:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144230;
        bh=MlZzqlvhZXIzlNXZFf3Hkq3xqbJVUiR+P5qXyxr/b0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPaUMKyai52vnBn+GpL0QVPsuTaTXD89s89st7gZlzfagMV4eUAN2AynIPaRXQMjx
         NS63x1R75M79q2BxrxXy1MYwA9m93/3LlL/jFFnUUW92WrP0ZjLQvZ4GBwbi+jPc66
         mnl9vBl6AECw1RdWbcjvaq8iwBxdwmdI0cHsY0So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pradeep P V K <ppvk@codeaurora.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 33/49] fuse: fix page dereference after free
Date:   Sat, 31 Oct 2020 12:35:29 +0100
Message-Id: <20201031113457.039865220@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit d78092e4937de9ce55edcb4ee4c5e3c707be0190 upstream.

After unlock_request() pages from the ap->pages[] array may be put (e.g. by
aborting the connection) and the pages can be freed.

Prevent use after free by grabbing a reference to the page before calling
unlock_request().

The original patch was created by Pradeep P V K.

Reported-by: Pradeep P V K <ppvk@codeaurora.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dev.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -786,15 +786,16 @@ static int fuse_try_move_page(struct fus
 	struct page *newpage;
 	struct pipe_buffer *buf = cs->pipebufs;
 
+	get_page(oldpage);
 	err = unlock_request(cs->req);
 	if (err)
-		return err;
+		goto out_put_old;
 
 	fuse_copy_finish(cs);
 
 	err = pipe_buf_confirm(cs->pipe, buf);
 	if (err)
-		return err;
+		goto out_put_old;
 
 	BUG_ON(!cs->nr_segs);
 	cs->currbuf = buf;
@@ -834,7 +835,7 @@ static int fuse_try_move_page(struct fus
 	err = replace_page_cache_page(oldpage, newpage, GFP_KERNEL);
 	if (err) {
 		unlock_page(newpage);
-		return err;
+		goto out_put_old;
 	}
 
 	get_page(newpage);
@@ -853,14 +854,19 @@ static int fuse_try_move_page(struct fus
 	if (err) {
 		unlock_page(newpage);
 		put_page(newpage);
-		return err;
+		goto out_put_old;
 	}
 
 	unlock_page(oldpage);
+	/* Drop ref for ap->pages[] array */
 	put_page(oldpage);
 	cs->len = 0;
 
-	return 0;
+	err = 0;
+out_put_old:
+	/* Drop ref obtained in this function */
+	put_page(oldpage);
+	return err;
 
 out_fallback_unlock:
 	unlock_page(newpage);
@@ -869,10 +875,10 @@ out_fallback:
 	cs->offset = buf->offset;
 
 	err = lock_request(cs->req);
-	if (err)
-		return err;
+	if (!err)
+		err = 1;
 
-	return 1;
+	goto out_put_old;
 }
 
 static int fuse_ref_page(struct fuse_copy_state *cs, struct page *page,
@@ -884,14 +890,16 @@ static int fuse_ref_page(struct fuse_cop
 	if (cs->nr_segs == cs->pipe->buffers)
 		return -EIO;
 
+	get_page(page);
 	err = unlock_request(cs->req);
-	if (err)
+	if (err) {
+		put_page(page);
 		return err;
+	}
 
 	fuse_copy_finish(cs);
 
 	buf = cs->pipebufs;
-	get_page(page);
 	buf->page = page;
 	buf->offset = offset;
 	buf->len = count;


