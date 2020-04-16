Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628251AC8CD
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502710AbgDPPOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441669AbgDPNuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:50:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAE6922250;
        Thu, 16 Apr 2020 13:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045002;
        bh=7TCSdWKuzTv+3biIWXj1nC1I9NWCKG66xkzKdYXC158=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=voFoplQtVb6J9jP4QTJ3u3b2AFhEsG9zTrO2fPPJp/ujSZGE3fh9l1jD4jkJyE34L
         93eGRlDQ/Zo+AyEcpirR8S+7BjQ6F+gfEcIdxoL5Pf4jPG6My1sW7Srv3vK1wsh9rf
         yGOKyhXoEDqgmk2mfczuQ9uQJ26Suw5FkPruCCVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 190/232] NFS: Fix use-after-free issues in nfs_pageio_add_request()
Date:   Thu, 16 Apr 2020 15:24:44 +0200
Message-Id: <20200416131338.905915129@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit dc9dc2febb17f72e9878eb540ad3996f7984239a upstream.

We need to ensure that we create the mirror requests before calling
nfs_pageio_add_request_mirror() on the request we are adding.
Otherwise, we can end up with a use-after-free if the call to
nfs_pageio_add_request_mirror() triggers I/O.

Fixes: c917cfaf9bbe ("NFS: Fix up NFS I/O subrequest creation")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/pagelist.c |   48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -1177,38 +1177,38 @@ int nfs_pageio_add_request(struct nfs_pa
 	if (desc->pg_error < 0)
 		goto out_failed;
 
-	for (midx = 0; midx < desc->pg_mirror_count; midx++) {
-		if (midx) {
-			nfs_page_group_lock(req);
-
-			/* find the last request */
-			for (lastreq = req->wb_head;
-			     lastreq->wb_this_page != req->wb_head;
-			     lastreq = lastreq->wb_this_page)
-				;
-
-			dupreq = nfs_create_subreq(req, lastreq,
-					pgbase, offset, bytes);
-
-			nfs_page_group_unlock(req);
-			if (IS_ERR(dupreq)) {
-				desc->pg_error = PTR_ERR(dupreq);
-				goto out_failed;
-			}
-		} else
-			dupreq = req;
+	/* Create the mirror instances first, and fire them off */
+	for (midx = 1; midx < desc->pg_mirror_count; midx++) {
+		nfs_page_group_lock(req);
+
+		/* find the last request */
+		for (lastreq = req->wb_head;
+		     lastreq->wb_this_page != req->wb_head;
+		     lastreq = lastreq->wb_this_page)
+			;
+
+		dupreq = nfs_create_subreq(req, lastreq,
+				pgbase, offset, bytes);
+
+		nfs_page_group_unlock(req);
+		if (IS_ERR(dupreq)) {
+			desc->pg_error = PTR_ERR(dupreq);
+			goto out_failed;
+		}
 
-		if (nfs_pgio_has_mirroring(desc))
-			desc->pg_mirror_idx = midx;
+		desc->pg_mirror_idx = midx;
 		if (!nfs_pageio_add_request_mirror(desc, dupreq))
 			goto out_cleanup_subreq;
 	}
 
+	desc->pg_mirror_idx = 0;
+	if (!nfs_pageio_add_request_mirror(desc, req))
+		goto out_failed;
+
 	return 1;
 
 out_cleanup_subreq:
-	if (req != dupreq)
-		nfs_pageio_cleanup_request(desc, dupreq);
+	nfs_pageio_cleanup_request(desc, dupreq);
 out_failed:
 	nfs_pageio_error_cleanup(desc);
 	return 0;


