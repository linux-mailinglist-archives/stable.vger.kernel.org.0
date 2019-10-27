Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66534E6815
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732748AbfJ0VZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732745AbfJ0VZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:29 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8018A21850;
        Sun, 27 Oct 2019 21:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211529;
        bh=ti2/6AttwyI/CUbzp9Nn0c4NFrp3fhY5UsaMZgfOQDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGkeeb7Yekds7MLDLBtykcbVKQBgxN1ETDC52EwQaTFeZCHTsBSG6AlqJVbudeNvI
         tVW9UgQT7M2CdLoVaF7AFDExjK4JkivUXK3U2UnfnQm8sLtdRMjJbD4/qSWXfKwjbe
         r4kkvGP8THx41++6jjSlD+4jJtwiV6P2cP4mtWlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 139/197] io_uring: Fix race for sqes with userspace
Date:   Sun, 27 Oct 2019 22:00:57 +0100
Message-Id: <20191027203359.214148601@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 935d1e45908afb8853c497f2c2bbbb685dec51dc ]

io_ring_submit() finalises with
1. io_commit_sqring(), which releases sqes to the userspace
2. Then calls to io_queue_link_head(), accessing released head's sqe

Reorder them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 518042cc6628b..d447f43d64a24 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2488,13 +2488,14 @@ static int io_ring_submit(struct io_ring_ctx *ctx, unsigned int to_submit)
 		submit++;
 		io_submit_sqe(ctx, &s, statep, &link);
 	}
-	io_commit_sqring(ctx);
 
 	if (link)
 		io_queue_sqe(ctx, link, &link->submit);
 	if (statep)
 		io_submit_state_end(statep);
 
+	io_commit_sqring(ctx);
+
 	return submit;
 }
 
-- 
2.20.1



