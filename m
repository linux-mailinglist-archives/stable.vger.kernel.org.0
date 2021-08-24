Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62ED3F66FC
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbhHXRaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:30:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241109AbhHXR1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:27:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB61E61B45;
        Tue, 24 Aug 2021 17:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824712;
        bh=kwbestylf5xeHwKiuEFzUP2GoyzaeOhFLm3sSpivY94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEaZov83xBZtZrYSBOi1MG3J4C6M++4oU0da2iLGXkHRQMCp6t9xs2bHPHR9CypoF
         GatmOIJoFdBFvPGLoRChI/eCfubWedho5PcK5BChppY5d+tRfnfguCWhfrWhjCG9F9
         Y/mz1PGw5wPRRnxBDnxq4R/0KD8Da3mt2fyav9alPVuYF8lti1Hj/xL2EU6lMNlZD0
         tawKhsRNUMXzZdOUn/7Q8r4S65MpsJUITjIpgq+BrPQuf332dNIkCz3GNvmJKSh6ln
         w7sRIaEOYcmoTihz0AmX8+aZy5RZCKwryuJ3EVizz20+vuoilp0kuiH1y4tSeyx2co
         H6YENxiVEpT9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/64] net: bridge: fix memleak in br_add_if()
Date:   Tue, 24 Aug 2021 13:04:07 -0400
Message-Id: <20210824170457.710623-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 519133debcc19f5c834e7e28480b60bdc234fe02 ]

I got a memleak report:

BUG: memory leak
unreferenced object 0x607ee521a658 (size 240):
comm "syz-executor.0", pid 955, jiffies 4294780569 (age 16.449s)
hex dump (first 32 bytes, cpu 1):
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
backtrace:
[<00000000d830ea5a>] br_multicast_add_port+0x1c2/0x300 net/bridge/br_multicast.c:1693
[<00000000274d9a71>] new_nbp net/bridge/br_if.c:435 [inline]
[<00000000274d9a71>] br_add_if+0x670/0x1740 net/bridge/br_if.c:611
[<0000000012ce888e>] do_set_master net/core/rtnetlink.c:2513 [inline]
[<0000000012ce888e>] do_set_master+0x1aa/0x210 net/core/rtnetlink.c:2487
[<0000000099d1cafc>] __rtnl_newlink+0x1095/0x13e0 net/core/rtnetlink.c:3457
[<00000000a01facc0>] rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3488
[<00000000acc9186c>] rtnetlink_rcv_msg+0x369/0xa10 net/core/rtnetlink.c:5550
[<00000000d4aabb9c>] netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2504
[<00000000bc2e12a3>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
[<00000000bc2e12a3>] netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1340
[<00000000e4dc2d0e>] netlink_sendmsg+0x789/0xc70 net/netlink/af_netlink.c:1929
[<000000000d22c8b3>] sock_sendmsg_nosec net/socket.c:654 [inline]
[<000000000d22c8b3>] sock_sendmsg+0x139/0x170 net/socket.c:674
[<00000000e281417a>] ____sys_sendmsg+0x658/0x7d0 net/socket.c:2350
[<00000000237aa2ab>] ___sys_sendmsg+0xf8/0x170 net/socket.c:2404
[<000000004f2dc381>] __sys_sendmsg+0xd3/0x190 net/socket.c:2433
[<0000000005feca6c>] do_syscall_64+0x37/0x90 arch/x86/entry/common.c:47
[<000000007304477d>] entry_SYSCALL_64_after_hwframe+0x44/0xae

On error path of br_add_if(), p->mcast_stats allocated in
new_nbp() need be freed, or it will be leaked.

Fixes: 1080ab95e3c7 ("net: bridge: add support for IGMP/MLD stats and export them via netlink")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Link: https://lore.kernel.org/r/20210809132023.978546-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_if.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 9a36592cf20f..c8bf044ab534 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -519,6 +519,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
 
 	err = dev_set_allmulti(dev, 1);
 	if (err) {
+		br_multicast_del_port(p);
 		kfree(p);	/* kobject not yet init'd, manually free */
 		goto err1;
 	}
@@ -623,6 +624,7 @@ err4:
 err3:
 	sysfs_remove_link(br->ifobj, p->dev->name);
 err2:
+	br_multicast_del_port(p);
 	kobject_put(&p->kobj);
 	dev_set_allmulti(dev, -1);
 err1:
-- 
2.30.2

