Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0AB913804C
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbgAKK2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:28:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731015AbgAKK2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:28:04 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 665D824649;
        Sat, 11 Jan 2020 10:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738484;
        bh=vzw/zTQ3T+frq0XShFckbtvL19mBCHgNPnD0vRv4qCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBw9RgT3tiPQgCQcKGntkgL32+b+Hg5jRrtPem5WG9vRejq0tyS2b4ZZAl2bGuTZQ
         evlZwshIKPu0TticO9aApqt26MHZzHtuLuh00Msjft/Q6as4iV033H3aIIvWIKDw6B
         KT63fIzLhXqGnl7IPCysShSuid4TSTd6icMEDN1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Penyaev <rpenyaev@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/165] block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT
Date:   Sat, 11 Jan 2020 10:50:22 +0100
Message-Id: <20200111094930.377706110@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Penyaev <rpenyaev@suse.de>

[ Upstream commit c58c1f83436b501d45d4050fd1296d71a9760bcb ]

Non-mq devs do not honor REQ_NOWAIT so give a chance to the caller to repeat
request gracefully on -EAGAIN error.

The problem is well reproduced using io_uring:

   mkfs.ext4 /dev/ram0
   mount /dev/ram0 /mnt

   # Preallocate a file
   dd if=/dev/zero of=/mnt/file bs=1M count=1

   # Start fio with io_uring and get -EIO
   fio --rw=write --ioengine=io_uring --size=1M --direct=1 --name=job --filename=/mnt/file

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d5e668ec751b..1075aaff606d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -886,11 +886,14 @@ generic_make_request_checks(struct bio *bio)
 	}
 
 	/*
-	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
-	 * if queue is not a request based queue.
+	 * Non-mq queues do not honor REQ_NOWAIT, so complete a bio
+	 * with BLK_STS_AGAIN status in order to catch -EAGAIN and
+	 * to give a chance to the caller to repeat request gracefully.
 	 */
-	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
-		goto not_supported;
+	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q)) {
+		status = BLK_STS_AGAIN;
+		goto end_io;
+	}
 
 	if (should_fail_bio(bio))
 		goto end_io;
-- 
2.20.1



