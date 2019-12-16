Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECAAE121945
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfLPRyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:54:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbfLPRyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:54:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 502FE2146E;
        Mon, 16 Dec 2019 17:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518854;
        bh=gqVIozMbV8/6ED/LSCxrq5AmMOXvoBr1JTXlHi5UOMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zT0BnsukXSkeWqmQGFMhhncJFRwo9KoBOPeQ06yFcg9eePqwg9zLUOoC46CUpj3VS
         5DXb0pBXZ51veq1Lo46TbH4S3y5igwJCPUuHSK2EHA33BRSRTmsSlUu6MVN7Lbs65+
         qi7wi5JVD0InGd+ZxlRBzG2H3ezJ21jQajuMwAuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 093/267] tcp: fix SNMP under-estimation on failed retransmission
Date:   Mon, 16 Dec 2019 18:46:59 +0100
Message-Id: <20191216174859.035168872@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index 5b808089eff89..6025cc509d974 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2932,7 +2932,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	if (likely(!err)) {
 		TCP_SKB_CB(skb)->sacked |= TCPCB_EVER_RETRANS;
 	} else if (err != -EBUSY) {
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRETRANSFAIL);
+		NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPRETRANSFAIL, segs);
 	}
 	return err;
 }
-- 
2.20.1



