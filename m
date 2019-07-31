Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9F17BA4E
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 09:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfGaHOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 03:14:07 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:9819 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfGaHOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 03:14:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564557244; x=1596093244;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8/Bd7m8m9nA9JNHaluOadd6FZPRUGwpDcOWe5ublbh8=;
  b=bIpiVdTJ6VkUjVhTNnhUqHzJaaahiPiulQhPv5N1kALA+VT4zGKeP7UN
   uJaSK9fyCVkuSJ+WccUQKVY8+0l6iYFVGuHu3c+lyVtF6XiLPc9jGHdqU
   YzzXGYydBNPxDY63gqt2iLmEU0MKVANKuEynzjKV7cDenq4RUPwirpzxG
   c=;
X-IronPort-AV: E=Sophos;i="5.64,329,1559520000"; 
   d="scan'208";a="413182838"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 31 Jul 2019 07:14:00 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 7C441A074F;
        Wed, 31 Jul 2019 07:14:00 +0000 (UTC)
Received: from EX13D17UWC004.ant.amazon.com (10.43.162.195) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 07:13:59 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D17UWC004.ant.amazon.com (10.43.162.195) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 07:13:59 +0000
Received: from dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (172.23.196.185)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 31 Jul 2019 07:13:58 +0000
Received: by dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (Postfix, from userid 5038314)
        id 7B32387441; Wed, 31 Jul 2019 00:13:58 -0700 (PDT)
From:   Qian Lu <luqia@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <trond.myklebust@hammerspace.com>,
        Qian Lu <luqia@amazon.com>
Subject: [PATCH 2/4] NFS: Refactor nfs_lookup_revalidate()
Date:   Wed, 31 Jul 2019 00:13:25 -0700
Message-ID: <20190731071327.28701-3-luqia@amazon.com>
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

commit 5ceb9d7fdaaf6d8ced6cd7861cf1deb9cd93fa47 upstream.

Refactor the code in nfs_lookup_revalidate() as a stepping stone towards
optimising and fixing nfs4_lookup_revalidate().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: <stable@vger.kernel.org> # 4.14.x
Signed-off-by: Qian Lu <luqia@amazon.com>
---
 fs/nfs/dir.c | 222 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 126 insertions(+), 96 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index bf2c43635062..9befb6752b97 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1059,6 +1059,100 @@ int nfs_neg_need_reval(struct inode *dir, struct dentry *dentry,
 	return !nfs_check_verifier(dir, dentry, flags & LOOKUP_RCU);
 }
 
