Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170C84E294F
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348816AbiCUOD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349101AbiCUODU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:03:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3275B1786B2;
        Mon, 21 Mar 2022 07:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4A9961258;
        Mon, 21 Mar 2022 14:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCEFC340E8;
        Mon, 21 Mar 2022 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871204;
        bh=bo9zOKsSPOLCrZ6NcwOe8SeUBQioNcpisEYtpHqZqnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFXbMWCOT1sZOxxuHJENvIZI1dOUvvSz0LEsyZJcSJh5HtBFzlsqAbLxxU2cYuZFW
         Lb/7LY5L8643yMhROnQrMv54xM5VPvf5adNRKxuR/yxBaebIHwEOmK2sX3clBwfEM9
         Xkl+dzLdt8h7nG0kZfr4A/NhmHyQ/da6RF5tRg0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/32] net/packet: fix slab-out-of-bounds access in packet_recvmsg()
Date:   Mon, 21 Mar 2022 14:52:47 +0100
Message-Id: <20220321133220.889945628@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
References: <20220321133220.559554263@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c700525fcc06b05adfea78039de02628af79e07a ]

syzbot found that when an AF_PACKET socket is using PACKET_COPY_THRESH
and mmap operations, tpacket_rcv() is queueing skbs with
garbage in skb->cb[], triggering a too big copy [1]

Presumably, users of af_packet using mmap() already gets correct
metadata from the mapped buffer, we can simply make sure
to clear 12 bytes that might be copied to user space later.

BUG: KASAN: stack-out-of-bounds in memcpy include/linux/fortify-string.h:225 [inline]
BUG: KASAN: stack-out-of-bounds in packet_recvmsg+0x56c/0x1150 net/packet/af_packet.c:3489
Write of size 165 at addr ffffc9000385fb78 by task syz-executor233/3631

CPU: 0 PID: 3631 Comm: syz-executor233 Not tainted 5.17.0-rc7-syzkaller-02396-g0b3660695e80 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xf/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 memcpy+0x39/0x60 mm/kasan/shadow.c:66
 memcpy include/linux/fortify-string.h:225 [inline]
 packet_recvmsg+0x56c/0x1150 net/packet/af_packet.c:3489
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 ____sys_recvmsg+0x2c4/0x600 net/socket.c:2632
 ___sys_recvmsg+0x127/0x200 net/socket.c:2674
 __sys_recvmsg+0xe2/0x1a0 net/socket.c:2704
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fdfd5954c29
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcf8e71e48 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fdfd5954c29
RDX: 0000000000000000 RSI: 0000000020000500 RDI: 0000000000000005
RBP: 0000000000000000 R08: 000000000000000d R09: 000000000000000d
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffcf8e71e60
R13: 00000000000f4240 R14: 000000000000c1ff R15: 00007ffcf8e71e54
 </TASK>

addr ffffc9000385fb78 is located in stack of task syz-executor233/3631 at offset 32 in frame:
 ____sys_recvmsg+0x0/0x600 include/linux/uio.h:246

this frame has 1 object:
 [32, 160) 'addr'

Memory state around the buggy address:
 ffffc9000385fa80: 00 04 f3 f3 f3 f3 f3 00 00 00 00 00 00 00 00 00
 ffffc9000385fb00: 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1 00
>ffffc9000385fb80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f3
                                                                ^
 ffffc9000385fc00: f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00 f1
 ffffc9000385fc80: f1 f1 f1 00 f2 f2 f2 00 f2 f2 f2 00 00 00 00 00
==================================================================

Fixes: 0fb375fb9b93 ("[AF_PACKET]: Allow for > 8 byte hardware addresses.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20220312232958.3535620-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e00c38f242c3..c0d4a65931de 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2281,8 +2281,11 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 					copy_skb = skb_get(skb);
 					skb_head = skb->data;
 				}
-				if (copy_skb)
+				if (copy_skb) {
+					memset(&PACKET_SKB_CB(copy_skb)->sa.ll, 0,
+					       sizeof(PACKET_SKB_CB(copy_skb)->sa.ll));
 					skb_set_owner_r(copy_skb, sk);
+				}
 			}
 			snaplen = po->rx_ring.frame_size - macoff;
 			if ((int)snaplen < 0) {
@@ -3434,6 +3437,8 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
+		const size_t max_len = min(sizeof(skb->cb),
+					   sizeof(struct sockaddr_storage));
 		int copy_len;
 
 		/* If the address length field is there to be filled
@@ -3456,6 +3461,10 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 				msg->msg_namelen = sizeof(struct sockaddr_ll);
 			}
 		}
+		if (WARN_ON_ONCE(copy_len > max_len)) {
+			copy_len = max_len;
+			msg->msg_namelen = copy_len;
+		}
 		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
 	}
 
-- 
2.34.1



