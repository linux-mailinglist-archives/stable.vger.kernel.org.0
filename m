Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE0A10661C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfKVG2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbfKVFuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAD882068F;
        Fri, 22 Nov 2019 05:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401806;
        bh=O8wyPceWayF533GAkTF/pAHkQtQKQAuf8TKGcWkyJoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wui7xc7b8H4Xmf2RtO2/lOcI19UqcrNRKrKQOgpJqT5hcVTrlnDhcF4haH7X28F7O
         y3zs63khc/TXnDmqB+bsEIjrmBZ9wbMv5ccMX83TmbNTJJiALJ6l/4MLOLs0Jv7CBZ
         J54YXy6WOXJc9dhAlswQJn9b/8Z/I1LY0daO5C2M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Bill O'Donnell <billodo@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 051/219] xfs: require both realtime inodes to mount
Date:   Fri, 22 Nov 2019 00:46:23 -0500
Message-Id: <20191122054911.1750-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 64bafd2f1e484e27071e7584642005d56516cb77 ]

Since mkfs always formats the filesystem with the realtime bitmap and
summary inodes immediately after the root directory, we should expect
that both of them are present and loadable, even if there isn't a
realtime volume attached.  There's no reason to skip this if rbmino ==
NULLFSINO; in fact, this causes an immediate crash if the there /is/ a
realtime volume and someone writes to it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 926ed314ffba1..484eb0adcefb2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1198,13 +1198,11 @@ xfs_rtmount_inodes(
 	xfs_sb_t	*sbp;
 
 	sbp = &mp->m_sb;
-	if (sbp->sb_rbmino == NULLFSINO)
-		return 0;
 	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
 	if (error)
 		return error;
 	ASSERT(mp->m_rbmip != NULL);
-	ASSERT(sbp->sb_rsumino != NULLFSINO);
+
 	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
 	if (error) {
 		xfs_irele(mp->m_rbmip);
-- 
2.20.1

