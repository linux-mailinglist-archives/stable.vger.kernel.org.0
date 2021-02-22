Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68EF3215FC
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhBVMPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:15:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230297AbhBVMOv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:14:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8A0264F02;
        Mon, 22 Feb 2021 12:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996039;
        bh=uhTqBtJBa+ehkNDxV1CWg1OsblPV+Tzr8aKkq9A5S/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWl/DGlmbOgF749zs/oJekiSIvdxtR1vnB0rvTBBHwwdPavDdwVC7inQYxYwmkS//
         OU4VvkLy7Yq2aWwojTXVXHwybj0KQHzszyikhalf6vX1wrw9+CoxGKKHYDMN+rW8xU
         dXBS361JZX3oMlGrmY4XYd9OKhhsIkhQwHcg3EOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/29] net: bridge: Fix a warning when del bridge sysfs
Date:   Mon, 22 Feb 2021 13:13:08 +0100
Message-Id: <20210222121022.132166826@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 989a1db06eb18ff605377eec87e18d795e0ec74b ]

I got a warining report:

br_sysfs_addbr: can't create group bridge4/bridge
------------[ cut here ]------------
sysfs group 'bridge' not found for kobject 'bridge4'
WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group fs/sysfs/group.c:279 [inline]
WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group+0x153/0x1b0 fs/sysfs/group.c:270
Modules linked in: iptable_nat
...
Call Trace:
  br_dev_delete+0x112/0x190 net/bridge/br_if.c:384
  br_dev_newlink net/bridge/br_netlink.c:1381 [inline]
  br_dev_newlink+0xdb/0x100 net/bridge/br_netlink.c:1362
  __rtnl_newlink+0xe11/0x13f0 net/core/rtnetlink.c:3441
  rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
  rtnetlink_rcv_msg+0x385/0x980 net/core/rtnetlink.c:5562
  netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2494
  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
  netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1330
  netlink_sendmsg+0x793/0xc80 net/netlink/af_netlink.c:1919
  sock_sendmsg_nosec net/socket.c:651 [inline]
  sock_sendmsg+0x139/0x170 net/socket.c:671
  ____sys_sendmsg+0x658/0x7d0 net/socket.c:2353
  ___sys_sendmsg+0xf8/0x170 net/socket.c:2407
  __sys_sendmsg+0xd3/0x190 net/socket.c:2440
  do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

In br_device_event(), if the bridge sysfs fails to be added,
br_device_event() should return error. This can prevent warining
when removing bridge sysfs that do not exist.

Fixes: bb900b27a2f4 ("bridge: allow creating bridge devices with netlink")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Tested-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Link: https://lore.kernel.org/r/20201211122921.40386-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 401eeb9142eb6..1b169f8e74919 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -43,7 +43,10 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
 
 		if (event == NETDEV_REGISTER) {
 			/* register of bridge completed, add sysfs entries */
-			br_sysfs_addbr(dev);
+			err = br_sysfs_addbr(dev);
+			if (err)
+				return notifier_from_errno(err);
+
 			return NOTIFY_DONE;
 		}
 	}
-- 
2.27.0



