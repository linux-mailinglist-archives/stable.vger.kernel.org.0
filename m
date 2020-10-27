Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD67129B6E9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368774AbgJ0P1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797263AbgJ0PWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:22:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8829020657;
        Tue, 27 Oct 2020 15:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812155;
        bh=DbNPr8SGbNlz4yy2XsnqHJEc/HN7hsmau32ijvjzmaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LziR7aN2lVQyTFjOlL9TCNy5u0UFGvFVpA9VfEnCgwW1n8CLlJ7IXV8aBDBriq5DR
         7/pviLMnvH7aaI7/YRvbYUcNrTsE1z5qfEla5sR1h0P4rhs1GmugC5ENg90T5HwQCG
         LGBZ+xXBaV9serEzZQMAr1u1rCNSqa5cKybyDPVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Botila <andrei.botila@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.9 080/757] crypto: caam - add xts check for block length equal to zero
Date:   Tue, 27 Oct 2020 14:45:30 +0100
Message-Id: <20201027135454.305894390@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

commit 297b931c2a3cada230d8b84432ee982fc68cf76a upstream.

XTS should not return succes when dealing with block length equal to zero.
This is different than the rest of the skcipher algorithms.

Fixes: 31bb2f0da1b50 ("crypto: caam - check zero-length input")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamalg.c     |    7 ++++++-
 drivers/crypto/caam/caamalg_qi.c  |    7 ++++++-
 drivers/crypto/caam/caamalg_qi2.c |   14 ++++++++++++--
 3 files changed, 24 insertions(+), 4 deletions(-)

--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1765,7 +1765,12 @@ static inline int skcipher_crypt(struct
 	u32 *desc;
 	int ret = 0;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
 	/* allocate extended descriptor */
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -1380,7 +1380,12 @@ static inline int skcipher_crypt(struct
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	int ret;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
 	if (unlikely(caam_congested))
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1451,7 +1451,12 @@ static int skcipher_encrypt(struct skcip
 	struct caam_request *caam_req = skcipher_request_ctx(req);
 	int ret;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 
 	/* allocate extended descriptor */
@@ -1482,7 +1487,12 @@ static int skcipher_decrypt(struct skcip
 	struct caam_request *caam_req = skcipher_request_ctx(req);
 	int ret;
 
-	if (!req->cryptlen)
+	/*
+	 * XTS is expected to return an error even for input length = 0
+	 * Note that the case input length < block size will be caught during
+	 * HW offloading and return an error.
+	 */
+	if (!req->cryptlen && !ctx->fallback)
 		return 0;
 	/* allocate extended descriptor */
 	edesc = skcipher_edesc_alloc(req);


