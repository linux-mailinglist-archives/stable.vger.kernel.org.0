Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2774BE82E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349425AbiBUJ1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:27:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350116AbiBUJ1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8831C5F76;
        Mon, 21 Feb 2022 01:11:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 07F0ECE0E79;
        Mon, 21 Feb 2022 09:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE60C340E9;
        Mon, 21 Feb 2022 09:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434698;
        bh=NiDEqgNTM0anrzgdi52tONruLfv+bKxdiq4x0ThFYBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQlR7etQ3360leVAcMtswAkPCMEank+l+Im0vSN9gU1MwbeGohFgfYMKiW/5GwSJJ
         0kDPZAv1SH/zSfSs6TnC0i3rJb/R6W3TY4YchiuF8V/LqruZn2o0KSJmsIClqD4Iq4
         muAMVEV9Wplk1GXEfhIIlk+mUKLR1fVNGYRu1tUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 099/196] bonding: fix data-races around agg_select_timer
Date:   Mon, 21 Feb 2022 09:48:51 +0100
Message-Id: <20220221084934.259088041@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 9ceaf6f76b203682bb6100e14b3d7da4c0bedde8 upstream.

syzbot reported that two threads might write over agg_select_timer
at the same time. Make agg_select_timer atomic to fix the races.

BUG: KCSAN: data-race in bond_3ad_initiate_agg_selection / bond_3ad_state_machine_handler

read to 0xffff8881242aea90 of 4 bytes by task 1846 on cpu 1:
 bond_3ad_state_machine_handler+0x99/0x2810 drivers/net/bonding/bond_3ad.c:2317
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x1bf/0x1e0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

write to 0xffff8881242aea90 of 4 bytes by task 25910 on cpu 0:
 bond_3ad_initiate_agg_selection+0x18/0x30 drivers/net/bonding/bond_3ad.c:1998
 bond_open+0x658/0x6f0 drivers/net/bonding/bond_main.c:3967
 __dev_open+0x274/0x3a0 net/core/dev.c:1407
 dev_open+0x54/0x190 net/core/dev.c:1443
 bond_enslave+0xcef/0x3000 drivers/net/bonding/bond_main.c:1937
 do_set_master net/core/rtnetlink.c:2532 [inline]
 do_setlink+0x94f/0x2500 net/core/rtnetlink.c:2736
 __rtnl_newlink net/core/rtnetlink.c:3414 [inline]
 rtnl_newlink+0xfeb/0x13e0 net/core/rtnetlink.c:3529
 rtnetlink_rcv_msg+0x745/0x7e0 net/core/rtnetlink.c:5594
 netlink_rcv_skb+0x14e/0x250 net/netlink/af_netlink.c:2494
 rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:5612
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x602/0x6d0 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x728/0x850 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmsg+0x195/0x230 net/socket.c:2496
 __do_sys_sendmsg net/socket.c:2505 [inline]
 __se_sys_sendmsg net/socket.c:2503 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2503
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000050 -> 0x0000004f

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 25910 Comm: syz-executor.1 Tainted: G        W         5.17.0-rc4-syzkaller-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_3ad.c |   30 +++++++++++++++++++++++++-----
 include/net/bond_3ad.h         |    2 +-
 2 files changed, 26 insertions(+), 6 deletions(-)

--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -225,7 +225,7 @@ static inline int __check_agg_selection_
 	if (bond == NULL)
 		return 0;
 
-	return BOND_AD_INFO(bond).agg_select_timer ? 1 : 0;
+	return atomic_read(&BOND_AD_INFO(bond).agg_select_timer) ? 1 : 0;
 }
 
 /**
@@ -1995,7 +1995,7 @@ static void ad_marker_response_received(
  */
 void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
 {
-	BOND_AD_INFO(bond).agg_select_timer = timeout;
+	atomic_set(&BOND_AD_INFO(bond).agg_select_timer, timeout);
 }
 
 /**
@@ -2279,6 +2279,28 @@ void bond_3ad_update_ad_actor_settings(s
 }
 
 /**
+ * bond_agg_timer_advance - advance agg_select_timer
+ * @bond:  bonding structure
+ *
+ * Return true when agg_select_timer reaches 0.
+ */
+static bool bond_agg_timer_advance(struct bonding *bond)
+{
+	int val, nval;
+
+	while (1) {
+		val = atomic_read(&BOND_AD_INFO(bond).agg_select_timer);
+		if (!val)
+			return false;
+		nval = val - 1;
+		if (atomic_cmpxchg(&BOND_AD_INFO(bond).agg_select_timer,
+				   val, nval) == val)
+			break;
+	}
+	return nval == 0;
+}
+
+/**
  * bond_3ad_state_machine_handler - handle state machines timeout
  * @work: work context to fetch bonding struct to work on from
  *
@@ -2313,9 +2335,7 @@ void bond_3ad_state_machine_handler(stru
 	if (!bond_has_slaves(bond))
 		goto re_arm;
 
-	/* check if agg_select_timer timer after initialize is timed out */
-	if (BOND_AD_INFO(bond).agg_select_timer &&
-	    !(--BOND_AD_INFO(bond).agg_select_timer)) {
+	if (bond_agg_timer_advance(bond)) {
 		slave = bond_first_slave_rcu(bond);
 		port = slave ? &(SLAVE_AD_INFO(slave)->port) : NULL;
 
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -262,7 +262,7 @@ struct ad_system {
 struct ad_bond_info {
 	struct ad_system system;	/* 802.3ad system structure */
 	struct bond_3ad_stats stats;
-	u32 agg_select_timer;		/* Timer to select aggregator after all adapter's hand shakes */
+	atomic_t agg_select_timer;		/* Timer to select aggregator after all adapter's hand shakes */
 	u16 aggregator_identifier;
 };
 


