Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DB71F223E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgFHXHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbgFHXHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 087F020890;
        Mon,  8 Jun 2020 23:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657633;
        bh=k4MFnelTjmAk2L09uBdFWuoRP2HDkQ+mXFg2HOps2v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVX7vW6v8iqJHZXuGpNHWmisgS+lZK+pE0vkw0bdXQFEHRcqupt2uddSCKdrVPyW/
         ex+aQmT6zIWtND/cBUF59+mu/AdVuYOMGmI3l6h9E191O4GHMOuUvNlYgftvvUrRiX
         DsGnaG1rT8mAbjquRTrnbbKfUo29RvWD9Ky7Oyrc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 052/274] io_uring: cleanup io_poll_remove_one() logic
Date:   Mon,  8 Jun 2020 19:02:25 -0400
Message-Id: <20200608230607.3361041-52-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index bb25e3997d41..03147b6694fd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4344,32 +4344,31 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
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

