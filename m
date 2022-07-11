Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306B7566DCD
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbiGEM1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbiGEMZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090C06431;
        Tue,  5 Jul 2022 05:18:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9645DB817D1;
        Tue,  5 Jul 2022 12:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E171BC341C7;
        Tue,  5 Jul 2022 12:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023480;
        bh=wuKprzqAZy3bD4LW+rLujthQcKFLaJ9Nym7b1Qb579A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4W2jY1nZv6qXDSB8ty4LaS4StLb63QeDkZB2WmMhTiSONzkgpWixrBKyGWwSnhgI
         4rujYxFfAYRYKFLWA/H4l15Af+nwsg9IT9W86d5YrvCzZG7AowFbHuZ3ElqV5Vp5Zr
         1ngNwwHwhqhXweYWPFIlkHpFDD5+0FgyjGU2pDXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.18 074/102] tunnels: do not assume mac header is set in skb_tunnel_check_pmtu()
Date:   Tue,  5 Jul 2022 13:58:40 +0200
Message-Id: <20220705115620.510777326@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 853a7614880231747040cada91d2b8d2e995c51a upstream.

Recently added debug in commit f9aefd6b2aa3 ("net: warn if mac header
was not set") caught a bug in skb_tunnel_check_pmtu(), as shown
in this syzbot report [1].

In ndo_start_xmit() paths, there is really no need to use skb->mac_header,
because skb->data is supposed to point at it.

[1] WARNING: CPU: 1 PID: 8604 at include/linux/skbuff.h:2784 skb_mac_header_len include/linux/skbuff.h:2784 [inline]
WARNING: CPU: 1 PID: 8604 at include/linux/skbuff.h:2784 skb_tunnel_check_pmtu+0x5de/0x2f90 net/ipv4/ip_tunnel_core.c:413
Modules linked in:
CPU: 1 PID: 8604 Comm: syz-executor.3 Not tainted 5.19.0-rc2-syzkaller-00443-g8720bd951b8e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:skb_mac_header_len include/linux/skbuff.h:2784 [inline]
RIP: 0010:skb_tunnel_check_pmtu+0x5de/0x2f90 net/ipv4/ip_tunnel_core.c:413
Code: 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 80 3c 02 00 0f 84 b9 fe ff ff 4c 89 ff e8 7c 0f d7 f9 e9 ac fe ff ff e8 c2 13 8a f9 <0f> 0b e9 28 fc ff ff e8 b6 13 8a f9 48 8b 54 24 70 48 b8 00 00 00
RSP: 0018:ffffc90002e4f520 EFLAGS: 00010212
RAX: 0000000000000324 RBX: ffff88804d5fd500 RCX: ffffc90005b52000
RDX: 0000000000040000 RSI: ffffffff87f05e3e RDI: 0000000000000003
RBP: ffffc90002e4f650 R08: 0000000000000003 R09: 000000000000ffff
R10: 000000000000ffff R11: 0000000000000000 R12: 000000000000ffff
R13: 0000000000000000 R14: 000000000000ffcd R15: 000000000000001f
FS: 00007f3babba9700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 0000000075319000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
geneve_xmit_skb drivers/net/geneve.c:927 [inline]
geneve_xmit+0xcf8/0x35d0 drivers/net/geneve.c:1107
__netdev_start_xmit include/linux/netdevice.h:4805 [inline]
netdev_start_xmit include/linux/netdevice.h:4819 [inline]
__dev_direct_xmit+0x500/0x730 net/core/dev.c:4309
dev_direct_xmit include/linux/netdevice.h:3007 [inline]
packet_direct_xmit+0x1b8/0x2c0 net/packet/af_packet.c:282
packet_snd net/packet/af_packet.c:3073 [inline]
packet_sendmsg+0x21f4/0x55d0 net/packet/af_packet.c:3104
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg+0xcf/0x120 net/socket.c:734
____sys_sendmsg+0x6eb/0x810 net/socket.c:2489
___sys_sendmsg+0xf3/0x170 net/socket.c:2543
__sys_sendmsg net/socket.c:2572 [inline]
__do_sys_sendmsg net/socket.c:2581 [inline]
__se_sys_sendmsg net/socket.c:2579 [inline]
__x64_sys_sendmsg+0x132/0x220 net/socket.c:2579
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f3baaa89109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3babba9168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f3baab9bf60 RCX: 00007f3baaa89109
RDX: 0000000000000000 RSI: 0000000020000a00 RDI: 0000000000000003
RBP: 00007f3baaae305d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe74f2543f R14: 00007f3babba9300 R15: 0000000000022000
</TASK>

Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -410,7 +410,7 @@ int skb_tunnel_check_pmtu(struct sk_buff
 	u32 mtu = dst_mtu(encap_dst) - headroom;
 
 	if ((skb_is_gso(skb) && skb_gso_validate_network_len(skb, mtu)) ||
-	    (!skb_is_gso(skb) && (skb->len - skb_mac_header_len(skb)) <= mtu))
+	    (!skb_is_gso(skb) && (skb->len - skb_network_offset(skb)) <= mtu))
 		return 0;
 
 	skb_dst_update_pmtu_no_confirm(skb, mtu);


