Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553052475BE
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731993AbgHQT16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730345AbgHQPdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:33:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B52F20729;
        Mon, 17 Aug 2020 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678380;
        bh=MDW7zPGSxlpGtuVlSdNQEyo/5VeyAqxAcooG2pKk2kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJtgwKs3mr8Y91Rpr7+iEFJCjc0qSVCc88SHNWSVyr+v6v1R/HPQGZI32IucqbX0A
         Fl7k3BsB0yKcySADrey3fJNx/rFXhVG0Psh3i2dQtQZAX8JbWEbz7wBfESxMCnz2Bu
         cOfsOvvu7mz4xvc4L3lNpdI9otb8ywOZbfCn0Dh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 313/464] xfs: fix inode allocation block res calculation precedence
Date:   Mon, 17 Aug 2020 17:14:26 +0200
Message-Id: <20200817143848.789582937@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit b2a8864728683443f34a9fd33a2b78b860934cc1 ]

The block reservation calculation for inode allocation is supposed
to consist of the blocks required for the inode chunk plus
(maxlevels-1) of the inode btree multiplied by the number of inode
btrees in the fs (2 when finobt is enabled, 1 otherwise).

Instead, the macro returns (ialloc_blocks + 2) due to a precedence
error in the calculation logic. This leads to block reservation
overruns via generic/531 on small block filesystems with finobt
enabled. Add braces to fix the calculation and reserve the
appropriate number of blocks.

Fixes: 9d43b180af67 ("xfs: update inode allocation/free transaction reservations for finobt")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_space.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 88221c7a04ccf..c6df01a2a1585 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -57,7 +57,7 @@
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
 #define	XFS_IALLOC_SPACE_RES(mp)	\
 	(M_IGEO(mp)->ialloc_blks + \
-	 (xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1 * \
+	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
 	  (M_IGEO(mp)->inobt_maxlevels - 1)))
 
 /*
-- 
2.25.1



