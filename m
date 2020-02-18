Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB88E162202
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 09:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgBRIG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 03:06:26 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:41925 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbgBRIG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 03:06:26 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7B92751A;
        Tue, 18 Feb 2020 03:06:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 18 Feb 2020 03:06:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cxbWRP
        CQEKP2Zv5d6LOlCsRD9tnG08HdHhD1NqzG7TM=; b=VL71IyJoYskmK59C5gEJro
        MjntWnmqV8XgVeSXkNeBpbJYYgA9qO3GtAT7bjiYNzeKkJYSk/NnnlCSNr3B+mmg
        ixeSxn6XBAk3TKhRqG43vS65l4gZHyYoP9S0ZdRTPW5pVO7FOGg9ShoVvvWiqM/o
        zWfVcAfpmrhMKg+Tc4BHA6mkS2bdDxHIS+b46YScpNm8GZbmGe9fJJVbWTBGGHGB
        QjFNrKct4RRrvK4Y9upW8ja+/5sxFFqZXra3LlUM4fuE2VYgREu7+LLJ+CX05SfM
        y7TIl9zRMex7850G94kVZGfeAa68FcfiugX2DvACvZ7KoLXgWFwhFgWJ1moLd+wA
        ==
X-ME-Sender: <xms:AJtLXvS3Zdsj8Hde6h-hJImwwK9AFi0Yh_l_A1yPke-f1vufWBevXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeejgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:AJtLXlCAqZsDfgM8FB9CJDbpmpppikTBmFyD-tBp7qaJucRemE-H4g>
    <xmx:AJtLXv1u3vv3Fte-xwE82lw9Qj9eIQx3YIgDj_wXeD3VXk5cNVm4dA>
    <xmx:AJtLXjWZp9vTOc_Bs60WFLe5JvqnaIU4bh1147sKAHFTTXjDSa4waA>
    <xmx:AZtLXlij1FNVvJeAfbhNcvOeKW7qtKsXOphb_gNBfhF7Axq9w0u4KQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64FAA328005E;
        Tue, 18 Feb 2020 03:06:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] NFSv4: Ensure the delegation is pinned in" failed to apply to 5.5-stable tree
To:     trondmy@gmail.com, Anna.Schumaker@Netapp.com,
        trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Feb 2020 09:06:22 +0100
Message-ID: <15820131823246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8c75593c6eee0f661ddf25dfde0e6ad2a84be7a9 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trondmy@gmail.com>
Date: Thu, 13 Feb 2020 14:51:06 -0500
Subject: [PATCH] NFSv4: Ensure the delegation is pinned in
 nfs_do_return_delegation()

The call to nfs_do_return_delegation() needs to be taken without
any RCU locks. Add a refcount to make sure the delegation remains
pinned in memory until we're done.

Fixes: ee05f456772d ("NFSv4: Fix races between open and delegreturn")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index d856326836a2..c17ff826e7e9 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -47,10 +47,22 @@ static void nfs_mark_delegation_revoked(struct nfs_delegation *delegation)
 	}
 }
 
+static struct nfs_delegation *nfs_get_delegation(struct nfs_delegation *delegation)
+{
+	refcount_inc(&delegation->refcount);
+	return delegation;
+}
+
+static void nfs_put_delegation(struct nfs_delegation *delegation)
+{
+	if (refcount_dec_and_test(&delegation->refcount))
+		__nfs_free_delegation(delegation);
+}
+
 static void nfs_free_delegation(struct nfs_delegation *delegation)
 {
 	nfs_mark_delegation_revoked(delegation);
-	__nfs_free_delegation(delegation);
+	nfs_put_delegation(delegation);
 }
 
 /**
@@ -275,8 +287,10 @@ nfs_start_delegation_return_locked(struct nfs_inode *nfsi)
 	if (delegation == NULL)
 		goto out;
 	spin_lock(&delegation->lock);
-	if (!test_and_set_bit(NFS_DELEGATION_RETURNING, &delegation->flags))
-		ret = delegation;
+	if (!test_and_set_bit(NFS_DELEGATION_RETURNING, &delegation->flags)) {
+		/* Refcount matched in nfs_end_delegation_return() */
+		ret = nfs_get_delegation(delegation);
+	}
 	spin_unlock(&delegation->lock);
 	if (ret)
 		nfs_clear_verifier_delegated(&nfsi->vfs_inode);
@@ -397,6 +411,7 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
 	if (delegation == NULL)
 		return -ENOMEM;
 	nfs4_stateid_copy(&delegation->stateid, stateid);
+	refcount_set(&delegation->refcount, 1);
 	delegation->type = type;
 	delegation->pagemod_limit = pagemod_limit;
 	delegation->change_attr = inode_peek_iversion_raw(inode);
@@ -496,6 +511,8 @@ static int nfs_end_delegation_return(struct inode *inode, struct nfs_delegation
 
 	err = nfs_do_return_delegation(inode, delegation, issync);
 out:
+	/* Refcount matched in nfs_start_delegation_return_locked() */
+	nfs_put_delegation(delegation);
 	return err;
 }
 
@@ -690,7 +707,8 @@ void nfs4_inode_return_delegation_on_close(struct inode *inode)
 		    list_empty(&NFS_I(inode)->open_files) &&
 		    !test_and_set_bit(NFS_DELEGATION_RETURNING, &delegation->flags)) {
 			clear_bit(NFS_DELEGATION_RETURN_IF_CLOSED, &delegation->flags);
-			ret = delegation;
+			/* Refcount matched in nfs_end_delegation_return() */
+			ret = nfs_get_delegation(delegation);
 		}
 		spin_unlock(&delegation->lock);
 		if (ret)
@@ -1094,10 +1112,11 @@ void nfs_delegation_reap_unclaimed(struct nfs_client *clp)
 			delegation = nfs_start_delegation_return_locked(NFS_I(inode));
 			rcu_read_unlock();
 			if (delegation != NULL) {
-				delegation = nfs_detach_delegation(NFS_I(inode),
-					delegation, server);
-				if (delegation != NULL)
+				if (nfs_detach_delegation(NFS_I(inode), delegation,
+							server) != NULL)
 					nfs_free_delegation(delegation);
+				/* Match nfs_start_delegation_return_locked */
+				nfs_put_delegation(delegation);
 			}
 			iput(inode);
 			nfs_sb_deactive(server->super);
diff --git a/fs/nfs/delegation.h b/fs/nfs/delegation.h
index 31b84604d383..9b00a0b7f832 100644
--- a/fs/nfs/delegation.h
+++ b/fs/nfs/delegation.h
@@ -22,6 +22,7 @@ struct nfs_delegation {
 	unsigned long pagemod_limit;
 	__u64 change_attr;
 	unsigned long flags;
+	refcount_t refcount;
 	spinlock_t lock;
 	struct rcu_head rcu;
 };

