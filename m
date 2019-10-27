Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972D3E68C6
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbfJ0VPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:15:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730661AbfJ0VPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:15:38 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FC07205C9;
        Sun, 27 Oct 2019 21:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210937;
        bh=3+6xcR6HMWluZuqTM5picN4Lb40T3NdoJmOQ1JBR3UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQ6vRGcsakULaIJUt3T79uPLgjkFsZKyz9zaXwGgTUKpcN62CuaaHEGAJj5l82P0K
         iLQu+Bud2SGM+0rdmdG8CEl6dAS4p3eZgxu8PVcjTNCmqGlzCWZSXsQ1IWdIbihd+3
         IRsKwy4kqmzdRg0JXCCvcamJxnIS5GQp7DnoyjEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com,
        syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 32/93] net: ipv6: fix listify ip6_rcv_finish in case of forwarding
Date:   Sun, 27 Oct 2019 22:00:44 +0100
Message-Id: <20191027203257.430392682@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit c7a42eb49212f93a800560662d17d5293960d3c3 ]

We need a similar fix for ipv6 as Commit 0761680d5215 ("net: ipv4: fix
listify ip_rcv_finish in case of forwarding") does for ipv4.

This issue can be reprocuded by syzbot since Commit 323ebb61e32b ("net:
use listified RX for handling GRO_NORMAL skbs") on net-next. The call
trace was:

  kernel BUG at include/linux/skbuff.h:2225!
  RIP: 0010:__skb_pull include/linux/skbuff.h:2225 [inline]
  RIP: 0010:skb_pull+0xea/0x110 net/core/skbuff.c:1902
  Call Trace:
    sctp_inq_pop+0x2f1/0xd80 net/sctp/inqueue.c:202
    sctp_endpoint_bh_rcv+0x184/0x8d0 net/sctp/endpointola.c:385
    sctp_inq_push+0x1e4/0x280 net/sctp/inqueue.c:80
    sctp_rcv+0x2807/0x3590 net/sctp/input.c:256
    sctp6_rcv+0x17/0x30 net/sctp/ipv6.c:1049
    ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
    ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
    NF_HOOK include/linux/netfilter.h:305 [inline]
    NF_HOOK include/linux/netfilter.h:299 [inline]
    ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
    dst_input include/net/dst.h:442 [inline]
    ip6_sublist_rcv_finish+0x98/0x1e0 net/ipv6/ip6_input.c:84
    ip6_list_rcv_finish net/ipv6/ip6_input.c:118 [inline]
    ip6_sublist_rcv+0x80c/0xcf0 net/ipv6/ip6_input.c:282
    ipv6_list_rcv+0x373/0x4b0 net/ipv6/ip6_input.c:316
    __netif_receive_skb_list_ptype net/core/dev.c:5049 [inline]
    __netif_receive_skb_list_core+0x5fc/0x9d0 net/core/dev.c:5097
    __netif_receive_skb_list net/core/dev.c:5149 [inline]
    netif_receive_skb_list_internal+0x7eb/0xe60 net/core/dev.c:5244
    gro_normal_list.part.0+0x1e/0xb0 net/core/dev.c:5757
    gro_normal_list net/core/dev.c:5755 [inline]
    gro_normal_one net/core/dev.c:5769 [inline]
    napi_frags_finish net/core/dev.c:5782 [inline]
    napi_gro_frags+0xa6a/0xea0 net/core/dev.c:5855
    tun_get_user+0x2e98/0x3fa0 drivers/net/tun.c:1974
    tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2020

Fixes: d8269e2cbf90 ("net: ipv6: listify ipv6_rcv() and ip6_rcv_finish()")
Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
Reported-by: syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_input.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -80,8 +80,10 @@ static void ip6_sublist_rcv_finish(struc
 {
 	struct sk_buff *skb, *next;
 
-	list_for_each_entry_safe(skb, next, head, list)
+	list_for_each_entry_safe(skb, next, head, list) {
+		skb_list_del_init(skb);
 		dst_input(skb);
+	}
 }
 
 static void ip6_list_rcv_finish(struct net *net, struct sock *sk,


