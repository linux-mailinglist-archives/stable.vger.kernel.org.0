Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C68F7DE0
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbfKKTAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:00:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728886AbfKKSyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:54:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D29B204EC;
        Mon, 11 Nov 2019 18:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498494;
        bh=LtG2NPGIHm0pbfQxb/HQjSTrNE0maxo1tVhJxeSH2DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgOX0v2DaY3f8WOlctKJV66aLkyC6RStYvNfCAJrY3kxEZUQlDHVbOAE9jjaBKy+o
         m7nO81K54BRALQzANcm+7YHMjr3aALvuU6oLbW/luW1vccwqbdeWo3VZngWNKAV3i6
         WsBAzWZ+atBAeJ7wQ6ptOLsdigLc9VQTz447CyTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 135/193] virt_wifi: fix refcnt leak in module exit routine
Date:   Mon, 11 Nov 2019 19:28:37 +0100
Message-Id: <20191111181511.126441444@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 1962f86b42ed06ea6af9ff09390243b99d9eb83a ]

virt_wifi_newlink() calls netdev_upper_dev_link() and it internally
holds reference count of lower interface.

Current code does not release a reference count of the lower interface
when the lower interface is being deleted.
So, reference count leaks occur.

Test commands:
    ip link add dummy0 type dummy
    ip link add vw1 link dummy0 type virt_wifi
    ip link del dummy0

Splat looks like:
[  133.787526][  T788] WARNING: CPU: 1 PID: 788 at net/core/dev.c:8274 rollback_registered_many+0x835/0xc80
[  133.788355][  T788] Modules linked in: virt_wifi cfg80211 dummy team af_packet sch_fq_codel ip_tables x_tables unix
[  133.789377][  T788] CPU: 1 PID: 788 Comm: ip Not tainted 5.4.0-rc3+ #96
[  133.790069][  T788] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  133.791167][  T788] RIP: 0010:rollback_registered_many+0x835/0xc80
[  133.791906][  T788] Code: 00 4d 85 ff 0f 84 b5 fd ff ff ba c0 0c 00 00 48 89 de 4c 89 ff e8 9b 58 04 00 48 89 df e8 30
[  133.794317][  T788] RSP: 0018:ffff88805ba3f338 EFLAGS: 00010202
[  133.795080][  T788] RAX: ffff88805e57e801 RBX: ffff88805ba34000 RCX: ffffffffa9294723
[  133.796045][  T788] RDX: 1ffff1100b746816 RSI: 0000000000000008 RDI: ffffffffabcc4240
[  133.797006][  T788] RBP: ffff88805ba3f4c0 R08: fffffbfff5798849 R09: fffffbfff5798849
[  133.797993][  T788] R10: 0000000000000001 R11: fffffbfff5798848 R12: dffffc0000000000
[  133.802514][  T788] R13: ffff88805ba3f440 R14: ffff88805ba3f400 R15: ffff88805ed622c0
[  133.803237][  T788] FS:  00007f2e9608c0c0(0000) GS:ffff88806cc00000(0000) knlGS:0000000000000000
[  133.804002][  T788] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.804664][  T788] CR2: 00007f2e95610603 CR3: 000000005f68c004 CR4: 00000000000606e0
[  133.805363][  T788] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  133.806073][  T788] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  133.806787][  T788] Call Trace:
[  133.807069][  T788]  ? generic_xdp_install+0x310/0x310
[  133.807612][  T788]  ? lock_acquire+0x164/0x3b0
[  133.808077][  T788]  ? is_bpf_text_address+0x5/0xf0
[  133.808640][  T788]  ? deref_stack_reg+0x9c/0xd0
[  133.809138][  T788]  ? __nla_validate_parse+0x98/0x1ab0
[  133.809944][  T788]  unregister_netdevice_many.part.122+0x13/0x1b0
[  133.810599][  T788]  rtnl_delete_link+0xbc/0x100
[  133.811073][  T788]  ? rtnl_af_register+0xc0/0xc0
[  133.811672][  T788]  rtnl_dellink+0x30e/0x8a0
[  133.812205][  T788]  ? is_bpf_text_address+0x5/0xf0
[ ... ]

