Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A822A8CD3
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731736AbfIDQSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732147AbfIDP6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AB1A22CF7;
        Wed,  4 Sep 2019 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612733;
        bh=mwSawzqvGepzHhzYcW+mOuWO/xbS9HzV7XVFuIbeqYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+oLNgIiPDygsj5VYVysVCrjMZPhzAQLrGeqrS9FEKeYdKwmb87Ax0muAmhLwyHC+
         /OGq+kCmfJjs+08/ZpMsEiLv0aRd5Koqp5C/q4K6k90RKi86JiqHqxPi9VJrnsVtS6
         owAVrhMQ6g8vP5t1Qfc2qIy4Oo144cWBLEQPqOYI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 49/94] NFS: Fix writepage(s) error handling to not report errors twice
Date:   Wed,  4 Sep 2019 11:56:54 -0400
Message-Id: <20190904155739.2816-49-sashal@kernel.org>
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

