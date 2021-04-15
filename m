Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BD4360DB4
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbhDOPF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234199AbhDOPBb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:01:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42FB5613B7;
        Thu, 15 Apr 2021 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498652;
        bh=heNJQ70uqvCspaLjMHfrojQJ1lC0s3guDaOnbcptdXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSaUHzfFvi2j/iVQopJ7WSX0QYUCtik8pXym50pEQAmr3URPiW95OGWUYyLkdu5yo
         ahrWZn2GR7J5xm+wGzvh1cV3fvcboUPfxDj0j2JdUmJ+7izTcQovg+VHZpLtWK4HPn
         to1ThslsDz4HSEoUr3//5Q7tB+vVGQpVmcNt2IEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/25] block: dont ignore REQ_NOWAIT for direct IO
Date:   Thu, 15 Apr 2021 16:48:14 +0200
Message-Id: <20210415144413.791984438@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
References: <20210415144413.165663182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6516051807b8..718533f0fb90 100644
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



