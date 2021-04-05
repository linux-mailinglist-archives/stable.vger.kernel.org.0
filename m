Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243D0354477
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241974AbhDEQFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242199AbhDEQFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BBC9613C9;
        Mon,  5 Apr 2021 16:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638698;
        bh=g9MAv3HrLHNBtDeS5EIkFuSTE/0xOXN77La23FB3nJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rD/u7ZweeFRw5M9Dwe5rV2bym880ubbeSZka35yoEDvRFdGpZMe09FlD6odTWUq2H
         /zRg0EG4cuctH8aH0qWcxlSMp5uD4vZqSnUPJRacV3iHG11XlgZb3nH1bt0SNz97R8
         x0xiJ3bJPIw18dxEvJXbuWeCAvU07OnAiEMxV3esUARblmCuvkySklORXuM6TWw0DN
         o8yeIMoIPIa38LsMKeW207BuJXxSGAkgc4hO5dw8XZ9lE6wxZk38MgOK7TM/W5zMOu
         dC46bT9Sv0DnjD1aaTva1ZBSJtY7PrW+VaeCxSaTBe2MKBm9FZfgK0Y/gpX4/Ng6D5
         VhTU7BW3BkZyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/22] block: don't ignore REQ_NOWAIT for direct IO
Date:   Mon,  5 Apr 2021 12:04:31 -0400
Message-Id: <20210405160432.268374-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160432.268374-1-sashal@kernel.org>
References: <20210405160432.268374-1-sashal@kernel.org>
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
index fe201b757baa..1b6a34fd1fef 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -280,6 +280,8 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 		bio.bi_opf = dio_bio_write_op(iocb);
 		task_io_account_write(ret);
 	}
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		bio.bi_opf |= REQ_NOWAIT;
 	if (iocb->ki_flags & IOCB_HIPRI)
 		bio_set_polled(&bio, iocb);
 
@@ -433,6 +435,8 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 			bio->bi_opf = dio_bio_write_op(iocb);
 			task_io_account_write(bio->bi_iter.bi_size);
 		}
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			bio->bi_opf |= REQ_NOWAIT;
 
 		dio->size += bio->bi_iter.bi_size;
 		pos += bio->bi_iter.bi_size;
-- 
2.30.2

