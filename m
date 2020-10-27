Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901DF29AF48
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755231AbgJ0OIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:08:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755227AbgJ0OIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:08:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA8E6218AC;
        Tue, 27 Oct 2020 14:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807734;
        bh=bLXa6Zvc/A0U3L/brtR1buwg/a3P6Bys9Ppsmx5ZWto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQruL+FPSsfPhIA+wAKrbz9fL+juju0qWfuiCgEJroRDU4PtqzYpGSZGHlnFoRwO0
         Y/b9QCyCmOzOdK54N8vFncpJuAyKAEnWYg42rX1DlaPjok7cJDZbetH4HpSHI0OD6k
         vw6akxVdA3O/K1KjgjDxUR3RGALNS5dJoCJit5s8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 021/191] crypto: algif_aead - Do not set MAY_BACKLOG on the async path
Date:   Tue, 27 Oct 2020 14:47:56 +0100
Message-Id: <20201027134910.740997899@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit cbdad1f246dd98e6c9c32a6e5212337f542aa7e0 upstream.

The async path cannot use MAY_BACKLOG because it is not meant to
block, which is what MAY_BACKLOG does.  On the other hand, both
the sync and async paths can make use of MAY_SLEEP.

Fixes: 83094e5e9e49 ("crypto: af_alg - add async support to...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/algif_aead.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -83,7 +83,7 @@ static int crypto_aead_copy_sgl(struct c
 	SKCIPHER_REQUEST_ON_STACK(skreq, null_tfm);
 
 	skcipher_request_set_tfm(skreq, null_tfm);
-	skcipher_request_set_callback(skreq, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	skcipher_request_set_callback(skreq, CRYPTO_TFM_REQ_MAY_SLEEP,
 				      NULL, NULL);
 	skcipher_request_set_crypt(skreq, src, dst, len, NULL);
 
@@ -296,19 +296,20 @@ static int _aead_recvmsg(struct socket *
 		areq->outlen = outlen;
 
 		aead_request_set_callback(&areq->cra_u.aead_req,
-					  CRYPTO_TFM_REQ_MAY_BACKLOG,
+					  CRYPTO_TFM_REQ_MAY_SLEEP,
 					  af_alg_async_cb, areq);
 		err = ctx->enc ? crypto_aead_encrypt(&areq->cra_u.aead_req) :
 				 crypto_aead_decrypt(&areq->cra_u.aead_req);
 
 		/* AIO operation in progress */
-		if (err == -EINPROGRESS || err == -EBUSY)
+		if (err == -EINPROGRESS)
 			return -EIOCBQUEUED;
 
 		sock_put(sk);
 	} else {
 		/* Synchronous operation */
 		aead_request_set_callback(&areq->cra_u.aead_req,
+					  CRYPTO_TFM_REQ_MAY_SLEEP |
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
 					  af_alg_complete, &ctx->completion);
 		err = af_alg_wait_for_completion(ctx->enc ?


