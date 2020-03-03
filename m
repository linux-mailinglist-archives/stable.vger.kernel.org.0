Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6E2177EDF
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbgCCRr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:47:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731351AbgCCRr3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:47:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32B3A208C3;
        Tue,  3 Mar 2020 17:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257648;
        bh=+0DCorTTN4tjWO1sG8JADOF2c+tIaEeqv2Mh+42zHBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TpKIjLNGmBHfa6LcDfinnag6Jo4P7P/TnlsJkEzUwmP+xTccwnbs4U5DFM0XD4/T
         uZWMn+VpOT7HlW8nODikc0Q9HvXH1zUARqNq/49ApO3r+ElFh6QSKCDwKWD/C/s3SI
         Gdx7Z2OfZCYmVqybKvGexLG6b3Yaq87iHoeyhlH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 043/176] ceph: do not execute direct write in parallel if O_APPEND is specified
Date:   Tue,  3 Mar 2020 18:41:47 +0100
Message-Id: <20200303174309.514277525@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 8e4473bb50a1796c9c32b244e5dbc5ee24ead937 ]

In O_APPEND & O_DIRECT mode, the data from different writers will
be possibly overlapping each other since they take the shared lock.

For example, both Writer1 and Writer2 are in O_APPEND and O_DIRECT
mode:

          Writer1                         Writer2

     shared_lock()                   shared_lock()
     getattr(CAP_SIZE)               getattr(CAP_SIZE)
     iocb->ki_pos = EOF              iocb->ki_pos = EOF
     write(data1)
                                     write(data2)
     shared_unlock()                 shared_unlock()

The data2 will overlap the data1 from the same file offset, the
old EOF.

Switch to exclusive lock instead when O_APPEND is specified.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/file.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 11929d2bb594c..cd09e63d682b7 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1418,6 +1418,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct ceph_cap_flush *prealloc_cf;
 	ssize_t count, written = 0;
 	int err, want, got;
+	bool direct_lock = false;
 	loff_t pos;
 	loff_t limit = max(i_size_read(inode), fsc->max_file_size);
 
@@ -1428,8 +1429,11 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (!prealloc_cf)
 		return -ENOMEM;
 
+	if ((iocb->ki_flags & (IOCB_DIRECT | IOCB_APPEND)) == IOCB_DIRECT)
+		direct_lock = true;
+
 retry_snap:
-	if (iocb->ki_flags & IOCB_DIRECT)
+	if (direct_lock)
 		ceph_start_io_direct(inode);
 	else
 		ceph_start_io_write(inode);
@@ -1519,14 +1523,15 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 		/* we might need to revert back to that point */
 		data = *from;
-		if (iocb->ki_flags & IOCB_DIRECT) {
+		if (iocb->ki_flags & IOCB_DIRECT)
 			written = ceph_direct_read_write(iocb, &data, snapc,
 							 &prealloc_cf);
-			ceph_end_io_direct(inode);
-		} else {
+		else
 			written = ceph_sync_write(iocb, &data, pos, snapc);
+		if (direct_lock)
+			ceph_end_io_direct(inode);
+		else
 			ceph_end_io_write(inode);
-		}
 		if (written > 0)
 			iov_iter_advance(from, written);
 		ceph_put_snap_context(snapc);
@@ -1577,7 +1582,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	goto out_unlocked;
 out:
-	if (iocb->ki_flags & IOCB_DIRECT)
+	if (direct_lock)
 		ceph_end_io_direct(inode);
 	else
 		ceph_end_io_write(inode);
-- 
2.20.1



