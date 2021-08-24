Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7633F560A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 04:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhHXC6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 22:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234116AbhHXC6h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 22:58:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A547C61181;
        Tue, 24 Aug 2021 02:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773874;
        bh=7+VsE/8n2awtAHPKX2PwIAzAYrvuvgiPrb2jQemy15o=;
        h=From:To:Cc:Subject:Date:From;
        b=We4wcZ8WVUzQR58kWTgZ3Tr6G1CdIiDnqlHyKL7VJ2fnDEgbZO3O5JKmE0b8YdNmB
         eOMdm73Vrgcl5+J+Bu6wVqqmR09/VH/Z7tjXv7hCmFRhmtjuEqiW4uKEGrjkpkmRSj
         bt2HEO3ne2h/1S5C+5Qkzs3qOkL+2jbqD3cC4HIGrNiFC6XoUb8Zbu3VYs3ti/d/W+
         +xkj/LFP2G+kpdxHEJ7QezFHL94Azu4n4Dv6E0lZAAOpx1oQrU1p4j9+WApKRbdGza
         MLXE9hcxLiemismPbi8oSS6cKUEjPlxC+VB6RV+ReubEOdBUbSr+EQu8nDOtxl53W1
         ov8S7Po065h2A==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: FAILED: Patch "io_uring: fix xa_alloc_cycle() error return value check" failed to apply to 5.10-stable tree
Date:   Mon, 23 Aug 2021 22:57:52 -0400
Message-Id: <20210824025752.658321-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From a30f895ad3239f45012e860d4f94c1a388b36d14 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 20 Aug 2021 14:53:59 -0600
Subject: [PATCH] io_uring: fix xa_alloc_cycle() error return value check

We currently check for ret != 0 to indicate error, but '1' is a valid
return and just indicates that the allocation succeeded with a wrap.
Correct the check to be for < 0, like it was before the xarray
conversion.

Cc: stable@vger.kernel.org
Fixes: 61cf93700fe6 ("io_uring: Convert personality_idr to XArray")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 979941bcd15a..a2e20a6fbfed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9843,10 +9843,11 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 
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




