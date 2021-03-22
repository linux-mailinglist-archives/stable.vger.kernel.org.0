Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFE9344296
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhCVMn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231749AbhCVMlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:41:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6686B6191A;
        Mon, 22 Mar 2021 12:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416763;
        bh=0PoQavVuGTknLHfldFaFZTD4CViIkpBtQw2co5v1IB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVLX7J6h5aqk6K+Of36rpxPtFRA3N51WXHHiT0+pPqMOs76gCQWw/6xFhugSXLFVB
         aIeCskeGaKLU8tfGRMlPHL5Gfnl76DHK36Y/MXuqvHoi6LLuSVThfdxRlqnpNUqhRn
         8kMRFHrISuGi5F6PqF4Fj/GhtltW8529CahvI2rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/157] io_uring: dont attempt IO reissue from the ring exit path
Date:   Mon, 22 Mar 2021 13:27:42 +0100
Message-Id: <20210322121937.100575291@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 7c977a58dc83366e488c217fd88b1469d242bee5 ]

If we're exiting the ring, just let the IO fail with -EAGAIN as nobody
will care anyway. It's not the right context to reissue from.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5746998799ab..7625b3e2db2c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2617,6 +2617,13 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 		return false;
 	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
 		return false;
+	/*
+	 * If ref is dying, we might be running poll reap from the exit work.
+	 * Don't attempt to reissue from that path, just let it fail with
+	 * -EAGAIN.
+	 */
+	if (percpu_ref_is_dying(&req->ctx->refs))
+		return false;
 
 	ret = io_sq_thread_acquire_mm(req->ctx, req);
 
-- 
2.30.1



