Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486C222638E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbgGTPiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729087AbgGTPiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:38:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0405922B4E;
        Mon, 20 Jul 2020 15:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259490;
        bh=dXssBx4W+l8RClRgWqHGMlGzIqvB09LnZ0zFuEuYNW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+3WxiM664c2RTo+ZlVHmQovwRHi3/qgiMhutkSkOegc1DFmonRls0RJvlM3HwuCT
         mSk7G5jY14FB8UNa1IXcGP3fps9YYjcVe0J8XpGl0gPoOp4joOgHuxolla4JHg44ed
         JfGNu7TXECr0vqAgTXqwM20axjTbbM+UZayZP2uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 26/58] tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
Date:   Mon, 20 Jul 2020 17:36:42 +0200
Message-Id: <20200720152748.455368338@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
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
 net/ipv4/tcp.c      |    5 ++++-
 net/ipv4/tcp_ipv4.c |    3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3088,9 +3088,12 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
 
 int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
 {
+	u8 keylen = key->keylen;
 	struct scatterlist sg;
 
-	sg_init_one(&sg, key->key, key->keylen);
+	smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
+
+	sg_init_one(&sg, key->key, keylen);
 	return crypto_hash_update(&hp->md5_desc, &sg, key->keylen);
 }
 EXPORT_SYMBOL(tcp_md5_hash_key);
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -933,6 +933,9 @@ int tcp_md5_do_add(struct sock *sk, cons
 	if (key) {
 		/* Pre-existing entry - just update that one. */
 		memcpy(key->key, newkey, newkeylen);
+
+		smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
+
 		key->keylen = newkeylen;
 		return 0;
 	}


