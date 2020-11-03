Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC302A557B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388551AbgKCVS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:18:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388520AbgKCVJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41B2E207BC;
        Tue,  3 Nov 2020 21:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437770;
        bh=DGM/X/a9t9GYZ2siAxQ06ZsOOPNmq5LLGDLadmqlSgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+9QrBxBeKsZpPKehcdxssKk03ewne8asXkn7K9ipFacPUo1gXrd66htZMmcPZ3uG
         bGgbG/fCD6StJl2MVWN4XsSJq1k8FZJMokzkGlNXA4JUj2GE3fx9XBE1PRWS6YocKE
         Kz6TplJB5qcCxxYOHVsHvkbu8KlmPzG5GUHS6jbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pradeep P V K <ppvk@codeaurora.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.14 009/125] fuse: fix page dereference after free
Date:   Tue,  3 Nov 2020 21:36:26 +0100
Message-Id: <20201103203158.107723172@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
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
@@ -845,15 +845,16 @@ static int fuse_try_move_page(struct fus
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
@@ -893,7 +894,7 @@ static int fuse_try_move_page(struct fus
 	err = replace_page_cache_page(oldpage, newpage, GFP_KERNEL);
 	if (err) {
 		unlock_page(newpage);
-		return err;
+		goto out_put_old;
 	}
 
 	get_page(newpage);
@@ -912,14 +913,19 @@ static int fuse_try_move_page(struct fus
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
@@ -928,10 +934,10 @@ out_fallback:
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
@@ -943,14 +949,16 @@ static int fuse_ref_page(struct fuse_cop
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


