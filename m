Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599FE27C341
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgI2LEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:04:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbgI2LDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:03:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E9F720C09;
        Tue, 29 Sep 2020 11:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377430;
        bh=ImMx++kpp07Hq0kepsuk/QTEl2u2P7t1iGvCh0958a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEX3H6Eug2HN9wW1VkNSL2sphnvCoEU50oC7X7i6+rnSZb05/anwL4DfT1XdnirrB
         aZqbG76vs9MvvLnJ9eCHjofL/bHL/AZL/HAqGt/aVxc7benhvkt9/JoXe5vXoCVOoI
         GWM3lZ9lGKOG2kXP9+2tvwxRYHv90DrEqS89dnfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuang Li <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 08/85] tipc: use skb_unshare() instead in tipc_buf_append()
Date:   Tue, 29 Sep 2020 12:59:35 +0200
Message-Id: <20200929105928.633391461@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit ff48b6222e65ebdba5a403ef1deba6214e749193 ]

In tipc_buf_append() it may change skb's frag_list, and it causes
problems when this skb is cloned. skb_unclone() doesn't really
make this skb's flag_list available to change.

Shuang Li has reported an use-after-free issue because of this
when creating quite a few macvlan dev over the same dev, where
the broadcast packets will be cloned and go up to the stack:

 [ ] BUG: KASAN: use-after-free in pskb_expand_head+0x86d/0xea0
 [ ] Call Trace:
 [ ]  dump_stack+0x7c/0xb0
 [ ]  print_address_description.constprop.7+0x1a/0x220
 [ ]  kasan_report.cold.10+0x37/0x7c
 [ ]  check_memory_region+0x183/0x1e0
 [ ]  pskb_expand_head+0x86d/0xea0
 [ ]  process_backlog+0x1df/0x660
 [ ]  net_rx_action+0x3b4/0xc90
 [ ]
 [ ] Allocated by task 1786:
 [ ]  kmem_cache_alloc+0xbf/0x220
 [ ]  skb_clone+0x10a/0x300
 [ ]  macvlan_broadcast+0x2f6/0x590 [macvlan]
 [ ]  macvlan_process_broadcast+0x37c/0x516 [macvlan]
 [ ]  process_one_work+0x66a/0x1060
 [ ]  worker_thread+0x87/0xb10
 [ ]
 [ ] Freed by task 3253:
 [ ]  kmem_cache_free+0x82/0x2a0
 [ ]  skb_release_data+0x2c3/0x6e0
 [ ]  kfree_skb+0x78/0x1d0
 [ ]  tipc_recvmsg+0x3be/0xa40 [tipc]

So fix it by using skb_unshare() instead, which would create a new
skb for the cloned frag and it'll be safe to change its frag_list.
The similar things were also done in sctp_make_reassembled_event(),
which is using skb_copy().

Reported-by: Shuang Li <shuali@redhat.com>
Fixes: 37e22164a8a3 ("tipc: rename and move message reassembly function")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/msg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -138,7 +138,8 @@ int tipc_buf_append(struct sk_buff **hea
 	if (fragid == FIRST_FRAGMENT) {
 		if (unlikely(head))
 			goto err;
-		if (unlikely(skb_unclone(frag, GFP_ATOMIC)))
+		frag = skb_unshare(frag, GFP_ATOMIC);
+		if (unlikely(!frag))
 			goto err;
 		head = *headbuf = frag;
 		*buf = NULL;


