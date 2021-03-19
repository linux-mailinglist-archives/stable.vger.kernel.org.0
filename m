Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F127A341C72
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhCSMUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231246AbhCSMUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B27FB6146D;
        Fri, 19 Mar 2021 12:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156427;
        bh=ZcEPbgVJdj6iNRdNVfImzjCi0acB2vTyFwj9mjIKps0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5dXOuwxuCxW6VIkBd2fwHKjvZDpV3TdcQAmJhmzYxZ7TwMjKs0vztRYt37tvl1P7
         JO1j8Bu2NmqeLBmfqBFK+gMEXmMV+mXhn+uFrysY+92L1Y8vDBKCjsuDDIV04U0+dz
         kgzj6c05nUwY5gawhmUBGdS7tLWwQy3LTfacRdsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 01/31] io_uring: dont attempt IO reissue from the ring exit path
Date:   Fri, 19 Mar 2021 13:18:55 +0100
Message-Id: <20210319121747.252708051@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
index 00ef0b90d149..68508f010b90 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2717,6 +2717,13 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
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
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-- 
2.30.1



