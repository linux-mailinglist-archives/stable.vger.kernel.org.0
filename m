Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473972E7973
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgL3NJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727316AbgL3NFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D807C22287;
        Wed, 30 Dec 2020 13:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333450;
        bh=sMyrdGaSkUI7HSmRU9MW0autRFm3hR4EuYecnD49Y8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMkSDnWeZI3PGXjZ/p4EFiFK+WDgSHUQUOrE9zXOCOrCdAPwBue5v+rq8NFvuCEN5
         CjEvB7s6HclHrzYPaSdA/5GXHecw4XHgh9PPqhvAOsgvZgm8rPbN2MIwO/BaLJCN7V
         trVkCX4Nt0pR//WBeU4fJWAjtZg7LEHWZLgMyUpoAB42ajFsWqADwluv1paG1OAxI2
         BFR6MkDFjwH1WeZNnEMnOalN9hRohnnmrYo/qM33TpNIMODoow9My+1HtiduOIgKEM
         r5XewpwmscBVnDfRniIhgT6zCvcsNWiFkkT5btlJyF7rHeh1xkIE/ujFLXaBCizkO6
         RviAuaW7gPMtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/17] NFSv4: Fix a pNFS layout related use-after-free race when freeing the inode
Date:   Wed, 30 Dec 2020 08:03:49 -0500
Message-Id: <20201230130357.3637261-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130357.3637261-1-sashal@kernel.org>
References: <20201230130357.3637261-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b6d49ecd1081740b6e632366428b960461f8158b ]

When returning the layout in nfs4_evict_inode(), we need to ensure that
the layout is actually done being freed before we can proceed to free the
inode itself.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4super.c |  2 +-
 fs/nfs/pnfs.c      | 33 +++++++++++++++++++++++++++++++--
 fs/nfs/pnfs.h      |  5 +++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4super.c b/fs/nfs/nfs4super.c
index 04c57066a11af..b90642b022eb9 100644
--- a/fs/nfs/nfs4super.c
+++ b/fs/nfs/nfs4super.c
@@ -96,7 +96,7 @@ static void nfs4_evict_inode(struct inode *inode)
 	nfs_inode_return_delegation_noreclaim(inode);
 	/* Note that above delegreturn would trigger pnfs return-on-close */
 	pnfs_return_layout(inode);
-	pnfs_destroy_layout(NFS_I(inode));
+	pnfs_destroy_layout_final(NFS_I(inode));
 	/* First call standard NFS clear_inode() code */
 	nfs_clear_inode(inode);
 }
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 9c2b07ce57b27..9fd115c4d0a2f 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -294,6 +294,7 @@ void
 pnfs_put_layout_hdr(struct pnfs_layout_hdr *lo)
 {
 	struct inode *inode;
+	unsigned long i_state;
 
 	if (!lo)
 		return;
@@ -304,8 +305,12 @@ pnfs_put_layout_hdr(struct pnfs_layout_hdr *lo)
 		if (!list_empty(&lo->plh_segs))
 			WARN_ONCE(1, "NFS: BUG unfreed layout segments.\n");
 		pnfs_detach_layout_hdr(lo);
+		i_state = inode->i_state;
 		spin_unlock(&inode->i_lock);
 		pnfs_free_layout_hdr(lo);
+		/* Notify pnfs_destroy_layout_final() that we're done */
+		if (i_state & (I_FREEING | I_CLEAR))
+			wake_up_var(lo);
 	}
 }
 
@@ -723,8 +728,7 @@ pnfs_free_lseg_list(struct list_head *free_me)
 	}
 }
 
-void
-pnfs_destroy_layout(struct nfs_inode *nfsi)
+static struct pnfs_layout_hdr *__pnfs_destroy_layout(struct nfs_inode *nfsi)
 {
 	struct pnfs_layout_hdr *lo;
 	LIST_HEAD(tmp_list);
@@ -742,9 +746,34 @@ pnfs_destroy_layout(struct nfs_inode *nfsi)
 		pnfs_put_layout_hdr(lo);
 	} else
 		spin_unlock(&nfsi->vfs_inode.i_lock);
+	return lo;
+}
+
+void pnfs_destroy_layout(struct nfs_inode *nfsi)
+{
+	__pnfs_destroy_layout(nfsi);
 }
 EXPORT_SYMBOL_GPL(pnfs_destroy_layout);
 
+static bool pnfs_layout_removed(struct nfs_inode *nfsi,
+				struct pnfs_layout_hdr *lo)
+{
+	bool ret;
+
+	spin_lock(&nfsi->vfs_inode.i_lock);
+	ret = nfsi->layout != lo;
+	spin_unlock(&nfsi->vfs_inode.i_lock);
+	return ret;
+}
+
+void pnfs_destroy_layout_final(struct nfs_inode *nfsi)
+{
+	struct pnfs_layout_hdr *lo = __pnfs_destroy_layout(nfsi);
+
+	if (lo)
+		wait_var_event(lo, pnfs_layout_removed(nfsi, lo));
+}
+
 static bool
 pnfs_layout_add_bulk_destroy_list(struct inode *inode,
 		struct list_head *layout_list)
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index f8a38065c7e47..63da33a92d831 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -255,6 +255,7 @@ struct pnfs_layout_segment *pnfs_layout_process(struct nfs4_layoutget *lgp);
 void pnfs_layoutget_free(struct nfs4_layoutget *lgp);
 void pnfs_free_lseg_list(struct list_head *tmp_list);
 void pnfs_destroy_layout(struct nfs_inode *);
+void pnfs_destroy_layout_final(struct nfs_inode *);
 void pnfs_destroy_all_layouts(struct nfs_client *);
 int pnfs_destroy_layouts_byfsid(struct nfs_client *clp,
 		struct nfs_fsid *fsid,
@@ -651,6 +652,10 @@ static inline void pnfs_destroy_layout(struct nfs_inode *nfsi)
 {
 }
 
+static inline void pnfs_destroy_layout_final(struct nfs_inode *nfsi)
+{
+}
+
 static inline struct pnfs_layout_segment *
 pnfs_get_lseg(struct pnfs_layout_segment *lseg)
 {
-- 
2.27.0

