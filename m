Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480EE3DD8EA
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbhHBNzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236142AbhHBNzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEA8761181;
        Mon,  2 Aug 2021 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912404;
        bh=HQxIcOAvhNI2I91G09vCuSLtsqulbba5cNQQCXjJzjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOwVDlJooSqfRI6GvBOSTS0Njk6A/rL7SoSkD5RnL74TgWPYdadWneJys5piIfyhi
         sj0J2Vv0Uo86OrNT2OAJFdCZwwomtCVuE1O+IqIXuWynIj1y+7ieuZSMouc0HJrTx9
         QOw9q3mlZz26vynsOXurqEv1GolldfC5hu1AyaIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuang Li <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 44/67] tipc: do not write skb_shinfo frags when doing decrytion
Date:   Mon,  2 Aug 2021 15:45:07 +0200
Message-Id: <20210802134340.523356311@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 3cf4375a090473d240281a0d2b04a3a5aaeac34b ]

One skb's skb_shinfo frags are not writable, and they can be shared with
other skbs' like by pskb_copy(). To write the frags may cause other skb's
data crash.

So before doing en/decryption, skb_cow_data() should always be called for
a cloned or nonlinear skb if req dst is using the same sg as req src.
While at it, the likely branch can be removed, as it will be covered
by skb_cow_data().

Note that esp_input() has the same issue, and I will fix it in another
patch. tipc_aead_encrypt() doesn't have this issue, as it only processes
linear data in the unlikely branch.

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 2301b66280de..f8e73c4a0093 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -891,16 +891,10 @@ static int tipc_aead_decrypt(struct net *net, struct tipc_aead *aead,
 	if (unlikely(!aead))
 		return -ENOKEY;
 
-	/* Cow skb data if needed */
-	if (likely(!skb_cloned(skb) &&
-		   (!skb_is_nonlinear(skb) || !skb_has_frag_list(skb)))) {
-		nsg = 1 + skb_shinfo(skb)->nr_frags;
-	} else {
-		nsg = skb_cow_data(skb, 0, &unused);
-		if (unlikely(nsg < 0)) {
-			pr_err("RX: skb_cow_data() returned %d\n", nsg);
-			return nsg;
-		}
+	nsg = skb_cow_data(skb, 0, &unused);
+	if (unlikely(nsg < 0)) {
+		pr_err("RX: skb_cow_data() returned %d\n", nsg);
+		return nsg;
 	}
 
 	/* Allocate memory for the AEAD operation */
-- 
2.30.2



