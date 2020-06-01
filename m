Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25AA1EAD5E
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgFASo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730959AbgFASKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:10:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C8032068D;
        Mon,  1 Jun 2020 18:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035006;
        bh=jNDYEjGX5dcj38Vs0IdUJol9ZXOahXz5X18qV3qqY4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzDFYvLLC+H0AUgKWFae4ivV0eEUkvOmpvNKAU28ARrpfa7kNS2bErbUrOze7zYRZ
         WEwkidTdszMGabusOVX4yHnNlZigSftiIuSGkCcuBTugh5u2l103jrk/xDgfiBqugK
         dgYPr11ry7Z8qj/2bu92DJt0hOn70WtcDcITlDt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/142] Revert "block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT"
Date:   Mon,  1 Jun 2020 19:54:21 +0200
Message-Id: <20200601174048.647302799@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e ]

This reverts commit c58c1f83436b501d45d4050fd1296d71a9760bcb.

io_uring does do the right thing for this case, and we're still returning
-EAGAIN to userspace for the cases we don't support. Revert this change
to avoid doing endless spins of resubmits.

Cc: stable@vger.kernel.org # v5.6
Reported-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1075aaff606d..d5e668ec751b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -886,14 +886,11 @@ generic_make_request_checks(struct bio *bio)
 	}
 
 	/*
-	 * Non-mq queues do not honor REQ_NOWAIT, so complete a bio
-	 * with BLK_STS_AGAIN status in order to catch -EAGAIN and
-	 * to give a chance to the caller to repeat request gracefully.
+	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
+	 * if queue is not a request based queue.
 	 */
-	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q)) {
-		status = BLK_STS_AGAIN;
-		goto end_io;
-	}
+	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
+		goto not_supported;
 
 	if (should_fail_bio(bio))
 		goto end_io;
-- 
2.25.1



