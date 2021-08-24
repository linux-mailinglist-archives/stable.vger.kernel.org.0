Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA533F6575
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239664AbhHXRNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:13:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240299AbhHXRLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ACEB61A0B;
        Tue, 24 Aug 2021 17:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824445;
        bh=7e49G3toGPZPMhvrxxtODANFvIKMmozXSQzKa+JsLSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrBCm20ijQqcDeq+2M+HOkpuBUefH6E4grjizKKAgqTWZlUWxSwP/rt4+WHgabDUY
         TYFBJm04HtWEx6Tk+j+heWayjQMOUd6HQSPTK3rcZDZDrlUPIX0ZwH66gOGFm1Xsho
         su494TyuDvYV9vcLffY0YVyTxyFTzbUTGIizQdFXAzL55gE7kPz4At9kyHuE1PdtnZ
         40w9AzJO89OKoPTQj5dXcb/EQ4lKDEhz4SrF92tMtUDgviQOajmPbBUtW3ZmXkN9Mo
         u81ZLuhGnIKVP4imGxzbhMmBQ7oC7bjxI27FUC17gVDZ2Eg6mXYqVcHUAxo3Lh1A0I
         4sn2ds9o9yeKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 96/98] io_uring: fix xa_alloc_cycle() error return value check
Date:   Tue, 24 Aug 2021 12:59:06 -0400
Message-Id: <20210824165908.709932-97-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ upstream commit a30f895ad3239f45012e860d4f94c1a388b36d14 ]

We currently check for ret != 0 to indicate error, but '1' is a valid
return and just indicates that the allocation succeeded with a wrap.
Correct the check to be for < 0, like it was before the xarray
conversion.

Cc: stable@vger.kernel.org
Fixes: 61cf93700fe6 ("io_uring: Convert personality_idr to XArray")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ed641dca7957..762eae2440b5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9601,11 +9601,12 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 
 	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)iod,
 			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
-	if (!ret)
-		return id;
-	put_cred(iod->creds);
-	kfree(iod);
-	return ret;
+	if (ret < 0) {
+		put_cred(iod->creds);
+		kfree(iod);
+		return ret;
+	}
+	return id;
 }
 
 static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
-- 
2.30.2

