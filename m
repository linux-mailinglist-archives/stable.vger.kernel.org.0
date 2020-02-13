Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1164E15C40D
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387616AbgBMP0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:26:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728844AbgBMP0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:38 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 155762467C;
        Thu, 13 Feb 2020 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607597;
        bh=IJpjRiOLbSqEhtq0ENmlYXhXJ9LGqGQS8O/WZpPfKdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjAdfSbKjTzFXIvB91i3tRmrBdF6GEByRIjJ51KObT8ENZ0ZOU9QUwFE5dDXX06No
         1AcIxA1WTZdNEnCCVI1z18iohT+uHGmhV3HLLu4lneXrKN18AV1m02sM71Q/A0cAHb
         o5q1rmRHL4mM0B1IJFgNSwFRImdf1UwQF8zgceOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.19 14/52] NFS/pnfs: Fix pnfs_generic_prepare_to_resend_writes()
Date:   Thu, 13 Feb 2020 07:20:55 -0800
Message-Id: <20200213151816.832087433@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
References: <20200213151810.331796857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 221203ce6406273cf00e5c6397257d986c003ee6 upstream.

Instead of making assumptions about the commit verifier contents, change
the commit code to ensure we always check that the verifier was set
by the XDR code.

Fixes: f54bcf2ecee9 ("pnfs: Prepare for flexfiles by pulling out common code")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/direct.c   |    4 ++--
 fs/nfs/nfs3xdr.c  |    5 ++++-
 fs/nfs/nfs4xdr.c  |    5 ++++-
 fs/nfs/pnfs_nfs.c |    7 +++----
 fs/nfs/write.c    |    4 +++-
 5 files changed, 16 insertions(+), 9 deletions(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -261,10 +261,10 @@ static int nfs_direct_cmp_commit_data_ve
 					 data->ds_commit_index);
 
 	/* verifier not set so always fail */
-	if (verfp->committed < 0)
+	if (verfp->committed < 0 || data->res.verf->committed <= NFS_UNSTABLE)
 		return 1;
 
-	return nfs_direct_cmp_verf(verfp, &data->verf);
+	return nfs_direct_cmp_verf(verfp, data->res.verf);
 }
 
 /**
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -2380,6 +2380,7 @@ static int nfs3_xdr_dec_commit3res(struc
 				   void *data)
 {
 	struct nfs_commitres *result = data;
+	struct nfs_writeverf *verf = result->verf;
 	enum nfs_stat status;
 	int error;
 
@@ -2392,7 +2393,9 @@ static int nfs3_xdr_dec_commit3res(struc
 	result->op_status = status;
 	if (status != NFS3_OK)
 		goto out_status;
-	error = decode_writeverf3(xdr, &result->verf->verifier);
+	error = decode_writeverf3(xdr, &verf->verifier);
+	if (!error)
+		verf->committed = NFS_FILE_SYNC;
 out:
 	return error;
 out_status:
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4439,11 +4439,14 @@ static int decode_write_verifier(struct
 
 static int decode_commit(struct xdr_stream *xdr, struct nfs_commitres *res)
 {
+	struct nfs_writeverf *verf = res->verf;
 	int status;
 
 	status = decode_op_hdr(xdr, OP_COMMIT);
 	if (!status)
-		status = decode_write_verifier(xdr, &res->verf->verifier);
+		status = decode_write_verifier(xdr, &verf->verifier);
+	if (!status)
+		verf->committed = NFS_FILE_SYNC;
 	return status;
 }
 
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -30,12 +30,11 @@ EXPORT_SYMBOL_GPL(pnfs_generic_rw_releas
 /* Fake up some data that will cause nfs_commit_release to retry the writes. */
 void pnfs_generic_prepare_to_resend_writes(struct nfs_commit_data *data)
 {
-	struct nfs_page *first = nfs_list_entry(data->pages.next);
+	struct nfs_writeverf *verf = data->res.verf;
 
 	data->task.tk_status = 0;
-	memcpy(&data->verf.verifier, &first->wb_verf,
-	       sizeof(data->verf.verifier));
-	data->verf.verifier.data[0]++; /* ensure verifier mismatch */
+	memset(&verf->verifier, 0, sizeof(verf->verifier));
+	verf->committed = NFS_UNSTABLE;
 }
 EXPORT_SYMBOL_GPL(pnfs_generic_prepare_to_resend_writes);
 
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1814,6 +1814,7 @@ static void nfs_commit_done(struct rpc_t
 
 static void nfs_commit_release_pages(struct nfs_commit_data *data)
 {
+	const struct nfs_writeverf *verf = data->res.verf;
 	struct nfs_page	*req;
 	int status = data->task.tk_status;
 	struct nfs_commit_info cinfo;
@@ -1840,7 +1841,8 @@ static void nfs_commit_release_pages(str
 
 		/* Okay, COMMIT succeeded, apparently. Check the verifier
 		 * returned by the server against all stored verfs. */
-		if (!nfs_write_verifier_cmp(&req->wb_verf, &data->verf.verifier)) {
+		if (verf->committed > NFS_UNSTABLE &&
+		    !nfs_write_verifier_cmp(&req->wb_verf, &verf->verifier)) {
 			/* We have a match */
 			if (req->wb_page)
 				nfs_inode_remove_request(req);


