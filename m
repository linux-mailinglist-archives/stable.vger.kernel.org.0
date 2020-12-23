Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF332E16DC
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgLWDDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728647AbgLWCT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79107206EC;
        Wed, 23 Dec 2020 02:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689939;
        bh=RtqJsKm5KDbxgsapWnnxMcKyIwnfwCzHQepqTKGp/0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+Ha4qujhKtL78BfBbckxubv18MA7taVYEKJVAWGAep9z9ic9PiiCoKSBqYOlseY/
         e+QCdqHJosefkbymwWGqZTw7IHHf0RjnuD2qfN/0V7YcWL0b1ODz7O3rzRvfSL27Ym
         1ztJ0+qUFoCJouQv1ILWrKFFnlEfhLrM1i89GGyzV+HP17QsnFD6uHhsYFuJSGkq48
         ciRsxLimyjdXA/oezwi81Dyu014WUfIAQEZcQCAH9HJ3s10MV2GSHpxPBp0iMAMIZ0
         GtpafRNr/CX7QCzt/e3fX4s2Gbjv0QtC0ublKwa0Hxv6fC88ltKqY9hXSY25m5tav/
         ik5B59RektkKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 035/130] jfs: Fix memleak in dbAdjCtl
Date:   Tue, 22 Dec 2020 21:16:38 -0500
Message-Id: <20201223021813.2791612-35-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index caade185e568d..51b2c8f6ef35d 100644
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

