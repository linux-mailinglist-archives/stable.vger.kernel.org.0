Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75496201340
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392231AbgFSP71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390447AbgFSPTL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:19:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8D8321582;
        Fri, 19 Jun 2020 15:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579950;
        bh=5KjT2Q7sslPxO+QD3x+tYDerEQL9bSgfkWmtLzJrTJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2mCzcThRbZBOZgusM4OUEs3yisoIaj4tccXmbDBU9Z8KG7doC17hmkWlfimz90Kar
         d9K6/q5XwcGGFU2UzBBdMVmFBpvd6XZhiUahTDgPQo4H0yTzexPFfJkaDdTcwzab07
         hpyGV5+96/lMPX/lSkBfd17x7sggsKcpY09XJbJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 048/376] io_uring: cleanup io_poll_remove_one() logic
Date:   Fri, 19 Jun 2020 16:29:26 +0200
Message-Id: <20200619141712.629967948@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 3bfa5bcb26f0b52d7ae8416aa0618fff21aceaaf ]

We only need apoll in the one section, do the juggling with the work
restoration there. This removes a special case further down as well.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f071505e3430..07d9414268f1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4354,32 +4354,31 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 		do_complete = true;
 	}
 	spin_unlock(&poll->head->lock);
+	hash_del(&req->hash_node);
 	return do_complete;
 }
 
 static bool io_poll_remove_one(struct io_kiocb *req)
 {
-	struct async_poll *apoll = NULL;
 	bool do_complete;
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
-		apoll = req->apoll;
+		struct async_poll *apoll = req->apoll;
+
 		/* non-poll requests have submit ref still */
-		do_complete = __io_poll_remove_one(req, &req->apoll->poll);
-		if (do_complete)
+		do_complete = __io_poll_remove_one(req, &apoll->poll);
+		if (do_complete) {
 			io_put_req(req);
-	}
-
-	hash_del(&req->hash_node);
-
-	if (do_complete && apoll) {
-		/*
-		 * restore ->work because we need to call io_req_work_drop_env.
-		 */
-		memcpy(&req->work, &apoll->work, sizeof(req->work));
-		kfree(apoll);
+			/*
+			 * restore ->work because we will call
+			 * io_req_work_drop_env below when dropping the
+			 * final reference.
+			 */
+			memcpy(&req->work, &apoll->work, sizeof(req->work));
+			kfree(apoll);
+		}
 	}
 
 	if (do_complete) {
-- 
2.25.1



