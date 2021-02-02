Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0A830C363
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbhBBPQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:16:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234981AbhBBPNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:13:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00E7664F92;
        Tue,  2 Feb 2021 15:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278440;
        bh=JdyYKbU1YEl8DFdnMMhTxGdbT0e34XzBbDJBJQP+y0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pL3Lc/Vf8Te0Pr70bCV4MhknNpbLaBvdJcniO6C7fKGy3RUFKlLC/3zwzvktc3n8A
         4k1TR9UQPE3G16EPvqiCUxw8ce/w74eQP+QHFsnRJMcq49Rw3/ra5AlQp8m2I5TRDj
         MHEciZWUTZR3EiW3lLXgHWvKqCI6ZdSBSIMF3/4vfABKwI1Y7NQN1TE/cQN77oAqge
         TP4ENXNXkqr1hqwYlFpdCxDRN3u+dIzENF8Yw2WmJo05OpJFXfyzXUvHFwWegPBON8
         Vr7o/8NZSqiJzhZdKyEU6shglAHsFrRIqUFR7MdwGRfe9SpymlWnaDNCYdAwQA0Ty7
         U4Csnp9wk3E7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/10] pNFS/NFSv4: Try to return invalid layout in pnfs_layout_process()
Date:   Tue,  2 Feb 2021 10:07:08 -0500
Message-Id: <20210202150715.1864614-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150715.1864614-1-sashal@kernel.org>
References: <20210202150715.1864614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 08bd8dbe88825760e953759d7ec212903a026c75 ]

If the server returns a new stateid that does not match the one in our
cache, then try to return the one we hold instead of just invalidating
it on the client side. This ensures that both client and server will
agree that the stateid is invalid.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 46ca5592b8b0d..2c43583e2aa1c 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2301,7 +2301,13 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
 		 * We got an entirely new state ID.  Mark all segments for the
 		 * inode invalid, and retry the layoutget
 		 */
-		pnfs_mark_layout_stateid_invalid(lo, &free_me);
+		struct pnfs_layout_range range = {
+			.iomode = IOMODE_ANY,
+			.length = NFS4_MAX_UINT64,
+		};
+		pnfs_set_plh_return_info(lo, IOMODE_ANY, 0);
+		pnfs_mark_matching_lsegs_return(lo, &lo->plh_return_segs,
+						&range, 0);
 		goto out_forget;
 	}
 
-- 
2.27.0

