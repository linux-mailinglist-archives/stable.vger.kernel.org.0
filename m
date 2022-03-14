Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5976E4D810B
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237818AbiCNLik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239234AbiCNLhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:37:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7BC433A3;
        Mon, 14 Mar 2022 04:36:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21ECAB80D96;
        Mon, 14 Mar 2022 11:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766E3C340E9;
        Mon, 14 Mar 2022 11:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257775;
        bh=qlrDATYtfqPu2mqxw9sZgbxz/1qZjr7i9KFMJjW5mYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiCwBO9kwPNA7xc9drNMJAo4Z9s1jXfoZmb5Lz8zljzahe5nSdpbXQ16bLAwUpa26
         Si5/7s4JHDvZg/r2dbPi2fBhCvFPCA5RFAG2FKLEYAlxeYG+/V07LtlD/n442jili7
         8gkIwszPTorLQTjGma2X6dQLtkJsRlYPTCjhAXQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/23] sctp: fix kernel-infoleak for SCTP sockets
Date:   Mon, 14 Mar 2022 12:34:23 +0100
Message-Id: <20220314112731.356741386@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.050583127@linuxfoundation.org>
References: <20220314112731.050583127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 633593a808980f82d251d0ca89730d8bb8b0220c ]

syzbot reported a kernel infoleak [1] of 4 bytes.

After analysis, it turned out r->idiag_expires is not initialized
if inet_sctp_diag_fill() calls inet_diag_msg_common_fill()

Make sure to clear idiag_timer/idiag_retrans/idiag_expires
and let inet_diag_msg_sctpasoc_fill() fill them again if needed.

[1]

BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline]
BUG: KMSAN: kernel-infoleak in copyout lib/iov_iter.c:154 [inline]
BUG: KMSAN: kernel-infoleak in _copy_to_iter+0x6ef/0x25a0 lib/iov_iter.c:668
 instrument_copy_to_user include/linux/instrumented.h:121 [inline]
 copyout lib/iov_iter.c:154 [inline]
 _copy_to_iter+0x6ef/0x25a0 lib/iov_iter.c:668
 copy_to_iter include/linux/uio.h:162 [inline]
 simple_copy_to_iter+0xf3/0x140 net/core/datagram.c:519
 __skb_datagram_iter+0x2d5/0x11b0 net/core/datagram.c:425
 skb_copy_datagram_iter+0xdc/0x270 net/core/datagram.c:533
 skb_copy_datagram_msg include/linux/skbuff.h:3696 [inline]
 netlink_recvmsg+0x669/0x1c80 net/netlink/af_netlink.c:1977
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 __sys_recvfrom+0x795/0xa10 net/socket.c:2097
 __do_sys_recvfrom net/socket.c:2115 [inline]
 __se_sys_recvfrom net/socket.c:2111 [inline]
 __x64_sys_recvfrom+0x19d/0x210 net/socket.c:2111
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:737 [inline]
 slab_alloc_node mm/slub.c:3247 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4975
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1158 [inline]
 netlink_dump+0x3e5/0x16c0 net/netlink/af_netlink.c:2248
 __netlink_dump_start+0xcf8/0xe90 net/netlink/af_netlink.c:2373
 netlink_dump_start include/linux/netlink.h:254 [inline]
 inet_diag_handler_cmd+0x2e7/0x400 net/ipv4/inet_diag.c:1341
 sock_diag_rcv_msg+0x24a/0x620
 netlink_rcv_skb+0x40c/0x7e0 net/netlink/af_netlink.c:2494
 sock_diag_rcv+0x63/0x80 net/core/sock_diag.c:277
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x1093/0x1360 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x14d9/0x1720 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 sock_write_iter+0x594/0x690 net/socket.c:1061
 do_iter_readv_writev+0xa7f/0xc70
 do_iter_write+0x52c/0x1500 fs/read_write.c:851
 vfs_writev fs/read_write.c:924 [inline]
 do_writev+0x645/0xe00 fs/read_write.c:967
 __do_sys_writev fs/read_write.c:1040 [inline]
 __se_sys_writev fs/read_write.c:1037 [inline]
 __x64_sys_writev+0xe5/0x120 fs/read_write.c:1037
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Bytes 68-71 of 2508 are uninitialized
Memory access of size 2508 starts at ffff888114f9b000
Data copied to user address 00007f7fe09ff2e0

CPU: 1 PID: 3478 Comm: syz-executor306 Not tainted 5.17.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/20220310001145.297371-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sctp_diag.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sctp_diag.c b/net/sctp/sctp_diag.c
index 7c7b476bad31..9c9d6cbdd14f 100644
--- a/net/sctp/sctp_diag.c
+++ b/net/sctp/sctp_diag.c
@@ -45,10 +45,6 @@ static void inet_diag_msg_sctpasoc_fill(struct inet_diag_msg *r,
 		r->idiag_timer = SCTP_EVENT_TIMEOUT_T3_RTX;
 		r->idiag_retrans = asoc->rtx_data_chunks;
 		r->idiag_expires = jiffies_to_msecs(t3_rtx->expires - jiffies);
-	} else {
-		r->idiag_timer = 0;
-		r->idiag_retrans = 0;
-		r->idiag_expires = 0;
 	}
 }
 
@@ -128,13 +124,14 @@ static int inet_sctp_diag_fill(struct sock *sk, struct sctp_association *asoc,
 	r = nlmsg_data(nlh);
 	BUG_ON(!sk_fullsock(sk));
 
+	r->idiag_timer = 0;
+	r->idiag_retrans = 0;
+	r->idiag_expires = 0;
 	if (asoc) {
 		inet_diag_msg_sctpasoc_fill(r, sk, asoc);
 	} else {
 		inet_diag_msg_common_fill(r, sk);
 		r->idiag_state = sk->sk_state;
-		r->idiag_timer = 0;
-		r->idiag_retrans = 0;
 	}
 
 	if (inet_diag_msg_attrs_fill(sk, skb, r, ext, user_ns, net_admin))
-- 
2.34.1



