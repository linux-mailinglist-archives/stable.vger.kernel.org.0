Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793E63DA51C
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbhG2N6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238274AbhG2N5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:57:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D0E260F5C;
        Thu, 29 Jul 2021 13:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567068;
        bh=gWvgCTQg7rvnBzmXLUKMJjQDvXWX+T5EnRxDJmA5gno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+raSCF73f7Nr9AlencdO2UiHYEYyH0+9m/lqFIPsvUjMqDBBEPJmJIuSHfkJ2a4H
         hWK6OLR5U48Jks7HWBYR+COVw+Z/uYej5t5+9kF2yTiNCGlcgeLkltgbEQnbjZosDM
         sI0Em9Ta4MTOEawKh4s1w+YyzI34re44VbCMNASE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/21] ipv6: ip6_finish_output2: set sk into newly allocated nskb
Date:   Thu, 29 Jul 2021 15:54:28 +0200
Message-Id: <20210729135143.583420235@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135142.920143237@linuxfoundation.org>
References: <20210729135142.920143237@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 2d85a1b31dde84038ea07ad825c3d8d3e71f4344 ]

skb_set_owner_w() should set sk not to old skb but to new nskb.

Fixes: 5796015fa968 ("ipv6: allocate enough headroom in ip6_finish_output2()")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Link: https://lore.kernel.org/r/70c0744f-89ae-1869-7e3e-4fa292158f4b@virtuozzo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f26ef5606d8a..fc913f09606d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -73,7 +73,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 
 			if (likely(nskb)) {
 				if (skb->sk)
-					skb_set_owner_w(skb, skb->sk);
+					skb_set_owner_w(nskb, skb->sk);
 				consume_skb(skb);
 			} else {
 				kfree_skb(skb);
-- 
2.30.2



