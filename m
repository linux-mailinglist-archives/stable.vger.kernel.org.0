Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABED3323D8B
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhBXNNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:13:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235369AbhBXNCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:02:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 952A264F13;
        Wed, 24 Feb 2021 12:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171200;
        bh=1voqjsAoBFLxX7rDbdvLrvHACJsPGL3qdmFT+MVPv9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4CaV2DsapOHyAY2CTejx635bsmN1PT/GI+bXaSP41g0MUkn97yPgHWDfUXDGusrK
         hJYCVndOTt3ljWNDEpNMfC+OwFIWm1Y3O7RlCa8ajND8LdyjkXHFjBnJKfAhempKb+
         FrCFJyhjQLdQFEOJhAPQ+ezCqlszTuMIAwjc4wmZUsH3UYNbNpXF/D5N3qzaZx2fMn
         vs88qYTVw4CanXIbaallaqKw5ZJCkNUESoOl5oc5VYtTk3LrgntI4V5abPeY1m+lJB
         C02lj9za7z7k5bu7x2r24d7iynMZK1mZhdTxXkTUkxvwsBF7jQ3duMS6nw0kc2NV49
         WWwh3F9SmVCuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Beulich <jbeulich@suse.com>, Juergen Gross <jgross@suse.com>,
        Julien Grall <julien@xen.org>, Sasha Levin <sashal@kernel.org>,
        xen-devel@lists.xenproject.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 51/56] xen-blkback: fix error handling in xen_blkbk_map()
Date:   Wed, 24 Feb 2021 07:52:07 -0500
Message-Id: <20210224125212.482485-51-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 871997bc9e423f05c7da7c9178e62dde5df2a7f8 ]

The function uses a goto-based loop, which may lead to an earlier error
getting discarded by a later iteration. Exit this ad-hoc loop when an
error was encountered.

The out-of-memory error path additionally fails to fill a structure
field looked at by xen_blkbk_unmap_prepare() before inspecting the
handle which does get properly set (to BLKBACK_INVALID_HANDLE).

Since the earlier exiting from the ad-hoc loop requires the same field
filling (invalidation) as that on the out-of-memory path, fold both
paths. While doing so, drop the pr_alert(), as extra log messages aren't
going to help the situation (the kernel will log oom conditions already
anyway).

This is XSA-365.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkback/blkback.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 9ebf53903d7bf..9301de1386436 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -794,8 +794,13 @@ static int xen_blkbk_map(struct xen_blkif_ring *ring,
 			pages[i]->persistent_gnt = persistent_gnt;
 		} else {
 			if (gnttab_page_cache_get(&ring->free_pages,
-						  &pages[i]->page))
-				goto out_of_memory;
+						  &pages[i]->page)) {
+				gnttab_page_cache_put(&ring->free_pages,
+						      pages_to_gnt,
+						      segs_to_map);
+				ret = -ENOMEM;
+				goto out;
+			}
 			addr = vaddr(pages[i]->page);
 			pages_to_gnt[segs_to_map] = pages[i]->page;
 			pages[i]->persistent_gnt = NULL;
@@ -882,17 +887,18 @@ static int xen_blkbk_map(struct xen_blkif_ring *ring,
 	}
 	segs_to_map = 0;
 	last_map = map_until;
-	if (map_until != num)
+	if (!ret && map_until != num)
 		goto again;
 
-	return ret;
-
-out_of_memory:
-	pr_alert("%s: out of memory\n", __func__);
-	gnttab_page_cache_put(&ring->free_pages, pages_to_gnt, segs_to_map);
-	for (i = last_map; i < num; i++)
+out:
+	for (i = last_map; i < num; i++) {
+		/* Don't zap current batch's valid persistent grants. */
+		if(i >= last_map + segs_to_map)
+			pages[i]->persistent_gnt = NULL;
 		pages[i]->handle = BLKBACK_INVALID_HANDLE;
-	return -ENOMEM;
+	}
+
+	return ret;
 }
 
 static int xen_blkbk_map_seg(struct pending_req *pending_req)
-- 
2.27.0

