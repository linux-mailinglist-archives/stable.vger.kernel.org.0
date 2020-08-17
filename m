Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2329E2476E0
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbgHQTmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbgHQPY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:24:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F7723719;
        Mon, 17 Aug 2020 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677866;
        bh=kj5QzK2QJ5tDlUU1DjpaLCU+najP8yUzh2g6eZosa5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i992kPiar466vW5AhEMQv7ykkZo3pcF9GjP+n++qrIYs4OpIKwhiu+AdeqNCVadtK
         8sIy9YhAN7Fh4nf7uDZsLnDUFpad3lXzcUfz/BuUnhtOHDc+LdCqZqvFdbry3dJNC7
         +XDpKDD0TL1cn13YrUVvBuFRglqFv8oSLMwDJiZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 137/464] io_uring: fix stalled deferred requests
Date:   Mon, 17 Aug 2020 17:11:30 +0200
Message-Id: <20200817143840.378805823@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit dd9dfcdf5a603680458f5e7b0d2273c66e5417db ]

Always do io_commit_cqring() after completing a request, even if it was
accounted as overflowed on the CQ side. Failing to do that may lead to
not to pushing deferred requests when needed, and so stalling the whole
ring.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1d8761a9f3b88..1619ca74b44d9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7538,6 +7538,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			}
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
+			io_commit_cqring(ctx);
 			spin_unlock_irq(&ctx->completion_lock);
 
 			/*
-- 
2.25.1



