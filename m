Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B7273C71
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405331AbfGXUBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405328AbfGXUBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:01:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 921D9205C9;
        Wed, 24 Jul 2019 20:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998464;
        bh=KO1mmfrXB/4Qi6kQgaa12CkoQHiEMULINy7lqSaWw2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbrbQmZPxJEHNQC0+bducLxv9X5adm2K4mWHN0sO11NSMj3S5tfXgsv+8fg3RwSgF
         p5hW7We75zU1/p+LEo7hP+ODIho1C7ujienEP7Dnl4EvBl6hbYi6wTGLbwVl9T1Ifw
         QyLpb2LLVaIUsu5fV02QmMuCBEXpmId/yZFYAtJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 345/371] xfs: abort unaligned nowait directio early
Date:   Wed, 24 Jul 2019 21:21:37 +0200
Message-Id: <20190724191749.638151167@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1fdeaea4d92c69fb9f871a787af6ad00f32eeea7 ]

Dave Chinner noticed that xfs_file_dio_aio_write returns EAGAIN without
dropping the IOLOCK when its deciding not to wait, which means that we
leak the IOLOCK there.  Since we now make unaligned directio always
wait, we have the opportunity to bail out before trying to take the
lock, which should reduce the overhead of this never-gonna-work case
considerably while also solving the dropped lock problem.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a7ceae90110e..76748255f843 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -517,6 +517,9 @@ xfs_file_dio_aio_write(
 	}
 
 	if (iocb->ki_flags & IOCB_NOWAIT) {
+		/* unaligned dio always waits, bail */
+		if (unaligned_io)
+			return -EAGAIN;
 		if (!xfs_ilock_nowait(ip, iolock))
 			return -EAGAIN;
 	} else {
@@ -536,9 +539,6 @@ xfs_file_dio_aio_write(
 	 * xfs_file_aio_write_checks() for other reasons.
 	 */
 	if (unaligned_io) {
-		/* unaligned dio always waits, bail */
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			return -EAGAIN;
 		inode_dio_wait(inode);
 	} else if (iolock == XFS_IOLOCK_EXCL) {
 		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
-- 
2.20.1



