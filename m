Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA66CA8A49
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732150AbfIDP6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732131AbfIDP6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6553C23400;
        Wed,  4 Sep 2019 15:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612733;
        bh=CJmj8ChZiWKMSqdu2DgTc6/pCt/Wdcyt/lnwzZtrHgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8BXEpq1+krSGI16uOI/R+rGY0vl5ANrjFl7xOj34uPPuP3bTmjj4zVDi5BZ7nIkK
         x8FYaxfXINmeDLCGdl+yMEymcaWQMhOQz4cytCXKv20aWLMfEhz988JXSG3zRvIDUI
         RA8GgQmSTzRtLzHBmEZmdGlABtBvU3rL3GgaJDDg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 48/94] NFS: Fix spurious EIO read errors
Date:   Wed,  4 Sep 2019 11:56:53 -0400
Message-Id: <20190904155739.2816-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 8f54c7a4babf58bbaf849e126f7ae9664bdc9e04 ]

If the client attempts to read a page, but the read fails due to some
spurious error (e.g. an ACCESS error or a timeout, ...) then we need
to allow other processes to retry.
Also try to report errors correctly when doing a synchronous readpage.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/internal.h | 10 ++++++++++
 fs/nfs/read.c     | 35 ++++++++++++++++++++++++++---------
 fs/nfs/write.c    | 12 ------------
 3 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 81e2fdff227ed..9ab9427405f3f 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -773,3 +773,13 @@ static inline bool nfs_error_is_fatal(int err)
 	}
 }
 
+static inline bool nfs_error_is_fatal_on_server(int err)
+{
+	switch (err) {
+	case 0:
+	case -ERESTARTSYS:
+	case -EINTR:
+		return false;
+	}
+	return nfs_error_is_fatal(err);
+}
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index c19841c82b6a3..cfe0b586eadd4 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -91,19 +91,25 @@ void nfs_pageio_reset_read_mds(struct nfs_pageio_descriptor *pgio)
 }
 EXPORT_SYMBOL_GPL(nfs_pageio_reset_read_mds);
 
-static void nfs_readpage_release(struct nfs_page *req)
+static void nfs_readpage_release(struct nfs_page *req, int error)
 {
 	struct inode *inode = d_inode(nfs_req_openctx(req)->dentry);
+	struct page *page = req->wb_page;
 
 	dprintk("NFS: read done (%s/%llu %d@%lld)\n", inode->i_sb->s_id,
 		(unsigned long long)NFS_FILEID(inode), req->wb_bytes,
 		(long long)req_offset(req));
 
+	if (nfs_error_is_fatal_on_server(error) && error != -ETIMEDOUT)
+		SetPageError(page);
 	if (nfs_page_group_sync_on_bit(req, PG_UNLOCKPAGE)) {
-		if (PageUptodate(req->wb_page))
-			nfs_readpage_to_fscache(inode, req->wb_page, 0);
+		struct address_space *mapping = page_file_mapping(page);
 
-		unlock_page(req->wb_page);
+		if (PageUptodate(page))
+			nfs_readpage_to_fscache(inode, page, 0);
+		else if (!PageError(page) && !PagePrivate(page))
+			generic_error_remove_page(mapping, page);
+		unlock_page(page);
 	}
 	nfs_release_request(req);
 }
@@ -131,7 +137,7 @@ int nfs_readpage_async(struct nfs_open_context *ctx, struct inode *inode,
 			     &nfs_async_read_completion_ops);
 	if (!nfs_pageio_add_request(&pgio, new)) {
 		nfs_list_remove_request(new);
-		nfs_readpage_release(new);
+		nfs_readpage_release(new, pgio.pg_error);
 	}
 	nfs_pageio_complete(&pgio);
 
@@ -153,6 +159,7 @@ static void nfs_page_group_set_uptodate(struct nfs_page *req)
 static void nfs_read_completion(struct nfs_pgio_header *hdr)
 {
 	unsigned long bytes = 0;
+	int error;
 
 	if (test_bit(NFS_IOHDR_REDO, &hdr->flags))
 		goto out;
@@ -179,14 +186,19 @@ static void nfs_read_completion(struct nfs_pgio_header *hdr)
 				zero_user_segment(page, start, end);
 			}
 		}
+		error = 0;
 		bytes += req->wb_bytes;
 		if (test_bit(NFS_IOHDR_ERROR, &hdr->flags)) {
 			if (bytes <= hdr->good_bytes)
 				nfs_page_group_set_uptodate(req);
+			else {
+				error = hdr->error;
+				xchg(&nfs_req_openctx(req)->error, error);
+			}
 		} else
 			nfs_page_group_set_uptodate(req);
 		nfs_list_remove_request(req);
-		nfs_readpage_release(req);
+		nfs_readpage_release(req, error);
 	}
 out:
 	hdr->release(hdr);
@@ -213,7 +225,7 @@ nfs_async_read_error(struct list_head *head, int error)
 	while (!list_empty(head)) {
 		req = nfs_list_entry(head->next);
 		nfs_list_remove_request(req);
-		nfs_readpage_release(req);
+		nfs_readpage_release(req, error);
 	}
 }
 
@@ -337,8 +349,13 @@ int nfs_readpage(struct file *file, struct page *page)
 			goto out;
 	}
 
+	xchg(&ctx->error, 0);
 	error = nfs_readpage_async(ctx, inode, page);
-
+	if (!error) {
+		error = wait_on_page_locked_killable(page);
+		if (!PageUptodate(page) && !error)
+			error = xchg(&ctx->error, 0);
+	}
 out:
 	put_nfs_open_context(ctx);
 	return error;
@@ -372,8 +389,8 @@ readpage_async_filler(void *data, struct page *page)
 		zero_user_segment(page, len, PAGE_SIZE);
 	if (!nfs_pageio_add_request(desc->pgio, new)) {
 		nfs_list_remove_request(new);
-		nfs_readpage_release(new);
 		error = desc->pgio->pg_error;
+		nfs_readpage_release(new, error);
 		goto out;
 	}
 	return 0;
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index bf3a3f5e1884e..f15dda5efb741 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -599,18 +599,6 @@ static void nfs_write_error(struct nfs_page *req, int error)
 	nfs_release_request(req);
 }
 
-static bool
-nfs_error_is_fatal_on_server(int err)
-{
-	switch (err) {
-	case 0:
-	case -ERESTARTSYS:
-	case -EINTR:
-		return false;
-	}
-	return nfs_error_is_fatal(err);
-}
-
 /*
  * Find an associated nfs write request, and prepare to flush it out
  * May return an error if the user signalled nfs_wait_on_request().
-- 
2.20.1

