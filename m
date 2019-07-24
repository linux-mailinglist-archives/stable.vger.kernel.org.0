Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C30D8745C6
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfGYFqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:46:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbfGYFqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:46:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5457021880;
        Thu, 25 Jul 2019 05:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033566;
        bh=b2UBcwkfIU2ZO7dtFRhcgHXFH5JZVsiLzCQVo4m4NaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhKkKATFv07TICJG8wUFdrHLMzmkPnQEPSmBRtOFoXfOIOaZ0yYsndZBRtiLG4lcJ
         mQKeIS0c72PaymRdU7H++oVo/ddfSyJaj4s4MpgMFckLLecjUBuVQURJ23NtBPLb5L
         2QDZWn+ZwNDOZkQel7Ot71XOCbKoUx98n2WwE9m0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 250/271] xfs: abort unaligned nowait directio early
Date:   Wed, 24 Jul 2019 21:21:59 +0200
Message-Id: <20190724191716.606604161@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1fdeaea4d92c69fb9f871a787af6ad00f32eeea7 upstream.

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
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 10f75965243c..259549698ba7 100644
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



