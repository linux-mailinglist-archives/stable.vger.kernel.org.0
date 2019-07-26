Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3951476312
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 12:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfGZKFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 06:05:43 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:56311 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbfGZKFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 06:05:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 01B192D9;
        Fri, 26 Jul 2019 06:05:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 26 Jul 2019 06:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=x4gwaU
        bw6nlMWYVPyRfOxq1cKrrmUpLi/ZoFo8qepWM=; b=UnCDErL6dBuDQ0pn75J41k
        KTU/cMbBH6D6+ZQplXQGvVZqyQNMCxn+wHp8oP+J6AXQPONr59HO3OlsZiiAgeK+
        PkdiA4beueXkRQmFVbZW6s1iMd9mXJXk7W942a5m5Q8i99wsgg1vh7umbNAOY1Qm
        /cYke3J01ayC5nd7PJVkW/+4qIFIpvgRjf3PDypaG+L0YMu2+vGQFK+5pcBZtvmy
        Az4s8uynfqTI76OKxEi151VZ58Qt4gUoNUm6fPcQSTILqwORLj8KdhZHnc9zKzDf
        OIuIA07u1MDxdGg2xs3J48AfTUcoJIyF9u3k+X98W9oBNFNQzMavqdJH0QfjM3Og
        ==
X-ME-Sender: <xms:ddA6Xbe8VIXEdySpOutugjGSV-ToqHI1RmMO9kaPsebSrA-vERqpWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeggddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:ddA6XfVtRjVuGf6jnJO3gyD_Qbdsm5pVmw8sF8346x-wp-ba_6SElw>
    <xmx:ddA6XfFGmoFZZ80mbphngRC5_s9_MldRBw-Zw8C9uHWJrAzAcapDvA>
    <xmx:ddA6XRfRPLjEEnjfOcMvQ8VgvXcKqJUtVypOm4O0ogvKC-5Iq9YDLQ>
    <xmx:ddA6XbyzjB-WIYC7MucrKhwNRyOpJiXmRsq8Z_FadLp6WqCwxoeI3w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E245D380074;
        Fri, 26 Jul 2019 06:05:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] vxlan: do not destroy fdb if register_netdevice() is failed" failed to apply to 4.19-stable tree
To:     ap420073@gmail.com, davem@davemloft.net, roopa@cumulusnetworks.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Jul 2019 12:05:39 +0200
Message-ID: <15641355392228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7c31e54aeee517d1318dfc0bde9fa7de75893dc6 Mon Sep 17 00:00:00 2001
From: Taehee Yoo <ap420073@gmail.com>
Date: Fri, 28 Jun 2019 14:07:25 +0900
Subject: [PATCH] vxlan: do not destroy fdb if register_netdevice() is failed

__vxlan_dev_create() destroys FDB using specific pointer which indicates
a fdb when error occurs.
But that pointer should not be used when register_netdevice() fails because
register_netdevice() internally destroys fdb when error occurs.

This patch makes vxlan_fdb_create() to do not link fdb entry to vxlan dev
internally.
Instead, a new function vxlan_fdb_insert() is added to link fdb to vxlan
dev.

vxlan_fdb_insert() is called after calling register_netdevice().
This routine can avoid situation that ->ndo_uninit() destroys fdb entry
in error path of register_netdevice().
Hence, error path of __vxlan_dev_create() routine can have an opportunity
to destroy default fdb entry by hand.

Test command
    ip link add bonding_masters type vxlan id 0 group 239.1.1.1 \
	    dev enp0s9 dstport 4789

