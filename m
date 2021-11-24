Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5F445C389
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349241AbhKXNkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352803AbhKXNiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:38:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F17963212;
        Wed, 24 Nov 2021 12:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758559;
        bh=pANrnW5xFnxW0Az6wOwYKPWZY3yIAnuoulTmTxJN+Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+mD/R8JwBJXi8GsRP8wi61vUA7f0fAVgWiWZkNPPs80nNTEbdECjwTL6SEoI8jNR
         fP6tNQ4nbpeQf7pgEM4o7jncH/1q5M/xXmUImHLdNV5FC4pA28d2mApDeUwWVCPP8t
         YSt/5Oc1beGUHxt2M9Dy19cKPYActa7gOF1wfbEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jmaloy@redhat.com>, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/154] tipc: only accept encrypted MSG_CRYPTO msgs
Date:   Wed, 24 Nov 2021 12:57:52 +0100
Message-Id: <20211124115704.787294959@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
index c92e6984933cb..29591955d08a5 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1258,8 +1258,11 @@ static bool tipc_data_input(struct tipc_link *l, struct sk_buff *skb,
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



