Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE8D45C56B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350773AbhKXN5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:57:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352540AbhKXNze (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:55:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 409176328F;
        Wed, 24 Nov 2021 13:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759190;
        bh=toY88Tonkz8nyYQ8YpbfkjxzrYejRJxWtQV0oXLoPjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WytOGWcVRfv14QY+2DhcJzYdqzP39eBxZDwDswVteyYn5YbnGni9Zy6VmJBAKKjFt
         oj6BtH9TE2XvXV9fyDcUw/bKUjC3X/dZe6faHsSXJFTmYrSRmo1uZkzkbA/O1XAGgV
         bj2SauBkESrsSRpfM0TtpTikpDYLvDbefMK4olAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jmaloy@redhat.com>, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/279] tipc: only accept encrypted MSG_CRYPTO msgs
Date:   Wed, 24 Nov 2021 12:56:46 +0100
Message-Id: <20211124115722.916344345@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 271351d255b09e39c7f6437738cba595f9b235be ]

The MSG_CRYPTO msgs are always encrypted and sent to other nodes
for keys' deployment. But when receiving in peers, if those nodes
do not validate it and make sure it's encrypted, one could craft
a malicious MSG_CRYPTO msg to deploy its key with no need to know
other nodes' keys.

This patch is to do that by checking TIPC_SKB_CB(skb)->decrypted
and discard it if this packet never got decrypted.

Note that this is also a supplementary fix to CVE-2021-43267 that
can be triggered by an unencrypted malicious MSG_CRYPTO msg.

Fixes: 1ef6f7c9390f ("tipc: add automatic session key exchange")
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/link.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 1b7a487c88419..09ae8448f394f 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1298,8 +1298,11 @@ static bool tipc_data_input(struct tipc_link *l, struct sk_buff *skb,
 		return false;
 #ifdef CONFIG_TIPC_CRYPTO
 	case MSG_CRYPTO:
-		tipc_crypto_msg_rcv(l->net, skb);
-		return true;
+		if (TIPC_SKB_CB(skb)->decrypted) {
+			tipc_crypto_msg_rcv(l->net, skb);
+			return true;
+		}
+		fallthrough;
 #endif
 	default:
 		pr_warn("Dropping received illegal msg type\n");
-- 
2.33.0



