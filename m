Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20084B497E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347913AbiBNKe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:34:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347878AbiBNKec (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F513CCB;
        Mon, 14 Feb 2022 02:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBE4260B33;
        Mon, 14 Feb 2022 10:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E09C340E9;
        Mon, 14 Feb 2022 10:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832871;
        bh=b/rW6f0Dsg0WzuWtDuW0qjocZXcNKX3ee7GrgJuuhY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZnJnbFun8oMHiSzRQTlGKMohS2JnkyebzUuZ+IcYdlxLDxp3A1q97P7MND+nid4z
         D8t/OPwCzHRyXMQvZ9ntnTuLLMiWZEe2W0ZFjfK3DgKKhDqHhBskujP+oQVcCo/Tgx
         7lzlOLXtyITSr79AEMqcUAT6ZSkGtTEz6Kx7pstI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Richter <rafael.richter@gin.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 152/203] net: dsa: fix panic when DSA master device unbinds on shutdown
Date:   Mon, 14 Feb 2022 10:26:36 +0100
Message-Id: <20220214092515.419944498@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit ee534378f00561207656663d93907583958339ae ]

Rafael reports that on a system with LX2160A and Marvell DSA switches,
if a reboot occurs while the DSA master (dpaa2-eth) is up, the following
panic can be seen:

systemd-shutdown[1]: Rebooting.
Unable to handle kernel paging request at virtual address 00a0000800000041
[00a0000800000041] address between user and kernel address ranges
Internal error: Oops: 96000004 [#1] PREEMPT SMP
CPU: 6 PID: 1 Comm: systemd-shutdow Not tainted 5.16.5-00042-g8f5585009b24 #32
pc : dsa_slave_netdevice_event+0x130/0x3e4
lr : raw_notifier_call_chain+0x50/0x6c
Call trace:
 dsa_slave_netdevice_event+0x130/0x3e4
 raw_notifier_call_chain+0x50/0x6c
 call_netdevice_notifiers_info+0x54/0xa0
 __dev_close_many+0x50/0x130
 dev_close_many+0x84/0x120
 unregister_netdevice_many+0x130/0x710
 unregister_netdevice_queue+0x8c/0xd0
 unregister_netdev+0x20/0x30
 dpaa2_eth_remove+0x68/0x190
 fsl_mc_driver_remove+0x20/0x5c
 __device_release_driver+0x21c/0x220
 device_release_driver_internal+0xac/0xb0
 device_links_unbind_consumers+0xd4/0x100
 __device_release_driver+0x94/0x220
 device_release_driver+0x28/0x40
 bus_remove_device+0x118/0x124
 device_del+0x174/0x420
 fsl_mc_device_remove+0x24/0x40
 __fsl_mc_device_remove+0xc/0x20
 device_for_each_child+0x58/0xa0
 dprc_remove+0x90/0xb0
 fsl_mc_driver_remove+0x20/0x5c
 __device_release_driver+0x21c/0x220
 device_release_driver+0x28/0x40
 bus_remove_device+0x118/0x124
 device_del+0x174/0x420
 fsl_mc_bus_remove+0x80/0x100
 fsl_mc_bus_shutdown+0xc/0x1c
 platform_shutdown+0x20/0x30
 device_shutdown+0x154/0x330
 __do_sys_reboot+0x1cc/0x250
 __arm64_sys_reboot+0x20/0x30
 invoke_syscall.constprop.0+0x4c/0xe0
 do_el0_svc+0x4c/0x150
 el0_svc+0x24/0xb0
 el0t_64_sync_handler+0xa8/0xb0
 el0t_64_sync+0x178/0x17c

It can be seen from the stack trace that the problem is that the
deregistration of the master causes a dev_close(), which gets notified
as NETDEV_GOING_DOWN to dsa_slave_netdevice_event().
But dsa_switch_shutdown() has already run, and this has unregistered the
DSA slave interfaces, and yet, the NETDEV_GOING_DOWN handler attempts to
call dev_close_many() on those slave interfaces, leading to the problem.

The previous attempt to avoid the NETDEV_GOING_DOWN on the master after
dsa_switch_shutdown() was called seems improper. Unregistering the slave
interfaces is unnecessary and unhelpful. Instead, after the slaves have
stopped being uppers of the DSA master, we can now reset to NULL the
master->dsa_ptr pointer, which will make DSA start ignoring all future
notifier events on the master.

Fixes: 0650bf52b31f ("net: dsa: be compatible with masters which unregister on shutdown")
Reported-by: Rafael Richter <rafael.richter@gin.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa2.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 826957b6442b0..7578b1350f182 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1609,7 +1609,6 @@ EXPORT_SYMBOL_GPL(dsa_unregister_switch);
 void dsa_switch_shutdown(struct dsa_switch *ds)
 {
 	struct net_device *master, *slave_dev;
-	LIST_HEAD(unregister_list);
 	struct dsa_port *dp;
 
 	mutex_lock(&dsa2_mutex);
@@ -1620,25 +1619,13 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 		slave_dev = dp->slave;
 
 		netdev_upper_dev_unlink(master, slave_dev);
-		/* Just unlinking ourselves as uppers of the master is not
-		 * sufficient. When the master net device unregisters, that will
-		 * also call dev_close, which we will catch as NETDEV_GOING_DOWN
-		 * and trigger a dev_close on our own devices (dsa_slave_close).
-		 * In turn, that will call dev_mc_unsync on the master's net
-		 * device. If the master is also a DSA switch port, this will
-		 * trigger dsa_slave_set_rx_mode which will call dev_mc_sync on
-		 * its own master. Lockdep will complain about the fact that
-		 * all cascaded masters have the same dsa_master_addr_list_lock_key,
-		 * which it normally would not do if the cascaded masters would
-		 * be in a proper upper/lower relationship, which we've just
-		 * destroyed.
-		 * To suppress the lockdep warnings, let's actually unregister
-		 * the DSA slave interfaces too, to avoid the nonsensical
-		 * multicast address list synchronization on shutdown.
-		 */
-		unregister_netdevice_queue(slave_dev, &unregister_list);
 	}
-	unregister_netdevice_many(&unregister_list);
+
+	/* Disconnect from further netdevice notifiers on the master,
+	 * since netdev_uses_dsa() will now return false.
+	 */
+	dsa_switch_for_each_cpu_port(dp, ds)
+		dp->master->dsa_ptr = NULL;
 
 	rtnl_unlock();
 	mutex_unlock(&dsa2_mutex);
-- 
2.34.1



