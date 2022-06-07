Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B765415A9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376810AbiFGUhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377943AbiFGUek (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2406B17FC06;
        Tue,  7 Jun 2022 11:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7164F60B3D;
        Tue,  7 Jun 2022 18:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CFEC385A2;
        Tue,  7 Jun 2022 18:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627013;
        bh=WXLvoDEgOURHcqxi5b70GJyTNlEI6Sj6KOIHstgFnBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evtZEGj0vIL7DIGRH+8wGZQiQaDsHI7vSnuBvI9rF2LErS2iTJxRVvftc/ORSOubw
         tgFVyRvhBDnw0Qn6Tq/FdpGgm/dQkbPbx2ZNzoM8nNzGZUuPW5K0O8iWXN06aPwbTL
         qSu8FSdRrvBVarzxc5OGNsv+mufD+meumUrKIRMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <aglo@umich.edu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 586/772] NFS: Further fixes to the writeback error handling
Date:   Tue,  7 Jun 2022 19:02:58 +0200
Message-Id: <20220607165006.215044926@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit c6fd3511c3397dd9cbc6dc5d105bbedb69bf4061 ]

When we handle an error by redirtying the page, we're not corrupting the
mapping, so we don't want the error to be recorded in the mapping.
If the caller has specified a sync_mode of WB_SYNC_NONE, we can just
return AOP_WRITEPAGE_ACTIVATE. However if we're dealing with
WB_SYNC_ALL, we need to ensure that retries happen when the errors are
non-fatal.

Reported-by: Olga Kornievskaia <aglo@umich.edu>
Fixes: 8fc75bed96bb ("NFS: Fix up return value on fatal errors in nfs_page_async_flush()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index b28be2582c90..477162d2e8a2 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -603,8 +603,9 @@ static void nfs_write_error(struct nfs_page *req, int error)
  * Find an associated nfs write request, and prepare to flush it out
  * May return an error if the user signalled nfs_wait_on_request().
  */
-static int nfs_page_async_flush(struct nfs_pageio_descriptor *pgio,
-				struct page *page)
+static int nfs_page_async_flush(struct page *page,
+				struct writeback_control *wbc,
+				struct nfs_pageio_descriptor *pgio)
 {
 	struct nfs_page *req;
 	int ret = 0;
@@ -630,11 +631,11 @@ static int nfs_page_async_flush(struct nfs_pageio_descriptor *pgio,
 		/*
 		 * Remove the problematic req upon fatal errors on the server
 		 */
-		if (nfs_error_is_fatal(ret)) {
-			if (nfs_error_is_fatal_on_server(ret))
-				goto out_launder;
-		} else
-			ret = -EAGAIN;
+		if (nfs_error_is_fatal_on_server(ret))
+			goto out_launder;
+		if (wbc->sync_mode == WB_SYNC_NONE)
+			ret = AOP_WRITEPAGE_ACTIVATE;
+		redirty_page_for_writepage(wbc, page);
 		nfs_redirty_request(req);
 		pgio->pg_error = 0;
 	} else
@@ -650,15 +651,8 @@ static int nfs_page_async_flush(struct nfs_pageio_descriptor *pgio,
 static int nfs_do_writepage(struct page *page, struct writeback_control *wbc,
 			    struct nfs_pageio_descriptor *pgio)
 {
-	int ret;
-
 	nfs_pageio_cond_complete(pgio, page_index(page));
-	ret = nfs_page_async_flush(pgio, page);
-	if (ret == -EAGAIN) {
-		redirty_page_for_writepage(wbc, page);
-		ret = AOP_WRITEPAGE_ACTIVATE;
-	}
-	return ret;
+	return nfs_page_async_flush(page, wbc, pgio);
 }
 
 /*
@@ -725,12 +719,15 @@ int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 		priority = wb_priority(wbc);
 	}
 
-	nfs_pageio_init_write(&pgio, inode, priority, false,
-				&nfs_async_write_completion_ops);
-	pgio.pg_io_completion = ioc;
-	err = write_cache_pages(mapping, wbc, nfs_writepages_callback, &pgio);
-	pgio.pg_error = 0;
-	nfs_pageio_complete(&pgio);
+	do {
+		nfs_pageio_init_write(&pgio, inode, priority, false,
+				      &nfs_async_write_completion_ops);
+		pgio.pg_io_completion = ioc;
+		err = write_cache_pages(mapping, wbc, nfs_writepages_callback,
+					&pgio);
+		pgio.pg_error = 0;
+		nfs_pageio_complete(&pgio);
+	} while (err < 0 && !nfs_error_is_fatal(err));
 	nfs_io_completion_put(ioc);
 
 	if (err < 0)
-- 
2.35.1