[  144.110530][  T788] unregister_netdevice: waiting for dummy0 to become free. Usage count = 1

This patch adds notifier routine to delete upper interface before deleting
lower interface.

Fixes: c7cdba31ed8b ("mac80211-next: rtnetlink wifi simulation device")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virt_wifi.c | 54 ++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index be92e1220284c..7997cc6de334f 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -548,6 +548,7 @@ static int virt_wifi_newlink(struct net *src_net, struct net_device *dev,
 	priv->is_connected = false;
 	priv->is_up = false;
 	INIT_DELAYED_WORK(&priv->connect, virt_wifi_connect_complete);
+	__module_get(THIS_MODULE);
 
 	return 0;
 unregister_netdev:
@@ -578,6 +579,7 @@ static void virt_wifi_dellink(struct net_device *dev,
 	netdev_upper_dev_unlink(priv->lowerdev, dev);
 
 	unregister_netdevice_queue(dev, head);
+	module_put(THIS_MODULE);
 
 	/* Deleting the wiphy is handled in the module destructor. */
 }
@@ -590,6 +592,42 @@ static struct rtnl_link_ops virt_wifi_link_ops = {
 	.priv_size	= sizeof(struct virt_wifi_netdev_priv),
 };
 
+static bool netif_is_virt_wifi_dev(const struct net_device *dev)
+{
+	return rcu_access_pointer(dev->rx_handler) == virt_wifi_rx_handler;
+}
+
+static int virt_wifi_event(struct notifier_block *this, unsigned long event,
+			   void *ptr)
+{
+	struct net_device *lower_dev = netdev_notifier_info_to_dev(ptr);
+	struct virt_wifi_netdev_priv *priv;
+	struct net_device *upper_dev;
+	LIST_HEAD(list_kill);
+
+	if (!netif_is_virt_wifi_dev(lower_dev))
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_UNREGISTER:
+		priv = rtnl_dereference(lower_dev->rx_handler_data);
+		if (!priv)
+			return NOTIFY_DONE;
+
+		upper_dev = priv->upperdev;
+
+		upper_dev->rtnl_link_ops->dellink(upper_dev, &list_kill);
+		unregister_netdevice_many(&list_kill);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block virt_wifi_notifier = {
+	.notifier_call = virt_wifi_event,
+};
+
 /* Acquires and releases the rtnl lock. */
 static int __init virt_wifi_init_module(void)
 {
@@ -598,14 +636,25 @@ static int __init virt_wifi_init_module(void)
 	/* Guaranteed to be locallly-administered and not multicast. */
 	eth_random_addr(fake_router_bssid);
 
+	err = register_netdevice_notifier(&virt_wifi_notifier);
+	if (err)
+		return err;
+
+	err = -ENOMEM;
 	common_wiphy = virt_wifi_make_wiphy();
 	if (!common_wiphy)
-		return -ENOMEM;
+		goto notifier;
 
 	err = rtnl_link_register(&virt_wifi_link_ops);
 	if (err)
-		virt_wifi_destroy_wiphy(common_wiphy);
+		goto destroy_wiphy;
 
+	return 0;
+
+destroy_wiphy:
+	virt_wifi_destroy_wiphy(common_wiphy);
+notifier:
+	unregister_netdevice_notifier(&virt_wifi_notifier);
 	return err;
 }
 
@@ -615,6 +664,7 @@ static void __exit virt_wifi_cleanup_module(void)
 	/* Will delete any devices that depend on the wiphy. */
 	rtnl_link_unregister(&virt_wifi_link_ops);
 	virt_wifi_destroy_wiphy(common_wiphy);
+	unregister_netdevice_notifier(&virt_wifi_notifier);
 }
 
 module_init(virt_wifi_init_module);
-- 
2.20.1



