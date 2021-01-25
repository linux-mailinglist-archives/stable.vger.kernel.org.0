Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130DE304AFE
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbhAZExO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:53:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbhAYSre (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 490FD20665;
        Mon, 25 Jan 2021 18:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600411;
        bh=rhdd9zoGwTGc+vAf2PO+qrNMwyqttEzin2sdVGvKGeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMIW16PItlgyy5wYyRq8XR0rAeXB4As0eC8ee67qcom/aI2X+kS5AECXLt/AVSAkR
         22u02BJ6C4GDFJYLh1nBYNNhrITP1bAl8gO0rQvFEC6tCFeCdkf69GtPOpJKoKSh8T
         8df1sFkJVFztWWZ2XeB/zNIeZ3e9DJjW1Thv9h9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 79/86] net_sched: avoid shift-out-of-bounds in tcindex_set_parms()
Date:   Mon, 25 Jan 2021 19:40:01 +0100
Message-Id: <20210125183204.395227355@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit bcd0cf19ef8258ac31b9a20248b05c15a1f4b4b0 upstream.

tc_index being 16bit wide, we need to check that TCA_TCINDEX_SHIFT
attribute is not silly.

UBSAN: shift-out-of-bounds in net/sched/cls_tcindex.c:260:29
shift exponent 255 is too large for 32-bit type 'int'
CPU: 0 PID: 8516 Comm: syz-executor228 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 valid_perfect_hash net/sched/cls_tcindex.c:260 [inline]
 tcindex_set_parms.cold+0x1b/0x215 net/sched/cls_tcindex.c:425
 tcindex_change+0x232/0x340 net/sched/cls_tcindex.c:546
 tc_new_tfilter+0x13fb/0x21b0 net/sched/cls_api.c:2127
 rtnetlink_rcv_msg+0x8b6/0xb80 net/core/rtnetlink.c:5555
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2336
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2390
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2423
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20210114185229.1742255-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/cls_tcindex.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -366,9 +366,13 @@ tcindex_set_parms(struct net *net, struc
 	if (tb[TCA_TCINDEX_MASK])
 		cp->mask = nla_get_u16(tb[TCA_TCINDEX_MASK]);
 
-	if (tb[TCA_TCINDEX_SHIFT])
+	if (tb[TCA_TCINDEX_SHIFT]) {
 		cp->shift = nla_get_u32(tb[TCA_TCINDEX_SHIFT]);
-
+		if (cp->shift > 16) {
+			err = -EINVAL;
+			goto errout;
+		}
+	}
 	if (!cp->hash) {
 		/* Hash not specified, use perfect hash if the upper limit
 		 * of the hashing index is below the threshold.


