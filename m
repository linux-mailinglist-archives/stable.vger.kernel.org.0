Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2DF311401
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbhBEVzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233008AbhBEO7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:59:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6135650BF;
        Fri,  5 Feb 2021 14:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534487;
        bh=e1prSTddSkWw/ilWFplrlJELLFrEZbDwcFhS0hiXMZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HND2+G0cTpzRjzffmy43+3EOflH5jaJDSc2E0x1BqGrdgn157Kr/GAetP10FoiDOG
         qm4YCKqtQn8O+aIDwq02yNMl1XWosgQK1IgWX11+MLIIr88RcX+nshQMvGhC6KX8ij
         4m2+69yeenMon9Z6BGKqIlp1ByF4YIEsnv8qaMGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 04/15] net_sched: reject silly cell_log in qdisc_get_rtab()
Date:   Fri,  5 Feb 2021 15:08:49 +0100
Message-Id: <20210205140649.905338362@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.733510103@linuxfoundation.org>
References: <20210205140649.733510103@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit e4bedf48aaa5552bc1f49703abd17606e7e6e82a upstream

iproute2 probably never goes beyond 8 for the cell exponent,
but stick to the max shift exponent for signed 32bit.

UBSAN reported:
UBSAN: shift-out-of-bounds in net/sched/sch_api.c:389:22
shift exponent 130 is too large for 32-bit type 'int'
CPU: 1 PID: 8450 Comm: syz-executor586 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x183/0x22e lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:148 [inline]
 __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
 __detect_linklayer+0x2a9/0x330 net/sched/sch_api.c:389
 qdisc_get_rtab+0x2b5/0x410 net/sched/sch_api.c:435
 cbq_init+0x28f/0x12c0 net/sched/sch_cbq.c:1180
 qdisc_create+0x801/0x1470 net/sched/sch_api.c:1246
 tc_modify_qdisc+0x9e3/0x1fc0 net/sched/sch_api.c:1662
 rtnetlink_rcv_msg+0xb1d/0xe60 net/core/rtnetlink.c:5564
 netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x7de/0x9b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xaa6/0xe90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x5a2/0x900 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x319/0x400 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/r/20210114160637.1660597-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_api.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -397,7 +397,8 @@ struct qdisc_rate_table *qdisc_get_rtab(
 {
 	struct qdisc_rate_table *rtab;
 
-	if (tab == NULL || r->rate == 0 || r->cell_log == 0 ||
+	if (tab == NULL || r->rate == 0 ||
+	    r->cell_log == 0 || r->cell_log >= 32 ||
 	    nla_len(tab) != TC_RTAB_SIZE)
 		return NULL;
 


