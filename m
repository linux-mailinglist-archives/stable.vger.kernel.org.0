Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3539055CEA8
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbiF0LiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbiF0Lhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A573E9;
        Mon, 27 Jun 2022 04:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2804D60920;
        Mon, 27 Jun 2022 11:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DD7C3411D;
        Mon, 27 Jun 2022 11:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329584;
        bh=2uTsw3cpCSAGgJPjhuBn3ne6D/kRVIkE7v+l+KXRE18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WaY0gybMET9d6ZPF22EwFrhxwh0NFHAxk2y07LncbF8RA/d1upq5ZH/JWSVjHO2c+
         dH5nPKJ6UM8s1DpkK+woItEfrNKexIW5e1+m4jg1gO9iuOcWSSsVd4A2nC/MUsMOCL
         cHc1y2Y2h+qD98OUSpzCUFfYNBdv0RvfzlDGI1ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/135] net: fix data-race in dev_isalive()
Date:   Mon, 27 Jun 2022 13:20:55 +0200
Message-Id: <20220627111939.554811216@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cc26c2661fefea215f41edb665193324a5f99021 ]

dev_isalive() is called under RTNL or dev_base_lock protection.

This means that changes to dev->reg_state should be done with both locks held.

syzbot reported:

BUG: KCSAN: data-race in register_netdevice / type_show

write to 0xffff888144ecf518 of 1 bytes by task 20886 on cpu 0:
register_netdevice+0xb9f/0xdf0 net/core/dev.c:10050
lapbeth_new_device drivers/net/wan/lapbether.c:414 [inline]
lapbeth_device_event+0x4a0/0x6c0 drivers/net/wan/lapbether.c:456
notifier_call_chain kernel/notifier.c:87 [inline]
raw_notifier_call_chain+0x53/0xb0 kernel/notifier.c:455
__dev_notify_flags+0x1d6/0x3a0
dev_change_flags+0xa2/0xc0 net/core/dev.c:8607
do_setlink+0x778/0x2230 net/core/rtnetlink.c:2780
__rtnl_newlink net/core/rtnetlink.c:3546 [inline]
rtnl_newlink+0x114c/0x16a0 net/core/rtnetlink.c:3593
rtnetlink_rcv_msg+0x811/0x8c0 net/core/rtnetlink.c:6089
netlink_rcv_skb+0x13e/0x240 net/netlink/af_netlink.c:2501
rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:6107
netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
netlink_unicast+0x58a/0x660 net/netlink/af_netlink.c:1345
netlink_sendmsg+0x661/0x750 net/netlink/af_netlink.c:1921
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg net/socket.c:734 [inline]
__sys_sendto+0x21e/0x2c0 net/socket.c:2119
__do_sys_sendto net/socket.c:2131 [inline]
__se_sys_sendto net/socket.c:2127 [inline]
__x64_sys_sendto+0x74/0x90 net/socket.c:2127
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

read to 0xffff888144ecf518 of 1 bytes by task 20423 on cpu 1:
dev_isalive net/core/net-sysfs.c:38 [inline]
netdev_show net/core/net-sysfs.c:50 [inline]
type_show+0x24/0x90 net/core/net-sysfs.c:112
dev_attr_show+0x35/0x90 drivers/base/core.c:2095
sysfs_kf_seq_show+0x175/0x240 fs/sysfs/file.c:59
kernfs_seq_show+0x75/0x80 fs/kernfs/file.c:162
seq_read_iter+0x2c3/0x8e0 fs/seq_file.c:230
kernfs_fop_read_iter+0xd1/0x2f0 fs/kernfs/file.c:235
call_read_iter include/linux/fs.h:2052 [inline]
new_sync_read fs/read_write.c:401 [inline]
vfs_read+0x5a5/0x6a0 fs/read_write.c:482
ksys_read+0xe8/0x1a0 fs/read_write.c:620
__do_sys_read fs/read_write.c:630 [inline]
__se_sys_read fs/read_write.c:628 [inline]
__x64_sys_read+0x3e/0x50 fs/read_write.c:628
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

value changed: 0x00 -> 0x01

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 20423 Comm: udevd Tainted: G W 5.19.0-rc2-syzkaller-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c       | 28 ++++++++++++++++------------
 net/core/net-sysfs.c |  1 +
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 860fc6a98373..6111506a4105 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -378,16 +378,18 @@ static void list_netdevice(struct net_device *dev)
 /* Device list removal
  * caller must respect a RCU grace period before freeing/reusing dev
  */
-static void unlist_netdevice(struct net_device *dev)
+static void unlist_netdevice(struct net_device *dev, bool lock)
 {
 	ASSERT_RTNL();
 
 	/* Unlink dev from the device chain */
-	write_lock(&dev_base_lock);
+	if (lock)
+		write_lock(&dev_base_lock);
 	list_del_rcu(&dev->dev_list);
 	netdev_name_node_del(dev->name_node);
 	hlist_del_rcu(&dev->index_hlist);
-	write_unlock(&dev_base_lock);
+	if (lock)
+		write_unlock(&dev_base_lock);
 
 	dev_base_seq_inc(dev_net(dev));
 }
@@ -10319,11 +10321,11 @@ int register_netdevice(struct net_device *dev)
 		goto err_uninit;
 
 	ret = netdev_register_kobject(dev);
-	if (ret) {
-		dev->reg_state = NETREG_UNREGISTERED;
+	write_lock(&dev_base_lock);
+	dev->reg_state = ret ? NETREG_UNREGISTERED : NETREG_REGISTERED;
+	write_unlock(&dev_base_lock);
+	if (ret)
 		goto err_uninit;
-	}
-	dev->reg_state = NETREG_REGISTERED;
 
 	__netdev_update_features(dev);
 
@@ -10483,8 +10485,6 @@ static void netdev_wait_allrefs(struct net_device *dev)
 	unsigned long rebroadcast_time, warning_time;
 	int wait = 0, refcnt;
 
-	linkwatch_forget_dev(dev);
-
 	rebroadcast_time = warning_time = jiffies;
 	refcnt = netdev_refcnt_read(dev);
 
@@ -10598,7 +10598,10 @@ void netdev_run_todo(void)
 			continue;
 		}
 
+		write_lock(&dev_base_lock);
 		dev->reg_state = NETREG_UNREGISTERED;
+		write_unlock(&dev_base_lock);
+		linkwatch_forget_dev(dev);
 
 		netdev_wait_allrefs(dev);
 
@@ -11043,9 +11046,10 @@ void unregister_netdevice_many(struct list_head *head)
 
 	list_for_each_entry(dev, head, unreg_list) {
 		/* And unlink it from device chain. */
-		unlist_netdevice(dev);
-
+		write_lock(&dev_base_lock);
+		unlist_netdevice(dev, false);
 		dev->reg_state = NETREG_UNREGISTERING;
+		write_unlock(&dev_base_lock);
 	}
 	flush_all_backlogs();
 
@@ -11190,7 +11194,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	dev_close(dev);
 
 	/* And unlink it from device chain */
-	unlist_netdevice(dev);
+	unlist_netdevice(dev, true);
 
 	synchronize_net();
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9e5657f63245..e9ea0695efb4 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -32,6 +32,7 @@ static const char fmt_dec[] = "%d\n";
 static const char fmt_ulong[] = "%lu\n";
 static const char fmt_u64[] = "%llu\n";
 
+/* Caller holds RTNL or dev_base_lock */
 static inline int dev_isalive(const struct net_device *dev)
 {
 	return dev->reg_state <= NETREG_REGISTERED;
-- 
2.35.1



