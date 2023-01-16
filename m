Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC3966C8E3
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbjAPQoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbjAPQn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:43:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64254274BB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:31:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DD11B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D0EC433D2;
        Mon, 16 Jan 2023 16:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886672;
        bh=0cBI1m2B+X6vijZV7z/XgLMIUfD+Eh6hR0oG2lIwtF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evOTMUot4e4ATQJzVP31My/zsz1mk/ED+s0e8J/hUrMltjx9T52cYx+sy/F35rUUd
         2Cx6WE2teZNKEGsyCuym2V4OYBHYtLPYjfsMoIgk9HYQzg+0r1z5VKgSgIFWref2sp
         y25hnafugw1bB+yXVW8Jy06PNzuk51/drAVeiSEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 5.4 478/658] net/af_packet: make sure to pull mac header
Date:   Mon, 16 Jan 2023 16:49:26 +0100
Message-Id: <20230116154931.348408864@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit e9d3f80935b6607dcdc5682b00b1d4b28e0a0c5d upstream.

GSO assumes skb->head contains link layer headers.

tun device in some case can provide base 14 bytes,
regardless of VLAN being used or not.

After blamed commit, we can end up setting a network
header offset of 18+, we better pull the missing
bytes to avoid a posible crash in GSO.

syzbot report was:
kernel BUG at include/linux/skbuff.h:2699!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 3601 Comm: syz-executor210 Not tainted 5.18.0-syzkaller-11338-g2c5ca23f7414 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__skb_pull include/linux/skbuff.h:2699 [inline]
RIP: 0010:skb_mac_gso_segment+0x48f/0x530 net/core/gro.c:136
Code: 00 48 c7 c7 00 96 d4 8a c6 05 cb d3 45 06 01 e8 26 bb d0 01 e9 2f fd ff ff 49 c7 c4 ea ff ff ff e9 f1 fe ff ff e8 91 84 19 fa <0f> 0b 48 89 df e8 97 44 66 fa e9 7f fd ff ff e8 ad 44 66 fa e9 48
RSP: 0018:ffffc90002e2f4b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000012 RCX: 0000000000000000
RDX: ffff88805bb58000 RSI: ffffffff8760ed0f RDI: 0000000000000004
RBP: 0000000000005dbc R08: 0000000000000004 R09: 0000000000000fe0
R10: 0000000000000fe4 R11: 0000000000000000 R12: 0000000000000fe0
R13: ffff88807194d780 R14: 1ffff920005c5e9b R15: 0000000000000012
FS:  000055555730f300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200015c0 CR3: 0000000071ff8000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 __skb_gso_segment+0x327/0x6e0 net/core/dev.c:3411
 skb_gso_segment include/linux/netdevice.h:4749 [inline]
 validate_xmit_skb+0x6bc/0xf10 net/core/dev.c:3669
 validate_xmit_skb_list+0xbc/0x120 net/core/dev.c:3719
 sch_direct_xmit+0x3d1/0xbe0 net/sched/sch_generic.c:327
 __dev_xmit_skb net/core/dev.c:3815 [inline]
 __dev_queue_xmit+0x14a1/0x3a00 net/core/dev.c:4219
 packet_snd net/packet/af_packet.c:3071 [inline]
 packet_sendmsg+0x21cb/0x5550 net/packet/af_packet.c:3102
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f4b95da06c9
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd7defc4c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffd7defc4f0 RCX: 00007f4b95da06c9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 0000000000000003 R08: bb1414ac00000050 R09: bb1414ac00000050
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd7defc4e0 R14: 00007ffd7defc4d8 R15: 00007ffd7defc4d4
 </TASK>

Fixes: dfed913e8b55 ("net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1875,8 +1875,10 @@ static void packet_parse_headers(struct
 	/* Move network header to the right position for VLAN tagged packets */
 	if (likely(skb->dev->type == ARPHRD_ETHER) &&
 	    eth_type_vlan(skb->protocol) &&
-	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
-		skb_set_network_header(skb, depth);
+	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0) {
+		if (pskb_may_pull(skb, depth))
+			skb_set_network_header(skb, depth);
+	}
 
 	skb_probe_transport_header(skb);
 }


