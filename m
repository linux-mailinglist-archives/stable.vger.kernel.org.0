Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8242B65A5
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbgKQNTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730397AbgKQNTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:19:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D7A22465E;
        Tue, 17 Nov 2020 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619186;
        bh=CHrSrhxaSDBygUeWx8DikqmEOYsoGcez1vsSOkiG43o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckvgoKjbKmtVkeeTjiRmV/dcsjQLag+f3Bs6YJJWN6irXsS7wcHxIhRySTJBb9GFX
         MxiLQ4eTLnMRaYGgUg4YM+K8/JW9DQUtMk8xKwAHcxLJiEyzOS30WOzcvjcfgLxHaO
         aTQRtAkOC40X+Hi5Lxq7kOB2SVcbJA+29gKPBDcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/101] xfs: fix brainos in the refcount scrubbers rmap fragment processor
Date:   Tue, 17 Nov 2020 14:05:24 +0100
Message-Id: <20201117122115.877021179@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 54e9b09e153842ab5adb8a460b891e11b39e9c3d ]

Fix some serious WTF in the reference count scrubber's rmap fragment
processing.  The code comment says that this loop is supposed to move
all fragment records starting at or before bno onto the worklist, but
there's no obvious reason why nr (the number of items added) should
increment starting from 1, and breaking the loop when we've added the
target number seems dubious since we could have more rmap fragments that
should have been added to the worklist.

This seems to manifest in xfs/411 when adding one to the refcount field.

Fixes: dbde19da9637 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/refcount.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index e8c82b026083e..76e4f16a9fab2 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -180,7 +180,6 @@ xchk_refcountbt_process_rmap_fragments(
 	 */
 	INIT_LIST_HEAD(&worklist);
 	rbno = NULLAGBLOCK;
-	nr = 1;
 
 	/* Make sure the fragments actually /are/ in agbno order. */
 	bno = 0;
@@ -194,15 +193,14 @@ xchk_refcountbt_process_rmap_fragments(
 	 * Find all the rmaps that start at or before the refc extent,
 	 * and put them on the worklist.
 	 */
+	nr = 0;
 	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
-		if (frag->rm.rm_startblock > refchk->bno)
-			goto done;
+		if (frag->rm.rm_startblock > refchk->bno || nr > target_nr)
+			break;
 		bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
 		if (bno < rbno)
 			rbno = bno;
 		list_move_tail(&frag->list, &worklist);
-		if (nr == target_nr)
-			break;
 		nr++;
 	}
 
-- 
2.27.0



