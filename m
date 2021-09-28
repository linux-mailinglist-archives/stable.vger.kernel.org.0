Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C479541A75C
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238921AbhI1F5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238877AbhI1F5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 729FA611CC;
        Tue, 28 Sep 2021 05:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808527;
        bh=8hgJn1Ih+9Ernuswh+NV/WK81g7IXRnOXBF10QK3Gsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8lvlS3Ve9VZCLZaAqXmGKwh4s1500vVDahHEB+1xdww9gmReNMKDXcqC+qqamaHT
         EdNm3KSOANSg5Kcu5T4NYYH6/QZBVipe4l9QzOejSEUR8HKJOAx7smAE1ubuwGN0o8
         yphJuNgCDhlQQZHZrI37iH8SNyBvyUMXIGud2/StXPAFuAgsqxJ5iX13+R/OIJCi/B
         s647ejz+iAaw7Sr9ZsZBbAs8dY4XP9+7uFpdae9Y1JaDUD49bUbQF0t6Bk6fEsvywB
         WYlrBbxGXgGzS1qYeXra1ZPCPceX8TKE5125afKvI+5BtJMdirY1ixszuQUEW+y43h
         l6Gntqn8txB2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dai Ngo <dai.ngo@oracle.com>, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, bfields@fieldses.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 05/40] nfsd: back channel stuck in SEQ4_STATUS_CB_PATH_DOWN
Date:   Tue, 28 Sep 2021 01:54:49 -0400
Message-Id: <20210928055524.172051-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 02579b2ff8b0becfb51d85a975908ac4ab15fba8 ]

When the back channel enters SEQ4_STATUS_CB_PATH_DOWN state, the client
recovers by sending BIND_CONN_TO_SESSION but the server fails to recover
the back channel and leaves it as NFSD4_CB_DOWN.

Fix by enhancing nfsd4_bind_conn_to_session to probe the back channel
by calling nfsd4_probe_callback.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 3d805f5b1f5d..1c33a5255893 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3570,7 +3570,7 @@ static struct nfsd4_conn *__nfsd4_find_conn(struct svc_xprt *xpt, struct nfsd4_s
 }
 
 static __be32 nfsd4_match_existing_connection(struct svc_rqst *rqst,
-				struct nfsd4_session *session, u32 req)
+		struct nfsd4_session *session, u32 req, struct nfsd4_conn **conn)
 {
 	struct nfs4_client *clp = session->se_client;
 	struct svc_xprt *xpt = rqst->rq_xprt;
@@ -3593,6 +3593,8 @@ static __be32 nfsd4_match_existing_connection(struct svc_rqst *rqst,
 	else
 		status = nfserr_inval;
 	spin_unlock(&clp->cl_lock);
+	if (status == nfs_ok && conn)
+		*conn = c;
 	return status;
 }
 
@@ -3617,8 +3619,16 @@ __be32 nfsd4_bind_conn_to_session(struct svc_rqst *rqstp,
 	status = nfserr_wrong_cred;
 	if (!nfsd4_mach_creds_match(session->se_client, rqstp))
 		goto out;
-	status = nfsd4_match_existing_connection(rqstp, session, bcts->dir);
-	if (status == nfs_ok || status == nfserr_inval)
+	status = nfsd4_match_existing_connection(rqstp, session,
+			bcts->dir, &conn);
+	if (status == nfs_ok) {
+		if (bcts->dir == NFS4_CDFC4_FORE_OR_BOTH ||
+				bcts->dir == NFS4_CDFC4_BACK)
+			conn->cn_flags |= NFS4_CDFC4_BACK;
+		nfsd4_probe_callback(session->se_client);
+		goto out;
+	}
+	if (status == nfserr_inval)
 		goto out;
 	status = nfsd4_map_bcts_dir(&bcts->dir);
 	if (status)
-- 
2.33.0

