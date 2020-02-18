Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B72F8163202
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgBRUEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729128AbgBRUDj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:03:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA9F124125;
        Tue, 18 Feb 2020 20:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056219;
        bh=oM3IV5POdbjJh4hmqvmev7NnW2IKj0WapaGYhE37NXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I44bABFxPW1nHxB42MkNi28bcrHulEeB1KcL2645bci7H/e+l8u67OOYyNWBdoB9r
         A/y5TrkSz6QowNq89ElHQ2Cu5kw8Yf91n+ci9Jn5YmCSgKyk0A/8fgORbmCCQ4QTBH
         p9g+NPWB8z5CLO7U+O6S3Q3DIddy/d/NoKiS7gSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.5 73/80] NFSv4: Ensure the delegation cred is pinned when we call delegreturn
Date:   Tue, 18 Feb 2020 20:55:34 +0100
Message-Id: <20200218190438.811033255@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 5d63944f8206a80636ae8cb4b9107d3b49f43d37 upstream.

Ensure we don't release the delegation cred during the call to
nfs4_proc_delegreturn().

Fixes: ee05f456772d ("NFSv4: Fix races between open and delegreturn")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/delegation.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -222,13 +222,18 @@ void nfs_inode_reclaim_delegation(struct
 
 static int nfs_do_return_delegation(struct inode *inode, struct nfs_delegation *delegation, int issync)
 {
+	const struct cred *cred;
 	int res = 0;
 
-	if (!test_bit(NFS_DELEGATION_REVOKED, &delegation->flags))
-		res = nfs4_proc_delegreturn(inode,
-				delegation->cred,
+	if (!test_bit(NFS_DELEGATION_REVOKED, &delegation->flags)) {
+		spin_lock(&delegation->lock);
+		cred = get_cred(delegation->cred);
+		spin_unlock(&delegation->lock);
+		res = nfs4_proc_delegreturn(inode, cred,
 				&delegation->stateid,
 				issync);
+		put_cred(cred);
+	}
 	return res;
 }
 


