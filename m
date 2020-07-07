Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B0B216FE0
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgGGPLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728626AbgGGPLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:11:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E427A2065D;
        Tue,  7 Jul 2020 15:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134671;
        bh=NDSl2fJtyWjMwyx1tgk5KUtqdBTmmhz/9Mb98EPWzeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0t0Wq7RvT9Mj4cBaVnHNBqS4PdpvvEKbPGemmmsaeW09O03Ct325RGe+qrAP1EN+2
         /FEUB0gydWNcjA8CujiNyPoIwxErJJghat31ZRqZs17i+6fZuQxLEtQzesD26kHF8P
         7QHVkWBT4BackZHgk5hNDVba4exE8eCO8a8LwAdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Moyles <bmoyles@netflix.com>,
        Mauricio Faria de Oliveira <mfo@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 08/19] crypto: af_alg - fix use-after-free in af_alg_accept() due to bh_lock_sock()
Date:   Tue,  7 Jul 2020 17:10:11 +0200
Message-Id: <20200707145747.922400264@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145747.493710555@linuxfoundation.org>
References: <20200707145747.493710555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 34c86f4c4a7be3b3e35aa48bd18299d4c756064d upstream.

The locking in af_alg_release_parent is broken as the BH socket
lock can only be taken if there is a code-path to handle the case
where the lock is owned by process-context.  Instead of adding
such handling, we can fix this by changing the ref counts to
atomic_t.

This patch also modifies the main refcnt to include both normal
and nokey sockets.  This way we don't have to fudge the nokey
ref count when a socket changes from nokey to normal.

Credits go to Mauricio Faria de Oliveira who diagnosed this bug
and sent a patch for it:

https://lore.kernel.org/linux-crypto/20200605161657.535043-1-mfo@canonical.com/

Reported-by: Brian Moyles <bmoyles@netflix.com>
Reported-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Fixes: 37f96694cf73 ("crypto: af_alg - Use bh_lock_sock in...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/af_alg.c         |   26 +++++++++++---------------
 crypto/algif_aead.c     |    9 +++------
 crypto/algif_hash.c     |    9 +++------
 crypto/algif_skcipher.c |    9 +++------
 include/crypto/if_alg.h |    4 ++--
 5 files changed, 22 insertions(+), 35 deletions(-)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -130,21 +130,15 @@ EXPORT_SYMBOL_GPL(af_alg_release);
 void af_alg_release_parent(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	unsigned int nokey = ask->nokey_refcnt;
-	bool last = nokey && !ask->refcnt;
+	unsigned int nokey = atomic_read(&ask->nokey_refcnt);
 
 	sk = ask->parent;
 	ask = alg_sk(sk);
 
-	local_bh_disable();
-	bh_lock_sock(sk);
-	ask->nokey_refcnt -= nokey;
-	if (!last)
-		last = !--ask->refcnt;
-	bh_unlock_sock(sk);
-	local_bh_enable();
+	if (nokey)
+		atomic_dec(&ask->nokey_refcnt);
 
-	if (last)
+	if (atomic_dec_and_test(&ask->refcnt))
 		sock_put(sk);
 }
 EXPORT_SYMBOL_GPL(af_alg_release_parent);
@@ -189,7 +183,7 @@ static int alg_bind(struct socket *sock,
 
 	err = -EBUSY;
 	lock_sock(sk);
-	if (ask->refcnt | ask->nokey_refcnt)
+	if (atomic_read(&ask->refcnt))
 		goto unlock;
 
 	swap(ask->type, type);
@@ -238,7 +232,7 @@ static int alg_setsockopt(struct socket
 	int err = -EBUSY;
 
 	lock_sock(sk);
-	if (ask->refcnt)
+	if (atomic_read(&ask->refcnt) != atomic_read(&ask->nokey_refcnt))
 		goto unlock;
 
 	type = ask->type;
@@ -305,12 +299,14 @@ int af_alg_accept(struct sock *sk, struc
 
 	sk2->sk_family = PF_ALG;
 
-	if (nokey || !ask->refcnt++)
+	if (atomic_inc_return_relaxed(&ask->refcnt) == 1)
 		sock_hold(sk);
-	ask->nokey_refcnt += nokey;
+	if (nokey) {
+		atomic_inc(&ask->nokey_refcnt);
+		atomic_set(&alg_sk(sk2)->nokey_refcnt, 1);
+	}
 	alg_sk(sk2)->parent = sk;
 	alg_sk(sk2)->type = type;
-	alg_sk(sk2)->nokey_refcnt = nokey;
 
 	newsock->ops = type->ops;
 	newsock->state = SS_CONNECTED;
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -528,7 +528,7 @@ static int aead_check_key(struct socket
 	struct alg_sock *ask = alg_sk(sk);
 
 	lock_sock(sk);
-	if (ask->refcnt)
+	if (!atomic_read(&ask->nokey_refcnt))
 		goto unlock_child;
 
 	psk = ask->parent;
@@ -540,11 +540,8 @@ static int aead_check_key(struct socket
 	if (!tfm->has_key)
 		goto unlock;
 
-	if (!pask->refcnt++)
-		sock_hold(psk);
-
-	ask->refcnt = 1;
-	sock_put(psk);
+	atomic_dec(&pask->nokey_refcnt);
+	atomic_set(&ask->nokey_refcnt, 0);
 
 	err = 0;
 
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -252,7 +252,7 @@ static int hash_check_key(struct socket
 	struct alg_sock *ask = alg_sk(sk);
 
 	lock_sock(sk);
-	if (ask->refcnt)
+	if (!atomic_read(&ask->nokey_refcnt))
 		goto unlock_child;
 
 	psk = ask->parent;
@@ -264,11 +264,8 @@ static int hash_check_key(struct socket
 	if (!tfm->has_key)
 		goto unlock;
 
-	if (!pask->refcnt++)
-		sock_hold(psk);
-
-	ask->refcnt = 1;
-	sock_put(psk);
+	atomic_dec(&pask->nokey_refcnt);
+	atomic_set(&ask->nokey_refcnt, 0);
 
 	err = 0;
 
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -774,7 +774,7 @@ static int skcipher_check_key(struct soc
 	struct alg_sock *ask = alg_sk(sk);
 
 	lock_sock(sk);
-	if (ask->refcnt)
+	if (!atomic_read(&ask->nokey_refcnt))
 		goto unlock_child;
 
 	psk = ask->parent;
@@ -786,11 +786,8 @@ static int skcipher_check_key(struct soc
 	if (!tfm->has_key)
 		goto unlock;
 
-	if (!pask->refcnt++)
-		sock_hold(psk);
-
-	ask->refcnt = 1;
-	sock_put(psk);
+	atomic_dec(&pask->nokey_refcnt);
+	atomic_set(&ask->nokey_refcnt, 0);
 
 	err = 0;
 
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -30,8 +30,8 @@ struct alg_sock {
 
 	struct sock *parent;
 
-	unsigned int refcnt;
-	unsigned int nokey_refcnt;
+	atomic_t refcnt;
+	atomic_t nokey_refcnt;
 
 	const struct af_alg_type *type;
 	void *private;


