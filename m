Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A92C2E9A96
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbhADQLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:11:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbhADQAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99AEA22473;
        Mon,  4 Jan 2021 15:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775935;
        bh=3kuHzY4yx1SVEHMeOsRR8JLpQJFo33DMO4NBlvtdluo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kltc4a2Q0pyB2dv5FZLzadF5RhUC6TDKk37pyBRReiCXMbTAx06roAu6f7Ubj7B/m
         pBHqv49hxv2B7b4m8KS743fpomSh3KE9gGnLNFVPi5kCRkNnD0lGthZnWY05EW/utV
         Ye8yZGiZcxP2r4IRnkGbOP6fZbB9IWZEIzchfuIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 32/35] NFSv4: Fix a pNFS layout related use-after-free race when freeing the inode
Date:   Mon,  4 Jan 2021 16:57:35 +0100
Message-Id: <20210104155704.938968452@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155703.375788488@linuxfoundation.org>
References: <20210104155703.375788488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6fb7cb6b3f4b0..e7a10f5f54057 100644
--- a/fs/nfs/nfs4super.c
+++ b/fs/nfs/nfs4super.c
@@ -95,7 +95,7 @@ static void nfs4_evict_inode(struct inode *inode)
 	nfs_inode_return_delegation_noreclaim(inode);
 	/* Note that above delegreturn would trigger pnfs return-on-close */
 	pnfs_return_layout(inode);
-	pnfs_destroy_layout(NFS_I(inode));
+	pnfs_destroy_layout_final(NFS_I(inode));
 	/* First call standard NFS clear_inode() code */
 	nfs_clear_inode(inode);
 }
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 2b9e139a29975..a253384a4710b 100644
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
 
@@ -713,8 +718,7 @@ pnfs_free_lseg_list(struct list_head *free_me)
 	}
 }
 
-void
-pnfs_destroy_layout(struct nfs_inode *nfsi)
+static struct pnfs_layout_hdr *__pnfs_destroy_layout(struct nfs_inode *nfsi)
 {
 	struct pnfs_layout_hdr *lo;
 	LIST_HEAD(tmp_list);
@@ -732,9 +736,34 @@ pnfs_destroy_layout(struct nfs_inode *nfsi)
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
index 3ba44819a88ae..80fafa29e567a 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -254,6 +254,7 @@ struct pnfs_layout_segment *pnfs_layout_process(struct nfs4_layoutget *lgp);
 void pnfs_layoutget_free(struct nfs4_layoutget *lgp);
 void pnfs_free_lseg_list(struct list_head *tmp_list);
 void pnfs_destroy_layout(struct nfs_inode *);
+void pnfs_destroy_layout_final(struct nfs_inode *);
 void pnfs_destroy_all_layouts(struct nfs_client *);
 int pnfs_destroy_layouts_byfsid(struct nfs_client *clp,
 		struct nfs_fsid *fsid,
@@ -645,6 +646,10 @@ static inline void pnfs_destroy_layout(struct nfs_inode *nfsi)
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



