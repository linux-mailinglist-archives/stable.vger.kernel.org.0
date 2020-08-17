Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A5C246B74
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388037AbgHQPzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388024AbgHQPz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:55:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19A26206FA;
        Mon, 17 Aug 2020 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679727;
        bh=b1Joc9SR0SknpivEopfDwLGYXHEMh8/ddplm6ONQKW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+3uFE78lp9HL82QnmJKW7AEkXy1jUFL5d5wt2tkdzc5MsultonD+9z3y9pbUwvda
         oWLET39CBXx19HG1Vvx5tBtwIyVszCGzr/OuKbHn63dSiTIK7vmOlFyiu6644+tgwG
         afowdWerLO2UMXalvwrkHi/Hu5X8kCVGoDXzzGo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 313/393] nfsd: avoid a NULL dereference in __cld_pipe_upcall()
Date:   Mon, 17 Aug 2020 17:16:03 +0200
Message-Id: <20200817143834.793032974@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit df60446cd1fb487becd1f36f4c0da9e0e523c0cf ]

If the rpc_pipefs is unmounted, then the rpc_pipe->dentry becomes NULL
and dereferencing the dentry->d_sb will trigger an oops.  The only
reason we're doing that is to determine the nfsd_net, which could
instead be passed in by the caller.  So do that instead.

Fixes: 11a60d159259 ("nfsd: add a "GetVersion" upcall for nfsdcld")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index a8fb18609146a..82679990dd9b4 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -755,13 +755,11 @@ struct cld_upcall {
 };
 
 static int
-__cld_pipe_upcall(struct rpc_pipe *pipe, void *cmsg)
+__cld_pipe_upcall(struct rpc_pipe *pipe, void *cmsg, struct nfsd_net *nn)
 {
 	int ret;
 	struct rpc_pipe_msg msg;
 	struct cld_upcall *cup = container_of(cmsg, struct cld_upcall, cu_u);
-	struct nfsd_net *nn = net_generic(pipe->dentry->d_sb->s_fs_info,
-					  nfsd_net_id);
 
 	memset(&msg, 0, sizeof(msg));
 	msg.data = cmsg;
@@ -781,7 +779,7 @@ __cld_pipe_upcall(struct rpc_pipe *pipe, void *cmsg)
 }
 
 static int
-cld_pipe_upcall(struct rpc_pipe *pipe, void *cmsg)
+cld_pipe_upcall(struct rpc_pipe *pipe, void *cmsg, struct nfsd_net *nn)
 {
 	int ret;
 
@@ -790,7 +788,7 @@ cld_pipe_upcall(struct rpc_pipe *pipe, void *cmsg)
 	 *  upcalls queued.
 	 */
 	do {
-		ret = __cld_pipe_upcall(pipe, cmsg);
+		ret = __cld_pipe_upcall(pipe, cmsg, nn);
 	} while (ret == -EAGAIN);
 
 	return ret;
@@ -1123,7 +1121,7 @@ nfsd4_cld_create(struct nfs4_client *clp)
 	memcpy(cup->cu_u.cu_msg.cm_u.cm_name.cn_id, clp->cl_name.data,
 			clp->cl_name.len);
 
-	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg);
+	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg, nn);
 	if (!ret) {
 		ret = cup->cu_u.cu_msg.cm_status;
 		set_bit(NFSD4_CLIENT_STABLE, &clp->cl_flags);
@@ -1191,7 +1189,7 @@ nfsd4_cld_create_v2(struct nfs4_client *clp)
 	} else
 		cmsg->cm_u.cm_clntinfo.cc_princhash.cp_len = 0;
 
-	ret = cld_pipe_upcall(cn->cn_pipe, cmsg);
+	ret = cld_pipe_upcall(cn->cn_pipe, cmsg, nn);
 	if (!ret) {
 		ret = cmsg->cm_status;
 		set_bit(NFSD4_CLIENT_STABLE, &clp->cl_flags);
@@ -1229,7 +1227,7 @@ nfsd4_cld_remove(struct nfs4_client *clp)
 	memcpy(cup->cu_u.cu_msg.cm_u.cm_name.cn_id, clp->cl_name.data,
 			clp->cl_name.len);
 
-	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg);
+	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg, nn);
 	if (!ret) {
 		ret = cup->cu_u.cu_msg.cm_status;
 		clear_bit(NFSD4_CLIENT_STABLE, &clp->cl_flags);
@@ -1272,7 +1270,7 @@ nfsd4_cld_check_v0(struct nfs4_client *clp)
 	memcpy(cup->cu_u.cu_msg.cm_u.cm_name.cn_id, clp->cl_name.data,
 			clp->cl_name.len);
 
-	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg);
+	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg, nn);
 	if (!ret) {
 		ret = cup->cu_u.cu_msg.cm_status;
 		set_bit(NFSD4_CLIENT_STABLE, &clp->cl_flags);
@@ -1418,7 +1416,7 @@ nfsd4_cld_grace_start(struct nfsd_net *nn)
 	}
 
 	cup->cu_u.cu_msg.cm_cmd = Cld_GraceStart;
-	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg);
+	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg, nn);
 	if (!ret)
 		ret = cup->cu_u.cu_msg.cm_status;
 
@@ -1446,7 +1444,7 @@ nfsd4_cld_grace_done_v0(struct nfsd_net *nn)
 
 	cup->cu_u.cu_msg.cm_cmd = Cld_GraceDone;
 	cup->cu_u.cu_msg.cm_u.cm_gracetime = nn->boot_time;
-	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg);
+	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg, nn);
 	if (!ret)
 		ret = cup->cu_u.cu_msg.cm_status;
 
@@ -1474,7 +1472,7 @@ nfsd4_cld_grace_done(struct nfsd_net *nn)
 	}
 
 	cup->cu_u.cu_msg.cm_cmd = Cld_GraceDone;
-	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg);
+	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg, nn);
 	if (!ret)
 		ret = cup->cu_u.cu_msg.cm_status;
 
@@ -1538,7 +1536,7 @@ nfsd4_cld_get_version(struct nfsd_net *nn)
 		goto out_err;
 	}
 	cup->cu_u.cu_msg.cm_cmd = Cld_GetVersion;
-	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg);
+	ret = cld_pipe_upcall(cn->cn_pipe, &cup->cu_u.cu_msg, nn);
 	if (!ret) {
 		ret = cup->cu_u.cu_msg.cm_status;
 		if (ret)
-- 
2.25.1



