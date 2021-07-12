Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C149A3C55F0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350707AbhGLIMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354094AbhGLID2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F07666124C;
        Mon, 12 Jul 2021 08:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076806;
        bh=TGBdE+wFKIdiSwEYjSLMiEsncMHma1044xBauCEov0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YUt4VURy6PevIaT2aR/UTlZm8gvvEkK32bkF9Rxt1U2IpmABmV85ycpkwP3CIRyK
         RoHMQ71qqwyYMCDiZeTV5Tnu3oCOKRtSx25ywobw82EkXEbS0Q3oAKF1Jb+2p7qc2k
         pHoOSK69ByTTMjjkjSTvclrbz7IAtwLI1bbnT9SY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 795/800] io_uring: add IOPOLL and reserved field checks to IORING_OP_RENAMEAT
Date:   Mon, 12 Jul 2021 08:13:38 +0200
Message-Id: <20210712061051.249530228@linuxfoundation.org>
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
@@ -3453,6 +3453,10 @@ static int io_renameat_prep(struct io_ki
 	struct io_rename *ren = &req->rename;
 	const char __user *oldf, *newf;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->buf_index)
+		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 


