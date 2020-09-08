Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB310261DAE
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731248AbgIHTkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730784AbgIHPyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:54:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B2212405B;
        Tue,  8 Sep 2020 15:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579502;
        bh=OAxXVkiTY4WkLY8eq1lxYAV81cTJf3df8ZOVKpj8x/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fl3ZDRC2TaWIEFAswng7HjpNpBBIGLKNdFtNwzC33939p5Fi681mq0FeSlqKX/kJ8
         ckg8dDOAto1ZMyjl1N8Nlu06bXS8oOoCfLcoQ4ZNdCxggMZBaiOAJF1bCb/vblcirV
         Jn1spKa6JCuz3/kImjJ0j4buCc85cMi/A7H1p4Ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 104/186] xfs: fix xfs_bmap_validate_extent_raw when checking attr fork of rt files
Date:   Tue,  8 Sep 2020 17:24:06 +0200
Message-Id: <20200908152246.678092950@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
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
index 667cdd0dfdf4a..aa784404964a0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6222,7 +6222,7 @@ xfs_bmap_validate_extent(
 
 	isrt = XFS_IS_REALTIME_INODE(ip);
 	endfsb = irec->br_startblock + irec->br_blockcount - 1;
-	if (isrt) {
+	if (isrt && whichfork == XFS_DATA_FORK) {
 		if (!xfs_verify_rtbno(mp, irec->br_startblock))
 			return __this_address;
 		if (!xfs_verify_rtbno(mp, endfsb))
-- 
2.25.1



