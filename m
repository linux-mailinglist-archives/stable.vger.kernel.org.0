Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D83426952
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242695AbhJHLgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241759AbhJHLeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:34:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C977C61350;
        Fri,  8 Oct 2021 11:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692693;
        bh=7IFTgHmDk+NZJOgLv6P8aY226whWo0FQCWtd7vn/C8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDanQpz05KeXhTGOdaxmm0d0DZ2A8VZ1RoL1lTMllJEikvmWdogZC8Keosgq4YifR
         wQBnSXOXQkHij+ene+Fgia/XwlBc86I3aRnkUYUmanrmtvyLRPbOt+KwSqJX3cTnxO
         ggkjjl+E0vhvVJQat/c0gO04VSiIazmV5SWpT83g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 04/29] nfsd: back channel stuck in SEQ4_STATUS_CB_PATH_DOWN
Date:   Fri,  8 Oct 2021 13:27:51 +0200
Message-Id: <20211008112717.072800853@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0313390fa4b4..1cdf7e0a5c22 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3512,7 +3512,7 @@ static struct nfsd4_conn *__nfsd4_find_conn(struct svc_xprt *xpt, struct nfsd4_s
 }
 
 static __be32 nfsd4_match_existing_connection(struct svc_rqst *rqst,
-				struct nfsd4_session *session, u32 req)
+		struct nfsd4_session *session, u32 req, struct nfsd4_conn **conn)
 {
 	struct nfs4_client *clp = session->se_client;
 	struct svc_xprt *xpt = rqst->rq_xprt;
@@ -3535,6 +3535,8 @@ static __be32 nfsd4_match_existing_connection(struct svc_rqst *rqst,
 	else
 		status = nfserr_inval;
 	spin_unlock(&clp->cl_lock);
+	if (status == nfs_ok && conn)
+		*conn = c;
 	return status;
 }
 
@@ -3559,8 +3561,16 @@ __be32 nfsd4_bind_conn_to_session(struct svc_rqst *rqstp,
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



