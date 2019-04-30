Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD1DF734
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbfD3Ls1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730846AbfD3Ls0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:48:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB5522054F;
        Tue, 30 Apr 2019 11:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624905;
        bh=0PDFe32l2J+JXZU23rkNgpJGbpdv8x+Mxo14+BuAzpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTRUF36xfqLa8eX0xyEf1Wdh3i1ZuVAoMNiM8uY9T/JL9CCh+YPrJ/4Yf6DqYfZ0U
         hgKtV7Sw19CF5ETKM18Kh5RHXr0PGwjS39k+aISoUustHXBZq+yzvYmPazis0QYDmA
         Um+OnGay/sDQWvYl6HLt5PMYWcdli1IirLrTusnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.0 09/89] cifs: fix page reference leak with readv/writev
Date:   Tue, 30 Apr 2019 13:38:00 +0200
Message-Id: <20190430113610.196430694@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

commit 13f5938d8264b5501368523c4513ff26608a33e8 upstream.

CIFS can leak pages reference gotten through GUP (get_user_pages*()
through iov_iter_get_pages()). This happen if cifs_send_async_read()
or cifs_write_from_iter() calls fail from within __cifs_readv() and
__cifs_writev() respectively. This patch move page unreference to
cifs_aio_ctx_release() which will happens on all code paths this is
all simpler to follow for correctness.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |   15 +--------------
 fs/cifs/misc.c |   23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 15 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2796,7 +2796,6 @@ static void collect_uncached_write_data(
 	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb;
 	struct dentry *dentry = ctx->cfile->dentry;
-	unsigned int i;
 	int rc;
 
 	tcon = tlink_tcon(ctx->cfile->tlink);
@@ -2860,10 +2859,6 @@ restart_loop:
 		kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 	}
 
-	if (!ctx->direct_io)
-		for (i = 0; i < ctx->npages; i++)
-			put_page(ctx->bv[i].bv_page);
-
 	cifs_stats_bytes_written(tcon, ctx->total_len);
 	set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(dentry->d_inode)->flags);
 
@@ -3472,7 +3467,6 @@ collect_uncached_read_data(struct cifs_a
 	struct iov_iter *to = &ctx->iter;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
-	unsigned int i;
 	int rc;
 
 	tcon = tlink_tcon(ctx->cfile->tlink);
@@ -3556,15 +3550,8 @@ again:
 		kref_put(&rdata->refcount, cifs_uncached_readdata_release);
 	}
 
-	if (!ctx->direct_io) {
-		for (i = 0; i < ctx->npages; i++) {
-			if (ctx->should_dirty)
-				set_page_dirty(ctx->bv[i].bv_page);
-			put_page(ctx->bv[i].bv_page);
-		}
-
+	if (!ctx->direct_io)
 		ctx->total_len = ctx->len - iov_iter_count(to);
-	}
 
 	cifs_stats_bytes_read(tcon, ctx->total_len);
 
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -789,6 +789,11 @@ cifs_aio_ctx_alloc(void)
 {
 	struct cifs_aio_ctx *ctx;
 
+	/*
+	 * Must use kzalloc to initialize ctx->bv to NULL and ctx->direct_io
+	 * to false so that we know when we have to unreference pages within
+	 * cifs_aio_ctx_release()
+	 */
 	ctx = kzalloc(sizeof(struct cifs_aio_ctx), GFP_KERNEL);
 	if (!ctx)
 		return NULL;
@@ -807,7 +812,23 @@ cifs_aio_ctx_release(struct kref *refcou
 					struct cifs_aio_ctx, refcount);
 
 	cifsFileInfo_put(ctx->cfile);
-	kvfree(ctx->bv);
+
+	/*
+	 * ctx->bv is only set if setup_aio_ctx_iter() was call successfuly
+	 * which means that iov_iter_get_pages() was a success and thus that
+	 * we have taken reference on pages.
+	 */
+	if (ctx->bv) {
+		unsigned i;
+
+		for (i = 0; i < ctx->npages; i++) {
+			if (ctx->should_dirty)
+				set_page_dirty(ctx->bv[i].bv_page);
+			put_page(ctx->bv[i].bv_page);
+		}
+		kvfree(ctx->bv);
+	}
+
 	kfree(ctx);
 }
 


