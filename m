Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF02E2E13AA
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgLWCdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:33:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730430AbgLWCZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E80A229CA;
        Wed, 23 Dec 2020 02:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690275;
        bh=YrbTY5JpEvTtuhqP3HWPxAhzZ0+tfCCafdmz15WdEwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxLpMN/5e6BoXdM4dJKJNbDgN0OKJefubQWRbmNdpW9XPKKD6Vjv6HcESPOM15uQS
         NMl4MAh6kElYDCHRS3YpAoUR384z9tdiOgBTHAbooXfYQzT9fvdYO1eA8azv8vUltT
         yrnicZpARKBnYEwea9bHubEOZZwqLdSr36JBhGhrSabHRQ6T7KeqStQqAymNQKMhaH
         gM6dwsgFWjCASTbCv9jj5hZJIUbLexSE+nrI9UdanDFkaZCdtq+jKXtSQ2UbcKK/fH
         w8XlbULUr3vmHDVErU9wiaBAOcH4TDM6sOvLJncSaCwfQsGNJlCU7ALj9P/VP8NKBI
         Ohz6Z3FN/XiMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 15/48] jfs: Fix memleak in dbAdjCtl
Date:   Tue, 22 Dec 2020 21:23:43 -0500
Message-Id: <20201223022417.2794032-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
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
index 2d514c7affc2a..fa14a01950853 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -2562,15 +2562,19 @@ dbAdjCtl(struct bmap * bmp, s64 blkno, int newval, int alloc, int level)
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

