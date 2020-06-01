Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7451EADB4
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730337AbgFASrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730678AbgFASII (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:08:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A501207D0;
        Mon,  1 Jun 2020 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034887;
        bh=kVn8x1kydNngyAysBZ+UdkS1JAW1XNUyRrmBJQGKbEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqdU91VxbxLlbAgQsFaGsy2HYncNfw6NtGWuxbIB8ftDmEGyuD8E5kygJQBca26WM
         Goxvv8Ie1YY5lMF8sGnf+0uI+PYPpQkhsp/qgWC9lxONWKsKhWIfqo4DvU6szE6Ddk
         WW+PGlzh2ZHvWj/SjZv7HtLkoxD8lhphWiwFhnzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 020/142] tipc: block BH before using dst_cache
Date:   Mon,  1 Jun 2020 19:52:58 +0200
Message-Id: <20200601174039.942780034@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1378817486d6860f6a927f573491afe65287abf1 ]

dst_cache_get() documents it must be used with BH disabled.

sysbot reported :

BUG: using smp_processor_id() in preemptible [00000000] code: /21697
caller is dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
CPU: 0 PID: 21697 Comm:  Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_preemption_disabled lib/smp_processor_id.c:47 [inline]
 debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
 dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
 tipc_udp_xmit.isra.0+0xb9/0xad0 net/tipc/udp_media.c:164
 tipc_udp_send_msg+0x3e6/0x490 net/tipc/udp_media.c:244
 tipc_bearer_xmit_skb+0x1de/0x3f0 net/tipc/bearer.c:526
 tipc_enable_bearer+0xb2f/0xd60 net/tipc/bearer.c:331
 __tipc_nl_bearer_enable+0x2bf/0x390 net/tipc/bearer.c:995
 tipc_nl_bearer_enable+0x1e/0x30 net/tipc/bearer.c:1003
 genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
 genl_rcv_msg+0x627/0xdf0 net/netlink/genetlink.c:735
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45ca29

Fixes: e9c1a793210f ("tipc: add dst_cache support for udp media")
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/udp_media.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -161,9 +161,11 @@ static int tipc_udp_xmit(struct net *net
 			 struct udp_bearer *ub, struct udp_media_addr *src,
 			 struct udp_media_addr *dst, struct dst_cache *cache)
 {
-	struct dst_entry *ndst = dst_cache_get(cache);
+	struct dst_entry *ndst;
 	int ttl, err = 0;
 
+	local_bh_disable();
+	ndst = dst_cache_get(cache);
 	if (dst->proto == htons(ETH_P_IP)) {
 		struct rtable *rt = (struct rtable *)ndst;
 
@@ -210,9 +212,11 @@ static int tipc_udp_xmit(struct net *net
 					   src->port, dst->port, false);
 #endif
 	}
+	local_bh_enable();
 	return err;
 
 tx_error:
+	local_bh_enable();
 	kfree_skb(skb);
 	return err;
 }


