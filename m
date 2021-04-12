Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939CC35C04F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238655AbhDLJMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239606AbhDLJIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:08:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 166E161220;
        Mon, 12 Apr 2021 09:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218239;
        bh=+e2r2grzBTdyP+uMHvEFBRxFfA8UirfmEE45ddhy5y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZyz9Bj7JNXrynb1FXVDqcfahPQDf5DRAbE0cpL72mfKCKTgswhn1mdB/AotWVNuY
         i8ERiEtXo5hYq+vWRQRPM+BpV6+2tMvXrAxG8fsTFAlRvuGhZjAs8sLKyAHUslNutQ
         yCHOmSRB9g3zrkIwh2qJUMggQKSIsmJP/FznbSQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 122/210] sch_red: fix off-by-one checks in red_check_params()
Date:   Mon, 12 Apr 2021 10:40:27 +0200
Message-Id: <20210412084020.073423406@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3a87571f0ffc51ba3bf3ecdb6032861d0154b164 ]

This fixes following syzbot report:

UBSAN: shift-out-of-bounds in ./include/net/red.h:237:23
shift exponent 32 is too large for 32-bit type 'unsigned int'
CPU: 1 PID: 8418 Comm: syz-executor170 Not tainted 5.12.0-rc4-next-20210324-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
 red_set_parms include/net/red.h:237 [inline]
 choke_change.cold+0x3c/0xc8 net/sched/sch_choke.c:414
 qdisc_create+0x475/0x12f0 net/sched/sch_api.c:1247
 tc_modify_qdisc+0x4c8/0x1a50 net/sched/sch_api.c:1663
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f039
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdfa725168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f039
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 0000000000403020 R08: 0000000000400488 R09: 0000000000400488
R10: 0000000000400488 R11: 0000000000000246 R12: 00000000004030b0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488

Fixes: 8afa10cbe281 ("net_sched: red: Avoid illegal values")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/red.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/red.h b/include/net/red.h
index 9e6647c4ccd1..cc9f6b0d7f1e 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -171,9 +171,9 @@ static inline void red_set_vars(struct red_vars *v)
 static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog,
 				    u8 Scell_log, u8 *stab)
 {
-	if (fls(qth_min) + Wlog > 32)
+	if (fls(qth_min) + Wlog >= 32)
 		return false;
-	if (fls(qth_max) + Wlog > 32)
+	if (fls(qth_max) + Wlog >= 32)
 		return false;
 	if (Scell_log >= 32)
 		return false;
-- 
2.30.2



