Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAC5291F71
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 22:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388958AbgJRUAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 16:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727698AbgJRTSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAD4B22274;
        Sun, 18 Oct 2020 19:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048712;
        bh=jiy9vWTn50fD4MZ6fl/rHP8hti2qRxhKsMglCxxq8WI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4onsN16Z46l3lw4BDB/12tsYp5Kq0kUfgPivGpRfpYRdHxw5FIjLnvCQkw4QdQVg
         QkEvcS5L1EyQHS3ILIFwn1G6qaHbW7zA7VZkVFGroSRdwUpKamNE8i/hM1wHqe7wEP
         b1j0UezWXHkxLjPrmBIqyn9wjI4AXgIjHgWToRAw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Longfang Liu <liulongfang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 020/111] crypto: hisilicon - fixed memory allocation error
Date:   Sun, 18 Oct 2020 15:16:36 -0400
Message-Id: <20201018191807.4052726-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit 24efcec2919afa7d56f848c83a605b46c8042a53 ]

1. Fix the bug of 'mac' memory leak as allocating 'pbuf' failing.
2. Fix the bug of 'qps' leak as allocating 'qp_ctx' failing.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 497969ae8b230..b9973d152a24a 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -342,11 +342,14 @@ static int sec_alg_resource_alloc(struct sec_ctx *ctx,
 		ret = sec_alloc_pbuf_resource(dev, res);
 		if (ret) {
 			dev_err(dev, "fail to alloc pbuf dma resource!\n");
-			goto alloc_fail;
+			goto alloc_pbuf_fail;
 		}
 	}
 
 	return 0;
+alloc_pbuf_fail:
+	if (ctx->alg_type == SEC_AEAD)
+		sec_free_mac_resource(dev, qp_ctx->res);
 alloc_fail:
 	sec_free_civ_resource(dev, res);
 
@@ -457,8 +460,10 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 	ctx->fake_req_limit = QM_Q_DEPTH >> 1;
 	ctx->qp_ctx = kcalloc(sec->ctx_q_num, sizeof(struct sec_qp_ctx),
 			      GFP_KERNEL);
-	if (!ctx->qp_ctx)
-		return -ENOMEM;
+	if (!ctx->qp_ctx) {
+		ret = -ENOMEM;
+		goto err_destroy_qps;
+	}
 
 	for (i = 0; i < sec->ctx_q_num; i++) {
 		ret = sec_create_qp_ctx(&sec->qm, ctx, i, 0);
@@ -467,12 +472,15 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 	}
 
 	return 0;
+
 err_sec_release_qp_ctx:
 	for (i = i - 1; i >= 0; i--)
 		sec_release_qp_ctx(ctx, &ctx->qp_ctx[i]);
 
-	sec_destroy_qps(ctx->qps, sec->ctx_q_num);
 	kfree(ctx->qp_ctx);
+err_destroy_qps:
+	sec_destroy_qps(ctx->qps, sec->ctx_q_num);
+
 	return ret;
 }
 
-- 
2.25.1

