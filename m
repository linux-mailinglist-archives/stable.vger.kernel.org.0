Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E3A2B621B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbgKQNZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730802AbgKQNZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:25:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 367222464E;
        Tue, 17 Nov 2020 13:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619523;
        bh=icsVlTOXLNN+criObkESs5KjI6CTJWsp8/wy9bJPGe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p13wen/qR+WLTzBRjnQu0Jw1bS+8YTerql9TcSiU0tTcuzu6h637Oj19NKFRQaIM7
         hTtfzGQczpeCbHuGipQVcmDn0xFkh5MfZvSzXa5gNy8HPbFTl7JtRhMYaXJ8mxOqQC
         2scJ4XVj2eY4aRFXtBuciil79x+w3HW8oCHLA0x0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/151] xfs: fix scrub flagging rtinherit even if there is no rt device
Date:   Tue, 17 Nov 2020 14:04:30 +0100
Message-Id: <20201117122123.369889021@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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



