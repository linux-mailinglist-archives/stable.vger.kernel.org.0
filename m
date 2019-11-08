Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F67CF5579
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390613AbfKHTCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390600AbfKHTCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:02:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFD11218AE;
        Fri,  8 Nov 2019 19:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239761;
        bh=vezJ62qKN7SM97dUKY4AMhuPYiu4Q4LvtGB+qGrNF5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WpUv3v5hCx5RDOASgFkw2kMqAAQT5o9LKC+xU9lwyIZ9NoIz9iKDwG5afQtPprD18
         /OhsQwxepKpMzMipOGwOcZpEqxKkQUkdSVqf8ZA9Q5/De2w3wUVzZMqzBLTWypP+Ut
         LmwuuIyXaq9pr+iFBf4HfsnOi8go68RC5clQsD7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 52/79] udp: fix data-race in udp_set_dev_scratch()
Date:   Fri,  8 Nov 2019 19:50:32 +0100
Message-Id: <20191108174815.485316010@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a793183caa9afae907a0d7ddd2ffd57329369bf5 ]

KCSAN reported a data-race in udp_set_dev_scratch() [1]

The issue here is that we must not write over skb fields
if skb is shared. A similar issue has been fixed in commit
89c22d8c3b27 ("net: Fix skb csum races when peeking")

While we are at it, use a helper only dealing with
udp_skb_scratch(skb)->csum_unnecessary, as this allows
udp_set_dev_scratch() to be called once and thus inlined.

[1]
BUG: KCSAN: data-race in udp_set_dev_scratch / udpv6_recvmsg

write to 0xffff888120278317 of 1 bytes by task 10411 on cpu 1:
 udp_set_dev_scratch+0xea/0x200 net/ipv4/udp.c:1308
 __first_packet_length+0x147/0x420 net/ipv4/udp.c:1556
 first_packet_length+0x68/0x2a0 net/ipv4/udp.c:1579
 udp_poll+0xea/0x110 net/ipv4/udp.c:2720
 sock_poll+0xed/0x250 net/socket.c:1256
 vfs_poll include/linux/poll.h:90 [inline]
 do_select+0x7d0/0x1020 fs/select.c:534
 core_sys_select+0x381/0x550 fs/select.c:677
 do_pselect.constprop.0+0x11d/0x160 fs/select.c:759
 __do_sys_pselect6 fs/select.c:784 [inline]
 __se_sys_pselect6 fs/select.c:769 [inline]
 __x64_sys_pselect6+0x12e/0x170 fs/select.c:769
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

read to 0xffff888120278317 of 1 bytes by task 10413 on cpu 0:
 udp_skb_csum_unnecessary include/net/udp.h:358 [inline]
 udpv6_recvmsg+0x43e/0xe90 net/ipv6/udp.c:310
 inet6_recvmsg+0xbb/0x240 net/ipv6/af_inet6.c:592
 sock_recvmsg_nosec+0x5c/0x70 net/socket.c:871
 ___sys_recvmsg+0x1a0/0x3e0 net/socket.c:2480
 do_recvmmsg+0x19a/0x5c0 net/socket.c:2601
 __sys_recvmmsg+0x1ef/0x200 net/socket.c:2680
 __do_sys_recvmmsg net/socket.c:2703 [inline]
 __se_sys_recvmmsg net/socket.c:2696 [inline]
 __x64_sys_recvmmsg+0x89/0xb0 net/socket.c:2696
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 10413 Comm: syz-executor.0 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 2276f58ac589 ("udp: use a separate rx queue for packet reception")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1270,6 +1270,20 @@ static void udp_set_dev_scratch(struct s
 		scratch->_tsize_state |= UDP_SKB_IS_STATELESS;
 }
 
+static void udp_skb_csum_unnecessary_set(struct sk_buff *skb)
+{
+	/* We come here after udp_lib_checksum_complete() returned 0.
+	 * This means that __skb_checksum_complete() might have
+	 * set skb->csum_valid to 1.
+	 * On 64bit platforms, we can set csum_unnecessary
+	 * to true, but only if the skb is not shared.
+	 */
+#if BITS_PER_LONG == 64
+	if (!skb_shared(skb))
+		udp_skb_scratch(skb)->csum_unnecessary = true;
+#endif
+}
+
 static int udp_skb_truesize(struct sk_buff *skb)
 {
 	return udp_skb_scratch(skb)->_tsize_state & ~UDP_SKB_IS_STATELESS;
@@ -1504,10 +1518,7 @@ static struct sk_buff *__first_packet_le
 			*total += skb->truesize;
 			kfree_skb(skb);
 		} else {
-			/* the csum related bits could be changed, refresh
-			 * the scratch area
-			 */
-			udp_set_dev_scratch(skb);
+			udp_skb_csum_unnecessary_set(skb);
 			break;
 		}
 	}


