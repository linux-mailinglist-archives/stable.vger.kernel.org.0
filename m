Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB2C2011D4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405229AbgFSPpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393519AbgFSP1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:27:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A5D520734;
        Fri, 19 Jun 2020 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580421;
        bh=sUAeO8rbA0N30Grcc1+ej5kBzyS6iBFuX9rKypyt0+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kiioj7lSBKS1pJ1kVh3o+owwHqdEdn4G7X/ys0Ni2nLrv6ObH9fR0CqAR7GIwCfwD
         JAU4j5AE+sS9SVrMwexzEhU+pdyClw23Q9fmEA+7zo0kHuVjHj3Ts+awsfUTPMSYEm
         x/a72UnfxvySCx9RF8o/eTcSX0XurYXaQdVALWzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 241/376] io_uring: fix overflowed reqs cancellation
Date:   Fri, 19 Jun 2020 16:32:39 +0200
Message-Id: <20200619141721.739474082@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 7b53d59859bc932b37895d2d37388e7fa29af7a5 ]

Overflowed requests in io_uring_cancel_files() should be shed only of
inflight and overflowed refs. All other left references are owned by
someone else.

If refcount_sub_and_test() fails, it will go further and put put extra
ref, don't do that. Also, don't need to do io_wq_cancel_work()
for overflowed reqs, they will be let go shortly anyway.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2d5f81a1bf9c..2698e9b08490 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7477,10 +7477,11 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				finish_wait(&ctx->inflight_wait, &wait);
 				continue;
 			}
+		} else {
+			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
+			io_put_req(cancel_req);
 		}
 
-		io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
-		io_put_req(cancel_req);
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
-- 
2.25.1



