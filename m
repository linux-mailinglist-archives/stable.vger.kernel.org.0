Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EA14890E8
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbiAJH0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:26:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55802 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239278AbiAJHZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:25:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4DC1B81202;
        Mon, 10 Jan 2022 07:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C59C36AED;
        Mon, 10 Jan 2022 07:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799529;
        bh=k1pkdxJYuZfLin3wMDyj9JxHBcrS/bsXfkra77hIsEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0S9T3vzHQ9xi2iTOBoACclJvXEv4SCwZQZAMsi88YOddDcwUNTcPLealOT7ZTsrOF
         zpdqNfawD4/Bz/Ri1itHGZTSBu7OXD8SHbMUm6iuartwSJND1COMa3Rv0OhT26Hp+7
         XQUH/61xcPb/hRMNGE1nzmYQEY/bhoUV82EAFN4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 08/21] sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc
Date:   Mon, 10 Jan 2022 08:22:55 +0100
Message-Id: <20220110071813.084706313@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
References: <20220110071812.806606886@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 7d18a07897d07495ee140dd319b0e9265c0f68ba upstream.

tx_queue_len can be set to ~0U, we need to be more
careful about overflows.

__fls(0) is undefined, as this report shows:

UBSAN: shift-out-of-bounds in net/sched/sch_qfq.c:1430:24
shift exponent 51770272 is too large for 32-bit type 'int'
CPU: 0 PID: 25574 Comm: syz-executor.0 Not tainted 5.16.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x201/0x2d8 lib/dump_stack.c:106
 ubsan_epilogue lib/ubsan.c:151 [inline]
 __ubsan_handle_shift_out_of_bounds+0x494/0x530 lib/ubsan.c:330
 qfq_init_qdisc+0x43f/0x450 net/sched/sch_qfq.c:1430
 qdisc_create+0x895/0x1430 net/sched/sch_api.c:1253
 tc_modify_qdisc+0x9d9/0x1e20 net/sched/sch_api.c:1660
 rtnetlink_rcv_msg+0x934/0xe60 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x200/0x470 net/netlink/af_netlink.c:2496
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x814/0x9f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0xaea/0xe60 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0x5b9/0x910 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x280/0x370 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 462dbc9101ac ("pkt_sched: QFQ Plus: fair-queueing service at DRR cost")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_qfq.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1439,10 +1439,8 @@ static int qfq_init_qdisc(struct Qdisc *
 	if (err < 0)
 		return err;
 
-	if (qdisc_dev(sch)->tx_queue_len + 1 > QFQ_MAX_AGG_CLASSES)
-		max_classes = QFQ_MAX_AGG_CLASSES;
-	else
-		max_classes = qdisc_dev(sch)->tx_queue_len + 1;
+	max_classes = min_t(u64, (u64)qdisc_dev(sch)->tx_queue_len + 1,
+			    QFQ_MAX_AGG_CLASSES);
 	/* max_cl_shift = floor(log_2(max_classes)) */
 	max_cl_shift = __fls(max_classes);
 	q->max_agg_classes = 1<<max_cl_shift;


