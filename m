Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D547B681005
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbjA3N7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236826AbjA3N6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:58:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CF139CC6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:58:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DA8260FE0
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5A0C433D2;
        Mon, 30 Jan 2023 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087104;
        bh=8GU/kw5G7/rHc2P1sEzR+PzivwtEwdapU1zdzB03oXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oojdBdzWh4sNPeT3dwommSby7CmOQPQiP371choWrQp45ufz8zV7xw2skM3OuIWj
         6fBSLydoRjtnhVdeAYMePT/q0t2jGMS4PX0kbsKFoQrALBXqejCKdgQpQDyvDQ/GA5
         sdRL9PCC5DMCFxAzGbnqYbb414lmUtGoTB9d/FhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/313] net: enetc: avoid deadlock in enetc_tx_onestep_tstamp()
Date:   Mon, 30 Jan 2023 14:48:26 +0100
Message-Id: <20230130134339.983687043@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 3c463721a73bdb57a913e0d3124677a3758886fc ]

This lockdep splat says it better than I could:

================================
WARNING: inconsistent lock state
6.2.0-rc2-07010-ga9b9500ffaac-dirty #967 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
kworker/1:3/179 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffff3ec4036ce098 (_xmit_ETHER#2){+.?.}-{3:3}, at: netif_freeze_queues+0x5c/0xc0
{IN-SOFTIRQ-W} state was registered at:
  _raw_spin_lock+0x5c/0xc0
  sch_direct_xmit+0x148/0x37c
  __dev_queue_xmit+0x528/0x111c
  ip6_finish_output2+0x5ec/0xb7c
  ip6_finish_output+0x240/0x3f0
  ip6_output+0x78/0x360
  ndisc_send_skb+0x33c/0x85c
  ndisc_send_rs+0x54/0x12c
  addrconf_rs_timer+0x154/0x260
  call_timer_fn+0xb8/0x3a0
  __run_timers.part.0+0x214/0x26c
  run_timer_softirq+0x3c/0x74
  __do_softirq+0x14c/0x5d8
  ____do_softirq+0x10/0x20
  call_on_irq_stack+0x2c/0x5c
  do_softirq_own_stack+0x1c/0x30
  __irq_exit_rcu+0x168/0x1a0
  irq_exit_rcu+0x10/0x40
  el1_interrupt+0x38/0x64
irq event stamp: 7825
hardirqs last  enabled at (7825): [<ffffdf1f7200cae4>] exit_to_kernel_mode+0x34/0x130
hardirqs last disabled at (7823): [<ffffdf1f708105f0>] __do_softirq+0x550/0x5d8
softirqs last  enabled at (7824): [<ffffdf1f7081050c>] __do_softirq+0x46c/0x5d8
softirqs last disabled at (7811): [<ffffdf1f708166e0>] ____do_softirq+0x10/0x20

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(_xmit_ETHER#2);
  <Interrupt>
    lock(_xmit_ETHER#2);

 *** DEADLOCK ***

3 locks held by kworker/1:3/179:
 #0: ffff3ec400004748 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x1f4/0x6c0
 #1: ffff80000a0bbdc8 ((work_completion)(&priv->tx_onestep_tstamp)){+.+.}-{0:0}, at: process_one_work+0x1f4/0x6c0
 #2: ffff3ec4036cd438 (&dev->tx_global_lock){+.+.}-{3:3}, at: netif_tx_lock+0x1c/0x34

Workqueue: events enetc_tx_onestep_tstamp
Call trace:
 print_usage_bug.part.0+0x208/0x22c
 mark_lock+0x7f0/0x8b0
 __lock_acquire+0x7c4/0x1ce0
 lock_acquire.part.0+0xe0/0x220
 lock_acquire+0x68/0x84
 _raw_spin_lock+0x5c/0xc0
 netif_freeze_queues+0x5c/0xc0
 netif_tx_lock+0x24/0x34
 enetc_tx_onestep_tstamp+0x20/0x100
 process_one_work+0x28c/0x6c0
 worker_thread+0x74/0x450
 kthread+0x118/0x11c

but I'll say it anyway: the enetc_tx_onestep_tstamp() work item runs in
process context, therefore with softirqs enabled (i.o.w., it can be
interrupted by a softirq). If we hold the netif_tx_lock() when there is
an interrupt, and the NET_TX softirq then gets scheduled, this will take
the netif_tx_lock() a second time and deadlock the kernel.

To solve this, use netif_tx_lock_bh(), which blocks softirqs from
running.

Fixes: 7294380c5211 ("enetc: support PTP Sync packet one-step timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/20230112105440.1786799-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3a79ead5219a..e96449eedfb5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2290,14 +2290,14 @@ static void enetc_tx_onestep_tstamp(struct work_struct *work)
 
 	priv = container_of(work, struct enetc_ndev_priv, tx_onestep_tstamp);
 
-	netif_tx_lock(priv->ndev);
+	netif_tx_lock_bh(priv->ndev);
 
 	clear_bit_unlock(ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS, &priv->flags);
 	skb = skb_dequeue(&priv->tx_skbs);
 	if (skb)
 		enetc_start_xmit(skb, priv->ndev);
 
-	netif_tx_unlock(priv->ndev);
+	netif_tx_unlock_bh(priv->ndev);
 }
 
 static void enetc_tx_onestep_tstamp_init(struct enetc_ndev_priv *priv)
-- 
2.39.0



