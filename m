Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4A912EFCF
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgABW1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729698AbgABW1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:27:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6BEF20863;
        Thu,  2 Jan 2020 22:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004024;
        bh=bGamLmmbCCFD4+K5HX2MERPAemTDSDDQamEPOTkYB3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hE10A8Fju3FFThscEvnGLR3LNWf1OEw/CLYNr+sP9cD8IcBNg9I8k6tz2mHU/PP+q
         A7Z5yZ9BAPGXThxERaVr5yM40VJdq8/1rDWhtKbwLDP1EMJL41eM9gXkz/KfkrF5bJ
         PVc8wHfZnIzbr4OlTV4kgn4t+44F8TGn3p8xGCJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 4.14 90/91] gtp: fix an use-after-free in ipv4_pdp_find()
Date:   Thu,  2 Jan 2020 23:08:12 +0100
Message-Id: <20200102220453.369797268@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 94dc550a5062030569d4aa76e10e50c8fc001930 ]

ipv4_pdp_find() is called in TX packet path of GTP.
ipv4_pdp_find() internally uses gtp->tid_hash to lookup pdp context.
In the current code, gtp->tid_hash and gtp->addr_hash are freed by
->dellink(), which is gtp_dellink().
But gtp_dellink() would be called while packets are processing.
So, gtp_dellink() should not free gtp->tid_hash and gtp->addr_hash.
Instead, dev->priv_destructor() would be used because this callback
is called after all packet processing safely.

Test commands:
    ip link add veth1 type veth peer name veth2
    ip a a 172.0.0.1/24 dev veth1
    ip link set veth1 up
    ip a a 172.99.0.1/32 dev lo

    gtp-link add gtp1 &

    gtp-tunnel add gtp1 v1 200 100 172.99.0.2 172.0.0.2
    ip r a  172.99.0.2/32 dev gtp1
    ip link set gtp1 mtu 1500

    ip netns add ns2
    ip link set veth2 netns ns2
    ip netns exec ns2 ip a a 172.0.0.2/24 dev veth2
    ip netns exec ns2 ip link set veth2 up
    ip netns exec ns2 ip a a 172.99.0.2/32 dev lo
    ip netns exec ns2 ip link set lo up

    ip netns exec ns2 gtp-link add gtp2 &
    ip netns exec ns2 gtp-tunnel add gtp2 v1 100 200 172.99.0.1 172.0.0.1
    ip netns exec ns2 ip r a 172.99.0.1/32 dev gtp2
    ip netns exec ns2 ip link set gtp2 mtu 1500

    hping3 172.99.0.2 -2 --flood &
    ip link del gtp1

