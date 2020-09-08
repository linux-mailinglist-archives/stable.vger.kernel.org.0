Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F7E261A17
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731734AbgIHSay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731369AbgIHQJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5993E24182;
        Tue,  8 Sep 2020 15:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580181;
        bh=7vBnW+7r1KO/QK7OEx5kuf2AHpYunFubelARJTNRJb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWiyyDEU31aU3EeIpez1gS9Sjv1k3Ij9/iDGlFSd0xtf3DrinRsJ9oUVWnIrfTkpg
         6sqPkrJ8lMf7e7dAjNZiIA+UZRa0MLQRY2ueMmPegU+H2yjgRVPt6QdZO/7DZeIjoy
         OpftKQ6bzD50zqqrkQ2r2S8/Cz64/5jC7A4HaNJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/88] xfs: fix xfs_bmap_validate_extent_raw when checking attr fork of rt files
Date:   Tue,  8 Sep 2020 17:25:46 +0200
Message-Id: <20200908152223.385289892@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit d0c20d38af135b2b4b90aa59df7878ef0c8fbef4 ]

The realtime flag only applies to the data fork, so don't use the
realtime block number checks on the attr fork of a realtime file.

Fixes: 30b0984d9117 ("xfs: refactor bmap record validation")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0b7145fdb8aa1..f35e1801f1c90 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6130,7 +6130,7 @@ xfs_bmap_validate_extent(
 
 	isrt = XFS_IS_REALTIME_INODE(ip);
 	endfsb = irec->br_startblock + irec->br_blockcount - 1;
-	if (isrt) {
+	if (isrt && whichfork == XFS_DATA_FORK) {
 		if (!xfs_verify_rtbno(mp, irec->br_startblock))
 			return __this_address;
 		if (!xfs_verify_rtbno(mp, endfsb))
-- 
2.25.1



