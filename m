Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41441BC7EC
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgD1S1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbgD1S1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:27:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06E6B208E0;
        Tue, 28 Apr 2020 18:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098473;
        bh=zlddwORQrlH5IAiGWGOgrWrkmekZCrnXInhF3wrWrA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfUQcp4nExM2rZZ+zvTByS0IjmFvdbRROcCgCKn+LGhsZbUwYhKMQaHWRJ/ZK+qad
         mrntbLc0fXEcqx2Y9XXtxvtUjvl6Yrshk2U9bbR/Ova/0sJgqU0ow5lt5z+ERKzfP7
         QN44tU2byGryH0Q0ujt5GrZerUdV/lK6hNfzoE7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        Yi-Hung Wei <yihung.wei@gmail.com>,
        syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 055/167] net: openvswitch: ovs_ct_exit to be done under ovs_lock
Date:   Tue, 28 Apr 2020 20:23:51 +0200
Message-Id: <20200428182231.932558521@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

[ Upstream commit 27de77cec985233bdf6546437b9761853265c505 ]

syzbot wrote:
| =============================
| WARNING: suspicious RCU usage
| 5.7.0-rc1+ #45 Not tainted
| -----------------------------
| net/openvswitch/conntrack.c:1898 RCU-list traversed in non-reader section!!
|
| other info that might help us debug this:
| rcu_scheduler_active = 2, debug_locks = 1
| ...
|
| stack backtrace:
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
| Workqueue: netns cleanup_net
| Call Trace:
| ...
| ovs_ct_exit
| ovs_exit_net
| ops_exit_list.isra.7
| cleanup_net
| process_one_work
| worker_thread

To avoid that warning, invoke the ovs_ct_exit under ovs_lock and add
lockdep_ovsl_is_held as optional lockdep expression.

Link: https://lore.kernel.org/lkml/000000000000e642a905a0cbee6e@google.com
Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Yi-Hung Wei <yihung.wei@gmail.com>
Reported-by: syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/conntrack.c |    3 ++-
 net/openvswitch/datapath.c  |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1895,7 +1895,8 @@ static void ovs_ct_limit_exit(struct net
 		struct hlist_head *head = &info->limits[i];
 		struct ovs_ct_limit *ct_limit;
 
-		hlist_for_each_entry_rcu(ct_limit, head, hlist_node)
+		hlist_for_each_entry_rcu(ct_limit, head, hlist_node,
+					 lockdep_ovsl_is_held())
 			kfree_rcu(ct_limit, rcu);
 	}
 	kfree(ovs_net->ct_limit_info->limits);
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2466,8 +2466,10 @@ static void __net_exit ovs_exit_net(stru
 	struct net *net;
 	LIST_HEAD(head);
 
-	ovs_ct_exit(dnet);
 	ovs_lock();
+
+	ovs_ct_exit(dnet);
+
 	list_for_each_entry_safe(dp, dp_next, &ovs_net->dps, list_node)
 		__dp_destroy(dp);
 


