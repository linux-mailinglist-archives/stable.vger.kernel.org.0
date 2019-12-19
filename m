Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058AC126A12
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbfLSSnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:43:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbfLSSnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:43:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2828024679;
        Thu, 19 Dec 2019 18:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781031;
        bh=hn2/d0wR3F14WDj3QEXynxmohsEgJD9QGTYyc0rFEfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gh/QoC5Kq+AvHpJeWnd9JSlx7Bmtfl+wWP2E6DPiUWzIBu68RMSUGzDhz14UZANwT
         DLRm1QwmJI8iGRqy/2x5cDfXHcjG0e58BZ6k6FVSVq3QC4abIJMzW/mHAZ1kvuIggk
         U5mT9klxDj4TOBLQMs2SIWRBqN39S7TolMpLBzOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 055/199] tcp: fix SNMP TCP timeout under-estimation
Date:   Thu, 19 Dec 2019 19:32:17 +0100
Message-Id: <20191219183218.006003853@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit e1561fe2dd69dc5dddd69bd73aa65355bdfb048b ]

Previously the SNMP TCPTIMEOUTS counter has inconsistent accounting:
1. It counts all SYN and SYN-ACK timeouts
2. It counts timeouts in other states except recurring timeouts and
   timeouts after fast recovery or disorder state.

Such selective accounting makes analysis difficult and complicated. For
example the monitoring system needs to collect many other SNMP counters
to infer the total amount of timeout events. This patch makes TCPTIMEOUTS
counter simply counts all the retransmit timeout (SYN or data or FIN).

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_timer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index ad0083f7b5dd3..761a198ed5f30 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -478,11 +478,12 @@ void tcp_retransmit_timer(struct sock *sk)
 		goto out_reset_timer;
 	}
 
+	__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPTIMEOUTS);
 	if (tcp_write_timeout(sk))
 		goto out;
 
 	if (icsk->icsk_retransmits == 0) {
-		int mib_idx;
+		int mib_idx = 0;
 
 		if (icsk->icsk_ca_state == TCP_CA_Recovery) {
 			if (tcp_is_sack(tp))
@@ -497,10 +498,9 @@ void tcp_retransmit_timer(struct sock *sk)
 				mib_idx = LINUX_MIB_TCPSACKFAILURES;
 			else
 				mib_idx = LINUX_MIB_TCPRENOFAILURES;
-		} else {
-			mib_idx = LINUX_MIB_TCPTIMEOUTS;
 		}
-		__NET_INC_STATS(sock_net(sk), mib_idx);
+		if (mib_idx)
+			__NET_INC_STATS(sock_net(sk), mib_idx);
 	}
 
 	tcp_enter_loss(sk);
-- 
2.20.1



