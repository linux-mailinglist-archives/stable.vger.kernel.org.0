Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31CF27CD01
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgI2LOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:14:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728302AbgI2LNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:13:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFFFB20848;
        Tue, 29 Sep 2020 11:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377997;
        bh=7SEeLCj5yQrMSigHSE5afT9jiaFPEXd9v2iN4C8SSbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDiedx9jDoarEiYXv4nu0J+NJnM6Bx7YmPj07UKdc/XIF9EpPkMtSczxoRRMcwSFG
         16gon/pcqtPwDSQHYHRRXyH2IubC+fJaskvUg6bbMhil7G1ul2xJjobT8BcVMmw2kK
         aRBpz32Y295/hdrT79+LHzjjgsapOFLOud9Y/yaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 008/166] ip: fix tos reflection in ack and reset packets
Date:   Tue, 29 Sep 2020 12:58:40 +0200
Message-Id: <20200929105935.611172942@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
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
@@ -1562,7 +1563,7 @@ void ip_send_unicast_reply(struct sock *
 	if (IS_ERR(rt))
 		return;
 
-	inet_sk(sk)->tos = arg->tos;
+	inet_sk(sk)->tos = arg->tos & ~INET_ECN_MASK;
 
 	sk->sk_priority = skb->priority;
 	sk->sk_protocol = ip_hdr(skb)->protocol;


