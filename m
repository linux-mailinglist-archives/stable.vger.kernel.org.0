Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEC5226BA4
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbgGTPmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730029AbgGTPmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:42:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 678CA20773;
        Mon, 20 Jul 2020 15:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259734;
        bh=9YWaCtlFaS/RkIpFOKgFAogxLs9r0cAjS2ySI6Xkhuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgG5Gi4a1/oholFu9zn0REtV0Ua/t7zuXzL/M47tmfrTas0BYifMXXaURVQ/NvD9N
         afF49LpfDvERnAwBE0124GFGmKcSFQPmObpNhsH189fwi6LGt7Avbc/+dNQMdahfiA
         +mbyg0/mSHc8gERFQOlSxutLu5F0x87rRpbgoeRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Marco Elver <elver@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 33/86] tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers
Date:   Mon, 20 Jul 2020 17:36:29 +0200
Message-Id: <20200720152754.820313288@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e6ced831ef11a2a06e8d00aad9d4fc05b610bf38 ]

My prior fix went a bit too far, according to Herbert and Mathieu.

Since we accept that concurrent TCP MD5 lookups might see inconsistent
keys, we can use READ_ONCE()/WRITE_ONCE() instead of smp_rmb()/smp_wmb()

Clearing all key->key[] is needed to avoid possible KMSAN reports,
if key->keylen is increased. Since tcp_md5_do_add() is not fast path,
using __GFP_ZERO to clear all struct tcp_md5sig_key is simpler.

data_race() was added in linux-5.8 and will prevent KCSAN reports,
this can safely be removed in stable backports, if data_race() is
not yet backported.

v2: use data_race() both in tcp_md5_hash_key() and tcp_md5_do_add()

Fixes: 6a2febec338d ("tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marco Elver <elver@google.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c      |    6 +++---
 net/ipv4/tcp_ipv4.c |   14 ++++++++++----
 2 files changed, 13 insertions(+), 7 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3207,13 +3207,13 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
 
 int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
 {
-	u8 keylen = key->keylen;
+	u8 keylen = READ_ONCE(key->keylen); /* paired with WRITE_ONCE() in tcp_md5_do_add */
 	struct scatterlist sg;
 
-	smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
-
 	sg_init_one(&sg, key->key, keylen);
 	ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
+
+	/* tcp_md5_do_add() might change key->key under us */
 	return crypto_ahash_update(hp->md5_req);
 }
 EXPORT_SYMBOL(tcp_md5_hash_key);
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -936,12 +936,18 @@ int tcp_md5_do_add(struct sock *sk, cons
 
 	key = tcp_md5_do_lookup(sk, addr, family);
 	if (key) {
-		/* Pre-existing entry - just update that one. */
+		/* Pre-existing entry - just update that one.
+		 * Note that the key might be used concurrently.
+		 */
 		memcpy(key->key, newkey, newkeylen);
 
-		smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
+		/* Pairs with READ_ONCE() in tcp_md5_hash_key().
+		 * Also note that a reader could catch new key->keylen value
+		 * but old key->key[], this is the reason we use __GFP_ZERO
+		 * at sock_kmalloc() time below these lines.
+		 */
+		WRITE_ONCE(key->keylen, newkeylen);
 
-		key->keylen = newkeylen;
 		return 0;
 	}
 
@@ -957,7 +963,7 @@ int tcp_md5_do_add(struct sock *sk, cons
 		rcu_assign_pointer(tp->md5sig_info, md5sig);
 	}
 
-	key = sock_kmalloc(sk, sizeof(*key), gfp);
+	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
 		return -ENOMEM;
 	if (!tcp_alloc_md5sig_pool()) {


