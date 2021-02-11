Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D533C318E8C
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhBKP3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:29:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231216AbhBKP04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:26:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19DFA64EDC;
        Thu, 11 Feb 2021 15:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055840;
        bh=P3ySuIoZiGLqChplEii4dqImlShz5ythlBs/yPIdRFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=App0+lCnqHC7FHl7+IV+suMCWXk9udXc98gaGRIvQluiuuXU/u3IddHglZWTWoED2
         DkAP7iNcpvz/E9nC4+f37/L3thBWgeR9aN/oRkDaXFyLt5hT6LrJ7PjLjj1pgtdDIS
         e7c+wBHIxUZKCnS2UeWGTV5GAPVUtctdADJWDL20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/54] pNFS/NFSv4: Improve rejection of out-of-order layouts
Date:   Thu, 11 Feb 2021 16:02:11 +0100
Message-Id: <20210211150154.076278196@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2b98286376d40..b8712b835b105 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1000,7 +1000,7 @@ pnfs_layout_stateid_blocked(const struct pnfs_layout_hdr *lo,
 {
 	u32 seqid = be32_to_cpu(stateid->seqid);
 
-	return !pnfs_seqid_is_newer(seqid, lo->plh_barrier);
+	return !pnfs_seqid_is_newer(seqid, lo->plh_barrier) && lo->plh_barrier;
 }
 
 /* lget is set to 1 if called from inside send_layoutget call chain */
@@ -1913,6 +1913,11 @@ static void nfs_layoutget_end(struct pnfs_layout_hdr *lo)
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
@@ -2387,17 +2392,17 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
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
@@ -2410,6 +2415,11 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
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



