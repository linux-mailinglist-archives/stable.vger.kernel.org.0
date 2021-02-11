Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F157318E7E
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhBKP2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:28:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhBKPYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:24:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82CED64EAC;
        Thu, 11 Feb 2021 15:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055810;
        bh=UX8knx71OTQhAq2JbIxW49k4VFQBjNbCR0qusov5xgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAqb66xS1RIb/tiTtbPlTXDSzr++82Ku3ZxFwW+MiXHSBp5y9XdDJ1zsaqUOAI+xy
         fOP1ZUsGw3yOvPFbagZG5xvOvOvhCTahVYNNmqptjSa/ozv6SQpEQE19xnbNCjcSHS
         2PIWr4q0+wTFIIhai/rV3CVsSVd5V7p0wk5a71i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 16/54] io_uring: drop mm/files between task_work_submit
Date:   Thu, 11 Feb 2021 16:02:00 +0100
Message-Id: <20210211150153.580290349@linuxfoundation.org>
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

[ Upstream commit aec18a57edad562d620f7d19016de1fc0cc2208c ]

Since SQPOLL task can be shared and so task_work entries can be a mix of
them, we need to drop mm and files before trying to issue next request.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2084,6 +2084,9 @@ static void __io_req_task_submit(struct
 	else
 		__io_req_task_cancel(req, -EFAULT);
 	mutex_unlock(&ctx->uring_lock);
+
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		io_sq_thread_drop_mm();
 }
 
 static void io_req_task_submit(struct callback_head *cb)


