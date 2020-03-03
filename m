Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D28717820D
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgCCSIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:08:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731773AbgCCRxX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:53:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E80D520CC7;
        Tue,  3 Mar 2020 17:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258002;
        bh=yHzv1T7w5XflZfTdu0V4RPQ231BUuBe0kt/RYKK4i94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwhBTcg03lGtVAGYH3t41KQj796fEvo23pKDAiixtOb6QU4OH4WyM9Do/9KRzCBGG
         PPPIw6R0OD6xhg3VXxpkgBkLhyhoxYvgRV76+afgGtJ4Ve7HtvH844+snvr0SXembQ
         VlC1CBJS1eQ6FYgqzntNlP0iczIDcmVZIExew5q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Benjamin Coddington <bcodding@gmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/152] NFSv4: Fix races between open and dentry revalidation
Date:   Tue,  3 Mar 2020 18:42:11 +0100
Message-Id: <20200303174306.211969204@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit cf5b4059ba7197d6cef9c0e024979d178ed8c8ec ]

We want to make sure that we revalidate the dentry if and only if
we've done an OPEN by filename.
In order to avoid races with remote changes to the directory on the
server, we want to save the verifier before calling OPEN. The exception
is if the server returned a delegation with our OPEN, as we then
know that the filename can't have changed on the server.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Benjamin Coddington <bcodding@gmail.com>
Tested-by: Benjamin Coddington <bcodding@gmail.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4file.c |  1 -
 fs/nfs/nfs4proc.c | 18 ++++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 339663d04bf83..54f1c1f626fc5 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -86,7 +86,6 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 	if (inode != d_inode(dentry))
 		goto out_drop;
 
-	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
 	nfs_file_set_open_context(filp, ctx);
 	nfs_fscache_open_file(inode, filp);
 	err = 0;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f808fb34b1101..6b29703d2fe1e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2962,10 +2962,13 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
 	struct dentry *dentry;
 	struct nfs4_state *state;
 	fmode_t acc_mode = _nfs4_ctx_to_accessmode(ctx);
+	struct inode *dir = d_inode(opendata->dir);
+	unsigned long dir_verifier;
 	unsigned int seq;
 	int ret;
 
 	seq = raw_seqcount_begin(&sp->so_reclaim_seqcount);
+	dir_verifier = nfs_save_change_attribute(dir);
 
 	ret = _nfs4_proc_open(opendata, ctx);
 	if (ret != 0)
@@ -2993,8 +2996,19 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
 			dput(ctx->dentry);
 			ctx->dentry = dentry = alias;
 		}
-		nfs_set_verifier(dentry,
-				nfs_save_change_attribute(d_inode(opendata->dir)));
+	}
+
+	switch(opendata->o_arg.claim) {
+	default:
+		break;
+	case NFS4_OPEN_CLAIM_NULL:
+	case NFS4_OPEN_CLAIM_DELEGATE_CUR:
+	case NFS4_OPEN_CLAIM_DELEGATE_PREV:
+		if (!opendata->rpc_done)
+			break;
+		if (opendata->o_res.delegation_type != 0)
+			dir_verifier = nfs_save_change_attribute(dir);
+		nfs_set_verifier(dentry, dir_verifier);
 	}
 
 	/* Parse layoutget results before we check for access */
-- 
2.20.1



