Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279AE657A75
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiL1PLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiL1PLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:11:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB05213E10
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:11:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61C40B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1C5C433EF;
        Wed, 28 Dec 2022 15:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240272;
        bh=QSc7ICUxnojblo+gGNMCl4yx24zid3PlU/sjpWlAZ3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiSADtDrndVnQ3YCtlbbts3ukmHjsGBRxiOTqGdPDoqirham2eMz/RaSXwrveBPuI
         xUyqQnDvkZF0VLRb5B5ZS6NbIwQGXujwBcs0XPa+HGynxz+nCTvbn+Oialbh89BLKO
         R8q5pktR3np/goQ2mGZpj1K6VzkmX7LEg0uOCLYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0141/1073] NFSD: Finish converting the NFSv3 GETACL result encoder
Date:   Wed, 28 Dec 2022 15:28:49 +0100
Message-Id: <20221228144331.859197056@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 841fd0a3cb490eae5dfd262eccb8c8b11d57f8b8 ]

For some reason, the NFSv2 GETACL result encoder was fully converted
to use the new nfs_stream_encode_acl(), but the NFSv3 equivalent was
not similarly converted.

Fixes: 20798dfe249a ("NFSD: Update the NFSv3 GETACL result encoder to use struct xdr_stream")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3acl.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index 9446c6743664..7c798b5f4ec6 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -171,11 +171,7 @@ nfs3svc_encode_getaclres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 {
 	struct nfsd3_getaclres *resp = rqstp->rq_resp;
 	struct dentry *dentry = resp->fh.fh_dentry;
-	struct kvec *head = rqstp->rq_res.head;
 	struct inode *inode;
-	unsigned int base;
-	int n;
-	int w;
 
 	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
 		return false;
@@ -187,26 +183,12 @@ nfs3svc_encode_getaclres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 		if (xdr_stream_encode_u32(xdr, resp->mask) < 0)
 			return false;
 
-		base = (char *)xdr->p - (char *)head->iov_base;
-
-		rqstp->rq_res.page_len = w = nfsacl_size(
-			(resp->mask & NFS_ACL)   ? resp->acl_access  : NULL,
-			(resp->mask & NFS_DFACL) ? resp->acl_default : NULL);
-		while (w > 0) {
-			if (!*(rqstp->rq_next_page++))
-				return false;
-			w -= PAGE_SIZE;
-		}
-
-		n = nfsacl_encode(&rqstp->rq_res, base, inode,
-				  resp->acl_access,
-				  resp->mask & NFS_ACL, 0);
-		if (n > 0)
-			n = nfsacl_encode(&rqstp->rq_res, base + n, inode,
-					  resp->acl_default,
-					  resp->mask & NFS_DFACL,
-					  NFS_ACL_DEFAULT);
-		if (n <= 0)
+		if (!nfs_stream_encode_acl(xdr, inode, resp->acl_access,
+					   resp->mask & NFS_ACL, 0))
+			return false;
+		if (!nfs_stream_encode_acl(xdr, inode, resp->acl_default,
+					   resp->mask & NFS_DFACL,
+					   NFS_ACL_DEFAULT))
 			return false;
 		break;
 	default:
-- 
2.35.1



