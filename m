Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE2029C6A9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1827161AbgJ0SVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442688AbgJ0OCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:02:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1F0A221F8;
        Tue, 27 Oct 2020 14:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807331;
        bh=Wk+aSI7U0jXX/ygkhc1AR8h7iyiQ+5au4OFs/6FHIJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiCbnKjfpAOwfRwNsVQp6wxefKw6lfAJGk041nvAdAFafK5JHhZTMDatrNc5E4QTk
         m6Rzpy8PF0hsTf/ITKKVos08dsF6dBew3jnqiGRrh3rJHtBE9QABi7w6qd+2dPxDic
         QOZNV5Pk/Vqb546FePrZdUjy498GUR9eTP2KA7So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.9 014/139] crypto: algif_aead - Do not set MAY_BACKLOG on the async path
Date:   Tue, 27 Oct 2020 14:48:28 +0100
Message-Id: <20201027134902.824334213@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
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
 crypto/algif_aead.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -455,7 +455,7 @@ static int aead_recvmsg_async(struct soc
 	memcpy(areq->iv, ctx->iv, crypto_aead_ivsize(tfm));
 	aead_request_set_tfm(req, tfm);
 	aead_request_set_ad(req, ctx->aead_assoclen);
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
 				  aead_async_cb, req);
 	used -= ctx->aead_assoclen;
 
@@ -925,7 +925,7 @@ static int aead_accept_parent_nokey(void
 	ask->private = ctx;
 
 	aead_request_set_tfm(&ctx->aead_req, aead);
-	aead_request_set_callback(&ctx->aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	aead_request_set_callback(&ctx->aead_req, CRYPTO_TFM_REQ_MAY_SLEEP,
 				  af_alg_complete, &ctx->completion);
 
 	sk->sk_destruct = aead_sock_destruct;


