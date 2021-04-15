Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F835360D9F
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhDOPEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235421AbhDOPBU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:01:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFCFD613CB;
        Thu, 15 Apr 2021 14:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498645;
        bh=AXAVOkWMP4TJGq/t1me/jBeq5pvaOQy+i2sBDw2TSL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaIOIe/LG1rIp5zHBFnZb4LT3/fKDnxgft+mhWsufYwCjx4tGfYGz/HRaXZxA1366
         dT0dOJ3WzwLSRdEOV75WBwqs7e26Nl5eUby9xueN9bz0y8MA1xroUjBu0zeYJbI/xW
         BhUQRWMcR0LeRROPxJYZFROJ8UIMm1Kpk3Q5mJQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/25] io_uring: dont mark S_ISBLK async work as unbounded
Date:   Thu, 15 Apr 2021 16:48:12 +0200
Message-Id: <20210415144413.732165281@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
References: <20210415144413.165663182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 4b982bd0f383db9132e892c0c5144117359a6289 ]

S_ISBLK is marked as unbounded work for async preparation, because it
doesn't match S_ISREG. That is incorrect, as any read/write to a block
device is also a bounded operation. Fix it up and ensure that S_ISBLK
isn't marked unbounded.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0de27e75460d..dc1b0f6fd49b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1439,7 +1439,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 	if (req->flags & REQ_F_ISREG) {
 		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
 			io_wq_hash_work(&req->work, file_inode(req->file));
-	} else {
+	} else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
-- 
2.30.2