Splat looks like:
[  213.392816] kasan: GPF could be caused by NULL-ptr deref or user memory access
[  213.401257] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  213.402178] CPU: 0 PID: 1414 Comm: ip Not tainted 5.2.0-rc5+ #256
[  213.402178] RIP: 0010:vxlan_fdb_destroy+0x120/0x220 [vxlan]
[  213.402178] Code: df 48 8b 2b 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 06 01 00 00 4c 8b 63 08 48 b8 00 00 00 00 00 fc d
[  213.402178] RSP: 0018:ffff88810cb9f0a0 EFLAGS: 00010202
[  213.402178] RAX: dffffc0000000000 RBX: ffff888101d4a8c8 RCX: 0000000000000000
[  213.402178] RDX: 1bd5a00000000040 RSI: ffff888101d4a8c8 RDI: ffff888101d4a8d0
[  213.402178] RBP: 0000000000000000 R08: fffffbfff22b72d9 R09: 0000000000000000
[  213.402178] R10: 00000000ffffffef R11: 0000000000000000 R12: dead000000000200
[  213.402178] R13: ffff88810cb9f1f8 R14: ffff88810efccda0 R15: ffff88810efccda0
[  213.402178] FS:  00007f7f6621a0c0(0000) GS:ffff88811b000000(0000) knlGS:0000000000000000
[  213.402178] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  213.402178] CR2: 000055746f0807d0 CR3: 00000001123e0000 CR4: 00000000001006f0
[  213.402178] Call Trace:
[  213.402178]  __vxlan_dev_create+0x3a9/0x7d0 [vxlan]
[  213.402178]  ? vxlan_changelink+0x740/0x740 [vxlan]
[  213.402178]  ? rcu_read_unlock+0x60/0x60 [vxlan]
[  213.402178]  ? __kasan_kmalloc.constprop.3+0xa0/0xd0
[  213.402178]  vxlan_newlink+0x8d/0xc0 [vxlan]
[  213.402178]  ? __vxlan_dev_create+0x7d0/0x7d0 [vxlan]
[  213.554119]  ? __netlink_ns_capable+0xc3/0xf0
[  213.554119]  __rtnl_newlink+0xb75/0x1180
[  213.554119]  ? rtnl_link_unregister+0x230/0x230
[ ... ]

Fixes: 0241b836732f ("vxlan: fix default fdb entry netlink notify ordering during netdev create")
Suggested-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 083f3f0bf37f..b4283f52a09d 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -804,6 +804,14 @@ static struct vxlan_fdb *vxlan_fdb_alloc(struct vxlan_dev *vxlan,
 	return f;
 }
 
+static void vxlan_fdb_insert(struct vxlan_dev *vxlan, const u8 *mac,
+			     __be32 src_vni, struct vxlan_fdb *f)
+{
+	++vxlan->addrcnt;
+	hlist_add_head_rcu(&f->hlist,
+			   vxlan_fdb_head(vxlan, mac, src_vni));
+}
+
 static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 			    const u8 *mac, union vxlan_addr *ip,
 			    __u16 state, __be16 port, __be32 src_vni,
@@ -829,18 +837,13 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 		return rc;
 	}
 
-	++vxlan->addrcnt;
-	hlist_add_head_rcu(&f->hlist,
-			   vxlan_fdb_head(vxlan, mac, src_vni));
-
 	*fdb = f;
 
 	return 0;
 }
 
-static void vxlan_fdb_free(struct rcu_head *head)
+static void __vxlan_fdb_free(struct vxlan_fdb *f)
 {
-	struct vxlan_fdb *f = container_of(head, struct vxlan_fdb, rcu);
 	struct vxlan_rdst *rd, *nd;
 
 	list_for_each_entry_safe(rd, nd, &f->remotes, list) {
@@ -850,6 +853,13 @@ static void vxlan_fdb_free(struct rcu_head *head)
 	kfree(f);
 }
 
+static void vxlan_fdb_free(struct rcu_head *head)
+{
+	struct vxlan_fdb *f = container_of(head, struct vxlan_fdb, rcu);
+
+	__vxlan_fdb_free(f);
+}
+
 static void vxlan_fdb_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 			      bool do_notify, bool swdev_notify)
 {
@@ -977,6 +987,7 @@ static int vxlan_fdb_update_create(struct vxlan_dev *vxlan,
 	if (rc < 0)
 		return rc;
 
+	vxlan_fdb_insert(vxlan, mac, src_vni, f);
 	rc = vxlan_fdb_notify(vxlan, f, first_remote_rtnl(f), RTM_NEWNEIGH,
 			      swdev_notify, extack);
 	if (rc)
@@ -3571,12 +3582,17 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	if (err)
 		goto errout;
 
-	/* notify default fdb entry */
 	if (f) {
+		vxlan_fdb_insert(vxlan, all_zeros_mac,
+				 vxlan->default_dst.remote_vni, f);
+
+		/* notify default fdb entry */
 		err = vxlan_fdb_notify(vxlan, f, first_remote_rtnl(f),
 				       RTM_NEWNEIGH, true, extack);
-		if (err)
-			goto errout;
+		if (err) {
+			vxlan_fdb_destroy(vxlan, f, false, false);
+			goto unregister;
+		}
 	}
 
 	list_add(&vxlan->next, &vn->vxlan_list);
@@ -3588,7 +3604,8 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	 * destroy the entry by hand here.
 	 */
 	if (f)
-		vxlan_fdb_destroy(vxlan, f, false, false);
+		__vxlan_fdb_free(f);
+unregister:
 	if (unregister)
 		unregister_netdevice(dev);
 	return err;

