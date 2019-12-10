Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2527C119AD9
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbfLJWEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:04:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbfLJWEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:04:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4351320637;
        Tue, 10 Dec 2019 22:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015462;
        bh=Hh3R6bgpfIqgBXr1M5YNdXh6HBN0Bb9I12xn+qgoj1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBRC8/FxQ58Q5G6gr0zfw5XWravlGSKul8R+bo7ecgM8p5TegAEqtTIKwapEG4GpG
         RTdrXFBgLmfzrnhhL4YvOufIBerpw80+ZwX+RQrvHePoZgVZo7Nh/I2fA33g7qHT+o
         X8SLhuY8t7WyiPbHov1Ub/tsQBcfiTT0jmIIV5W8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 068/130] loop: fix no-unmap write-zeroes request behavior
Date:   Tue, 10 Dec 2019 17:01:59 -0500
Message-Id: <20191210220301.13262-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
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
index ec61dd873c93d..453e3728e6573 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -414,18 +414,20 @@ static int lo_read_transfer(struct loop_device *lo, struct request *rq,
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
@@ -565,9 +567,17 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
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

