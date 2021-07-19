Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41763CE369
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243801AbhGSPhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347898AbhGSPfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AB73614A7;
        Mon, 19 Jul 2021 16:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711188;
        bh=TK5hmaqnhb9CoIMS/EszauYQPHyrrRVARmPh2hE27hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDM3HhQhG1j/E9D8jVIG8fvyIa2J2yBfijfqCrlxn+qHQlsEibbOHc93QAd6eWa4k
         eVPCU6HoAspB4MtC+GnzzmDFkVQ/l5OXcKJahe1LHZ/bXaH4+DgWlGm3F0YjyZEdh5
         aDj4aHmEg8qwSKO07oaSH8aoNWtm562WealIy8IY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JianHong Yin <jiyin@redhat.com>,
        Chuck Lever III <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 260/351] nfsd: fix NULL dereference in nfs3svc_encode_getaclres
Date:   Mon, 19 Jul 2021 16:53:26 +0200
Message-Id: <20210719144953.550712506@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit ab1016d39cc052064e32f25ad18ef8767a0ee3b8 ]

In error cases the dentry may be NULL.

Before 20798dfe249a, the encoder also checked dentry and
d_really_is_positive(dentry), but that looks like overkill to me--zero
status should be enough to guarantee a positive dentry.

This isn't the first time we've seen an error-case NULL dereference
hidden in the initialization of a local variable in an xdr encoder.  But
I went back through the other recent rewrites and didn't spot any
similar bugs.

Reported-by: JianHong Yin <jiyin@redhat.com>
Reviewed-by: Chuck Lever III <chuck.lever@oracle.com>
Fixes: 20798dfe249a ("NFSD: Update the NFSv3 GETACL result encoder...")
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3acl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index a1591feeea22..5dfe7644a517 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -172,7 +172,7 @@ static int nfs3svc_encode_getaclres(struct svc_rqst *rqstp, __be32 *p)
 	struct nfsd3_getaclres *resp = rqstp->rq_resp;
 	struct dentry *dentry = resp->fh.fh_dentry;
 	struct kvec *head = rqstp->rq_res.head;
-	struct inode *inode = d_inode(dentry);
+	struct inode *inode;
 	unsigned int base;
 	int n;
 	int w;
@@ -181,6 +181,7 @@ static int nfs3svc_encode_getaclres(struct svc_rqst *rqstp, __be32 *p)
 		return 0;
 	switch (resp->status) {
 	case nfs_ok:
+		inode = d_inode(dentry);
 		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
 			return 0;
 		if (xdr_stream_encode_u32(xdr, resp->mask) < 0)
-- 
2.30.2



