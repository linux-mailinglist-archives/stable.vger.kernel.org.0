Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE99F48325B
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbiACO1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbiACO0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:26:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57886C0613A1;
        Mon,  3 Jan 2022 06:26:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECD6661120;
        Mon,  3 Jan 2022 14:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C047DC36AED;
        Mon,  3 Jan 2022 14:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219974;
        bh=jED4MMMF8uJ7RjfVPWjHWnawzmPhyXcRoRLQ81V70nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVsDvi6n5bdO4DGDly2LXcwgtb70lItGgEMnWeJkvCDs3PAzpahHGwd99HbE1Dk1M
         ac+ABDg9sunNGy2FQz4yZbW3giWzyJrKyRx/WXHu2CkrqiEXWLiWv+8mBs4HqX0bQJ
         mKf9+IP0xggKmFvt1y4AqZa2E1roLNZXonbzwJos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Fam Zheng <fam.zheng@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 27/27] net: fix use-after-free in tw_timer_handler
Date:   Mon,  3 Jan 2022 15:24:07 +0100
Message-Id: <20220103142053.046633087@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
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
@@ -1955,6 +1955,10 @@ static int __init inet_init(void)
 
 	ip_init();
 
+	/* Initialise per-cpu ipv4 mibs */
+	if (init_ipv4_mibs())
+		panic("%s: Cannot init ipv4 mibs\n", __func__);
+
 	/* Setup TCP slab cache for open requests. */
 	tcp_init();
 
@@ -1983,12 +1987,6 @@ static int __init inet_init(void)
 
 	if (init_inet_pernet_ops())
 		pr_crit("%s: Cannot init ipv4 inet pernet ops\n", __func__);
-	/*
-	 *	Initialise per-cpu ipv4 mibs
-	 */
-
-	if (init_ipv4_mibs())
-		pr_crit("%s: Cannot init ipv4 mibs\n", __func__);
 
 	ipv4_proc_init();
 


