Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99BFE18632F
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbgCPClG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729632AbgCPCds (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:33:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE76C20746;
        Mon, 16 Mar 2020 02:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326027;
        bh=6h5MTVyaKyz4i4lsW9DXrzFXoUBWZQhfBhzWyfVeCLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URk591NVGcVyVwEB0aUr5wl0htT9LUfliNxr4ZJX46qkJGXvRS3CAVzFdFiS5hPL3
         pGbzmHH1BsnLNG79Spp/wWL/i2D5IcKBu23kBiSKwnj6TTbn3L4m+y77h5KUkR7yBF
         1j9uKATdRlNZfj0sGeO1BnX0AgL4AP9JWI+cRwJI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 23/41] io-wq: fix IO_WQ_WORK_NO_CANCEL cancellation
Date:   Sun, 15 Mar 2020 22:33:01 -0400
Message-Id: <20200316023319.749-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023319.749-1-sashal@kernel.org>
References: <20200316023319.749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit fc04c39bae01a607454f7619665309870c60937a ]

To cancel a work, io-wq sets IO_WQ_WORK_CANCEL and executes the
callback. However, IO_WQ_WORK_NO_CANCEL works will just execute and may
return next work, which will be ignored and lost.

Cancel the whole link.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 25ffb6685baea..1f46fe663b287 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -733,6 +733,17 @@ static bool io_wq_can_queue(struct io_wqe *wqe, struct io_wqe_acct *acct,
 	return true;
 }
 
+static void io_run_cancel(struct io_wq_work *work)
+{
+	do {
+		struct io_wq_work *old_work = work;
+
+		work->flags |= IO_WQ_WORK_CANCEL;
+		work->func(&work);
+		work = (work == old_work) ? NULL : work;
+	} while (work);
+}
+
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
@@ -745,8 +756,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	 * It's close enough to not be an issue, fork() has the same delay.
 	 */
 	if (unlikely(!io_wq_can_queue(wqe, acct, work))) {
-		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		io_run_cancel(work);
 		return;
 	}
 
@@ -882,8 +892,7 @@ static enum io_wq_cancel io_wqe_cancel_cb_work(struct io_wqe *wqe,
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if (found) {
-		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		io_run_cancel(work);
 		return IO_WQ_CANCEL_OK;
 	}
 
@@ -957,8 +966,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if (found) {
-		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		io_run_cancel(work);
 		return IO_WQ_CANCEL_OK;
 	}
 
-- 
2.20.1

