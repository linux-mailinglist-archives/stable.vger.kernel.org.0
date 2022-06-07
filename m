Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9094A540DD8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354169AbiFGSu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354539AbiFGSrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BA1A3392;
        Tue,  7 Jun 2022 11:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DC0DB82340;
        Tue,  7 Jun 2022 18:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1800C385A5;
        Tue,  7 Jun 2022 18:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624914;
        bh=yU4Y4CWGbafh5hjlrIEjgy3QRA7QZ+6FNUPtpvxdkCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+UxZOup+sCD8li34hrG4k/8lJAkC8Ep2l3cAEu+x4e7jY5acvWONpBGMQL43x6lF
         WEDNLMa/LNcK5It9EbCY2zS1AwwQHdlEgA6tL1Ti097LjqZ2nAZF7oF1UyMMFquHSw
         fnUlhkScQIv/dHXgMO7/cXcq2Tqnui0r+JdFg06g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <aglo@umich.edu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 499/667] NFS: Further fixes to the writeback error handling
Date:   Tue,  7 Jun 2022 19:02:44 +0200
Message-Id: <20220607164949.666512678@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
index f47cf3e8c720..c2bc6c43d257 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -601,8 +601,9 @@ static void nfs_write_error(struct nfs_page *req, int error)
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
@@ -628,11 +629,11 @@ static int nfs_page_async_flush(struct nfs_pageio_descriptor *pgio,
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
@@ -648,15 +649,8 @@ static int nfs_page_async_flush(struct nfs_pageio_descriptor *pgio,
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
@@ -723,12 +717,15 @@ int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
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



