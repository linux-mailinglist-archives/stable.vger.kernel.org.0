Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353D5278883
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgIYMx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729484AbgIYMxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:53:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35403206DB;
        Fri, 25 Sep 2020 12:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038430;
        bh=Hjba65to0WbZ8H4xOBA7DEOuoppyWz/lZKp7NGB6ctY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZABgXrbEDv3k1Yot+WW0Gme2iiShNqEPPHwyG7vEE7g9KTiyNb/MWcAKLcHqkuXdv
         OMpOYYjzxN4Iu6QKzeq02P+2si2vGOQSr17UKtUexBo1qwQpwV+Tjz5zl4E1cxzA+j
         N0ORd81hrviaBjxbWE7lcuVtzC6lczQC7wcq2Yy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 08/37] ip: fix tos reflection in ack and reset packets
Date:   Fri, 25 Sep 2020 14:48:36 +0200
Message-Id: <20200925124722.198455654@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <weiwan@google.com>

[ Upstream commit ba9e04a7ddf4f22a10e05bf9403db6b97743c7bf ]

Currently, in tcp_v4_reqsk_send_ack() and tcp_v4_send_reset(), we
echo the TOS value of the received packets in the response.
However, we do not want to echo the lower 2 ECN bits in accordance
with RFC 3168 6.1.5 robustness principles.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_output.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -73,6 +73,7 @@
 #include <net/icmp.h>
 #include <net/checksum.h>
 #include <net/inetpeer.h>
+#include <net/inet_ecn.h>
 #include <net/lwtunnel.h>
 #include <linux/bpf-cgroup.h>
 #include <linux/igmp.h>
@@ -1582,7 +1583,7 @@ void ip_send_unicast_reply(struct sock *
 	if (IS_ERR(rt))
 		return;
 
-	inet_sk(sk)->tos = arg->tos;
+	inet_sk(sk)->tos = arg->tos & ~INET_ECN_MASK;
 
 	sk->sk_priority = skb->priority;
 	sk->sk_protocol = ip_hdr(skb)->protocol;


