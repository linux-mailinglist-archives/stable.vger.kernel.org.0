Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F6429B999
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802629AbgJ0Puf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1795105AbgJ0PPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:15:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 546AD20657;
        Tue, 27 Oct 2020 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811704;
        bh=UHq/nKFmMR0GDOVk+cziNE50FRsC7lMUxeb4brzJxpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmXe4lzTMUs/k0mW/Luzz5Hv40Kj8J+vlSM4gzUV3HpN/RPsFR51ix2eCLjNW3bCn
         GUGe2lTrJYNbU/p5nUiquDGyEsWETAN2WKXueCXMyrbKIxJvBptuIJ/ortL2J1lgbq
         vXXfdHG9C75Ca369W/PP33NoRLZBlRUYC83UanbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Longfang Liu <liulongfang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 546/633] crypto: hisilicon - fixed memory allocation error
Date:   Tue, 27 Oct 2020 14:54:49 +0100
Message-Id: <20201027135548.403891196@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 64614a9bdf219..047826f18bd35 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -332,11 +332,14 @@ static int sec_alg_resource_alloc(struct sec_ctx *ctx,
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
 
@@ -447,8 +450,10 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
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
@@ -457,12 +462,15 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
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



