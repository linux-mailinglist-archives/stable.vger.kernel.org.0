Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78C0191037
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgCXN0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729352AbgCXN0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:26:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1C8F20775;
        Tue, 24 Mar 2020 13:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056382;
        bh=YShN1UnADfwx6Zz25QADbRq6IpQPrZszv6+8irAYcyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0LdIkAMfiIeDgu3ErUH6V81WfnlaoInhjoyCW6KYZL7xZKELc88EiXOaPLACQrsoK
         Taf9Kn1nJu1ImOUz4OTrMtN49E346caNXSFN3rvRohjBPKfck0wJuOcvMZS5r4S/K0
         dsgXn39QWg1Fm9Os+Brs3QtK+2A69W59RzdWcje8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 102/119] io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}
Date:   Tue, 24 Mar 2020 14:11:27 +0100
Message-Id: <20200324130818.224608235@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit f1d96a8fcbbbb22d4fbc1d69eaaa678bbb0ff6e2 ]

Processing links, io_submit_sqe() prepares requests, drops sqes, and
passes them with sqe=NULL to io_queue_sqe(). There IOSQE_DRAIN and/or
IOSQE_ASYNC requests will go through the same prep, which doesn't expect
sqe=NULL and fail with NULL pointer deference.

Always do full prepare including io_alloc_async_ctx() for linked
requests, and then it can skip the second preparation.

Cc: stable@vger.kernel.org # 5.5
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 44ae2641b4b06..faa0198c99ffd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3098,6 +3098,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 {
 	ssize_t ret = 0;
 
+	if (!sqe)
+		return 0;
+
 	switch (req->opcode) {
 	case IORING_OP_NOP:
 		break;
@@ -3681,6 +3684,11 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			req->flags |= REQ_F_HARDLINK;
 
 		INIT_LIST_HEAD(&req->link_list);
+
+		if (io_alloc_async_ctx(req)) {
+			ret = -EAGAIN;
+			goto err_req;
+		}
 		ret = io_req_defer_prep(req, sqe);
 		if (ret)
 			req->flags |= REQ_F_FAIL_LINK;
-- 
2.20.1



