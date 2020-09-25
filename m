Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11925278822
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbgIYMxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbgIYMxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:53:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3DD42072E;
        Fri, 25 Sep 2020 12:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038384;
        bh=Idsqmbq3GtrPqkrlt8ZauucC73oBNswDpqEKtNm/KbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dU2FeYJhq0EnjVYEssdDLBR2Qe7WP/PKeeVd/2yx7MwI4HRU33L5fyDZoPwDlmEm7
         1C6sW8UOXIE5jnlC8T5nGnEzSdHvi3/ZR29eZM81gPmu2cTsf7gzqvtP2r0VDHr8CN
         wShEgUNzInq5fJ2vQWiVICi3b/oP1wQErk7DUw4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 13/43] ip: fix tos reflection in ack and reset packets
Date:   Fri, 25 Sep 2020 14:48:25 +0200
Message-Id: <20200925124725.549029038@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
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
@@ -74,6 +74,7 @@
 #include <net/icmp.h>
 #include <net/checksum.h>
 #include <net/inetpeer.h>
+#include <net/inet_ecn.h>
 #include <net/lwtunnel.h>
 #include <linux/bpf-cgroup.h>
 #include <linux/igmp.h>
@@ -1699,7 +1700,7 @@ void ip_send_unicast_reply(struct sock *
 	if (IS_ERR(rt))
 		return;
 
-	inet_sk(sk)->tos = arg->tos;
+	inet_sk(sk)->tos = arg->tos & ~INET_ECN_MASK;
 
 	sk->sk_protocol = ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if = arg->bound_dev_if;


