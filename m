Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7D73F6482
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbhHXRFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233322AbhHXRCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:02:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CE9F615A2;
        Tue, 24 Aug 2021 16:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824292;
        bh=mTDeRg+NY7pOqvN0mODZTpMz+1lkHmEhuLA18l/dae8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inyVtPMMyCOpOEauNCinkKr3V/ClRr04dheIblkJA6YpRjkSpobMIx/5zl1NVA/gH
         cDoFJQt1Li2UUZobXnfrGWtEsJT+YaY/yDLN2MWpUxCkjXFfyGB+exmJHK1U1AKX7F
         3B1WNtAYhHezhWFhtm8tjAknRHqkAJTSsI8H3HB5xEw4fcQLvpN6B6wvEoiJ1Iyzt5
         z+Kvl+It3TSjxwaGoFBYNw8beHit2IFsry1mjuw5siBYiUZGMRagBsNIvPkNzrUznr
         uQb6QtlSFsRB4WGpJmhAqVndemG800/C9i1es5KtwGNB2rlM1DAti8V/lhWhj1kewt
         zAzCuyrTzDybg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 125/127] io_uring: fix xa_alloc_cycle() error return value check
Date:   Tue, 24 Aug 2021 12:56:05 -0400
Message-Id: <20210824165607.709387-126-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a30f895ad3239f45012e860d4f94c1a388b36d14 ]

We currently check for ret != 0 to indicate error, but '1' is a valid
return and just indicates that the allocation succeeded with a wrap.
Correct the check to be for < 0, like it was before the xarray
conversion.

Cc: stable@vger.kernel.org
Fixes: 61cf93700fe6 ("io_uring: Convert personality_idr to XArray")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 221b80ae831f..9df82eee440a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9835,10 +9835,11 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 
 	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
 			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
-	if (!ret)
-		return id;
-	put_cred(creds);
-	return ret;
+	if (ret < 0) {
+		put_cred(creds);
+		return ret;
+	}
+	return id;
 }
 
 static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
-- 
2.30.2

