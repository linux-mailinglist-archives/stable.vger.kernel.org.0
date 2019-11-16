Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D44DFF1DB
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbfKPQPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:15:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728920AbfKPPrb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:31 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F12BE208C0;
        Sat, 16 Nov 2019 15:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919251;
        bh=7Z34qvYkmT7kuRZmfAtggVFqZxeEkdnPdZccfyOiPeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qG1ASKEsWMHiSkXDq/mdkIRPtz4LW7DE9JRMO9JmOmnvZyR/OQflfCWgvisF0Lk7U
         p2cfJHKGAXcXQNRxmWkvBpAduG4f6nFRjTFXE2KTwbyKOa+W+yQObyenxnSVAnpxwo
         lzbcGslGIBAZyvwUYzcQv50rYMjsuPSW2yFKwao8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 003/150] gfs2: Fix marking bitmaps non-full
Date:   Sat, 16 Nov 2019 10:45:01 -0500
Message-Id: <20191116154729.9573-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit ec23df2b0cf3e1620f5db77972b7fb735f267eff ]

Reservations in gfs can span multiple gfs2_bitmaps (but they won't span
multiple resource groups).  When removing a reservation, we want to
clear the GBF_FULL flags of all involved gfs2_bitmaps, not just that of
the first bitmap.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/rgrp.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index b0eee90738ff4..3b0debd066c96 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -623,7 +623,10 @@ static void __rs_deltree(struct gfs2_blkreserv *rs)
 	RB_CLEAR_NODE(&rs->rs_node);
 
 	if (rs->rs_free) {
-		struct gfs2_bitmap *bi = rbm_bi(&rs->rs_rbm);
+		u64 last_block = gfs2_rbm_to_block(&rs->rs_rbm) +
+				 rs->rs_free - 1;
+		struct gfs2_rbm last_rbm = { .rgd = rs->rs_rbm.rgd, };
+		struct gfs2_bitmap *start, *last;
 
 		/* return reserved blocks to the rgrp */
 		BUG_ON(rs->rs_rbm.rgd->rd_reserved < rs->rs_free);
@@ -634,7 +637,13 @@ static void __rs_deltree(struct gfs2_blkreserv *rs)
 		   it will force the number to be recalculated later. */
 		rgd->rd_extfail_pt += rs->rs_free;
 		rs->rs_free = 0;
-		clear_bit(GBF_FULL, &bi->bi_flags);
+		if (gfs2_rbm_from_block(&last_rbm, last_block))
+			return;
+		start = rbm_bi(&rs->rs_rbm);
+		last = rbm_bi(&last_rbm);
+		do
+			clear_bit(GBF_FULL, &start->bi_flags);
+		while (start++ != last);
 	}
 }
 
-- 
2.20.1

