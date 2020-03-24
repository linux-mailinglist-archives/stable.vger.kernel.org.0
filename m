Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49951910B7
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgCXNVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729071AbgCXNVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:21:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E83A20775;
        Tue, 24 Mar 2020 13:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056102;
        bh=6h5MTVyaKyz4i4lsW9DXrzFXoUBWZQhfBhzWyfVeCLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6fALpD7d2wqoHnHld/x250DUC2+ZdL69wUw4T59wWDrodP/r6oDX0wQuWmVsxDbC
         YM78oI+YCcoZoKZ+imv9HFjnN5DCcvYo5UjraykuH2CFxmSX8/5lflV1ULLMBwQIVN
         1pCS9fSaORZZqqSw8fQOghwJeGQEAyjyiXXfDRpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 022/119] io-wq: fix IO_WQ_WORK_NO_CANCEL cancellation
Date:   Tue, 24 Mar 2020 14:10:07 +0100
Message-Id: <20200324130810.607084704@linuxfoundation.org>
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



