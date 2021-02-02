Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE80F30C050
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhBBNyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:42464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233173AbhBBNwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:52:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F32364FBE;
        Tue,  2 Feb 2021 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273413;
        bh=4svhSsihdL7JqHm6L3zkuQqzjdfne7AylIwhUZrmfb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/GpJLsgSEjpTplUXr78BCKVY4RyeKVQtCnB3gKLbXmiy8NDvYkwlx6vtVsoYezxr
         PqcTJTnfoFeVPXKVFs8HQvlnUv8+urED5fVLjLns+DreAkcvsn2UUt5z5B343qRciS
         k9nPJ+j+xONSK6L54VDNFBRudZFv9R5+1XERb5F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/142] pNFS/NFSv4: Update the layout barrier when we schedule a layoutreturn
Date:   Tue,  2 Feb 2021 14:37:40 +0100
Message-Id: <20210202133001.715539613@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 1bcf34fdac5f8c2fcd16796495db75744612ca27 ]

When we're scheduling a layoutreturn, we need to ignore any further
incoming layouts with sequence ids that are going to be affected by the
layout return.

Fixes: 44ea8dfce021 ("NFS/pnfs: Reference the layout cred in pnfs_prepare_layoutreturn()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 426877f72441e..cbadcf6ca4da2 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -324,6 +324,21 @@ pnfs_grab_inode_layout_hdr(struct pnfs_layout_hdr *lo)
 	return NULL;
 }
 
+/*
+ * Compare 2 layout stateid sequence ids, to see which is newer,
+ * taking into account wraparound issues.
+ */
+static bool pnfs_seqid_is_newer(u32 s1, u32 s2)
+{
+	return (s32)(s1 - s2) > 0;
+}
+
+static void pnfs_barrier_update(struct pnfs_layout_hdr *lo, u32 newseq)
+{
+	if (pnfs_seqid_is_newer(newseq, lo->plh_barrier))
+		lo->plh_barrier = newseq;
+}
+
 static void
 pnfs_set_plh_return_info(struct pnfs_layout_hdr *lo, enum pnfs_iomode iomode,
 			 u32 seq)
@@ -335,6 +350,7 @@ pnfs_set_plh_return_info(struct pnfs_layout_hdr *lo, enum pnfs_iomode iomode,
 	if (seq != 0) {
 		WARN_ON_ONCE(lo->plh_return_seq != 0 && lo->plh_return_seq != seq);
 		lo->plh_return_seq = seq;
+		pnfs_barrier_update(lo, seq);
 	}
 }
 
@@ -639,15 +655,6 @@ static int mark_lseg_invalid(struct pnfs_layout_segment *lseg,
 	return rv;
 }
 
-/*
- * Compare 2 layout stateid sequence ids, to see which is newer,
- * taking into account wraparound issues.
- */
-static bool pnfs_seqid_is_newer(u32 s1, u32 s2)
-{
-	return (s32)(s1 - s2) > 0;
-}
-
 static bool
 pnfs_should_free_range(const struct pnfs_layout_range *lseg_range,
 		 const struct pnfs_layout_range *recall_range)
@@ -984,8 +991,7 @@ pnfs_set_layout_stateid(struct pnfs_layout_hdr *lo, const nfs4_stateid *new,
 		new_barrier = be32_to_cpu(new->seqid);
 	else if (new_barrier == 0)
 		return;
-	if (pnfs_seqid_is_newer(new_barrier, lo->plh_barrier))
-		lo->plh_barrier = new_barrier;
+	pnfs_barrier_update(lo, new_barrier);
 }
 
 static bool
@@ -1183,20 +1189,17 @@ pnfs_prepare_layoutreturn(struct pnfs_layout_hdr *lo,
 		return false;
 	set_bit(NFS_LAYOUT_RETURN, &lo->plh_flags);
 	pnfs_get_layout_hdr(lo);
+	nfs4_stateid_copy(stateid, &lo->plh_stateid);
+	*cred = get_cred(lo->plh_lc_cred);
 	if (test_bit(NFS_LAYOUT_RETURN_REQUESTED, &lo->plh_flags)) {
-		nfs4_stateid_copy(stateid, &lo->plh_stateid);
-		*cred = get_cred(lo->plh_lc_cred);
 		if (lo->plh_return_seq != 0)
 			stateid->seqid = cpu_to_be32(lo->plh_return_seq);
 		if (iomode != NULL)
 			*iomode = lo->plh_return_iomode;
 		pnfs_clear_layoutreturn_info(lo);
-		return true;
-	}
-	nfs4_stateid_copy(stateid, &lo->plh_stateid);
-	*cred = get_cred(lo->plh_lc_cred);
-	if (iomode != NULL)
+	} else if (iomode != NULL)
 		*iomode = IOMODE_ANY;
+	pnfs_barrier_update(lo, be32_to_cpu(stateid->seqid));
 	return true;
 }
 
-- 
2.27.0



