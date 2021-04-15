Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E55360CF2
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhDOOzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234359AbhDOOyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DB8E613E9;
        Thu, 15 Apr 2021 14:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498376;
        bh=pXS7HcrEri1qk/T2C4B0R49ir6M9TZCkcZPLOhAro5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhGJVFcSGDMshOThK3eYKtLKCgsSEoXW3FezhG+rLz42nabvyHBIP9kl0ViaC5lgA
         b6D/R0aEoTQq56MeyzkgzqFqaStxtPGrp7qp2o5sL74ZKqB0ZAvP8VG1oiAjhqnmwe
         5uUOiMKjtZqPe1IAhXmm35dDemc4rQwWUzLXLQt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Balazs Nemeth <bnemeth@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 16/68] net: ensure mac header is set in virtio_net_hdr_to_skb()
Date:   Thu, 15 Apr 2021 16:46:57 +0200
Message-Id: <20210415144414.998180483@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 61431a5907fc36d0738e9a547c7e1556349a03e9 upstream.

Commit 924a9bc362a5 ("net: check if protocol extracted by virtio_net_hdr_set_proto is correct")
added a call to dev_parse_header_protocol() but mac_header is not yet set.

This means that eth_hdr() reads complete garbage, and syzbot complained about it [1]

This patch resets mac_header earlier, to get more coverage about this change.

Audit of virtio_net_hdr_to_skb() callers shows that this change should be safe.

[1]

BUG: KASAN: use-after-free in eth_header_parse_protocol+0xdc/0xe0 net/ethernet/eth.c:282
Read of size 2 at addr ffff888017a6200b by task syz-executor313/8409

CPU: 1 PID: 8409 Comm: syz-executor313 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 eth_header_parse_protocol+0xdc/0xe0 net/ethernet/eth.c:282
 dev_parse_header_protocol include/linux/netdevice.h:3177 [inline]
 virtio_net_hdr_to_skb.constprop.0+0x99d/0xcd0 include/linux/virtio_net.h:83
 packet_snd net/packet/af_packet.c:2994 [inline]
 packet_sendmsg+0x2325/0x52b0 net/packet/af_packet.c:3031
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 sock_no_sendpage+0xf3/0x130 net/core/sock.c:2860
 kernel_sendpage.part.0+0x1ab/0x350 net/socket.c:3631
 kernel_sendpage net/socket.c:3628 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:947
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 do_splice+0xb7e/0x1940 fs/splice.c:1079
 __do_splice+0x134/0x250 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1350 [inline]
 __se_sys_splice fs/splice.c:1332 [inline]
 __x64_sys_splice+0x198/0x250 fs/splice.c:1332
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46

Fixes: 924a9bc362a5 ("net: check if protocol extracted by virtio_net_hdr_set_proto is correct")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Balazs Nemeth <bnemeth@redhat.com>
Cc: Willem de Bruijn <willemb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/virtio_net.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -62,6 +62,8 @@ static inline int virtio_net_hdr_to_skb(
 			return -EINVAL;
 	}
 
+	skb_reset_mac_header(skb);
+
 	if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
 		u16 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
 		u16 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);


