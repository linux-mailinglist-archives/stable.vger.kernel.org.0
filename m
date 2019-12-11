Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F8911B4C0
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732537AbfLKPYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732648AbfLKPYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:24:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 143182077B;
        Wed, 11 Dec 2019 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077849;
        bh=Dq0fNFRV/9xFsNZdstNwHE220HFU4gDryd/VbmIWB/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxCOO1CubyJPeeyEyqihxxGSIYCx3Z0ifRekKv3gjEYdMvaUwLr6ArPItQ6fKbqc+
         7PCQMmdHRwwnxhkcOPtxMtWtusd8b7v2ssk/uFrX5btrLqok3sbblvIu57u5/UsKLL
         NIqUkVAeba3xX5hhgdTdh4gqscapehbd3KcrZHe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/243] tcp: fix SNMP TCP timeout under-estimation
Date:   Wed, 11 Dec 2019 16:05:19 +0100
Message-Id: <20191211150349.766066209@linuxfoundation.org>
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
index 50b15e1c633b4..681882a409686 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -482,11 +482,12 @@ void tcp_retransmit_timer(struct sock *sk)
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
@@ -501,10 +502,9 @@ void tcp_retransmit_timer(struct sock *sk)
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



