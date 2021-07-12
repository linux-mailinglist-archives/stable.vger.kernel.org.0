Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A393C55F7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350929AbhGLIMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354097AbhGLID3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BF5761222;
        Mon, 12 Jul 2021 08:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076808;
        bh=MIgoSWhJcPPgyL3J/925B84nhjnYx+zQ3C3809V7nio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddDxNWNWkV2tkZsS0SdlcS9hUQrVlWjZi0wrT/YXDmetBaVJbBTiD25A0VPQQotWt
         Ry0wmm6ppZ/ehDDDjmH09+oVftYWlqvmPYvT7KQLbS5Mi0Y2aLBF3V+NyMNPYLCGEn
         mBADweNf8xPKS6hT8N49SGwQ2MoQPGTY6ZEW4dvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 796/800] io_uring: add IOPOLL and reserved field checks to IORING_OP_UNLINKAT
Date:   Mon, 12 Jul 2021 08:13:39 +0200
Message-Id: <20210712061051.336381638@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 22634bc5620d29765e5199c7b230a372c7ddcda2 upstream.

We can't support IOPOLL with non-pollable request types, and we should
check for unused/reserved fields like we do for other request types.

Fixes: 14a1143b68ee ("io_uring: add support for IORING_OP_UNLINKAT")
Cc: stable@vger.kernel.org
Reported-by: Dmitry Kadashev <dkadashev@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3504,6 +3504,10 @@ static int io_unlinkat_prep(struct io_ki
 	struct io_unlink *un = &req->unlink;
 	const char __user *fname;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
+		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 