+static int
+nfs_lookup_revalidate_done(struct inode *dir, struct dentry *dentry,
+			   struct inode *inode, int error)
+{
+	switch (error) {
+	case 1:
+		dfprintk(LOOKUPCACHE, "NFS: %s(%pd2) is valid\n",
+			__func__, dentry);
+		return 1;
+	case 0:
+		nfs_mark_for_revalidate(dir);
+		if (inode && S_ISDIR(inode->i_mode)) {
+			/* Purge readdir caches. */
+			nfs_zap_caches(inode);
+			/*
+			 * We can't d_drop the root of a disconnected tree:
+			 * its d_hash is on the s_anon list and d_drop() would hide
+			 * it from shrink_dcache_for_unmount(), leading to busy
+			 * inodes on unmount and further oopses.
+			 */
+			if (IS_ROOT(dentry))
+				return 1;
+		}
+		dfprintk(LOOKUPCACHE, "NFS: %s(%pd2) is invalid\n",
+				__func__, dentry);
+		return 0;
+	}
+	dfprintk(LOOKUPCACHE, "NFS: %s(%pd2) lookup returned error %d\n",
+				__func__, dentry, error);
+	return error;
+}
+
+static int
+nfs_lookup_revalidate_negative(struct inode *dir, struct dentry *dentry,
+			       unsigned int flags)
+{
+	int ret = 1;
+	if (nfs_neg_need_reval(dir, dentry, flags)) {
+		if (flags & LOOKUP_RCU)
+			return -ECHILD;
+		ret = 0;
+	}
+	return nfs_lookup_revalidate_done(dir, dentry, NULL, ret);
+}
+
+static int
+nfs_lookup_revalidate_delegated(struct inode *dir, struct dentry *dentry,
+				struct inode *inode)
+{
+	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
+	return nfs_lookup_revalidate_done(dir, dentry, inode, 1);
+}
+
+static int
+nfs_lookup_revalidate_dentry(struct inode *dir, struct dentry *dentry,
+			     struct inode *inode)
+{
+	struct nfs_fh *fhandle;
+	struct nfs_fattr *fattr;
+	struct nfs4_label *label;
+	int ret;
+
+	ret = -ENOMEM;
+	fhandle = nfs_alloc_fhandle();
+	fattr = nfs_alloc_fattr();
+	label = nfs4_label_alloc(NFS_SERVER(inode), GFP_KERNEL);
+	if (fhandle == NULL || fattr == NULL || IS_ERR(label))
+		goto out;
+
+	ret = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, fhandle, fattr, label);
+	if (ret < 0) {
+		if (ret == -ESTALE || ret == -ENOENT)
+			ret = 0;
+		goto out;
+	}
+	ret = 0;
+	if (nfs_compare_fh(NFS_FH(inode), fhandle))
+		goto out;
+	if (nfs_refresh_inode(inode, fattr) < 0)
+		goto out;
+
+	nfs_setsecurity(inode, fattr, label);
+	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
+
+	/* set a readdirplus hint that we had a cache miss */
+	nfs_force_use_readdirplus(dir);
+	ret = 1;
+out:
+	nfs_free_fattr(fattr);
+	nfs_free_fhandle(fhandle);
+	nfs4_label_free(label);
+	return nfs_lookup_revalidate_done(dir, dentry, inode, ret);
+}
+
 /*
  * This is called every time the dcache has a lookup hit,
  * and we should check whether we can really trust that
@@ -1070,58 +1164,36 @@ int nfs_neg_need_reval(struct inode *dir, struct dentry *dentry,
  * If the parent directory is seen to have changed, we throw out the
  * cached dentry and do a new lookup.
  */
-static int nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
+static int
+nfs_do_lookup_revalidate(struct inode *dir, struct dentry *dentry,
+			 unsigned int flags)
 {
-	struct inode *dir;
 	struct inode *inode;
-	struct dentry *parent;
-	struct nfs_fh *fhandle = NULL;
-	struct nfs_fattr *fattr = NULL;
-	struct nfs4_label *label = NULL;
 	int error;
 
-	if (flags & LOOKUP_RCU) {
-		parent = ACCESS_ONCE(dentry->d_parent);
-		dir = d_inode_rcu(parent);
-		if (!dir)
-			return -ECHILD;
-	} else {
-		parent = dget_parent(dentry);
-		dir = d_inode(parent);
-	}
 	nfs_inc_stats(dir, NFSIOS_DENTRYREVALIDATE);
 	inode = d_inode(dentry);
 
-	if (!inode) {
-		if (nfs_neg_need_reval(dir, dentry, flags)) {
-			if (flags & LOOKUP_RCU)
-				return -ECHILD;
-			goto out_bad;
-		}
-		goto out_valid;
-	}
+	if (!inode)
+		return nfs_lookup_revalidate_negative(dir, dentry, flags);
 
 	if (is_bad_inode(inode)) {
-		if (flags & LOOKUP_RCU)
-			return -ECHILD;
 		dfprintk(LOOKUPCACHE, "%s: %pd2 has dud inode\n",
 				__func__, dentry);
 		goto out_bad;
 	}
 
 	if (NFS_PROTO(dir)->have_delegation(inode, FMODE_READ))
-		goto out_set_verifier;
+		return nfs_lookup_revalidate_delegated(dir, dentry, inode);
 
 	/* Force a full look up iff the parent directory has changed */
 	if (!nfs_is_exclusive_create(dir, flags) &&
 	    nfs_check_verifier(dir, dentry, flags & LOOKUP_RCU)) {
 		error = nfs_lookup_verify_inode(inode, flags);
 		if (error) {
-			if (flags & LOOKUP_RCU)
-				return -ECHILD;
 			if (error == -ESTALE)
-				goto out_zap_parent;
-			goto out_error;
+				nfs_zap_caches(dir);
+			goto out_bad;
 		}
 		nfs_advise_use_readdirplus(dir);
 		goto out_valid;
@@ -1133,81 +1205,39 @@ static int nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
 	if (NFS_STALE(inode))
 		goto out_bad;
 
-	error = -ENOMEM;
-	fhandle = nfs_alloc_fhandle();
-	fattr = nfs_alloc_fattr();
-	if (fhandle == NULL || fattr == NULL)
-		goto out_error;
-
-	label = nfs4_label_alloc(NFS_SERVER(inode), GFP_NOWAIT);
-	if (IS_ERR(label))
-		goto out_error;
-
 	trace_nfs_lookup_revalidate_enter(dir, dentry, flags);
-	error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, fhandle, fattr, label);
+	error = nfs_lookup_revalidate_dentry(dir, dentry, inode);
 	trace_nfs_lookup_revalidate_exit(dir, dentry, flags, error);
-	if (error == -ESTALE || error == -ENOENT)
-		goto out_bad;
-	if (error)
-		goto out_error;
-	if (nfs_compare_fh(NFS_FH(inode), fhandle))
-		goto out_bad;
-	if ((error = nfs_refresh_inode(inode, fattr)) != 0)
-		goto out_bad;
-
-	nfs_setsecurity(inode, fattr, label);
-
-	nfs_free_fattr(fattr);
-	nfs_free_fhandle(fhandle);
-	nfs4_label_free(label);
+	return error;
+out_valid:
+	return nfs_lookup_revalidate_done(dir, dentry, inode, 1);
+out_bad:
+	if (flags & LOOKUP_RCU)
+		return -ECHILD;
+	return nfs_lookup_revalidate_done(dir, dentry, inode, 0);
+}
 
