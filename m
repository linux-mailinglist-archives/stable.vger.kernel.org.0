Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A616C3CE571
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349378AbhGSPuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242729AbhGSPqU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:46:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3571F61241;
        Mon, 19 Jul 2021 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712019;
        bh=OmspyvnvLA1HVBdfgG/Hpumd9bm01t68OXzNd+vswFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ycw4sbw8BI0pb5eXwzi9EZwM81sH2v/UW5b6xOOnULxOooLiMxKX1QpR6+UQliLie
         /TvcUBdMSt/4nf8pPC/IEFy4I3SMcnjT0iYNHJtmoqD6+oEqN+US6hjBMGK4+ra52w
         wyclIT4XccwFUAp7FKDErwlvxE2z6IXmmeptExd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 218/292] NFS: Fix fscache read from NFS after cache error
Date:   Mon, 19 Jul 2021 16:54:40 +0200
Message-Id: <20210719144950.154056813@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit ba512c1bc3232124567a59a3995c773dc79716e8 ]

Earlier commits refactored some NFS read code and removed
nfs_readpage_async(), but neglected to properly fixup
nfs_readpage_from_fscache_complete().  The code path is
only hit when something unusual occurs with the cachefiles
backing filesystem, such as an IO error or while a cookie
is being invalidated.

Mark page with PG_checked if fscache IO completes in error,
unlock the page, and let the VM decide to re-issue based on
PG_uptodate.  When the VM reissues the readpage, PG_checked
allows us to skip over fscache and read from the server.

Link: https://marc.info/?l=linux-nfs&m=162498209518739
Fixes: 1e83b173b266 ("NFS: Add nfs_pageio_complete_read() and remove nfs_readpage_async()")
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fscache.c | 18 +++++++++++++-----
 fs/nfs/read.c    |  5 +++--
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index c4c021c6ebbd..d743629e05e1 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -385,12 +385,15 @@ static void nfs_readpage_from_fscache_complete(struct page *page,
 		 "NFS: readpage_from_fscache_complete (0x%p/0x%p/%d)\n",
 		 page, context, error);
 
-	/* if the read completes with an error, we just unlock the page and let
-	 * the VM reissue the readpage */
-	if (!error) {
+	/*
+	 * If the read completes with an error, mark the page with PG_checked,
+	 * unlock the page, and let the VM reissue the readpage.
+	 */
+	if (!error)
 		SetPageUptodate(page);
-		unlock_page(page);
-	}
+	else
+		SetPageChecked(page);
+	unlock_page(page);
 }
 
 /*
@@ -405,6 +408,11 @@ int __nfs_readpage_from_fscache(struct nfs_open_context *ctx,
 		 "NFS: readpage_from_fscache(fsc:%p/p:%p(i:%lx f:%lx)/0x%p)\n",
 		 nfs_i_fscache(inode), page, page->index, page->flags, inode);
 
+	if (PageChecked(page)) {
+		ClearPageChecked(page);
+		return 1;
+	}
+
 	ret = fscache_read_or_alloc_page(nfs_i_fscache(inode),
 					 page,
 					 nfs_readpage_from_fscache_complete,
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index d2b6dce1f99f..4ca50b70a7b0 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -363,13 +363,13 @@ int nfs_readpage(struct file *file, struct page *page)
 	} else
 		desc.ctx = get_nfs_open_context(nfs_file_open_context(file));
 
+	xchg(&desc.ctx->error, 0);
 	if (!IS_SYNC(inode)) {
 		ret = nfs_readpage_from_fscache(desc.ctx, inode, page);
 		if (ret == 0)
-			goto out;
+			goto out_wait;
 	}
 
-	xchg(&desc.ctx->error, 0);
 	nfs_pageio_init_read(&desc.pgio, inode, false,
 			     &nfs_async_read_completion_ops);
 
@@ -379,6 +379,7 @@ int nfs_readpage(struct file *file, struct page *page)
 		nfs_pageio_complete_read(&desc.pgio, inode);
 
 	ret = desc.pgio.pg_error < 0 ? desc.pgio.pg_error : 0;
+out_wait:
 	if (!ret) {
 		ret = wait_on_page_locked_killable(page);
 		if (!PageUptodate(page) && !ret)
-- 
2.30.2



