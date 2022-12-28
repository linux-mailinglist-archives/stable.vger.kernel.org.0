Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46318657873
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbiL1OvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiL1Ouh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:50:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71E4120A8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:50:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2EF43CE1337
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29535C433D2;
        Wed, 28 Dec 2022 14:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239032;
        bh=DocKAHVq/MdrJgsusRTatskEVQ3w9CxdGjV98ezDFrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0X7g56foqIw/u0uOh0sal81EUJKGPZV5Lyid+7ZBeMJI/p2Of77bUa8nupNikNMJH
         TKmPhUYFWO1hewG2vcCeUW4SJKJcNnMM/qmQNzeXq+5UdY1XGJkSIDzP9K81w7DY23
         nWfPO4n72bFua4AW0T0GavPQQHgtakfq7k8GXigE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Haowen Bai <baihaowen@meizu.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/731] SUNRPC: Return true/false (not 1/0) from bool functions
Date:   Wed, 28 Dec 2022 15:33:29 +0100
Message-Id: <20221228144259.507375790@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haowen Bai <baihaowen@meizu.com>

[ Upstream commit 5f7b839d47dbc74cf4a07beeab5191f93678673e ]

Return boolean values ("true" or "false") instead of 1 or 0 from bool
functions.  This fixes the following warnings from coccicheck:

./fs/nfsd/nfs2acl.c:289:9-10: WARNING: return of 0/1 in function
'nfsaclsvc_encode_accessres' with return type bool
./fs/nfsd/nfs2acl.c:252:9-10: WARNING: return of 0/1 in function
'nfsaclsvc_encode_getaclres' with return type bool

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: ea5021e911d3 ("NFSD: Finish converting the NFSv2 GETACL result encoder")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 4b43929c1f25..ec7776b0e868 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -249,34 +249,34 @@ static int nfsaclsvc_encode_getaclres(struct svc_rqst *rqstp, __be32 *p)
 	int w;
 
 	if (!svcxdr_encode_stat(xdr, resp->status))
-		return 0;
+		return false;
 
 	if (dentry == NULL || d_really_is_negative(dentry))
-		return 1;
+		return true;
 	inode = d_inode(dentry);
 
 	if (!svcxdr_encode_fattr(rqstp, xdr, &resp->fh, &resp->stat))
-		return 0;
+		return false;
 	if (xdr_stream_encode_u32(xdr, resp->mask) < 0)
-		return 0;
+		return false;
 
 	rqstp->rq_res.page_len = w = nfsacl_size(
 		(resp->mask & NFS_ACL)   ? resp->acl_access  : NULL,
 		(resp->mask & NFS_DFACL) ? resp->acl_default : NULL);
 	while (w > 0) {
 		if (!*(rqstp->rq_next_page++))
-			return 1;
+			return true;
 		w -= PAGE_SIZE;
 	}
 
 	if (!nfs_stream_encode_acl(xdr, inode, resp->acl_access,
 				   resp->mask & NFS_ACL, 0))
-		return 0;
+		return false;
 	if (!nfs_stream_encode_acl(xdr, inode, resp->acl_default,
 				   resp->mask & NFS_DFACL, NFS_ACL_DEFAULT))
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
 /* ACCESS */
@@ -286,17 +286,17 @@ static int nfsaclsvc_encode_accessres(struct svc_rqst *rqstp, __be32 *p)
 	struct nfsd3_accessres *resp = rqstp->rq_resp;
 
 	if (!svcxdr_encode_stat(xdr, resp->status))
-		return 0;
+		return false;
 	switch (resp->status) {
 	case nfs_ok:
 		if (!svcxdr_encode_fattr(rqstp, xdr, &resp->fh, &resp->stat))
-			return 0;
+			return false;
 		if (xdr_stream_encode_u32(xdr, resp->access) < 0)
-			return 0;
+			return false;
 		break;
 	}
 
-	return 1;
+	return true;
 }
 
 /*
-- 
2.35.1



