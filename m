Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381BD2B6159
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgKQNS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730107AbgKQNSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:18:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5523241A5;
        Tue, 17 Nov 2020 13:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619086;
        bh=++HxS3+p8gG6RTXrNM7OCmaJlpeTrw2wJbrK08BS/PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2XSJsoNDmtFHWeh+0ZmMCzd//XG78onDMeb8YONNspZg3DK/OdPnQ+sMwFLgdNNr
         MAUWPK0RC1ickNM+G72TUuoCqL85uih3v8h/YvDyE2c4lvi0DnWJWJwIwet6e9d4/X
         eRChoXvZX6ijg5uf1niVkQ02HSCvAeQoYYebG5MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 024/101] xfs: fix scrub flagging rtinherit even if there is no rt device
Date:   Tue, 17 Nov 2020 14:04:51 +0100
Message-Id: <20201117122114.266213618@linuxfoundation.org>
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

[ Upstream commit c1f6b1ac00756a7108e5fcb849a2f8230c0b62a5 ]

The kernel has always allowed directories to have the rtinherit flag
set, even if there is no rt device, so this check is wrong.

Fixes: 80e4e1268802 ("xfs: scrub inodes")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index e386c9b0b4ab7..8d45d60832db9 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -131,8 +131,7 @@ xchk_inode_flags(
 		goto bad;
 
 	/* rt flags require rt device */
-	if ((flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) &&
-	    !mp->m_rtdev_targp)
+	if ((flags & XFS_DIFLAG_REALTIME) && !mp->m_rtdev_targp)
 		goto bad;
 
 	/* new rt bitmap flag only valid for rbmino */
-- 
2.27.0



