Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D4E2264F9
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbgGTPtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731036AbgGTPtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:49:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A07822482;
        Mon, 20 Jul 2020 15:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260185;
        bh=uORrc+8HBjJ7VP7+P3vFQQKH9HLm2dnB8CiN/Kk4KhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRpDf0WyL30YjGY6vxxljbOZoaJxzDATbAtOXlznVT6Wd7N362rD612BAXHzWhy2i
         MeLIDTSjtAmHcQBv69iJdmnpkJwA2H56wlZ1IaJ2gR95tV2UKVoYv1SNAIM8UjlcQ8
         JBAqJDJgXgZRBUM7T0SJC4YfDd6JiLEdezOQfqjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 012/133] tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
Date:   Mon, 20 Jul 2020 17:35:59 +0200
Message-Id: <20200720152804.324509468@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6a2febec338df7e7699a52d00b2e1207dcf65b28 ]

MD5 keys are read with RCU protection, and tcp_md5_do_add()
might update in-place a prior key.

Normally, typical RCU updates would allocate a new piece
of memory. In this case only key->key and key->keylen might
be updated, and we do not care if an incoming packet could
see the old key, the new one, or some intermediate value,
since changing the key on a live flow is known to be problematic
anyway.

We only want to make sure that in the case key->keylen
is changed, cpus in tcp_md5_hash_key() wont try to use
uninitialized data, or crash because key->keylen was
read twice to feed sg_init_one() and ahash_request_set_crypt()

Fixes: 9ea88a153001 ("tcp: md5: check md5 signature without socket lock")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c      |    7 +++++--
 net/ipv4/tcp_ipv4.c |    3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3756,10 +3756,13 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
 
 int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
 {
+	u8 keylen = key->keylen;
 	struct scatterlist sg;
 
-	sg_init_one(&sg, key->key, key->keylen);
-	ahash_request_set_crypt(hp->md5_req, &sg, NULL, key->keylen);
+	smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
+
+	sg_init_one(&sg, key->key, keylen);
+	ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
 	return crypto_ahash_update(hp->md5_req);
 }
 EXPORT_SYMBOL(tcp_md5_hash_key);
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1065,6 +1065,9 @@ int tcp_md5_do_add(struct sock *sk, cons
 	if (key) {
 		/* Pre-existing entry - just update that one. */
 		memcpy(key->key, newkey, newkeylen);
+
+		smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
+
 		key->keylen = newkeylen;
 		return 0;
 	}


