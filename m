Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E2612F134
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgABWPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:15:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbgABWPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:15:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42D2D2253D;
        Thu,  2 Jan 2020 22:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003320;
        bh=bf552ruxuUI7QMhE+xOcCycft/fZFhLHYKX/xrzuPmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0poRwovI7Yk+FB+le99PAE/5iGkyNaerp0d1Gqc4zcaRPGZYDKanwZtiTS7DJZa+
         gRaOGvvqp3jqnuBuSEqIYevLT1eiX4G/wMeXHYNdJcMYwe+roodHWU2rxFF6FOek5m
         2oMJR1jfcJF1viz5AeBE5bwIMvT3jinfQLdjBrSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0d818c0d39399188f393@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/191] io_uring: io_allocate_scq_urings() should return a sane state
Date:   Thu,  2 Jan 2020 23:06:33 +0100
Message-Id: <20200102215841.790190941@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit eb065d301e8c83643367bdb0898becc364046bda ]

We currently rely on the ring destroy on cleaning things up in case of
failure, but io_allocate_scq_urings() can leave things half initialized
if only parts of it fails.

Be nice and return with either everything setup in success, or return an
error with things nicely cleaned up.

Reported-by: syzbot+0d818c0d39399188f393@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a340147387ec..74e786578c77 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3773,12 +3773,18 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	ctx->cq_entries = rings->cq_ring_entries;
 
 	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
-	if (size == SIZE_MAX)
+	if (size == SIZE_MAX) {
+		io_mem_free(ctx->rings);
+		ctx->rings = NULL;
 		return -EOVERFLOW;
+	}
 
 	ctx->sq_sqes = io_mem_alloc(size);
-	if (!ctx->sq_sqes)
+	if (!ctx->sq_sqes) {
+		io_mem_free(ctx->rings);
+		ctx->rings = NULL;
 		return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
2.20.1



