Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53CAC4BE10B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346995AbiBUJDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347135AbiBUJAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:00:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B22275EC;
        Mon, 21 Feb 2022 00:55:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26E3C60FB6;
        Mon, 21 Feb 2022 08:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0BFC340EB;
        Mon, 21 Feb 2022 08:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433746;
        bh=L0t5YggnSs2Fv0Sq5c+rxg4RYmPux4JjVL50pIWCAGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnw4k7Vbye5b6WWVQUH1Obi86+gSr6hxMmabtM0cphvxGWyU9GBXaC/dgEeudxuwK
         LuRcS6MRoN6oaAF/g0Csb8wPnsaKFelmz8DdXq/69CL5zs53VEX3n95qvFyEox/5Iv
         35ZQPHJd346DLdVBHwdqUfhUH8M1U4Xm8NLNBR9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 28/58] drop_monitor: fix data-race in dropmon_net_event / trace_napi_poll_hit
Date:   Mon, 21 Feb 2022 09:49:21 +0100
Message-Id: <20220221084912.792776834@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
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

commit dcd54265c8bc14bd023815e36e2d5f9d66ee1fee upstream.

trace_napi_poll_hit() is reading stat->dev while another thread can write
on it from dropmon_net_event()

Use READ_ONCE()/WRITE_ONCE() here, RCU rules are properly enforced already,
we only have to take care of load/store tearing.

BUG: KCSAN: data-race in dropmon_net_event / trace_napi_poll_hit

write to 0xffff88816f3ab9c0 of 8 bytes by task 20260 on cpu 1:
 dropmon_net_event+0xb8/0x2b0 net/core/drop_monitor.c:1579
 notifier_call_chain kernel/notifier.c:84 [inline]
 raw_notifier_call_chain+0x53/0xb0 kernel/notifier.c:392
 call_netdevice_notifiers_info net/core/dev.c:1919 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:1931 [inline]
 call_netdevice_notifiers net/core/dev.c:1945 [inline]
 unregister_netdevice_many+0x867/0xfb0 net/core/dev.c:10415
 ip_tunnel_delete_nets+0x24a/0x280 net/ipv4/ip_tunnel.c:1123
 vti_exit_batch_net+0x2a/0x30 net/ipv4/ip_vti.c:515
 ops_exit_list net/core/net_namespace.c:173 [inline]
 cleanup_net+0x4dc/0x8d0 net/core/net_namespace.c:597
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x1bf/0x1e0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

read to 0xffff88816f3ab9c0 of 8 bytes by interrupt on cpu 0:
 trace_napi_poll_hit+0x89/0x1c0 net/core/drop_monitor.c:292
 trace_napi_poll include/trace/events/napi.h:14 [inline]
 __napi_poll+0x36b/0x3f0 net/core/dev.c:6366
 napi_poll net/core/dev.c:6432 [inline]
 net_rx_action+0x29e/0x650 net/core/dev.c:6519
 __do_softirq+0x158/0x2de kernel/softirq.c:558
 do_softirq+0xb1/0xf0 kernel/softirq.c:459
 __local_bh_enable_ip+0x68/0x70 kernel/softirq.c:383
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:167 [inline]
 _raw_spin_unlock_bh+0x33/0x40 kernel/locking/spinlock.c:210
 spin_unlock_bh include/linux/spinlock.h:394 [inline]
 ptr_ring_consume_bh include/linux/ptr_ring.h:367 [inline]
 wg_packet_decrypt_worker+0x73c/0x780 drivers/net/wireguard/receive.c:506
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x1bf/0x1e0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

value changed: 0xffff88815883e000 -> 0x0000000000000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 26435 Comm: kworker/0:1 Not tainted 5.17.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-crypt-wg2 wg_packet_decrypt_worker

Fixes: 4ea7e38696c7 ("dropmon: add ability to detect when hardware dropsrxpackets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/drop_monitor.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -219,13 +219,17 @@ static void trace_napi_poll_hit(void *ig
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(new_stat, &hw_stats_list, list) {
+		struct net_device *dev;
+
 		/*
 		 * only add a note to our monitor buffer if:
 		 * 1) this is the dev we received on
 		 * 2) its after the last_rx delta
 		 * 3) our rx_dropped count has gone up
 		 */
-		if ((new_stat->dev == napi->dev)  &&
+		/* Paired with WRITE_ONCE() in dropmon_net_event() */
+		dev = READ_ONCE(new_stat->dev);
+		if ((dev == napi->dev)  &&
 		    (time_after(jiffies, new_stat->last_rx + dm_hw_check_delta)) &&
 		    (napi->dev->stats.rx_dropped != new_stat->last_drop_val)) {
 			trace_drop_common(NULL, NULL);
@@ -340,7 +344,10 @@ static int dropmon_net_event(struct noti
 		mutex_lock(&trace_state_mutex);
 		list_for_each_entry_safe(new_stat, tmp, &hw_stats_list, list) {
 			if (new_stat->dev == dev) {
-				new_stat->dev = NULL;
+
+				/* Paired with READ_ONCE() in trace_napi_poll_hit() */
+				WRITE_ONCE(new_stat->dev, NULL);
+
 				if (trace_state == TRACE_OFF) {
 					list_del_rcu(&new_stat->list);
 					kfree_rcu(new_stat, rcu);


