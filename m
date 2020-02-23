Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C22B169524
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgBWCVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:21:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbgBWCVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:21:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CF8C208C3;
        Sun, 23 Feb 2020 02:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424504;
        bh=+0DCorTTN4tjWO1sG8JADOF2c+tIaEeqv2Mh+42zHBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxA18fuBodYKiu3El6YEdKUjCg7J4cbCvXLlNqNL4a+E5eR1R6qy/K1MefShIpyn0
         pc/fBvs3TaoQNQmuG6dlxg049tnZSNQZlqGVd1SqjIbUbdynz9DWwMVBo+qzhmHoE/
         oxviOgk+UFL1PrHiNKt5swj/YXu6ePyRV/LflQHA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 20/58] ceph: do not execute direct write in parallel if O_APPEND is specified
Date:   Sat, 22 Feb 2020 21:20:41 -0500
Message-Id: <20200223022119.707-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

