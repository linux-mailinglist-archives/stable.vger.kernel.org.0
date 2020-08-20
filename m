Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AA824BD69
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgHTJjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728606AbgHTJjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:39:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E913121775;
        Thu, 20 Aug 2020 09:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916352;
        bh=6udAPmdYQ4kMuQFcAZHbE7RJt81G0dlqHFJZY8safgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqFyF2cUYN1RAVqVrsfAYkvpt9Vl3j7QzOvaR+3e1kp+WgO02WcQltCKFZMtEzIDM
         ZoKRA8bmRLPKhUhM2r+b18KSIY+ddi3/CyqJHAVlRZnjvSlaUzHccrHB+imU2PL4JN
         DLRixejCtyyKsX+mQz6K0gimC4TLPoaV/FvuNEtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 099/204] crypto: algif_aead - Only wake up when ctx->more is zero
Date:   Thu, 20 Aug 2020 11:19:56 +0200
Message-Id: <20200820091611.271368681@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit f3c802a1f30013f8f723b62d7fa49eb9e991da23 ]

AEAD does not support partial requests so we must not wake up
while ctx->more is set.  In order to distinguish between the
case of no data sent yet and a zero-length request, a new init
flag has been added to ctx.

SKCIPHER has also been modified to ensure that at least a block
of data is available if there is more data to come.

Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c         | 11 ++++++++---
 crypto/algif_aead.c     |  4 ++--
 crypto/algif_skcipher.c |  4 ++--
 include/crypto/if_alg.h |  4 +++-
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 28fc323e3fe30..9fcb91ea10c41 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -635,6 +635,7 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 
 	if (!ctx->used)
 		ctx->merge = 0;
+	ctx->init = ctx->more;
 }
 EXPORT_SYMBOL_GPL(af_alg_pull_tsgl);
 
@@ -734,9 +735,10 @@ EXPORT_SYMBOL_GPL(af_alg_wmem_wakeup);
  *
  * @sk socket of connection to user space
  * @flags If MSG_DONTWAIT is set, then only report if function would sleep
+ * @min Set to minimum request size if partial requests are allowed.
  * @return 0 when writable memory is available, < 0 upon error
  */
-int af_alg_wait_for_data(struct sock *sk, unsigned flags)
+int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct alg_sock *ask = alg_sk(sk);
@@ -754,7 +756,9 @@ int af_alg_wait_for_data(struct sock *sk, unsigned flags)
 		if (signal_pending(current))
 			break;
 		timeout = MAX_SCHEDULE_TIMEOUT;
-		if (sk_wait_event(sk, &timeout, (ctx->used || !ctx->more),
+		if (sk_wait_event(sk, &timeout,
+				  ctx->init && (!ctx->more ||
+						(min && ctx->used >= min)),
 				  &wait)) {
 			err = 0;
 			break;
@@ -843,7 +847,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	}
 
 	lock_sock(sk);
-	if (!ctx->more && ctx->used) {
+	if (ctx->init && (init || !ctx->more)) {
 		err = -EINVAL;
 		goto unlock;
 	}
@@ -854,6 +858,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			memcpy(ctx->iv, con.iv->iv, ivsize);
 
 		ctx->aead_assoclen = con.aead_assoclen;
+		ctx->init = true;
 	}
 
 	while (size) {
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 0ae000a61c7f5..d48d2156e6210 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -106,8 +106,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
 	size_t processed = 0;		/* [in]  TX bufs to be consumed */
 
-	if (!ctx->used) {
-		err = af_alg_wait_for_data(sk, flags);
+	if (!ctx->init || ctx->more) {
+		err = af_alg_wait_for_data(sk, flags, 0);
 		if (err)
 			return err;
 	}
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ec5567c87a6df..a51ba22fef58f 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -61,8 +61,8 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	int err = 0;
 	size_t len = 0;
 
-	if (!ctx->used) {
-		err = af_alg_wait_for_data(sk, flags);
+	if (!ctx->init || (ctx->more && ctx->used < bs)) {
+		err = af_alg_wait_for_data(sk, flags, bs);
 		if (err)
 			return err;
 	}
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 088c1ded27148..ee6412314f8f3 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -135,6 +135,7 @@ struct af_alg_async_req {
  *			SG?
  * @enc:		Cryptographic operation to be performed when
  *			recvmsg is invoked.
+ * @init:		True if metadata has been sent.
  * @len:		Length of memory allocated for this data structure.
  */
 struct af_alg_ctx {
@@ -151,6 +152,7 @@ struct af_alg_ctx {
 	bool more;
 	bool merge;
 	bool enc;
+	bool init;
 
 	unsigned int len;
 };
@@ -226,7 +228,7 @@ unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset);
 void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 		      size_t dst_offset);
 void af_alg_wmem_wakeup(struct sock *sk);
-int af_alg_wait_for_data(struct sock *sk, unsigned flags);
+int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min);
 int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		   unsigned int ivsize);
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
-- 
2.25.1



