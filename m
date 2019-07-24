Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2AB0745C4
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfGYFqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbfGYFqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:46:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B91FE21850;
        Thu, 25 Jul 2019 05:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033564;
        bh=8vP176BE1QHHUg47JaiFC0gZi7QLD3qCYVXke8Y2W60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ihn/YhybidxNgU10x2wsfBxJhufpuD2dGi6057icI2qrrbYjHyMu1CJ0b5KSb/CV0
         aEEGkQBnil63k4Z1KetuIdc4AZROagBbJ6/1VXF6vsBIuWQVJeCttVrc7xF4JtH7Xf
         Ql+/dWxA2dXE2CqHJlQR8weSripwaw3+el9f96/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 249/271] xfs: serialize unaligned dio writes against all other dio writes
Date:   Wed, 24 Jul 2019 21:21:58 +0200
Message-Id: <20190724191716.531152633@linuxfoundation.org>
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

commit 2032a8a27b5cc0f578d37fa16fa2494b80a0d00a upstream.

XFS applies more strict serialization constraints to unaligned
direct writes to accommodate things like direct I/O layer zeroing,
unwritten extent conversion, etc. Unaligned submissions acquire the
exclusive iolock and wait for in-flight dio to complete to ensure
multiple submissions do not race on the same block and cause data
corruption.

This generally works in the case of an aligned dio followed by an
unaligned dio, but the serialization is lost if I/Os occur in the
opposite order. If an unaligned write is submitted first and
immediately followed by an overlapping, aligned write, the latter
submits without the typical unaligned serialization barriers because
there is no indication of an unaligned dio still in-flight. This can
lead to unpredictable results.

To provide proper unaligned dio serialization, require that such
direct writes are always the only dio allowed in-flight at one time
for a particular inode. We already acquire the exclusive iolock and
drain pending dio before submitting the unaligned dio. Wait once
more after the dio submission to hold the iolock across the I/O and
prevent further submissions until the unaligned I/O completes. This
is heavy handed, but consistent with the current pre-submission
serialization for unaligned direct writes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_file.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 61a5ad2600e8..10f75965243c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -529,18 +529,17 @@ xfs_file_dio_aio_write(
 	count = iov_iter_count(from);
 
 	/*
-	 * If we are doing unaligned IO, wait for all other IO to drain,
-	 * otherwise demote the lock if we had to take the exclusive lock
-	 * for other reasons in xfs_file_aio_write_checks.
+	 * If we are doing unaligned IO, we can't allow any other overlapping IO
+	 * in-flight at the same time or we risk data corruption. Wait for all
+	 * other IO to drain before we submit. If the IO is aligned, demote the
+	 * iolock if we had to take the exclusive lock in
+	 * xfs_file_aio_write_checks() for other reasons.
 	 */
 	if (unaligned_io) {
-		/* If we are going to wait for other DIO to finish, bail */
-		if (iocb->ki_flags & IOCB_NOWAIT) {
-			if (atomic_read(&inode->i_dio_count))
-				return -EAGAIN;
-		} else {
-			inode_dio_wait(inode);
-		}
+		/* unaligned dio always waits, bail */
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+		inode_dio_wait(inode);
 	} else if (iolock == XFS_IOLOCK_EXCL) {
 		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		iolock = XFS_IOLOCK_SHARED;
@@ -548,6 +547,14 @@ xfs_file_dio_aio_write(
 
 	trace_xfs_file_direct_write(ip, count, iocb->ki_pos);
 	ret = iomap_dio_rw(iocb, from, &xfs_iomap_ops, xfs_dio_write_end_io);
+
+	/*
+	 * If unaligned, this is the only IO in-flight. If it has not yet
+	 * completed, wait on it before we release the iolock to prevent
+	 * subsequent overlapping IO.
+	 */
+	if (ret == -EIOCBQUEUED && unaligned_io)
+		inode_dio_wait(inode);
 out:
 	xfs_iunlock(ip, iolock);
 
-- 
2.20.1



