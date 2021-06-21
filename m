Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B843AEF87
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhFUQkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232784AbhFUQhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:37:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C85EC60FF4;
        Mon, 21 Jun 2021 16:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292939;
        bh=Dcxq6QrwIGhjFpKCcUl2E5LflXkcI/fewTYI77DVkCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hezh7Qz0H4jO+jTiQodc9sey75nGfnCFxcH7JJiyBTkS6bPyeIrlJ+yJQ11PzAeQg
         yYudaTPf5FI9BN0xHHuw6LHZIxXoe21I63Cm6icjidCfbh0xvdL70fC1SAkj5bwAeR
         8uXUMrBZSUlVg/R/NpyhIci06vK3I9J+kEXRpN9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Talal Ahmad <talalahmad@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 040/178] skbuff: fix incorrect msg_zerocopy copy notifications
Date:   Mon, 21 Jun 2021 18:14:14 +0200
Message-Id: <20210621154923.488559058@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 3bdd5ee0ec8c14131d560da492e6df452c6fdd75 ]

msg_zerocopy signals if a send operation required copying with a flag
in serr->ee.ee_code.

This field can be incorrect as of the below commit, as a result of
both structs uarg and serr pointing into the same skb->cb[].

uarg->zerocopy must be read before skb->cb[] is reinitialized to hold
serr. Similar to other fields len, hi and lo, use a local variable to
temporarily hold the value.

This was not a problem before, when the value was passed as a function
argument.

Fixes: 75518851a2a0 ("skbuff: Push status and refcounts into sock_zerocopy_callback")
Reported-by: Talal Ahmad <talalahmad@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c421c8f80925..7997d99afbd8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1252,6 +1252,7 @@ static void __msg_zerocopy_callback(struct ubuf_info *uarg)
 	struct sock *sk = skb->sk;
 	struct sk_buff_head *q;
 	unsigned long flags;
+	bool is_zerocopy;
 	u32 lo, hi;
 	u16 len;
 
@@ -1266,6 +1267,7 @@ static void __msg_zerocopy_callback(struct ubuf_info *uarg)
 	len = uarg->len;
 	lo = uarg->id;
 	hi = uarg->id + len - 1;
+	is_zerocopy = uarg->zerocopy;
 
 	serr = SKB_EXT_ERR(skb);
 	memset(serr, 0, sizeof(*serr));
@@ -1273,7 +1275,7 @@ static void __msg_zerocopy_callback(struct ubuf_info *uarg)
 	serr->ee.ee_origin = SO_EE_ORIGIN_ZEROCOPY;
 	serr->ee.ee_data = hi;
 	serr->ee.ee_info = lo;
-	if (!uarg->zerocopy)
+	if (!is_zerocopy)
 		serr->ee.ee_code |= SO_EE_CODE_ZEROCOPY_COPIED;
 
 	q = &sk->sk_error_queue;
-- 
2.30.2



