Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8393C509D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243903AbhGLHdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345409AbhGLH3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B82BF61624;
        Mon, 12 Jul 2021 07:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074781;
        bh=7H3AfD7/a7L0KSYQtxm6avVs+H9jxgWGFAmTGPx1LBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oupmAuHVZOcm5w89ynnLG0foM3yXJdIWIfvaP3HwUQ5s3bY382d33peFYjkFp00Pr
         xB0X7IQmsZY7IqHsfoCDXBklajn5JEXw8bRSmg3afDklj0hdsKcXDaOTH/kK5Te79h
         uehHPP2IZqSQIRam0TRC6vfM/fS94na2D0Ma88rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.12 695/700] io_uring: add IOPOLL and reserved field checks to IORING_OP_RENAMEAT
Date:   Mon, 12 Jul 2021 08:12:58 +0200
Message-Id: <20210712061049.881445152@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit ed7eb2592286ead7d3bfdf8adf65e65392167cc4 upstream.

We can't support IOPOLL with non-pollable request types, and we should
check for unused/reserved fields like we do for other request types.

Fixes: 80a261fd0032 ("io_uring: add support for IORING_OP_RENAMEAT")
Cc: stable@vger.kernel.org
Reported-by: Dmitry Kadashev <dkadashev@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3497,6 +3497,10 @@ static int io_renameat_prep(struct io_ki
 	struct io_rename *ren = &req->rename;
 	const char __user *oldf, *newf;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->buf_index)
+		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 


