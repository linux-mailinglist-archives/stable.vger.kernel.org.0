Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64676441738
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhKAJe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232894AbhKAJc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:32:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E284B611CC;
        Mon,  1 Nov 2021 09:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758686;
        bh=t7H4r1omUMT9khpENWuyBJJPIMOqjTHBXRbaflDlEBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EaDkVyr7BtQH1pfaoN6r1Vxzi7kGBaHAAbJajPdbrZzprQcgneV3+t8a+wzKdMTrD
         J6FkLPVYzXhXrWr4tFxeFLEMuBl9q8VVriiJnCnWsYNHv3Ag1Zrlkjd/J+zJTZzG9J
         HzUNfCx8CZrlHN0qb2QhzCWVAl7trpC1EQ4Jye00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max VA <maxv@sentinelone.com>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 16/77] tipc: fix size validations for the MSG_CRYPTO type
Date:   Mon,  1 Nov 2021 10:17:04 +0100
Message-Id: <20211101082515.260627105@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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
@@ -2278,43 +2278,53 @@ static bool tipc_crypto_key_rcv(struct t
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


