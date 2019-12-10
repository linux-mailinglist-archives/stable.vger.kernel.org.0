Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17DA119627
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbfLJVKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:10:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728559AbfLJVKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E07C246AA;
        Tue, 10 Dec 2019 21:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012238;
        bh=3Z/XIlAMV+/P+PxlAmNUW1N+KDG8KPyfiDrz1y3b0Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zSgCRdsCmtBgxwSuN7pbf1FNtSePXx/cF2o5SiuvaFevamK+Pv1XI2BJeGKS8Kb4
         UM30mGWbMUDr9ljIuNX8aOsuvvXFTTRiecE34d00lRJbL3lLIFTJuGKk0gT/sarU2v
         sQ7uaI3AHlbeAgpWSpIXCIpmR2fgrPWH0vv2iw/E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 187/350] loop: fix no-unmap write-zeroes request behavior
Date:   Tue, 10 Dec 2019 16:04:52 -0500
Message-Id: <20191210210735.9077-148-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit efcfec579f6139528c9e6925eca2bc4a36da65c6 ]

Currently, if the loop device receives a WRITE_ZEROES request, it asks
the underlying filesystem to punch out the range.  This behavior is
correct if unmapping is allowed.  However, a NOUNMAP request means that
the caller doesn't want us to free the storage backing the range, so
punching out the range is incorrect behavior.

To satisfy a NOUNMAP | WRITE_ZEROES request, loop should ask the
underlying filesystem to FALLOC_FL_ZERO_RANGE, which is (according to
the fallocate documentation) required to ensure that the entire range is
backed by real storage, which suffices for our purposes.

Fixes: 19372e2769179dd ("loop: implement REQ_OP_WRITE_ZEROES")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index f6f77eaa7217e..ef6e251857c8c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -417,18 +417,20 @@ static int lo_read_transfer(struct loop_device *lo, struct request *rq,
 	return ret;
 }
 
-static int lo_discard(struct loop_device *lo, struct request *rq, loff_t pos)
+static int lo_fallocate(struct loop_device *lo, struct request *rq, loff_t pos,
+			int mode)
 {
 	/*
-	 * We use punch hole to reclaim the free space used by the
-	 * image a.k.a. discard. However we do not support discard if
-	 * encryption is enabled, because it may give an attacker
-	 * useful information.
+	 * We use fallocate to manipulate the space mappings used by the image
+	 * a.k.a. discard/zerorange. However we do not support this if
+	 * encryption is enabled, because it may give an attacker useful
+	 * information.
 	 */
 	struct file *file = lo->lo_backing_file;
-	int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 	int ret;
 
+	mode |= FALLOC_FL_KEEP_SIZE;
+
 	if ((!file->f_op->fallocate) || lo->lo_encrypt_key_size) {
 		ret = -EOPNOTSUPP;
 		goto out;
@@ -596,9 +598,17 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 	switch (req_op(rq)) {
 	case REQ_OP_FLUSH:
 		return lo_req_flush(lo, rq);
-	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
-		return lo_discard(lo, rq, pos);
+		/*
+		 * If the caller doesn't want deallocation, call zeroout to
+		 * write zeroes the range.  Otherwise, punch them out.
+		 */
+		return lo_fallocate(lo, rq, pos,
+			(rq->cmd_flags & REQ_NOUNMAP) ?
+				FALLOC_FL_ZERO_RANGE :
+				FALLOC_FL_PUNCH_HOLE);
+	case REQ_OP_DISCARD:
+		return lo_fallocate(lo, rq, pos, FALLOC_FL_PUNCH_HOLE);
 	case REQ_OP_WRITE:
 		if (lo->transfer)
 			return lo_write_transfer(lo, rq, pos);
-- 
2.20.1

