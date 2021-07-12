Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8423C509B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344358AbhGLHdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345414AbhGLH3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D566A614A5;
        Mon, 12 Jul 2021 07:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074784;
        bh=3W871Qfg9H1Bij5bI2sZFMODcqMe4MuXxmNLYwDXHxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNOp75ybx3i42euss1e/ZSWvfujk3j5iwTQUBNiLnOsZk9bs4uXN5zoxgNzS74JPi
         171zxnnKCrWo1QEPprziEkFv1jcdxImj55D7E827Yv/VZJqMtETL9tfnRnmrync1q3
         qEtiEU2j7o+qeF/tBsMHPrxf4y6iIu0PIZxlCXmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.12 696/700] io_uring: add IOPOLL and reserved field checks to IORING_OP_UNLINKAT
Date:   Mon, 12 Jul 2021 08:12:59 +0200
Message-Id: <20210712061049.992994867@linuxfoundation.org>
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
@@ -3548,6 +3548,10 @@ static int io_unlinkat_prep(struct io_ki
 	struct io_unlink *un = &req->unlink;
 	const char __user *fname;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
+		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 


