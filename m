Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBEA318E09
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhBKPTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:19:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhBKPNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8990864EE9;
        Thu, 11 Feb 2021 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055862;
        bh=bOF1+ygeVJ0Xvrdhb7APeT6uiLTctc3tlWBM7fCpBYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFPmmFzbXggwWXbPkmGSMotiJ99LGOnO/KwJPULHIEzCdTryEvxDzRgkiGCcYY+1w
         vpMoHTcpRv7OSKSqIdfsW7QNbSXyZqv117HzBylYOxWv+jFu/Pa3c9jPJh5cq8lmBA
         MRWEwDe8Cphbo/qXB4BHwWK6b/eKlBLMvBBA6V7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 09/54] io_uring: fix __io_uring_files_cancel() with TASK_UNINTERRUPTIBLE
Date:   Thu, 11 Feb 2021 16:01:53 +0100
Message-Id: <20210211150153.284941450@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit a1bb3cd58913338e1b627ea6b8c03c2ae82d293f ]

If the tctx inflight number haven't changed because of cancellation,
__io_uring_task_cancel() will continue leaving the task in
TASK_UNINTERRUPTIBLE state, that's not expected by
__io_uring_files_cancel(). Ensure we always call finish_wait() before
retrying.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8829,15 +8829,15 @@ void __io_uring_task_cancel(void)
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 
 		/*
-		 * If we've seen completions, retry. This avoids a race where
-		 * a completion comes in before we did prepare_to_wait().
+		 * If we've seen completions, retry without waiting. This
+		 * avoids a race where a completion comes in before we did
+		 * prepare_to_wait().
 		 */
-		if (inflight != tctx_inflight(tctx))
-			continue;
-		schedule();
+		if (inflight == tctx_inflight(tctx))
+			schedule();
+		finish_wait(&tctx->wait, &wait);
 	} while (1);
 
-	finish_wait(&tctx->wait, &wait);
 	atomic_dec(&tctx->in_idle);
 
 	io_uring_remove_task_files(tctx);


