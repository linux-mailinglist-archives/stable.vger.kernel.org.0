Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191552E1725
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgLWDG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbgLWCTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FED423435;
        Wed, 23 Dec 2020 02:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689888;
        bh=1uP2c0+XEwO4wOTOior9AIKviSft5M0m/TbEzlHj4Qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLaFLtg5YAlm62Cs4hQ7gQ55aBplotx43N6YcWWq96XxaU44BDEQecWcyIwDel3HK
         k7I+oQcZ7Wpek1PnxRGYAsrF04rhrSlk3WZxdecf86K1ZU89GYSfAt1ig9W2D4yV5b
         yH8bqnlCWnxZUWNXXU5LOf8Dvee8wP4l4rbJgH/irZe4iv0Cyxl3FTY9ADSUyOuMFP
         MZs+I06moJeiRuPvIk0AepdVu+q4vEMGQuZ/PCO5J4ac1YosnxL17GJ1mBoef6KE0o
         5CfAFKDIwtvzZ06T0wG5FqChZTNU/VKsvSuWI2BwvIcucW7Gu+/wCkiF4w8cw+gu+D
         edI9uNbpMgj1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.10 076/217] jfs: Fix memleak in dbAdjCtl
Date:   Tue, 22 Dec 2020 21:14:05 -0500
Message-Id: <20201223021626.2790791-76-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 751341b4d7841e2b76e78eec382c2e119165497f ]

When dbBackSplit() fails, mp should be released to
prevent memleak. It's the same when dbJoin() fails.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 7dfcab2a2da68..619deeeb3d8b4 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -2549,15 +2549,19 @@ dbAdjCtl(struct bmap * bmp, s64 blkno, int newval, int alloc, int level)
 		 */
 		if (oldval == NOFREE) {
 			rc = dbBackSplit((dmtree_t *) dcp, leafno);
-			if (rc)
+			if (rc) {
+				release_metapage(mp);
 				return rc;
+			}
 			oldval = dcp->stree[ti];
 		}
 		dbSplit((dmtree_t *) dcp, leafno, dcp->budmin, newval);
 	} else {
 		rc = dbJoin((dmtree_t *) dcp, leafno, newval);
-		if (rc)
+		if (rc) {
+			release_metapage(mp);
 			return rc;
+		}
 	}
 
 	/* check if the root of the current dmap control page changed due
-- 
2.27.0

