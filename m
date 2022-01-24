Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCE1499703
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346698AbiAXVIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:08:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55874 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445481AbiAXVDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:03:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F37F36135E;
        Mon, 24 Jan 2022 21:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0BFC340E5;
        Mon, 24 Jan 2022 21:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058217;
        bh=+GukFv+UmmsfgFRsXbDyesdwasvKERbn/wIBoWXygSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJn3qcG2H4QbqJYIXyg12LovNdCqxZB1wk+Y7sDIeV8q2SQTYtd7AIobTSsmy7nlD
         +92qgXUkdPzQY9Lo9a0YoUk7Xh8g6aiAqzDMDHKb/xpSJ0EN+hIHGUW9QJfvGTovTK
         lEt8l6HyAoA8/cIIrnBl5p4E1jSpRcJFyBf8ZoAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gaurav Jain <gaurav.jain@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0217/1039] crypto: caam - save caam memory to support crypto engine retry mechanism.
Date:   Mon, 24 Jan 2022 19:33:26 +0100
Message-Id: <20220124184132.637954486@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaurav Jain <gaurav.jain@nxp.com>

[ Upstream commit 087e1d715bccf25dc0e83294576e416b0386ba20 ]

When caam queue is full (-ENOSPC), caam frees descriptor memory.
crypto-engine checks if retry support is true and h/w queue
is full(-ENOSPC), then requeue the crypto request.
During processing the requested descriptor again, caam gives below error.
(caam_jr 30902000.jr: 40000006: DECO: desc idx 0: Invalid KEY Command).

This patch adds a check to return when caam input ring is full
and retry support is true. so descriptor memory is not freed
and requeued request can be processed again.

Fixes: 2d653936eb2cf ("crypto: caam - enable crypto-engine retry mechanism")
Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamalg.c  | 6 ++++++
 drivers/crypto/caam/caamhash.c | 3 +++
 drivers/crypto/caam/caampkc.c  | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 8697ae53b0633..d3d8bb0a69900 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1533,6 +1533,9 @@ static int aead_do_one_req(struct crypto_engine *engine, void *areq)
 
 	ret = caam_jr_enqueue(ctx->jrdev, desc, aead_crypt_done, req);
 
+	if (ret == -ENOSPC && engine->retry_support)
+		return ret;
+
 	if (ret != -EINPROGRESS) {
 		aead_unmap(ctx->jrdev, rctx->edesc, req);
 		kfree(rctx->edesc);
@@ -1762,6 +1765,9 @@ static int skcipher_do_one_req(struct crypto_engine *engine, void *areq)
 
 	ret = caam_jr_enqueue(ctx->jrdev, desc, skcipher_crypt_done, req);
 
+	if (ret == -ENOSPC && engine->retry_support)
+		return ret;
+
 	if (ret != -EINPROGRESS) {
 		skcipher_unmap(ctx->jrdev, rctx->edesc, req);
 		kfree(rctx->edesc);
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index e8a6d8bc43b5d..36ef738e4a181 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -765,6 +765,9 @@ static int ahash_do_one_req(struct crypto_engine *engine, void *areq)
 
 	ret = caam_jr_enqueue(jrdev, desc, state->ahash_op_done, req);
 
+	if (ret == -ENOSPC && engine->retry_support)
+		return ret;
+
 	if (ret != -EINPROGRESS) {
 		ahash_unmap(jrdev, state->edesc, req, 0);
 		kfree(state->edesc);
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index bf6275ffc4aad..8867275767101 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -380,6 +380,9 @@ static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
 
 	ret = caam_jr_enqueue(jrdev, desc, req_ctx->akcipher_op_done, req);
 
+	if (ret == -ENOSPC && engine->retry_support)
+		return ret;
+
 	if (ret != -EINPROGRESS) {
 		rsa_pub_unmap(jrdev, req_ctx->edesc, req);
 		rsa_io_unmap(jrdev, req_ctx->edesc, req);
-- 
2.34.1



