Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9423CE3F0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245314AbhGSPlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348259AbhGSPfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4673A613F8;
        Mon, 19 Jul 2021 16:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711201;
        bh=MKIxljbSMiN4lQr+2bGaXyfWzaHMBqVx4BEhbmWgEeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmsirQcxCNIj/3rxQETifQbqHv/FvYqiwc5EL+6lHUHHIHKuwYK1IbQUbkYggMa+N
         z/40p4ng/AeUpqPlAnk6ZhJeI3zGo20SPM+XAULSe21QzAwz6oMZfBPjGTTybkh3TK
         mi96y6TmUbWth7d6USfJNiA2JWtCB2hlMj333eMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 265/351] NFSv4/pnfs: Fix the layout barrier update
Date:   Mon, 19 Jul 2021 16:53:31 +0200
Message-Id: <20210719144953.709968528@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit aa95edf309ef31e2df4a37ebf0e5c2ca2a6772ab ]

If we have multiple outstanding layoutget requests, the current code to
update the layout barrier assumes that the outstanding layout stateids
are updated in order. That's not necessarily the case.

Instead of using the value of lo->plh_outstanding as a guesstimate for
the window of values we need to accept, just wait to update the window
until we're processing the last one. The intention here is just to
ensure that we don't process 2^31 seqid updates without also updating
the barrier.

Fixes: 1bcf34fdac5f ("pNFS/NFSv4: Update the layout barrier when we schedule a layoutreturn")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 2c01ee805306..ffe02e43f8c0 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -966,10 +966,8 @@ void
 pnfs_set_layout_stateid(struct pnfs_layout_hdr *lo, const nfs4_stateid *new,
 			const struct cred *cred, bool update_barrier)
 {
-	u32 oldseq, newseq, new_barrier = 0;
-
-	oldseq = be32_to_cpu(lo->plh_stateid.seqid);
-	newseq = be32_to_cpu(new->seqid);
+	u32 oldseq = be32_to_cpu(lo->plh_stateid.seqid);
+	u32 newseq = be32_to_cpu(new->seqid);
 
 	if (!pnfs_layout_is_valid(lo)) {
 		pnfs_set_layout_cred(lo, cred);
@@ -979,19 +977,21 @@ pnfs_set_layout_stateid(struct pnfs_layout_hdr *lo, const nfs4_stateid *new,
 		clear_bit(NFS_LAYOUT_INVALID_STID, &lo->plh_flags);
 		return;
 	}
-	if (pnfs_seqid_is_newer(newseq, oldseq)) {
+
+	if (pnfs_seqid_is_newer(newseq, oldseq))
 		nfs4_stateid_copy(&lo->plh_stateid, new);
-		/*
-		 * Because of wraparound, we want to keep the barrier
-		 * "close" to the current seqids.
-		 */
-		new_barrier = newseq - atomic_read(&lo->plh_outstanding);
-	}
-	if (update_barrier)
-		new_barrier = be32_to_cpu(new->seqid);
-	else if (new_barrier == 0)
+
+	if (update_barrier) {
+		pnfs_barrier_update(lo, newseq);
 		return;
-	pnfs_barrier_update(lo, new_barrier);
+	}
+	/*
+	 * Because of wraparound, we want to keep the barrier
+	 * "close" to the current seqids. We really only want to
+	 * get here from a layoutget call.
+	 */
+	if (atomic_read(&lo->plh_outstanding) == 1)
+		 pnfs_barrier_update(lo, be32_to_cpu(lo->plh_stateid.seqid));
 }
 
 static bool
-- 
2.30.2



