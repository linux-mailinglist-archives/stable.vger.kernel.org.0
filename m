Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B9C2F9F84
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390769AbhARM0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:26:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390760AbhARLps (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9665D22D6D;
        Mon, 18 Jan 2021 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970312;
        bh=COXDG+oE+rl5dUnnvqwdIPGPaZUIGMomsyAMLsSDo6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+pLBvKUZWA0R7z5KylIqZv4grCogHCHagsHoGst9obkiwUjBcwWQXmfdobukSlfO
         ay8jMbRaElUHPasSNpzw/jqVbAD+YD50a1c3e2d1jv1IG9/xn6KxgEprmeh+uYUl9D
         naGZfXIwJa/K5b6U8zE4UDWWHu10C+12zE2SYzsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 126/152] NFS/pNFS: Dont call pnfs_free_bucket_lseg() before removing the request
Date:   Mon, 18 Jan 2021 12:35:01 +0100
Message-Id: <20210118113358.765493266@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 1757655d780d9d29bc4b60e708342e94924f7ef3 upstream.

In pnfs_generic_clear_request_commit(), we try calling
pnfs_free_bucket_lseg() before we remove the request from the DS bucket.
That will always fail, since the point is to test for whether or not
that bucket is empty.

Fixes: c84bea59449a ("NFS/pNFS: Simplify bucket layout segment reference counting")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/pnfs_nfs.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -78,22 +78,18 @@ void
 pnfs_generic_clear_request_commit(struct nfs_page *req,
 				  struct nfs_commit_info *cinfo)
 {
-	struct pnfs_layout_segment *freeme = NULL;
+	struct pnfs_commit_bucket *bucket = NULL;
 
 	if (!test_and_clear_bit(PG_COMMIT_TO_DS, &req->wb_flags))
 		goto out;
 	cinfo->ds->nwritten--;
-	if (list_is_singular(&req->wb_list)) {
-		struct pnfs_commit_bucket *bucket;
-
+	if (list_is_singular(&req->wb_list))
 		bucket = list_first_entry(&req->wb_list,
-					  struct pnfs_commit_bucket,
-					  written);
-		freeme = pnfs_free_bucket_lseg(bucket);
-	}
+					  struct pnfs_commit_bucket, written);
 out:
 	nfs_request_remove_commit_list(req, cinfo);
-	pnfs_put_lseg(freeme);
+	if (bucket)
+		pnfs_put_lseg(pnfs_free_bucket_lseg(bucket));
 }
 EXPORT_SYMBOL_GPL(pnfs_generic_clear_request_commit);
 


