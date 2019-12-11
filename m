Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83EF11B4C2
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbfLKPt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:49:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732794AbfLKPYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:24:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BED532173E;
        Wed, 11 Dec 2019 15:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077846;
        bh=2nZs4ApWwNQIsCU08z+BurQFudeLwNmTRiebfxufrRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMd/kh09dVSzs7ys/65KQFFcQaYjpyQ84WnUIfdeXfKuoRcwmjFcqBKom5W9dirri
         YlJFWeTxO3NM7FV83fqXJ/zA9wMegtejtn9nSQzDwzo1z5LB2OtmZ8NAJgnzqPwkKR
         xQsVLmWQwuGzrWKeY0dBlIgW86urCeC1+5rjkbH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 156/243] tcp: fix SNMP under-estimation on failed retransmission
Date:   Wed, 11 Dec 2019 16:05:18 +0100
Message-Id: <20191211150349.699865325@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit ec641b39457e17774313b66697a8a1dc070257bd ]

Previously the SNMP counter LINUX_MIB_TCPRETRANSFAIL is not counting
the TSO/GSO properly on failed retransmission. This patch fixes that.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 53f910bb55087..8971cc15d278b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2919,7 +2919,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 		TCP_SKB_CB(skb)->sacked |= TCPCB_EVER_RETRANS;
 		trace_tcp_retransmit_skb(sk, skb);
 	} else if (err != -EBUSY) {
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRETRANSFAIL);
+		NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPRETRANSFAIL, segs);
 	}
 	return err;
 }
-- 
2.20.1



