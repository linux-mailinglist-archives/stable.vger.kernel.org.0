Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8C83C5256
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345952AbhGLHpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344304AbhGLHnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:43:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F41E61175;
        Mon, 12 Jul 2021 07:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075608;
        bh=Zb8+YLuj1bpHSb/bnynV53LY/CQQUHbO+V4Sie/VhaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MqXK3lVyLXQNqVC6nGophXuwwHgYHcyK/mOxme9HMNZi6nLWK0uVv0VQ2IZ0y/PQs
         ksF8O+kFHXqDBQ0L/1Fm/Lwve6ewxDpokuKbR26mEkmEHPxoTSbSjFBvYQoZuIhIlD
         iUp/medkOyo2d8naxHGZ66EZgkao56hJU6Y5FBJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Tang <tanghui20@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 285/800] crypto: hisilicon/hpre - fix unmapping invalid dma address
Date:   Mon, 12 Jul 2021 08:05:08 +0200
Message-Id: <20210712060955.077500930@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 0b0553b701f830d820ba9026e5799c24e400a4b5 ]

Currently, an invalid dma address may be unmapped when calling
'xx_data_clr_all' in error path, so check dma address of sqe in/out
if initialized before calling 'dma_free_coherent' or 'dma_unmap_single'.

Fixes: a9214b0b6ed2 ("crypto: hisilicon - fix the check on dma address")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index a380087c83f7..782ddffa5d90 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -298,6 +298,8 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 	dma_addr_t tmp;
 
 	tmp = le64_to_cpu(sqe->in);
+	if (unlikely(dma_mapping_error(dev, tmp)))
+		return;
 
 	if (src) {
 		if (req->src)
@@ -307,6 +309,8 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 	}
 
 	tmp = le64_to_cpu(sqe->out);
+	if (unlikely(dma_mapping_error(dev, tmp)))
+		return;
 
 	if (req->dst) {
 		if (dst)
@@ -524,6 +528,8 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 		msg->key = cpu_to_le64(ctx->dh.dma_xa_p);
 	}
 
+	msg->in = cpu_to_le64(DMA_MAPPING_ERROR);
+	msg->out = cpu_to_le64(DMA_MAPPING_ERROR);
 	msg->dw0 |= cpu_to_le32(0x1 << HPRE_SQE_DONE_SHIFT);
 	msg->task_len1 = (ctx->key_sz >> HPRE_BITS_2_BYTES_SHIFT) - 1;
 	h_req->ctx = ctx;
@@ -1372,11 +1378,15 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
 	dma_addr_t dma;
 
 	dma = le64_to_cpu(sqe->in);
+	if (unlikely(dma_mapping_error(dev, dma)))
+		return;
 
 	if (src && req->src)
 		dma_free_coherent(dev, ctx->key_sz << 2, req->src, dma);
 
 	dma = le64_to_cpu(sqe->out);
+	if (unlikely(dma_mapping_error(dev, dma)))
+		return;
 
 	if (req->dst)
 		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
@@ -1431,6 +1441,8 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 	h_req->areq.ecdh = req;
 	msg = &h_req->req;
 	memset(msg, 0, sizeof(*msg));
+	msg->in = cpu_to_le64(DMA_MAPPING_ERROR);
+	msg->out = cpu_to_le64(DMA_MAPPING_ERROR);
 	msg->key = cpu_to_le64(ctx->ecdh.dma_p);
 
 	msg->dw0 |= cpu_to_le32(0x1U << HPRE_SQE_DONE_SHIFT);
@@ -1667,11 +1679,15 @@ static void hpre_curve25519_hw_data_clr_all(struct hpre_ctx *ctx,
 	dma_addr_t dma;
 
 	dma = le64_to_cpu(sqe->in);
+	if (unlikely(dma_mapping_error(dev, dma)))
+		return;
 
 	if (src && req->src)
 		dma_free_coherent(dev, ctx->key_sz, req->src, dma);
 
 	dma = le64_to_cpu(sqe->out);
+	if (unlikely(dma_mapping_error(dev, dma)))
+		return;
 
 	if (req->dst)
 		dma_free_coherent(dev, ctx->key_sz, req->dst, dma);
@@ -1722,6 +1738,8 @@ static int hpre_curve25519_msg_request_set(struct hpre_ctx *ctx,
 	h_req->areq.curve25519 = req;
 	msg = &h_req->req;
 	memset(msg, 0, sizeof(*msg));
+	msg->in = cpu_to_le64(DMA_MAPPING_ERROR);
+	msg->out = cpu_to_le64(DMA_MAPPING_ERROR);
 	msg->key = cpu_to_le64(ctx->curve25519.dma_p);
 
 	msg->dw0 |= cpu_to_le32(0x1U << HPRE_SQE_DONE_SHIFT);
-- 
2.30.2



