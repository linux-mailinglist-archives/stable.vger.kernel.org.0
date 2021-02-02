Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8561730C50A
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 17:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhBBQKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 11:10:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234968AbhBBPJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:09:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5549564F64;
        Tue,  2 Feb 2021 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278387;
        bh=VqIb8zJZ2BP7IvgMgSZbFaL0F0xc3/d7IDt5OBYA6D0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZRPWCs6l5m17DTf4UVBz4NexL+6cX2yUHdjDODbvGfd+EezncCDIKfzQLyTx7z/1
         l2enfpKO4uA1BJp9S3KsVs0+rDKPZ2TOZeKcTisA+OijniY8DQtY2D4MshPFVX1N77
         8YuQBqytjqPpvDrDE5+fdQWsS2dIZ6Yf2n7veI2bSMH2AuleF2hKkuBnbBbrFewwKI
         VDAKaxGqrKzaC7u3denZPqDqu969m7GiZ7vwVe23iEvsVDaOvW2uvYIXjFNsiqTB1N
         bxxMEGwt2cG8jurb2tnA+MIXA0zEJkSQgQKK6fQgEI6KDCttxLec/l9YqQx2XjjsJq
         5EDg3rphjy1yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/25] pNFS/NFSv4: Improve rejection of out-of-order layouts
Date:   Tue,  2 Feb 2021 10:05:59 -0500
Message-Id: <20210202150615.1864175-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d29b468da4f940bd2bff2628ba8d2d652671d244 ]

If a layoutget ends up being reordered w.r.t. a layoutreturn, e.g. due
to a layoutget-on-open not knowing a priori which file to lock, then we
must assume the layout is no longer being considered valid state by the
server.
Incrementally improve our ability to reject such states by using the
cached old stateid in conjunction with the plh_barrier to try to
identify them.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index cbe7a82d55824..bbf1d34d79a44 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -994,7 +994,7 @@ pnfs_layout_stateid_blocked(const struct pnfs_layout_hdr *lo,
 {
 	u32 seqid = be32_to_cpu(stateid->seqid);
 
-	return !pnfs_seqid_is_newer(seqid, lo->plh_barrier);
+	return !pnfs_seqid_is_newer(seqid, lo->plh_barrier) && lo->plh_barrier;
 }
 
 /* lget is set to 1 if called from inside send_layoutget call chain */
@@ -1910,6 +1910,11 @@ static void nfs_layoutget_end(struct pnfs_layout_hdr *lo)
 		wake_up_var(&lo->plh_outstanding);
 }
 
+static bool pnfs_is_first_layoutget(struct pnfs_layout_hdr *lo)
+{
+	return test_bit(NFS_LAYOUT_FIRST_LAYOUTGET, &lo->plh_flags);
+}
+
 static void pnfs_clear_first_layoutget(struct pnfs_layout_hdr *lo)
 {
 	unsigned long *bitlock = &lo->plh_flags;
@@ -2384,17 +2389,17 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
 		goto out_forget;
 	}
 
-	if (!pnfs_layout_is_valid(lo)) {
-		/* We have a completely new layout */
-		pnfs_set_layout_stateid(lo, &res->stateid, lgp->cred, true);
-	} else if (nfs4_stateid_match_other(&lo->plh_stateid, &res->stateid)) {
+	if (nfs4_stateid_match_other(&lo->plh_stateid, &res->stateid)) {
 		/* existing state ID, make sure the sequence number matches. */
 		if (pnfs_layout_stateid_blocked(lo, &res->stateid)) {
+			if (!pnfs_layout_is_valid(lo) &&
+			    pnfs_is_first_layoutget(lo))
+				lo->plh_barrier = 0;
 			dprintk("%s forget reply due to sequence\n", __func__);
 			goto out_forget;
 		}
 		pnfs_set_layout_stateid(lo, &res->stateid, lgp->cred, false);
-	} else {
+	} else if (pnfs_layout_is_valid(lo)) {
 		/*
 		 * We got an entirely new state ID.  Mark all segments for the
 		 * inode invalid, and retry the layoutget
@@ -2407,6 +2412,11 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
 		pnfs_mark_matching_lsegs_return(lo, &lo->plh_return_segs,
 						&range, 0);
 		goto out_forget;
+	} else {
+		/* We have a completely new layout */
+		if (!pnfs_is_first_layoutget(lo))
+			goto out_forget;
+		pnfs_set_layout_stateid(lo, &res->stateid, lgp->cred, true);
 	}
 
 	pnfs_get_lseg(lseg);
-- 
2.27.0

