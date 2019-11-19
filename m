Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C853710190B
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbfKSFWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbfKSFW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66F182231A;
        Tue, 19 Nov 2019 05:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140948;
        bh=L6RLN0ga6Us/fJjLbQ77BUQSJt7aTgp1YF6JLRdVaYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwIBtN2iFWstX+x5dXS/mSqbGkU3pbG0/EpVrKikaAIYLjLmFwnNxrvvhqCnlquBd
         kP9uiOH0skOl3VVtFu3G4fiAqjHORX/yzXsKG3tOzLRcZv5Ism/xjSeMXdsvONm8+A
         sWtVKjjRt2ViB7SaVx5AKU3HxpLpfHUWuV591V5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 04/48] ipmr: Fix skb headroom in ipmr_get_route().
Date:   Tue, 19 Nov 2019 06:19:24 +0100
Message-Id: <20191119050950.798307156@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 7901cd97963d6cbde88fa25a4a446db3554c16c6 ]

In route.c, inet_rtm_getroute_build_skb() creates an skb with no
headroom. This skb is then used by inet_rtm_getroute() which may pass
it to rt_fill_info() and, from there, to ipmr_get_route(). The later
might try to reuse this skb by cloning it and prepending an IPv4
header. But since the original skb has no headroom, skb_push() triggers
skb_under_panic():

skbuff: skb_under_panic: text:00000000ca46ad8a len:80 put:20 head:00000000cd28494e data:000000009366fd6b tail:0x3c end:0xec0 dev:veth0
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:108!
invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 6 PID: 587 Comm: ip Not tainted 5.4.0-rc6+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-2.fc30 04/01/2014
RIP: 0010:skb_panic+0xbf/0xd0
Code: 41 a2 ff 8b 4b 70 4c 8b 4d d0 48 c7 c7 20 76 f5 8b 44 8b 45 bc 48 8b 55 c0 48 8b 75 c8 41 54 41 57 41 56 41 55 e8 75 dc 7a ff <0f> 0b 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
RSP: 0018:ffff888059ddf0b0 EFLAGS: 00010286
RAX: 0000000000000086 RBX: ffff888060a315c0 RCX: ffffffff8abe4822
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88806c9a79cc
RBP: ffff888059ddf118 R08: ffffed100d9361b1 R09: ffffed100d9361b0
R10: ffff88805c68aee3 R11: ffffed100d9361b1 R12: ffff88805d218000
R13: ffff88805c689fec R14: 000000000000003c R15: 0000000000000ec0
FS:  00007f6af184b700(0000) GS:ffff88806c980000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc8204a000 CR3: 0000000057b40006 CR4: 0000000000360ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 skb_push+0x7e/0x80
 ipmr_get_route+0x459/0x6fa
 rt_fill_info+0x692/0x9f0
 inet_rtm_getroute+0xd26/0xf20
 rtnetlink_rcv_msg+0x45d/0x630
 netlink_rcv_skb+0x1a5/0x220
 rtnetlink_rcv+0x15/0x20
 netlink_unicast+0x305/0x3a0
 netlink_sendmsg+0x575/0x730
 sock_sendmsg+0xb5/0xc0
 ___sys_sendmsg+0x497/0x4f0
 __sys_sendmsg+0xcb/0x150
 __x64_sys_sendmsg+0x48/0x50
 do_syscall_64+0xd2/0xac0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Actually the original skb used to have enough headroom, but the
reserve_skb() call was lost with the introduction of
inet_rtm_getroute_build_skb() by commit 404eb77ea766 ("ipv4: support
sport, dport and ip_proto in RTM_GETROUTE").

We could reserve some headroom again in inet_rtm_getroute_build_skb(),
but this function shouldn't be responsible for handling the special
case of ipmr_get_route(). Let's handle that directly in
ipmr_get_route() by calling skb_realloc_headroom() instead of
skb_clone().

Fixes: 404eb77ea766 ("ipv4: support sport, dport and ip_proto in RTM_GETROUTE")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipmr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2289,7 +2289,8 @@ int ipmr_get_route(struct net *net, stru
 			rcu_read_unlock();
 			return -ENODEV;
 		}
-		skb2 = skb_clone(skb, GFP_ATOMIC);
+
+		skb2 = skb_realloc_headroom(skb, sizeof(struct iphdr));
 		if (!skb2) {
 			read_unlock(&mrt_lock);
 			rcu_read_unlock();


