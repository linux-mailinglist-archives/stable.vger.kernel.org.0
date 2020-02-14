Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 862D815E90D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404149AbgBNRE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:04:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392453AbgBNQPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:15:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE185246E1;
        Fri, 14 Feb 2020 16:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696930;
        bh=riPJA8zysV8grLm/AFidySN3vpdQ+3x0Y6KEiYJazbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YM1zJSB1xtVbSt7G+5HMn4f6E7Dsw3XZboOSJHtQcsr7DoEWS8vckj5edNoZddbM
         cYhGD3a/BllaFmxr+1dxrI2EU/eMeAuj2+zMrWntHI80czoYWNUugW7AgdRnuFz1LV
         YJEt2EfyJ7MSTxDRMPtNqzZvQwZKcfahpMcg6SeU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trondmy@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 176/252] NFS/pnfs: Fix pnfs_generic_prepare_to_resend_writes()
Date:   Fri, 14 Feb 2020 11:10:31 -0500
Message-Id: <20200214161147.15842-176-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 221203ce6406273cf00e5c6397257d986c003ee6 ]

Instead of making assumptions about the commit verifier contents, change
the commit code to ensure we always check that the verifier was set
by the XDR code.

Fixes: f54bcf2ecee9 ("pnfs: Prepare for flexfiles by pulling out common code")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c   | 4 ++--
 fs/nfs/nfs3xdr.c  | 5 ++++-
 fs/nfs/nfs4xdr.c  | 5 ++++-
 fs/nfs/pnfs_nfs.c | 7 +++----
 fs/nfs/write.c    | 4 +++-
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 29b70337dcd9f..c61bd3fc723ee 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -261,10 +261,10 @@ static int nfs_direct_cmp_commit_data_verf(struct nfs_direct_req *dreq,
 					 data->ds_commit_index);
 
 	/* verifier not set so always fail */
-	if (verfp->committed < 0)
+	if (verfp->committed < 0 || data->res.verf->committed <= NFS_UNSTABLE)
 		return 1;
 
-	return nfs_direct_cmp_verf(verfp, &data->verf);
+	return nfs_direct_cmp_verf(verfp, data->res.verf);
 }
 
 /**
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index 64e4fa33d89f0..9956453aa6ffc 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -2380,6 +2380,7 @@ static int nfs3_xdr_dec_commit3res(struct rpc_rqst *req,
 				   void *data)
 {
 	struct nfs_commitres *result = data;
+	struct nfs_writeverf *verf = result->verf;
 	enum nfs_stat status;
 	int error;
 
@@ -2392,7 +2393,9 @@ static int nfs3_xdr_dec_commit3res(struct rpc_rqst *req,
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
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 1c0227c78a7bc..c4cf0192d7bb8 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4439,11 +4439,14 @@ static int decode_write_verifier(struct xdr_stream *xdr, struct nfs_write_verifi
 
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
 
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index d5e4d3cd8c7f1..acfb52bc0007d 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -30,12 +30,11 @@ EXPORT_SYMBOL_GPL(pnfs_generic_rw_release);
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
 
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index e8152781814dd..ce1da8cbac003 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1814,6 +1814,7 @@ static void nfs_commit_done(struct rpc_task *task, void *calldata)
 
 static void nfs_commit_release_pages(struct nfs_commit_data *data)
 {
+	const struct nfs_writeverf *verf = data->res.verf;
 	struct nfs_page	*req;
 	int status = data->task.tk_status;
 	struct nfs_commit_info cinfo;
@@ -1840,7 +1841,8 @@ static void nfs_commit_release_pages(struct nfs_commit_data *data)
 
 		/* Okay, COMMIT succeeded, apparently. Check the verifier
 		 * returned by the server against all stored verfs. */
-		if (!nfs_write_verifier_cmp(&req->wb_verf, &data->verf.verifier)) {
+		if (verf->committed > NFS_UNSTABLE &&
+		    !nfs_write_verifier_cmp(&req->wb_verf, &verf->verifier)) {
 			/* We have a match */
 			if (req->wb_page)
 				nfs_inode_remove_request(req);
-- 
2.20.1