-	/* set a readdirplus hint that we had a cache miss */
-	nfs_force_use_readdirplus(dir);
+static int
+nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	struct dentry *parent;
+	struct inode *dir;
+	int ret;
 
-out_set_verifier:
-	nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
- out_valid:
 	if (flags & LOOKUP_RCU) {
+		parent = ACCESS_ONCE(dentry->d_parent);
+		dir = d_inode_rcu(parent);
+		if (!dir)
+			return -ECHILD;
+		ret = nfs_do_lookup_revalidate(dir, dentry, flags);
 		if (parent != ACCESS_ONCE(dentry->d_parent))
 			return -ECHILD;
-	} else
+	} else {
+		parent = dget_parent(dentry);
+		ret = nfs_do_lookup_revalidate(d_inode(parent), dentry, flags);
 		dput(parent);
-	dfprintk(LOOKUPCACHE, "NFS: %s(%pd2) is valid\n",
-			__func__, dentry);
-	return 1;
-out_zap_parent:
-	nfs_zap_caches(dir);
- out_bad:
-	WARN_ON(flags & LOOKUP_RCU);
-	nfs_free_fattr(fattr);
-	nfs_free_fhandle(fhandle);
-	nfs4_label_free(label);
-	nfs_mark_for_revalidate(dir);
-	if (inode && S_ISDIR(inode->i_mode)) {
-		/* Purge readdir caches. */
-		nfs_zap_caches(inode);
-		/*
-		 * We can't d_drop the root of a disconnected tree:
-		 * its d_hash is on the s_anon list and d_drop() would hide
-		 * it from shrink_dcache_for_unmount(), leading to busy
-		 * inodes on unmount and further oopses.
-		 */
-		if (IS_ROOT(dentry))
-			goto out_valid;
 	}
-	dput(parent);
-	dfprintk(LOOKUPCACHE, "NFS: %s(%pd2) is invalid\n",
-			__func__, dentry);
-	return 0;
-out_error:
-	WARN_ON(flags & LOOKUP_RCU);
-	nfs_free_fattr(fattr);
-	nfs_free_fhandle(fhandle);
-	nfs4_label_free(label);
-	dput(parent);
-	dfprintk(LOOKUPCACHE, "NFS: %s(%pd2) lookup returned error %d\n",
-			__func__, dentry, error);
-	return error;
+	return ret;
 }
 
 /*
-- 
2.15.3.AMZN

