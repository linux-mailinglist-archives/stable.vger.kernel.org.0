Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2303CE4F5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346590AbhGSPrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:47:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349552AbhGSPpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFD30613EB;
        Mon, 19 Jul 2021 16:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711928;
        bh=6aTflyQFmFomlDwzDmPE7l9RTZTxsm8IuLC6j0pLP30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NwECPMPdnfUfOJr4Hu29FnzeuIQVxig9j/2NKaDdu4Wk14t6/PObwIbDk0M/yTMRO
         Isxgo7y8Xcj9a2KxQtlgtyQYTnesTQkn6+hWMaZ7Qn7NXqRsoWvIN6pakpLhch6htH
         LkCB+JRPN7LRTJKib5mab1eRUYqIK5RVwfSzMudM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 183/292] NFSv4: Fix an Oops in pnfs_mark_request_commit() when doing O_DIRECT
Date:   Mon, 19 Jul 2021 16:54:05 +0200
Message-Id: <20210719144948.514357582@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 3731d44bba8e0116b052b1b374476c5f6dd9a456 ]

Fix an Oopsable condition in pnfs_mark_request_commit() when we're
putting a set of writes on the commit list to reschedule them after a
failed pNFS attempt.

Fixes: 9c455a8c1e14 ("NFS/pNFS: Clean up pNFS commit operations")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 2d30a4da49fa..2e894fec036b 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -700,8 +700,8 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 {
 	struct nfs_direct_req *dreq = hdr->dreq;
 	struct nfs_commit_info cinfo;
-	bool request_commit = false;
 	struct nfs_page *req = nfs_list_entry(hdr->pages.next);
+	int flags = NFS_ODIRECT_DONE;
 
 	nfs_init_cinfo_from_dreq(&cinfo, dreq);
 
@@ -713,15 +713,9 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 
 	nfs_direct_count_bytes(dreq, hdr);
 	if (hdr->good_bytes != 0 && nfs_write_need_commit(hdr)) {
-		switch (dreq->flags) {
-		case 0:
+		if (!dreq->flags)
 			dreq->flags = NFS_ODIRECT_DO_COMMIT;
-			request_commit = true;
-			break;
-		case NFS_ODIRECT_RESCHED_WRITES:
-		case NFS_ODIRECT_DO_COMMIT:
-			request_commit = true;
-		}
+		flags = dreq->flags;
 	}
 	spin_unlock(&dreq->lock);
 
@@ -729,12 +723,15 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 
 		req = nfs_list_entry(hdr->pages.next);
 		nfs_list_remove_request(req);
-		if (request_commit) {
+		if (flags == NFS_ODIRECT_DO_COMMIT) {
 			kref_get(&req->wb_kref);
 			memcpy(&req->wb_verf, &hdr->verf.verifier,
 			       sizeof(req->wb_verf));
 			nfs_mark_request_commit(req, hdr->lseg, &cinfo,
 				hdr->ds_commit_idx);
+		} else if (flags == NFS_ODIRECT_RESCHED_WRITES) {
+			kref_get(&req->wb_kref);
+			nfs_mark_request_commit(req, NULL, &cinfo, 0);
 		}
 		nfs_unlock_and_release_request(req);
 	}
-- 
2.30.2



