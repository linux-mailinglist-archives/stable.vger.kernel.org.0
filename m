Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E166D470F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbjDCOQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjDCOQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:16:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045B12B0DE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79EB161710
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914D9C433D2;
        Mon,  3 Apr 2023 14:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531399;
        bh=IJHv8sXMxW+/OdQCmInGtMbgjq035bRbcDWiUewyR2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brogT8Ef32ZNQkmCHzaOS35Nyey76ZWUWUEnqMq4DkrJWmuL5YWugaNeFJ1dic2ZB
         G/l2DvjJzzcJPP2aM9G3et4GyUszZX530VixoWHlKg+wmYjAiOW45Z7aCwPEr9oUs7
         0bmPG66z7ynxv/1g+43xneuhkiKSLkrCDf9D+B4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzkaller <syzkaller@googlegroups.com>,
        George Kennedy <george.kennedy@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dragos-Marian Panait <dragos.panait@windriver.com>
Subject: [PATCH 4.19 49/84] tun: avoid double free in tun_free_netdev
Date:   Mon,  3 Apr 2023 16:08:50 +0200
Message-Id: <20230403140355.085534310@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

commit 158b515f703e75e7d68289bf4d98c664e1d632df upstream.

Avoid double free in tun_free_netdev() by moving the
dev->tstats and tun->security allocs to a new ndo_init routine
(tun_net_init()) that will be called by register_netdevice().
ndo_init is paired with the desctructor (tun_free_netdev()),
so if there's an error in register_netdevice() the destructor
will handle the frees.

BUG: KASAN: double-free or invalid-free in selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605

CPU: 0 PID: 25750 Comm: syz-executor416 Not tainted 5.16.0-rc2-syzk #1
Hardware name: Red Hat KVM, BIOS
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:247
kasan_report_invalid_free+0x55/0x80 mm/kasan/report.c:372
____kasan_slab_free mm/kasan/common.c:346 [inline]
__kasan_slab_free+0x107/0x120 mm/kasan/common.c:374
kasan_slab_free include/linux/kasan.h:235 [inline]
slab_free_hook mm/slub.c:1723 [inline]
slab_free_freelist_hook mm/slub.c:1749 [inline]
slab_free mm/slub.c:3513 [inline]
kfree+0xac/0x2d0 mm/slub.c:4561
selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
tun_free_netdev+0xe6/0x150 drivers/net/tun.c:2215
netdev_run_todo+0x4df/0x840 net/core/dev.c:10627
rtnl_unlock+0x13/0x20 net/core/rtnetlink.c:112
__tun_chr_ioctl+0x80c/0x2870 drivers/net/tun.c:3302
tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
vfs_ioctl fs/ioctl.c:51 [inline]
__do_sys_ioctl fs/ioctl.c:874 [inline]
__se_sys_ioctl fs/ioctl.c:860 [inline]
__x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/1639679132-19884-1-git-send-email-george.kennedy@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[DP: adjusted context for 4.19 stable]
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |  109 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 59 insertions(+), 50 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -256,6 +256,9 @@ struct tun_struct {
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
 	struct ethtool_link_ksettings link_ksettings;
+	/* init args */
+	struct file *file;
+	struct ifreq *ifr;
 };
 
 struct veth {
@@ -281,6 +284,9 @@ void *tun_ptr_to_xdp(void *ptr)
 }
 EXPORT_SYMBOL(tun_ptr_to_xdp);
 
