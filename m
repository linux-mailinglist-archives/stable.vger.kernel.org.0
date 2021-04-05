Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C6F35449D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbhDEQFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238653AbhDEQFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B798C613E1;
        Mon,  5 Apr 2021 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638714;
        bh=S+LoKKB/P34fdLHzMLjqD/VG/Ol7NcL66qYaVLSZE38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfnUMFn5qCVbj2uF/vvBxBKW8awTDhUdUx0X+DzEVwMdBBIhF+z2hqQ8xOF+L/Xmd
         4pBG4YLdqkVdlE4WbvSeKgmls4UHYEtduHLpHMbGFYZPFSUQjRAhww1yQQwfc79bcv
         NDksTnamk3FjzypsoRkPRt3vusU3nhagZrT1UCWp54WAP/bPrUpLmAb2NkMKe7kT8J
         nqJyHV+Swwl3gC5N8PJCEuC8SpPzDDrxIi25N+CQ9qf7lE65XIEKH/6gVQKirBHvIc
         YRKrLdbdCwE5rT57gDfuYU64zCtQDP8Khe2QIuQRptZXwnbS263d9BDFniGuM+E4ap
         CB4DI1eczQzmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/13] block: don't ignore REQ_NOWAIT for direct IO
Date:   Mon,  5 Apr 2021 12:04:58 -0400
Message-Id: <20210405160459.268794-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160459.268794-1-sashal@kernel.org>
References: <20210405160459.268794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit f8b78caf21d5bc3fcfc40c18898f9d52ed1451a5 ]

If IOCB_NOWAIT is set on submission, then that needs to get propagated to
REQ_NOWAIT on the block side. Otherwise we completely lose this
information, and any issuer of IOCB_NOWAIT IO will potentially end up
blocking on eg request allocation on the storage side.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/block_dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 79272cdbe827..bd93563477a4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -246,6 +246,8 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 		bio.bi_opf = dio_bio_write_op(iocb);
 		task_io_account_write(ret);
 	}
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		bio.bi_opf |= REQ_NOWAIT;
 	if (iocb->ki_flags & IOCB_HIPRI)
 		bio_set_polled(&bio, iocb);
 
@@ -399,6 +401,8 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 			bio->bi_opf = dio_bio_write_op(iocb);
 			task_io_account_write(bio->bi_iter.bi_size);
 		}
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			bio->bi_opf |= REQ_NOWAIT;
 
 		dio->size += bio->bi_iter.bi_size;
 		pos += bio->bi_iter.bi_size;
-- 
2.30.2

