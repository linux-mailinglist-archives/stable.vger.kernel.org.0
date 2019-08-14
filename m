Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F2F8DA0D
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731127AbfHNROo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731122AbfHNROm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27AAC20665;
        Wed, 14 Aug 2019 17:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802881;
        bh=AprRWtGWuqegUHNLbg31UzWVjF36V4zOA4KIzTA8AtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wC6CktvafQwfzKgZvDXwWqSlFgyBlBBdpGDXPooYegUTkG7wDtO0nyALT/Y96TzcP
         BAyF7rgccWizy9HBqy7DXPi1dbKoIoACUtOVYvROtf1J4OHjposggqXGIMw+I03art
         PeDs4sauwHcVJJ34Kx6avuAj7l2LELLiA66OCmmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 62/69] NFSv4: Only pass the delegation to setattr if were sending a truncate
Date:   Wed, 14 Aug 2019 19:02:00 +0200
Message-Id: <20190814165750.296357469@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 991eedb1371dc09b0f9848f59c8898fe63d198c0 upstream.

Even then it isn't really necessary. The reason why we may not want to
pass in a stateid in other cases is that we cannot use the delegation
credential.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2954,7 +2954,6 @@ static int _nfs4_do_setattr(struct inode
 	};
 	struct rpc_cred *delegation_cred = NULL;
 	unsigned long timestamp = jiffies;
-	fmode_t fmode;
 	bool truncate;
 	int status;
 
@@ -2962,11 +2961,12 @@ static int _nfs4_do_setattr(struct inode
 
 	/* Servers should only apply open mode checks for file size changes */
 	truncate = (arg->iap->ia_valid & ATTR_SIZE) ? true : false;
-	fmode = truncate ? FMODE_WRITE : FMODE_READ;
+	if (!truncate)
+		goto zero_stateid;
 
-	if (nfs4_copy_delegation_stateid(inode, fmode, &arg->stateid, &delegation_cred)) {
+	if (nfs4_copy_delegation_stateid(inode, FMODE_WRITE, &arg->stateid, &delegation_cred)) {
 		/* Use that stateid */
-	} else if (truncate && ctx != NULL) {
+	} else if (ctx != NULL) {
 		struct nfs_lock_context *l_ctx;
 		if (!nfs4_valid_open_stateid(ctx->state))
 			return -EBADF;
@@ -2978,8 +2978,10 @@ static int _nfs4_do_setattr(struct inode
 		nfs_put_lock_context(l_ctx);
 		if (status == -EIO)
 			return -EBADF;
-	} else
+	} else {
+zero_stateid:
 		nfs4_stateid_copy(&arg->stateid, &zero_stateid);
+	}
 	if (delegation_cred)
 		msg.rpc_cred = delegation_cred;
 


