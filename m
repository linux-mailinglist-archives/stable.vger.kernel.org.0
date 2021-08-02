Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32E83DD972
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbhHBOA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234711AbhHBN66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:58:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDA6061100;
        Mon,  2 Aug 2021 13:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912522;
        bh=qoZEr6d8wVYq/9cZ+ZR4orz12XVv40Z+e7Uyce0nzw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUYWeEiVjebsoSPnWO+mZAPabNrt5bmwhQAjUpajqN5wzIzF4fz+jt9OHPtDdm7Bj
         PaUsqKStOmCU7Zn1j9aG1aKrFrufEcEn0jy7FD/RK3xLcWK+koWvnkFJ+eK3rDzaoL
         iyeq95nZERHJK808vrL3zNCwO/OxBzdIAEFK3HzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 031/104] io_uring: fix io_prep_async_link locking
Date:   Mon,  2 Aug 2021 15:44:28 +0200
Message-Id: <20210802134345.042397812@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 44eff40a32e8f5228ae041006352e32638ad2368 upstream.

io_prep_async_link() may be called after arming a linked timeout,
automatically making it unsafe to traverse the linked list. Guard
with completion_lock if there was a linked timeout.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/93f7c617e2b4f012a2a175b3dab6bc2f27cebc48.1627304436.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1258,8 +1258,17 @@ static void io_prep_async_link(struct io
 {
 	struct io_kiocb *cur;
 
-	io_for_each_link(cur, req)
-		io_prep_async_work(cur);
+	if (req->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock_irq(&ctx->completion_lock);
+		io_for_each_link(cur, req)
+			io_prep_async_work(cur);
+		spin_unlock_irq(&ctx->completion_lock);
+	} else {
+		io_for_each_link(cur, req)
+			io_prep_async_work(cur);
+	}
 }
 
 static void io_queue_async_work(struct io_kiocb *req)


