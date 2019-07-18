Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114A56D71D
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 01:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391713AbfGRXGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 19:06:33 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39194 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 19:06:33 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so14647218pls.6;
        Thu, 18 Jul 2019 16:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yEc9XLZPW7y6dr82LLDI0BVN3EGK1CtlYHnQMwvR/xs=;
        b=j1gHkBMW2emt2yau+2Cd52gpku3AKyBJgVlbW+SfrWbiw2L7wQcsqMf3eTQbDwgG1b
         jioinZ1nNMhp6xEdLlp9HmONn/NLWAouVbX0RKYEUBHr0/ZySChg/Z1y+nkUFAAM/+Mr
         KMgoDtrYleEKKTdxV2REL9lEyp9ptZF0udbqfuMS8CG5wRMkPpYX9p6pNYQiwO1aJw0G
         0CycLOMvA2m2qT8lQvGZtxGFUcLqct0rfoB3xeVaYENpugAv1ZBeDJp6w221D4fumJ/A
         9e57vyrwMPkW/fgphUBl4DUplMnk5iBy1fNkQZ40s9KQxUs+m9IrX3R/KW56twViJklU
         Xg0g==
X-Gm-Message-State: APjAAAUqBNT4FTo0uAeHw1zhklNGEyZpe4I527XdOdMMcZxvH/slZsTw
        s8qxavI7SW8eaEjR5Rcikxo=
X-Google-Smtp-Source: APXvYqzj57MLo9ebDpmD8MlccPKNlbWl23I3IRQrLAZkxs9SchXEZ8xKnZlZK6Zy9R4XYjn1sknv6g==
X-Received: by 2002:a17:902:be0a:: with SMTP id r10mr50064457pls.51.1563491192146;
        Thu, 18 Jul 2019 16:06:32 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id d14sm37989935pfo.154.2019.07.18.16.06.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 16:06:26 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 704E941405; Thu, 18 Jul 2019 23:06:19 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, Brian Foster <bfoster@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 8/9] xfs: serialize unaligned dio writes against all other dio writes
Date:   Thu, 18 Jul 2019 23:06:16 +0000
Message-Id: <20190718230617.7439-9-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

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

