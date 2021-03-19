Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B18341C96
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhCSMVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231183AbhCSMVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:21:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA42564F79;
        Fri, 19 Mar 2021 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156476;
        bh=tA2R1Xyov1vbbxO8oGGXj5HDDCZK3v8CM/aY/QGS8Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpCVpDbsSVCHS/38frqBj56ykpRkTfADrZsaurr7eVl9BNy+4D6mVL80/I2A35wKV
         Dm+jvnFeScxB5aFBBs6pj8+1E7zCeVos1BHA43do6fvsYM1XC8c1kE5WExeKChQF/D
         oTr/iXZxSzRY9c70BWCJFnpAyldFlEGC8boER7jI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timo Rothenpieler <timo@rothenpieler.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.11 29/31] Revert "nfsd4: a clients own opens neednt prevent delegations"
Date:   Fri, 19 Mar 2021 13:19:23 +0100
Message-Id: <20210319121748.147629081@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

commit 6ee65a773096ab3f39d9b00311ac983be5bdeb7c upstream.

This reverts commit 94415b06eb8aed13481646026dc995f04a3a534a.

That commit claimed to allow a client to get a read delegation when it
was the only writer.  Actually it allowed a client to get a read
delegation when *any* client has a write open!

The main problem is that it's depending on nfs4_clnt_odstate structures
that are actually only maintained for pnfs exports.

This causes clients to miss writes performed by other clients, even when
there have been intervening closes and opens, violating close-to-open
cache consistency.

We can do this a different way, but first we should just revert this.

I've added pynfs 4.1 test DELEG19 to test for this, as I should have
done originally!

Cc: stable@vger.kernel.org
Reported-by: Timo Rothenpieler <timo@rothenpieler.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/locks.c          |    3 --
 fs/nfsd/nfs4state.c |   54 +++++++++++++---------------------------------------
 2 files changed, 14 insertions(+), 43 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1808,9 +1808,6 @@ check_conflicting_open(struct file *filp
 
 	if (flags & FL_LAYOUT)
 		return 0;
-	if (flags & FL_DELEG)
-		/* We leave these checks to the caller. */
-		return 0;
 
 	if (arg == F_RDLCK)
 		return inode_is_open_for_write(inode) ? -EAGAIN : 0;
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4945,32 +4945,6 @@ static struct file_lock *nfs4_alloc_init
 	return fl;
 }
 
-static int nfsd4_check_conflicting_opens(struct nfs4_client *clp,
-						struct nfs4_file *fp)
-{
-	struct nfs4_clnt_odstate *co;
-	struct file *f = fp->fi_deleg_file->nf_file;
-	struct inode *ino = locks_inode(f);
-	int writes = atomic_read(&ino->i_writecount);
-
-	if (fp->fi_fds[O_WRONLY])
-		writes--;
-	if (fp->fi_fds[O_RDWR])
-		writes--;
-	WARN_ON_ONCE(writes < 0);
-	if (writes > 0)
-		return -EAGAIN;
-	spin_lock(&fp->fi_lock);
-	list_for_each_entry(co, &fp->fi_clnt_odstate, co_perfile) {
-		if (co->co_client != clp) {
-			spin_unlock(&fp->fi_lock);
-			return -EAGAIN;
-		}
-	}
-	spin_unlock(&fp->fi_lock);
-	return 0;
-}
-
 static struct nfs4_delegation *
 nfs4_set_delegation(struct nfs4_client *clp, struct svc_fh *fh,
 		    struct nfs4_file *fp, struct nfs4_clnt_odstate *odstate)
@@ -4990,12 +4964,9 @@ nfs4_set_delegation(struct nfs4_client *
 
 	nf = find_readable_file(fp);
 	if (!nf) {
-		/*
-		 * We probably could attempt another open and get a read
-		 * delegation, but for now, don't bother until the
-		 * client actually sends us one.
-		 */
-		return ERR_PTR(-EAGAIN);
+		/* We should always have a readable file here */
+		WARN_ON_ONCE(1);
+		return ERR_PTR(-EBADF);
 	}
 	spin_lock(&state_lock);
 	spin_lock(&fp->fi_lock);
@@ -5025,19 +4996,11 @@ nfs4_set_delegation(struct nfs4_client *
 	if (!fl)
 		goto out_clnt_odstate;
 
-	status = nfsd4_check_conflicting_opens(clp, fp);
-	if (status) {
-		locks_free_lock(fl);
-		goto out_clnt_odstate;
-	}
 	status = vfs_setlease(fp->fi_deleg_file->nf_file, fl->fl_type, &fl, NULL);
 	if (fl)
 		locks_free_lock(fl);
 	if (status)
 		goto out_clnt_odstate;
-	status = nfsd4_check_conflicting_opens(clp, fp);
-	if (status)
-		goto out_clnt_odstate;
 
 	spin_lock(&state_lock);
 	spin_lock(&fp->fi_lock);
@@ -5119,6 +5082,17 @@ nfs4_open_delegation(struct svc_fh *fh,
 				goto out_no_deleg;
 			if (!cb_up || !(oo->oo_flags & NFS4_OO_CONFIRMED))
 				goto out_no_deleg;
+			/*
+			 * Also, if the file was opened for write or
+			 * create, there's a good chance the client's
+			 * about to write to it, resulting in an
+			 * immediate recall (since we don't support
+			 * write delegations):
+			 */
+			if (open->op_share_access & NFS4_SHARE_ACCESS_WRITE)
+				goto out_no_deleg;
+			if (open->op_create == NFS4_OPEN_CREATE)
+				goto out_no_deleg;
 			break;
 		default:
 			goto out_no_deleg;