+static void tun_flow_init(struct tun_struct *tun);
+static void tun_flow_uninit(struct tun_struct *tun);
+
 static int tun_napi_receive(struct napi_struct *napi, int budget)
 {
 	struct tun_file *tfile = container_of(napi, struct tun_file, napi);
@@ -1038,6 +1044,49 @@ static int check_filter(struct tap_filte
 
 static const struct ethtool_ops tun_ethtool_ops;
 
+static int tun_net_init(struct net_device *dev)
+{
+	struct tun_struct *tun = netdev_priv(dev);
+	struct ifreq *ifr = tun->ifr;
+	int err;
+
+	tun->pcpu_stats = netdev_alloc_pcpu_stats(struct tun_pcpu_stats);
+	if (!tun->pcpu_stats)
+		return -ENOMEM;
+
+	spin_lock_init(&tun->lock);
+
+	err = security_tun_dev_alloc_security(&tun->security);
+	if (err < 0) {
+		free_percpu(tun->pcpu_stats);
+		return err;
+	}
+
+	tun_flow_init(tun);
+
+	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
+			   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
+			   NETIF_F_HW_VLAN_STAG_TX;
+	dev->features = dev->hw_features | NETIF_F_LLTX;
+	dev->vlan_features = dev->features &
+			     ~(NETIF_F_HW_VLAN_CTAG_TX |
+			       NETIF_F_HW_VLAN_STAG_TX);
+
+	tun->flags = (tun->flags & ~TUN_FEATURES) |
+		      (ifr->ifr_flags & TUN_FEATURES);
+
+	INIT_LIST_HEAD(&tun->disabled);
+	err = tun_attach(tun, tun->file, false, ifr->ifr_flags & IFF_NAPI,
+			 ifr->ifr_flags & IFF_NAPI_FRAGS, false);
+	if (err < 0) {
+		tun_flow_uninit(tun);
+		security_tun_dev_free_security(tun->security);
+		free_percpu(tun->pcpu_stats);
+		return err;
+	}
+	return 0;
+}
+
 /* Net device detach from fd. */
 static void tun_net_uninit(struct net_device *dev)
 {
@@ -1268,6 +1317,7 @@ static int tun_xdp(struct net_device *de
 }
 
 static const struct net_device_ops tun_netdev_ops = {
+	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
 	.ndo_open		= tun_net_open,
 	.ndo_stop		= tun_net_close,
@@ -1347,6 +1397,7 @@ static int tun_xdp_tx(struct net_device
 }
 
 static const struct net_device_ops tap_netdev_ops = {
+	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
 	.ndo_open		= tun_net_open,
 	.ndo_stop		= tun_net_close,
@@ -1386,7 +1437,7 @@ static void tun_flow_uninit(struct tun_s
 #define MAX_MTU 65535
 
 /* Initialize net device. */
-static void tun_net_init(struct net_device *dev)
+static void tun_net_initialize(struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
@@ -2658,9 +2709,6 @@ static int tun_set_iff(struct net *net,
 
 		if (!dev)
 			return -ENOMEM;
-		err = dev_get_valid_name(net, dev, name);
-		if (err < 0)
-			goto err_free_dev;
 
 		dev_net_set(dev, net);
 		dev->rtnl_link_ops = &tun_link_ops;
@@ -2679,41 +2727,16 @@ static int tun_set_iff(struct net *net,
 		tun->rx_batched = 0;
 		RCU_INIT_POINTER(tun->steering_prog, NULL);
 
-		tun->pcpu_stats = netdev_alloc_pcpu_stats(struct tun_pcpu_stats);
-		if (!tun->pcpu_stats) {
-			err = -ENOMEM;
-			goto err_free_dev;
-		}
-
-		spin_lock_init(&tun->lock);
-
-		err = security_tun_dev_alloc_security(&tun->security);
-		if (err < 0)
-			goto err_free_stat;
-
-		tun_net_init(dev);
-		tun_flow_init(tun);
+		tun->ifr = ifr;
+		tun->file = file;
 
-		dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
-				   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
-				   NETIF_F_HW_VLAN_STAG_TX;
-		dev->features = dev->hw_features | NETIF_F_LLTX;
-		dev->vlan_features = dev->features &
-				     ~(NETIF_F_HW_VLAN_CTAG_TX |
-				       NETIF_F_HW_VLAN_STAG_TX);
-
-		tun->flags = (tun->flags & ~TUN_FEATURES) |
-			      (ifr->ifr_flags & TUN_FEATURES);
-
-		INIT_LIST_HEAD(&tun->disabled);
-		err = tun_attach(tun, file, false, ifr->ifr_flags & IFF_NAPI,
-				 ifr->ifr_flags & IFF_NAPI_FRAGS, false);
-		if (err < 0)
-			goto err_free_flow;
+		tun_net_initialize(dev);
 
 		err = register_netdevice(tun->dev);
-		if (err < 0)
-			goto err_detach;
+		if (err < 0) {
+			free_netdev(dev);
+			return err;
+		}
 		/* free_netdev() won't check refcnt, to aovid race
 		 * with dev_put() we need publish tun after registration.
 		 */
@@ -2732,20 +2755,6 @@ static int tun_set_iff(struct net *net,
 
 	strcpy(ifr->ifr_name, tun->dev->name);
 	return 0;
-
-err_detach:
-	tun_detach_all(dev);
-	/* register_netdevice() already called tun_free_netdev() */
-	goto err_free_dev;
-
-err_free_flow:
-	tun_flow_uninit(tun);
-	security_tun_dev_free_security(tun->security);
-err_free_stat:
-	free_percpu(tun->pcpu_stats);
-err_free_dev:
-	free_netdev(dev);
-	return err;
 }
 
 static void tun_get_iff(struct net *net, struct tun_struct *tun,


