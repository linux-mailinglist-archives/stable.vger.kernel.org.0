Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7074C190FC6
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgCXNXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729197AbgCXNW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:22:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5810F20870;
        Tue, 24 Mar 2020 13:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056177;
        bh=mlERIezMSUR87vZkqlbgJBYeiGBo6RjW0u8RV2Ki8Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZ6H9FeFEzdaV3Q0YaL26hxBZlbXfGQR3TVTeCXcFujKiLgze+F86M11O8bckEqVH
         gF/orDfYKQ3Mlh5b2dpxwEIzYImalCkPXS6to5ftGnxBBh6nbIgHMNVYpQovdMViXu
         3f96cO7n/NuqrVSktCTMDCf1uGkHrNp6gba3cnjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 039/119] io_uring: fix lockup with timeouts
Date:   Tue, 24 Mar 2020 14:10:24 +0100
Message-Id: <20200324130812.288225410@linuxfoundation.org>
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

[ Upstream commit f0e20b8943509d81200cef5e30af2adfddba0f5c ]

There is a recipe to deadlock the kernel: submit a timeout sqe with a
linked_timeout (e.g.  test_single_link_timeout_ception() from liburing),
and SIGKILL the process.

Then, io_kill_timeouts() takes @ctx->completion_lock, but the timeout
isn't flagged with REQ_F_COMP_LOCKED, and will try to double grab it
during io_put_free() to cancel the linked timeout. Probably, the same
can happen with another io_kill_timeout() call site, that is
io_commit_cqring().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2547c6395d5e4..44ae2641b4b06 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -688,6 +688,7 @@ static void io_kill_timeout(struct io_kiocb *req)
 	if (ret != -1) {
 		atomic_inc(&req->ctx->cq_timeouts);
 		list_del_init(&req->list);
+		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, 0);
 		io_put_req(req);
 	}
-- 
2.20.1



