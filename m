Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94234B8441
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405397AbfISWJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405379AbfISWJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:09:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4C4321928;
        Thu, 19 Sep 2019 22:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930958;
        bh=mwSawzqvGepzHhzYcW+mOuWO/xbS9HzV7XVFuIbeqYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03rHlmI5zdQ7GLrnz/CWwkxVaZ1Ve+m2M0M9hIVhKuPN4gQF9IyithcXvwrC3/8wk
         KGWHx+Kz5VGTvKyq+bdU0Ds2UI/pqSklp8eeea0euoMvBv9J9i3n4I+bsMS9oq59IJ
         E4ypuxiE2k/8864ONtpt8/INBk6o24FjdGF5iIU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 069/124] NFS: Fix writepage(s) error handling to not report errors twice
Date:   Fri, 20 Sep 2019 00:02:37 +0200
Message-Id: <20190919214821.507334926@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 96c4145599b30c0eb6cbeaa24207802452dd1872 ]

If writepage()/writepages() saw an error, but handled it without
reporting it, we should not be re-reporting that error on exit.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index f15dda5efb741..0d6d7beb85053 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -621,12 +621,12 @@ static int nfs_page_async_flush(struct nfs_pageio_descriptor *pgio,
 	WARN_ON_ONCE(test_bit(PG_CLEAN, &req->wb_flags));
 
 	/* If there is a fatal error that covers this write, just exit */
-	ret = 0;
 	mapping = page_file_mapping(page);
-	if (test_bit(AS_ENOSPC, &mapping->flags) ||
-	    test_bit(AS_EIO, &mapping->flags))
+	ret = pgio->pg_error;
+	if (nfs_error_is_fatal_on_server(ret))
 		goto out_launder;
 
+	ret = 0;
 	if (!nfs_pageio_add_request(pgio, req)) {
 		ret = pgio->pg_error;
 		/*
@@ -638,6 +638,7 @@ static int nfs_page_async_flush(struct nfs_pageio_descriptor *pgio,
 		} else
 			ret = -EAGAIN;
 		nfs_redirty_request(req);
+		pgio->pg_error = 0;
 	} else
 		nfs_add_stats(page_file_mapping(page)->host,
 				NFSIOS_WRITEPAGES, 1);
@@ -657,7 +658,7 @@ static int nfs_do_writepage(struct page *page, struct writeback_control *wbc,
 	ret = nfs_page_async_flush(pgio, page);
 	if (ret == -EAGAIN) {
 		redirty_page_for_writepage(wbc, page);
-		ret = 0;
+		ret = AOP_WRITEPAGE_ACTIVATE;
 	}
 	return ret;
 }
@@ -676,10 +677,11 @@ static int nfs_writepage_locked(struct page *page,
 	nfs_pageio_init_write(&pgio, inode, 0,
 				false, &nfs_async_write_completion_ops);
 	err = nfs_do_writepage(page, wbc, &pgio);
+	pgio.pg_error = 0;
 	nfs_pageio_complete(&pgio);
 	if (err < 0)
 		return err;
-	if (pgio.pg_error < 0)
+	if (nfs_error_is_fatal(pgio.pg_error))
 		return pgio.pg_error;
 	return 0;
 }
@@ -689,7 +691,8 @@ int nfs_writepage(struct page *page, struct writeback_control *wbc)
 	int ret;
 
 	ret = nfs_writepage_locked(page, wbc);
-	unlock_page(page);
+	if (ret != AOP_WRITEPAGE_ACTIVATE)
+		unlock_page(page);
 	return ret;
 }
 
@@ -698,7 +701,8 @@ static int nfs_writepages_callback(struct page *page, struct writeback_control *
 	int ret;
 
 	ret = nfs_do_writepage(page, wbc, data);
-	unlock_page(page);
+	if (ret != AOP_WRITEPAGE_ACTIVATE)
+		unlock_page(page);
 	return ret;
 }
 
@@ -725,6 +729,7 @@ int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 				&nfs_async_write_completion_ops);
 	pgio.pg_io_completion = ioc;
 	err = write_cache_pages(mapping, wbc, nfs_writepages_callback, &pgio);
+	pgio.pg_error = 0;
 	nfs_pageio_complete(&pgio);
 	nfs_io_completion_put(ioc);
 
@@ -733,7 +738,7 @@ int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 	if (err < 0)
 		goto out_err;
 	err = pgio.pg_error;
-	if (err < 0)
+	if (nfs_error_is_fatal(err))
 		goto out_err;
 	return 0;
 out_err:
-- 
2.20.1