Splat looks like:
[   72.568081][ T1195] BUG: KASAN: use-after-free in ipv4_pdp_find.isra.12+0x130/0x170 [gtp]
[   72.568916][ T1195] Read of size 8 at addr ffff8880b9a35d28 by task hping3/1195
[   72.569631][ T1195]
[   72.569861][ T1195] CPU: 2 PID: 1195 Comm: hping3 Not tainted 5.5.0-rc1 #199
[   72.570547][ T1195] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   72.571438][ T1195] Call Trace:
[   72.571764][ T1195]  dump_stack+0x96/0xdb
[   72.572171][ T1195]  ? ipv4_pdp_find.isra.12+0x130/0x170 [gtp]
[   72.572761][ T1195]  print_address_description.constprop.5+0x1be/0x360
[   72.573400][ T1195]  ? ipv4_pdp_find.isra.12+0x130/0x170 [gtp]
[   72.573971][ T1195]  ? ipv4_pdp_find.isra.12+0x130/0x170 [gtp]
[   72.574544][ T1195]  __kasan_report+0x12a/0x16f
[   72.575014][ T1195]  ? ipv4_pdp_find.isra.12+0x130/0x170 [gtp]
[   72.575593][ T1195]  kasan_report+0xe/0x20
[   72.576004][ T1195]  ipv4_pdp_find.isra.12+0x130/0x170 [gtp]
[   72.576577][ T1195]  gtp_build_skb_ip4+0x199/0x1420 [gtp]
[ ... ]
[   72.647671][ T1195] BUG: unable to handle page fault for address: ffff8880b9a35d28
[   72.648512][ T1195] #PF: supervisor read access in kernel mode
[   72.649158][ T1195] #PF: error_code(0x0000) - not-present page
[   72.649849][ T1195] PGD a6c01067 P4D a6c01067 PUD 11fb07067 PMD 11f939067 PTE 800fffff465ca060
[   72.652958][ T1195] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[   72.653834][ T1195] CPU: 2 PID: 1195 Comm: hping3 Tainted: G    B             5.5.0-rc1 #199
[   72.668062][ T1195] RIP: 0010:ipv4_pdp_find.isra.12+0x86/0x170 [gtp]
[ ... ]
[   72.679168][ T1195] Call Trace:
[   72.679603][ T1195]  gtp_build_skb_ip4+0x199/0x1420 [gtp]
[   72.681915][ T1195]  ? ipv4_pdp_find.isra.12+0x170/0x170 [gtp]
[   72.682513][ T1195]  ? lock_acquire+0x164/0x3b0
[   72.682966][ T1195]  ? gtp_dev_xmit+0x35e/0x890 [gtp]
[   72.683481][ T1195]  gtp_dev_xmit+0x3c2/0x890 [gtp]
[ ... ]

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -644,9 +644,16 @@ static void gtp_link_setup(struct net_de
 }
 
 static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize);
-static void gtp_hashtable_free(struct gtp_dev *gtp);
 static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[]);
 
+static void gtp_destructor(struct net_device *dev)
+{
+	struct gtp_dev *gtp = netdev_priv(dev);
+
+	kfree(gtp->addr_hash);
+	kfree(gtp->tid_hash);
+}
+
 static int gtp_newlink(struct net *src_net, struct net_device *dev,
 		       struct nlattr *tb[], struct nlattr *data[],
 		       struct netlink_ext_ack *extack)
@@ -681,13 +688,15 @@ static int gtp_newlink(struct net *src_n
 
 	gn = net_generic(dev_net(dev), gtp_net_id);
 	list_add_rcu(&gtp->list, &gn->gtp_dev_list);
+	dev->priv_destructor = gtp_destructor;
 
 	netdev_dbg(dev, "registered new GTP interface\n");
 
 	return 0;
 
 out_hashtable:
-	gtp_hashtable_free(gtp);
+	kfree(gtp->addr_hash);
+	kfree(gtp->tid_hash);
 out_encap:
 	gtp_encap_disable(gtp);
 	return err;
@@ -696,9 +705,14 @@ out_encap:
 static void gtp_dellink(struct net_device *dev, struct list_head *head)
 {
 	struct gtp_dev *gtp = netdev_priv(dev);
+	struct pdp_ctx *pctx;
+	int i;
+
+	for (i = 0; i < gtp->hash_size; i++)
+		hlist_for_each_entry_rcu(pctx, &gtp->tid_hash[i], hlist_tid)
+			pdp_context_delete(pctx);
 
 	gtp_encap_disable(gtp);
-	gtp_hashtable_free(gtp);
 	list_del_rcu(&gtp->list);
 	unregister_netdevice_queue(dev, head);
 }
@@ -774,20 +788,6 @@ err1:
 	return -ENOMEM;
 }
 
-static void gtp_hashtable_free(struct gtp_dev *gtp)
-{
-	struct pdp_ctx *pctx;
-	int i;
-
-	for (i = 0; i < gtp->hash_size; i++)
-		hlist_for_each_entry_rcu(pctx, &gtp->tid_hash[i], hlist_tid)
-			pdp_context_delete(pctx);
-
-	synchronize_rcu();
-	kfree(gtp->addr_hash);
-	kfree(gtp->tid_hash);
-}
-
 static struct sock *gtp_encap_enable_socket(int fd, int type,
 					    struct gtp_dev *gtp)
 {


