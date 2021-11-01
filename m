Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB7B4417FB
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhKAJmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233510AbhKAJkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:40:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE44D611AE;
        Mon,  1 Nov 2021 09:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758861;
        bh=9y8q2OdqzwgLm2LSZqpo+PEyFuKNps3kvxfVZc2fV10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBgTQb0KWYJdKtLOqMJLsohLtSbYNkEh0HI329Oz+XPCCM7rtnsCPgZUkzWvNy74O
         uGWy2CFFZYzsitX1UIHbu33fHjdTdeQXxyPluSPmZ7F9w257xLrJodPt9hgv9mTOoH
         Z1vf3KwnfOVYV18/X6aeH9CeiRwl2vwx6WuUSDoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max VA <maxv@sentinelone.com>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 013/125] tipc: fix size validations for the MSG_CRYPTO type
Date:   Mon,  1 Nov 2021 10:16:26 +0100
Message-Id: <20211101082536.040392329@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max VA <maxv@sentinelone.com>

commit fa40d9734a57bcbfa79a280189799f76c88f7bb0 upstream.

The function tipc_crypto_key_rcv is used to parse MSG_CRYPTO messages
to receive keys from other nodes in the cluster in order to decrypt any
further messages from them.
This patch verifies that any supplied sizes in the message body are
valid for the received message.

Fixes: 1ef6f7c9390f ("tipc: add automatic session key exchange")
Signed-off-by: Max VA <maxv@sentinelone.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/crypto.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2285,43 +2285,53 @@ static bool tipc_crypto_key_rcv(struct t
 	u16 key_gen = msg_key_gen(hdr);
 	u16 size = msg_data_sz(hdr);
 	u8 *data = msg_data(hdr);
+	unsigned int keylen;
+
+	/* Verify whether the size can exist in the packet */
+	if (unlikely(size < sizeof(struct tipc_aead_key) + TIPC_AEAD_KEYLEN_MIN)) {
+		pr_debug("%s: message data size is too small\n", rx->name);
+		goto exit;
+	}
+
+	keylen = ntohl(*((__be32 *)(data + TIPC_AEAD_ALG_NAME)));
+
+	/* Verify the supplied size values */
+	if (unlikely(size != keylen + sizeof(struct tipc_aead_key) ||
+		     keylen > TIPC_AEAD_KEY_SIZE_MAX)) {
+		pr_debug("%s: invalid MSG_CRYPTO key size\n", rx->name);
+		goto exit;
+	}
 
 	spin_lock(&rx->lock);
 	if (unlikely(rx->skey || (key_gen == rx->key_gen && rx->key.keys))) {
 		pr_err("%s: key existed <%p>, gen %d vs %d\n", rx->name,
 		       rx->skey, key_gen, rx->key_gen);
-		goto exit;
+		goto exit_unlock;
 	}
 
 	/* Allocate memory for the key */
 	skey = kmalloc(size, GFP_ATOMIC);
 	if (unlikely(!skey)) {
 		pr_err("%s: unable to allocate memory for skey\n", rx->name);
-		goto exit;
+		goto exit_unlock;
 	}
 
 	/* Copy key from msg data */
-	skey->keylen = ntohl(*((__be32 *)(data + TIPC_AEAD_ALG_NAME)));
+	skey->keylen = keylen;
 	memcpy(skey->alg_name, data, TIPC_AEAD_ALG_NAME);
 	memcpy(skey->key, data + TIPC_AEAD_ALG_NAME + sizeof(__be32),
 	       skey->keylen);
 
-	/* Sanity check */
-	if (unlikely(size != tipc_aead_key_size(skey))) {
-		kfree(skey);
-		skey = NULL;
-		goto exit;
-	}
-
 	rx->key_gen = key_gen;
 	rx->skey_mode = msg_key_mode(hdr);
 	rx->skey = skey;
 	rx->nokey = 0;
 	mb(); /* for nokey flag */
 
-exit:
+exit_unlock:
 	spin_unlock(&rx->lock);
 
+exit:
 	/* Schedule the key attaching on this crypto */
 	if (likely(skey && queue_delayed_work(tx->wq, &rx->work, 0)))
 		return true;


