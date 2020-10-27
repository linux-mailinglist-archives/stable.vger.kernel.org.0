Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1AB29B64C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797292AbgJ0PWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797272AbgJ0PWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:22:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FF3520728;
        Tue, 27 Oct 2020 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812158;
        bh=BUOhf/KhDDkfbOeeQln3sQwrnmCVU5E+id99mlkoif8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9ELFGungfg/qHnWDzr9s+D9iDsaiDrjPc+/ceE6+mmNassSxXQHN98YpoecJKcss
         1kuMwPSFn4OqHcexjBuvQZthHH1YdF/2GTFMUl9VKehx25qmptRsAmmtArz27d3YhN
         wpRhDo2qIlGbWg7ov4GlEs/SIoYZ4du7AKEA63aU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.9 081/757] crypto: algif_aead - Do not set MAY_BACKLOG on the async path
Date:   Tue, 27 Oct 2020 14:45:31 +0100
Message-Id: <20201027135454.346085592@linuxfoundation.org>
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
@@ -78,7 +78,7 @@ static int crypto_aead_copy_sgl(struct c
 	SYNC_SKCIPHER_REQUEST_ON_STACK(skreq, null_tfm);
 
 	skcipher_request_set_sync_tfm(skreq, null_tfm);
-	skcipher_request_set_callback(skreq, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	skcipher_request_set_callback(skreq, CRYPTO_TFM_REQ_MAY_SLEEP,
 				      NULL, NULL);
 	skcipher_request_set_crypt(skreq, src, dst, len, NULL);
 
@@ -291,19 +291,20 @@ static int _aead_recvmsg(struct socket *
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
 					  crypto_req_done, &ctx->wait);
 		err = crypto_wait_req(ctx->enc ?


