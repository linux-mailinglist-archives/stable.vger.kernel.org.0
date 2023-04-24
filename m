Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195176D4750
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbjDCOTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbjDCOTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:19:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2012C9DB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:19:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6925961D08
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827E9C433EF;
        Mon,  3 Apr 2023 14:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531543;
        bh=1H4liDx8uhvViNhIMzlNK62Fw1wGsRffls38wzsRseA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6HVKs5DqsciKhvKOdaSN3zvYIhzY6+8NLb0CnOOcRJlfYGlQBXhgaf6QURcT819l
         mrtVVfHolUiAYosuy6XGuwKaCG8b5ZWzXAEHPW+o1RSFHMwTyeTiKyz4gV6CLxdsJJ
         UDr+uqMKLJtBZcNNtVf5DXQbcn8MlswG18/9Ez5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/104] erspan: do not use skb_mac_header() in ndo_start_xmit()
Date:   Mon,  3 Apr 2023 16:08:11 +0200
Message-Id: <20230403140404.968598746@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8e50ed774554f93d55426039b27b1e38d7fa64d8 ]

Drivers should not assume skb_mac_header(skb) == skb->data in their
ndo_start_xmit().

Use skb_network_offset() and skb_transport_offset() which
better describe what is needed in erspan_fb_xmit() and
ip6erspan_tunnel_xmit()

syzbot reported:
WARNING: CPU: 0 PID: 5083 at include/linux/skbuff.h:2873 skb_mac_header include/linux/skbuff.h:2873 [inline]
WARNING: CPU: 0 PID: 5083 at include/linux/skbuff.h:2873 ip6erspan_tunnel_xmit+0x1d9c/0x2d90 net/ipv6/ip6_gre.c:962
Modules linked in:
CPU: 0 PID: 5083 Comm: syz-executor406 Not tainted 6.3.0-rc2-syzkaller-00866-gd4671cb96fa3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
RIP: 0010:skb_mac_header include/linux/skbuff.h:2873 [inline]
RIP: 0010:ip6erspan_tunnel_xmit+0x1d9c/0x2d90 net/ipv6/ip6_gre.c:962
Code: 04 02 41 01 de 84 c0 74 08 3c 03 0f 8e 1c 0a 00 00 45 89 b4 24 c8 00 00 00 c6 85 77 fe ff ff 01 e9 33 e7 ff ff e8 b4 27 a1 f8 <0f> 0b e9 b6 e7 ff ff e8 a8 27 a1 f8 49 8d bf f0 0c 00 00 48 b8 00
RSP: 0018:ffffc90003b2f830 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 000000000000ffff RCX: 0000000000000000
RDX: ffff888021273a80 RSI: ffffffff88e1bd4c RDI: 0000000000000003
RBP: ffffc90003b2f9d8 R08: 0000000000000003 R09: 000000000000ffff
R10: 000000000000ffff R11: 0000000000000000 R12: ffff88802b28da00
R13: 00000000000000d0 R14: ffff88807e25b6d0 R15: ffff888023408000
FS: 0000555556a61300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e5b11eb6e8 CR3: 0000000027c1b000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
__netdev_start_xmit include/linux/netdevice.h:4900 [inline]
netdev_start_xmit include/linux/netdevice.h:4914 [inline]
__dev_direct_xmit+0x504/0x730 net/core/dev.c:4300
dev_direct_xmit include/linux/netdevice.h:3088 [inline]
packet_xmit+0x20a/0x390 net/packet/af_packet.c:285
packet_snd net/packet/af_packet.c:3075 [inline]
packet_sendmsg+0x31a0/0x5150 net/packet/af_packet.c:3107
sock_sendmsg_nosec net/socket.c:724 [inline]
sock_sendmsg+0xde/0x190 net/socket.c:747
__sys_sendto+0x23a/0x340 net/socket.c:2142
__do_sys_sendto net/socket.c:2154 [inline]
__se_sys_sendto net/socket.c:2150 [inline]
__x64_sys_sendto+0xe1/0x1b0 net/socket.c:2150
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f123aaa1039
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc15d12058 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f123aaa1039
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000020000040 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f123aa648c0
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000

Fixes: 1baf5ebf8954 ("erspan: auto detect truncated packets.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230320163427.8096-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c  | 4 ++--
 net/ipv6/ip6_gre.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 52dbffb7bc2fd..317fdb9f47e88 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -525,7 +525,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		truncate = true;
 	}
 
-	nhoff = skb_network_header(skb) - skb_mac_header(skb);
+	nhoff = skb_network_offset(skb);
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
@@ -534,7 +534,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		int thoff;
 
 		if (skb_transport_header_was_set(skb))
-			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+			thoff = skb_transport_offset(skb);
 		else
 			thoff = nhoff + sizeof(struct ipv6hdr);
 		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index fd4da1019e44c..85ec466b5735e 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -942,7 +942,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		truncate = true;
 	}
 
-	nhoff = skb_network_header(skb) - skb_mac_header(skb);
+	nhoff = skb_network_offset(skb);
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
@@ -951,7 +951,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		int thoff;
 
 		if (skb_transport_header_was_set(skb))
-			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+			thoff = skb_transport_offset(skb);
 		else
 			thoff = nhoff + sizeof(struct ipv6hdr);
 		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
-- 
2.39.2



