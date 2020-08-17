Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07F1246BA4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbgHQP7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:59:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730973AbgHQP7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:59:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 155B92072E;
        Mon, 17 Aug 2020 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679974;
        bh=jKOfGDb+Ma2P/IuavrLaR/NvUHLaZJplk3hkOcRTXkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNHKEOzKlYGEefmbYlKpCxcu5BN7TLapSyx7//HN9/O5P+APtdYbprmH2EpLdlRcM
         dkWnaZNK/cWfOZ87gtg4q06GShqLlV1WHPcr4DTMwzXJr17lYBzuJYgTnpGHtoEJ7s
         i5wK5KvRAK9JNOEYTzgidj8AHCu2VWiTNK/KFuMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 391/393] io_uring: add missing REQ_F_COMP_LOCKED for nested requests
Date:   Mon, 17 Aug 2020 17:17:21 +0200
Message-Id: <20200817143838.563246519@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 9b7adba9eaec28e0e4343c96d0dbeb9578802f5f upstream.

When we traverse into failing links or timeouts, we need to ensure we
propagate the REQ_F_COMP_LOCKED flag to ensure that we correctly signal
to the completion side that we already hold the completion lock.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/io_uring.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1484,12 +1484,9 @@ static void io_req_link_next(struct io_k
 /*
  * Called if REQ_F_LINK_HEAD is set, and we fail the head request
  */
-static void io_fail_links(struct io_kiocb *req)
+static void __io_fail_links(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->completion_lock, flags);
 
 	while (!list_empty(&req->link_list)) {
 		struct io_kiocb *link = list_first_entry(&req->link_list,
@@ -1503,13 +1500,29 @@ static void io_fail_links(struct io_kioc
 			io_link_cancel_timeout(link);
 		} else {
 			io_cqring_fill_event(link, -ECANCELED);
+			link->flags |= REQ_F_COMP_LOCKED;
 			__io_double_put_req(link);
 		}
 		req->flags &= ~REQ_F_LINK_TIMEOUT;
 	}
 
 	io_commit_cqring(ctx);
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+}
+
+static void io_fail_links(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!(req->flags & REQ_F_COMP_LOCKED)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->completion_lock, flags);
+		__io_fail_links(req);
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	} else {
+		__io_fail_links(req);
+	}
+
 	io_cqring_ev_posted(ctx);
 }
 
@@ -4828,6 +4841,7 @@ static int io_timeout_cancel(struct io_r
 		return -EALREADY;
 
 	req_set_fail_links(req);
+	req->flags |= REQ_F_COMP_LOCKED;
 	io_cqring_fill_event(req, -ECANCELED);
 	io_put_req(req);
 	return 0;


