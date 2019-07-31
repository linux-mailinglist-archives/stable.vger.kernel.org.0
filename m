Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450717BA4D
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 09:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfGaHOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 03:14:05 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:30791 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfGaHOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 03:14:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564557243; x=1596093243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=DDGUXILGpd/F6L0rzCT52zwL5bYTyEf/VQC2K8E5w3o=;
  b=mI8pd1Hy1vnp/vLuBLQ7mgEsml50aKNdgHOS8k98IQt071PKXxVB0ZgV
   BYe3qUZ9ZsV/S0XsZ03+yy8IrGbxIcKU7PqtNqIsPGleNm2Ny8y9ekGZD
   O9eVGyg3JS+keHtpmGdUyHJA0qodX+8thFx0Y3RocDmgVRXG6Pf94/4Cy
   I=;
X-IronPort-AV: E=Sophos;i="5.64,329,1559520000"; 
   d="scan'208";a="407396697"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 31 Jul 2019 07:14:02 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 72CA5A0504;
        Wed, 31 Jul 2019 07:14:01 +0000 (UTC)
Received: from EX13D17UWC001.ant.amazon.com (10.43.162.188) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 07:14:00 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D17UWC001.ant.amazon.com (10.43.162.188) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 07:14:00 +0000
Received: from dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (172.23.196.185)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 31 Jul 2019 07:14:00 +0000
Received: by dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (Postfix, from userid 5038314)
        id C00B287441; Wed, 31 Jul 2019 00:14:00 -0700 (PDT)
From:   Qian Lu <luqia@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <trond.myklebust@hammerspace.com>,
        Qian Lu <luqia@amazon.com>
Subject: [PATCH 3/4] NFSv4: Fix lookup revalidate of regular files
Date:   Wed, 31 Jul 2019 00:13:26 -0700
Message-ID: <20190731071327.28701-4-luqia@amazon.com>
X-Mailer: git-send-email 2.15.3.AMZN
In-Reply-To: <20190731071327.28701-1-luqia@amazon.com>
References: <20190731071327.28701-1-luqia@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit c7944ebb9ce9461079659e9e6ec5baaf73724b3b upstream.

If we're revalidating an existing dentry in order to open a file, we need
to ensure that we check the directory has not changed before we optimise
away the lookup.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: <stable@vger.kernel.org> # 4.14.x
Signed-off-by: Qian Lu <luqia@amazon.com>
---
 fs/nfs/dir.c | 79 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 39 insertions(+), 40 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 9befb6752b97..85a6fdd76e20 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1218,7 +1218,8 @@ nfs_do_lookup_revalidate(struct inode *dir, struct dentry *dentry,
 }
 
 static int
-nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
+__nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags,
+			int (*reval)(struct inode *, struct dentry *, unsigned int))
 {
 	struct dentry *parent;
 	struct inode *dir;
@@ -1229,17 +1230,22 @@ nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
 		dir = d_inode_rcu(parent);
 		if (!dir)
 			return -ECHILD;
-		ret = nfs_do_lookup_revalidate(dir, dentry, flags);
+		ret = reval(dir, dentry, flags);
 		if (parent != ACCESS_ONCE(dentry->d_parent))
 			return -ECHILD;
 	} else {
 		parent = dget_parent(dentry);
-		ret = nfs_do_lookup_revalidate(d_inode(parent), dentry, flags);
+		ret = reval(d_inode(parent), dentry, flags);
 		dput(parent);
 	}
 	return ret;
 }
 
+static int nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	return __nfs_lookup_revalidate(dentry, flags, nfs_do_lookup_revalidate);
+}
+
 /*
  * A weaker form of d_revalidate for revalidating just the d_inode(dentry)
  * when we don't really care about the dentry name. This is called when a
@@ -1590,62 +1596,55 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 }
 EXPORT_SYMBOL_GPL(nfs_atomic_open);
 
-static int nfs4_lookup_revalidate(struct dentry *dentry, unsigned int flags)
+static int
+nfs4_do_lookup_revalidate(struct inode *dir, struct dentry *dentry,
+			  unsigned int flags)
 {
 	struct inode *inode;
-	int ret = 0;
 
 	if (!(flags & LOOKUP_OPEN) || (flags & LOOKUP_DIRECTORY))
-		goto no_open;
+		goto full_reval;
 	if (d_mountpoint(dentry))
-		goto no_open;
-	if (NFS_SB(dentry->d_sb)->caps & NFS_CAP_ATOMIC_OPEN_V1)
-		goto no_open;
+		goto full_reval;
 
 	inode = d_inode(dentry);
 
 	/* We can't create new files in nfs_open_revalidate(), so we
 	 * optimize away revalidation of negative dentries.
 	 */
-	if (inode == NULL) {
-		struct dentry *parent;
-		struct inode *dir;
-
-		if (flags & LOOKUP_RCU) {
-			parent = ACCESS_ONCE(dentry->d_parent);
-			dir = d_inode_rcu(parent);
-			if (!dir)
-				return -ECHILD;
-		} else {
-			parent = dget_parent(dentry);
-			dir = d_inode(parent);
-		}
-		if (!nfs_neg_need_reval(dir, dentry, flags))
-			ret = 1;
-		else if (flags & LOOKUP_RCU)
-			ret = -ECHILD;
-		if (!(flags & LOOKUP_RCU))
-			dput(parent);
-		else if (parent != ACCESS_ONCE(dentry->d_parent))
-			return -ECHILD;
-		goto out;
-	}
+	if (inode == NULL)
+		goto full_reval;
+
+	if (NFS_PROTO(dir)->have_delegation(inode, FMODE_READ))
+		return nfs_lookup_revalidate_delegated(dir, dentry, inode);
 
 	/* NFS only supports OPEN on regular files */
 	if (!S_ISREG(inode->i_mode))
-		goto no_open;
+		goto full_reval;
+
 	/* We cannot do exclusive creation on a positive dentry */
-	if (flags & LOOKUP_EXCL)
-		goto no_open;
+	if (flags & (LOOKUP_EXCL | LOOKUP_REVAL))
+		goto reval_dentry;
+
+	/* Check if the directory changed */
+	if (!nfs_check_verifier(dir, dentry, flags & LOOKUP_RCU))
+		goto reval_dentry;
 
 	/* Let f_op->open() actually open (and revalidate) the file */
-	ret = 1;
+	return 1;
+reval_dentry:
+	if (flags & LOOKUP_RCU)
+		return -ECHILD;
+	return nfs_lookup_revalidate_dentry(dir, dentry, inode);;
 
-out:
-	return ret;
+full_reval:
+	return nfs_do_lookup_revalidate(dir, dentry, flags);
+}
 
-no_open:
-	return nfs_lookup_revalidate(dentry, flags);
+static int nfs4_lookup_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	return __nfs_lookup_revalidate(dentry, flags,
+			nfs4_do_lookup_revalidate);
 }
 
 #endif /* CONFIG_NFSV4 */
-- 
2.15.3.AMZN

