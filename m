Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB63835442B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241886AbhDEQEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242065AbhDEQEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CEC9613CC;
        Mon,  5 Apr 2021 16:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638667;
        bh=v3PhA6sR8KfW/SvfLTw00smiNVw2ncQdLuPe1Gr5iQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MknvCSXvQQBYsja0h/RBBTi9zohTXm1o2+DXV0hY/GqxfKEqrDoAPJr+ivg3mjj4H
         2eXoPkeDvLV2jN+lWzinqOv4K9CX6O0qOImp6J9gj113ruG36qa4QFLYXbkyx5lj5J
         hKrxOJX3Lypxpg0CzOVxK0TKmGVOh+2miW7l9NMSQDwtaqJCZPO9xQZQpi5aynoFcE
         b8fBL6kc0UMCBOI3q2Ox/y7QJuF8emivSvTZUSndiUm2xvokgziKTvVMtm14kMbyWE
         mbKlDvYB5X07cVK67f9eMUHIb+2di/5CNJc+IEbf6omaD1Tl+Tb8TG2h4vikt7EVGA
         st/hmNXhOlMEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 19/22] io_uring: don't mark S_ISBLK async work as unbounded
Date:   Mon,  5 Apr 2021 12:04:02 -0400
Message-Id: <20210405160406.268132-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160406.268132-1-sashal@kernel.org>
References: <20210405160406.268132-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5c4378694d54..d9a673976f2d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1546,7 +1546,7 @@ static void io_prep_async_work(struct io_kiocb *req)
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

