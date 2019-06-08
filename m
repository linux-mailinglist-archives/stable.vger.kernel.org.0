Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4ECD39F15
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbfFHLx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727665AbfFHLkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:40:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3E67214AF;
        Sat,  8 Jun 2019 11:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994035;
        bh=w5aQZhf7HlqizMDPAz0KOrvr2Obgz/W68H+SknGP92c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYPY3tvXWmJU1wxMqhsR/N9KlOam57+wsT9visuTn532JVPyI9Fl1SP1+DIbm3ooV
         ig6izqBQAfSz9DIn4ssYfEh5X6TDnDAmdg8invI4JwWqefNAAud/bBSJI7wa0BaSgt
         kSu15+ux1qBuznb07vknmDxgDwyqahwTWw2Xht9E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 29/70] io_uring: Fix __io_uring_register() false success
Date:   Sat,  8 Jun 2019 07:39:08 -0400
Message-Id: <20190608113950.8033-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit a278682dad37fd2f8d2f30d8e84e376a856ab472 ]

If io_copy_iov() fails, it will break the loop and report success,
albeit partially completed operation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 30a5687a17b6..69ff94558758 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2505,7 +2505,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 
 		ret = io_copy_iov(ctx, &iov, arg, i);
 		if (ret)
-			break;
+			goto err;
 
 		/*
 		 * Don't impose further limits on the size and buffer
-- 
2.20.1

