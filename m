Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB6A278811
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgIYMwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729290AbgIYMwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:52:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55BFF2075E;
        Fri, 25 Sep 2020 12:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038329;
        bh=FoBam2veeWQfEGkz6ViIW5Dqs9nvjPiWZ1sa5WoABDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJZcNVOWDPEBcx7bNAFjffDwRTlCwPjF2F+pfHfp8I84Lx4wWrQKOf6tyfLL4afJg
         qDpRAEZa8niQqb9As1lD/oCpPZpezQilBZUu2leseBASdi886GF3Xq44MsblRsZ9M1
         IDk1bKTiYaRt4m484Z3aHgEOx+PXaTUUEi0AC5fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuang Li <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 29/43] tipc: use skb_unshare() instead in tipc_buf_append()
Date:   Fri, 25 Sep 2020 14:48:41 +0200
Message-Id: <20200925124727.995311734@linuxfoundation.org>
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
@@ -140,7 +140,8 @@ int tipc_buf_append(struct sk_buff **hea
 	if (fragid == FIRST_FRAGMENT) {
 		if (unlikely(head))
 			goto err;
-		if (unlikely(skb_unclone(frag, GFP_ATOMIC)))
+		frag = skb_unshare(frag, GFP_ATOMIC);
+		if (unlikely(!frag))
 			goto err;
 		head = *headbuf = frag;
 		*buf = NULL;


