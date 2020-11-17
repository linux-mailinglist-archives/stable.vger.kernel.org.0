Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A332B6301
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732143AbgKQNeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:34:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732138AbgKQNeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF5B9207BC;
        Tue, 17 Nov 2020 13:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620046;
        bh=icsVlTOXLNN+criObkESs5KjI6CTJWsp8/wy9bJPGe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqJLq+FCa3MLln3cqNldWN80fwX+iza6TQUN3d/WOks76/puCLuomvFXX1ek1mY6J
         RsYb3x8EKRTgrRE8bHXMXRiEjetHjXBw66lBVrlHMKIQl/5BBtvI7lshahrDiKe5zn
         fAVFlGPdC+QWqXPcPBhHkxaJ2P/4ewnBVH08FLtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 060/255] xfs: fix scrub flagging rtinherit even if there is no rt device
Date:   Tue, 17 Nov 2020 14:03:20 +0100
Message-Id: <20201117122141.874527404@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
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
index 6d483ab29e639..1bea029b634a6 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -121,8 +121,7 @@ xchk_inode_flags(
 		goto bad;
 
 	/* rt flags require rt device */
-	if ((flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) &&
-	    !mp->m_rtdev_targp)
+	if ((flags & XFS_DIFLAG_REALTIME) && !mp->m_rtdev_targp)
 		goto bad;
 
 	/* new rt bitmap flag only valid for rbmino */
-- 
2.27.0



