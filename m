Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89220354476
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241975AbhDEQFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241945AbhDEQFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71157613C5;
        Mon,  5 Apr 2021 16:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638694;
        bh=V9tdGsk2e6klYbLzdx/hRbDiHSlkg2zltr+tGhr2IWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFQA/gs+r35IJpowPwI2pGAk9HfRYGtSCmnSXjII90vLaeQo9Ng+0VJtVUrogQt/k
         KwW08v/wKdmzjARW5woTKl19mMxVs058S/8imYb/TLGgDwTiA2K62JrJj+gI5y+cCc
         e87LTObfuwLvV5zGgLKaG7xDP85dwnAtX4r+ZaGdfhOADX/SVLBt4nvEl7qq4Iaufd
         UCQDXTicT3ammBVUW8PLz9sy4jXpbhVts3d6bZMa9S8fP4dWu2eaXUNPbrW+GPIj0o
         fdtC1UqErBzNrGaE3/PaibJCMixN2g46NuwRX8KC20fTsrr8Wpfs8hqbLGIT6d/Y+4
         +ojaw6MzJkT9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/22] io_uring: don't mark S_ISBLK async work as unbounded
Date:   Mon,  5 Apr 2021 12:04:28 -0400
Message-Id: <20210405160432.268374-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160432.268374-1-sashal@kernel.org>
References: <20210405160432.268374-1-sashal@kernel.org>
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
index dde290eb7dd0..dacfaa1f85ea 100644
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

