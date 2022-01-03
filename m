Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670114831C2
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbiACOVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:21:43 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45310 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiACOVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:21:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6A80DCE1107;
        Mon,  3 Jan 2022 14:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4884BC36AED;
        Mon,  3 Jan 2022 14:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219695;
        bh=UScpXn/wm8MPz2o3vK9ue4lnQ9EvfPsRuqBaEo5WgYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBtkbLPvSGjqlU+VaYV806Rz6BMMNd0+EX0ytvXogTDsVT89fbSTUVg/GazuaPBVs
         C9s82SFmTN/YdtkbKx4cwthvrWT/kTOUE1YhKZV/AgMtPQ5AUTzNI3CmRdXy1tn0cA
         alspmctGNJca9RYQr6l7QCWrPsPpke32B4MaSpls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Fam Zheng <fam.zheng@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 11/11] net: fix use-after-free in tw_timer_handler
Date:   Mon,  3 Jan 2022 15:21:22 +0100
Message-Id: <20220103142051.133867607@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142050.763904028@linuxfoundation.org>
References: <20220103142050.763904028@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit e22e45fc9e41bf9fcc1e92cfb78eb92786728ef0 upstream.

A real world panic issue was found as follow in Linux 5.4.

    BUG: unable to handle page fault for address: ffffde49a863de28
    PGD 7e6fe62067 P4D 7e6fe62067 PUD 7e6fe63067 PMD f51e064067 PTE 0
    RIP: 0010:tw_timer_handler+0x20/0x40
    Call Trace:
     <IRQ>
     call_timer_fn+0x2b/0x120
     run_timer_softirq+0x1ef/0x450
     __do_softirq+0x10d/0x2b8
     irq_exit+0xc7/0xd0
     smp_apic_timer_interrupt+0x68/0x120
     apic_timer_interrupt+0xf/0x20

This issue was also reported since 2017 in the thread [1],
unfortunately, the issue was still can be reproduced after fixing
DCCP.

The ipv4_mib_exit_net is called before tcp_sk_exit_batch when a net
namespace is destroyed since tcp_sk_ops is registered befrore
ipv4_mib_ops, which means tcp_sk_ops is in the front of ipv4_mib_ops
in the list of pernet_list. There will be a use-after-free on
net->mib.net_statistics in tw_timer_handler after ipv4_mib_exit_net
if there are some inflight time-wait timers.

This bug is not introduced by commit f2bf415cfed7 ("mib: add net to
NET_ADD_STATS_BH") since the net_statistics is a global variable
instead of dynamic allocation and freeing. Actually, commit
61a7e26028b9 ("mib: put net statistics on struct net") introduces
the bug since it put net statistics on struct net and free it when
net namespace is destroyed.

Moving init_ipv4_mibs() to the front of tcp_init() to fix this bug
and replace pr_crit() with panic() since continuing is meaningless
when init_ipv4_mibs() fails.

[1] https://groups.google.com/g/syzkaller/c/p1tn-_Kc6l4/m/smuL_FMAAgAJ?pli=1

Fixes: 61a7e26028b9 ("mib: put net statistics on struct net")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Cong Wang <cong.wang@bytedance.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211228104145.9426-1-songmuchun@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/af_inet.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1770,6 +1770,10 @@ static int __init inet_init(void)
 
 	tcp_v4_init();
 
+	/* Initialise per-cpu ipv4 mibs */
+	if (init_ipv4_mibs())
+		panic("%s: Cannot init ipv4 mibs\n", __func__);
+
 	/* Setup TCP slab cache for open requests. */
 	tcp_init();
 
@@ -1798,12 +1802,6 @@ static int __init inet_init(void)
 
 	if (init_inet_pernet_ops())
 		pr_crit("%s: Cannot init ipv4 inet pernet ops\n", __func__);
-	/*
-	 *	Initialise per-cpu ipv4 mibs
-	 */
-
-	if (init_ipv4_mibs())
-		pr_crit("%s: Cannot init ipv4 mibs\n", __func__);
 
 	ipv4_proc_init();
 


