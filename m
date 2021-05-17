Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B1D38361E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244697AbhEQP20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243712AbhEQP0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:26:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE5F36192D;
        Mon, 17 May 2021 14:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262182;
        bh=733M+gTPxvhRf4lI+v/Y3Y2ZT0Zb7pcf7r5FlUDrX/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zvX465ugisFc7HXSLOaHVVE9pWhoM9mK5JO8awi5FRFePhD49eK2H/P1lROgLNqa0
         5IgqzoI/lRqGSXWsdEw12AmFMS42mDxY8qoY8/AjmHZR8G3wuzzpnwMIjRvBppTJ1A
         qH7z1hP+akQSB+WEa9F37PVU498v0xZa19hsCsLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/289] nfsd: ensure new clients break delegations
Date:   Mon, 17 May 2021 16:00:53 +0200
Message-Id: <20210517140309.466992515@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 217fd6f625af591e2866bebb8cda778cf85bea2e ]

If nfsd already has an open file that it plans to use for IO from
another, it may not need to do another vfs open, but it still may need
to break any delegations in case the existing opens are for another
client.

Symptoms are that we may incorrectly fail to break a delegation on a
write open from a different client, when the delegation-holding client
already has a write open.

Fixes: 28df3d1539de ("nfsd: clients don't need to break their own delegations")
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 55cf60b71cde..ac20f79bbedd 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4874,6 +4874,11 @@ static __be32 nfs4_get_vfs_file(struct svc_rqst *rqstp, struct nfs4_file *fp,
 	if (nf)
 		nfsd_file_put(nf);
 
+	status = nfserrno(nfsd_open_break_lease(cur_fh->fh_dentry->d_inode,
+								access));
+	if (status)
+		goto out_put_access;
+
 	status = nfsd4_truncate(rqstp, cur_fh, open);
 	if (status)
 		goto out_put_access;
@@ -6856,11 +6861,20 @@ out:
 static __be32 nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file_lock *lock)
 {
 	struct nfsd_file *nf;
-	__be32 err = nfsd_file_acquire(rqstp, fhp, NFSD_MAY_READ, &nf);
-	if (!err) {
-		err = nfserrno(vfs_test_lock(nf->nf_file, lock));
-		nfsd_file_put(nf);
-	}
+	__be32 err;
+
+	err = nfsd_file_acquire(rqstp, fhp, NFSD_MAY_READ, &nf);
+	if (err)
+		return err;
+	fh_lock(fhp); /* to block new leases till after test_lock: */
+	err = nfserrno(nfsd_open_break_lease(fhp->fh_dentry->d_inode,
+							NFSD_MAY_READ));
+	if (err)
+		goto out;
+	err = nfserrno(vfs_test_lock(nf->nf_file, lock));
+out:
+	fh_unlock(fhp);
+	nfsd_file_put(nf);
 	return err;
 }
 
-- 
2.30.2



