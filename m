Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5D3586A61
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbiHAMQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbiHAMPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:15:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A2D78587;
        Mon,  1 Aug 2022 04:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 42A0ACE13B9;
        Mon,  1 Aug 2022 11:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577BEC4347C;
        Mon,  1 Aug 2022 11:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355088;
        bh=/7onE6s4mGX2NwJMW7RKS5TVN+YhEfVvY57cPQaN3Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0G6nZQi7tsQWOe3eF9VbE0hadX5MgaOOnlyFxj9HcQIjgn8UVpebzUTBx7txwXjv
         LX3IoAy+abfdEdeFe7gLtSb7sbtmotWpnhHrIUPhTZliebd/Kd1LBV2+7+JsnkMNH0
         R34sxqjOM1sGUGnaQqqLCGUTwiRqZ9+2OHvajv6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 57/88] net: mld: fix reference count leak in mld_{query | report}_work()
Date:   Mon,  1 Aug 2022 13:47:11 +0200
Message-Id: <20220801114140.645584322@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 3e7d18b9dca388940a19cae30bfc1f76dccd8c28 ]

mld_{query | report}_work() processes queued events.
If there are too many events in the queue, it re-queue a work.
And then, it returns without in6_dev_put().
But if queuing is failed, it should call in6_dev_put(), but it doesn't.
So, a reference count leak would occur.

THREAD0				THREAD1
mld_report_work()
				spin_lock_bh()
				if (!mod_delayed_work())
					in6_dev_hold();
				spin_unlock_bh()
	spin_lock_bh()
	schedule_delayed_work()
	spin_unlock_bh()

Script to reproduce(by Hangbin Liu):
   ip netns add ns1
   ip netns add ns2
   ip netns exec ns1 sysctl -w net.ipv6.conf.all.force_mld_version=1
   ip netns exec ns2 sysctl -w net.ipv6.conf.all.force_mld_version=1

   ip -n ns1 link add veth0 type veth peer name veth0 netns ns2
   ip -n ns1 link set veth0 up
   ip -n ns2 link set veth0 up

   for i in `seq 50`; do
           for j in `seq 100`; do
                   ip -n ns1 addr add 2021:${i}::${j}/64 dev veth0
                   ip -n ns2 addr add 2022:${i}::${j}/64 dev veth0
           done
   done
   modprobe -r veth
   ip -a netns del

splat looks like:
 unregister_netdevice: waiting for veth0 to become free. Usage count = 2
 leaked reference.
  ipv6_add_dev+0x324/0xec0
  addrconf_notify+0x481/0xd10
  raw_notifier_call_chain+0xe3/0x120
  call_netdevice_notifiers+0x106/0x160
  register_netdevice+0x114c/0x16b0
  veth_newlink+0x48b/0xa50 [veth]
  rtnl_newlink+0x11a2/0x1a40
  rtnetlink_rcv_msg+0x63f/0xc00
  netlink_rcv_skb+0x1df/0x3e0
  netlink_unicast+0x5de/0x850
  netlink_sendmsg+0x6c9/0xa90
  ____sys_sendmsg+0x76a/0x780
  __sys_sendmsg+0x27c/0x340
  do_syscall_64+0x43/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Tested-by: Hangbin Liu <liuhangbin@gmail.com>
Fixes: f185de28d9ae ("mld: add new workqueues for process mld events")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 7f695c39d9a8..87c699d57b36 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1522,7 +1522,6 @@ static void mld_query_work(struct work_struct *work)
 
 		if (++cnt >= MLD_MAX_QUEUE) {
 			rework = true;
-			schedule_delayed_work(&idev->mc_query_work, 0);
 			break;
 		}
 	}
@@ -1533,8 +1532,10 @@ static void mld_query_work(struct work_struct *work)
 		__mld_query_work(skb);
 	mutex_unlock(&idev->mc_lock);
 
-	if (!rework)
-		in6_dev_put(idev);
+	if (rework && queue_delayed_work(mld_wq, &idev->mc_query_work, 0))
+		return;
+
+	in6_dev_put(idev);
 }
 
 /* called with rcu_read_lock() */
@@ -1624,7 +1625,6 @@ static void mld_report_work(struct work_struct *work)
 
 		if (++cnt >= MLD_MAX_QUEUE) {
 			rework = true;
-			schedule_delayed_work(&idev->mc_report_work, 0);
 			break;
 		}
 	}
@@ -1635,8 +1635,10 @@ static void mld_report_work(struct work_struct *work)
 		__mld_report_work(skb);
 	mutex_unlock(&idev->mc_lock);
 
-	if (!rework)
-		in6_dev_put(idev);
+	if (rework && queue_delayed_work(mld_wq, &idev->mc_report_work, 0))
+		return;
+
+	in6_dev_put(idev);
 }
 
 static bool is_in(struct ifmcaddr6 *pmc, struct ip6_sf_list *psf, int type,
-- 
2.35.1



