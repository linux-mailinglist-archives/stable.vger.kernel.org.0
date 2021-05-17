Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBA9382FC4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbhEQOUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:20:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239125AbhEQOSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:18:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D5A361412;
        Mon, 17 May 2021 14:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260625;
        bh=bKNhFBveHdwDoNAtbTqIATiKOLJdAXj4bNeR3HmWwAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhNFhLM0K+9/KENNfY7VFSzHnQl6gJkOHFvggZxIykMAlFQEV0ri3qpEpcT3Sa5Tf
         jzmi1Etvr9ITweq2xy3lLkWUdzraUigQRXyaJ1BrCBQZhksBEe7h4jNs7T79SApCgV
         EPZ7Ad6z+I5A5G8YXXD0k0CITIZibJULF7Uqf+F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 166/363] nfsd: ensure new clients break delegations
Date:   Mon, 17 May 2021 16:00:32 +0200
Message-Id: <20210517140308.215419946@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
index 97447a64bad0..886e50ed07c2 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4869,6 +4869,11 @@ static __be32 nfs4_get_vfs_file(struct svc_rqst *rqstp, struct nfs4_file *fp,
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
@@ -6849,11 +6854,20 @@ out:
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



