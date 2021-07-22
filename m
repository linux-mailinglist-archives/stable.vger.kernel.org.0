Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECABC3D2913
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhGVQA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230117AbhGVP7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 870AC61241;
        Thu, 22 Jul 2021 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971979;
        bh=Qvfjr4chl92hN6bxWW/vDQa324GuRuDpITR32cbDmEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPQwD3W1PwgP/SsO7Oxj0A5Ch2s6GG/qXtKJhGxQqX7pv1833hcjFhheofXrvyoy/
         YsSvxOjzh0CgHPyGGs+2cremOdGFkcwKGcGZzAEYbi9IsmCGTOlR9c44U52a5kplCZ
         d3tqBM9tna56qGani219W4Qd5PV+QZbQVq9B+o5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 100/125] net: netdevsim: use xso.real_dev instead of xso.dev in callback functions of struct xfrmdev_ops
Date:   Thu, 22 Jul 2021 18:31:31 +0200
Message-Id: <20210722155628.012188529@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

commit 09adf7566d436322ced595b166dea48b06852efe upstream.

There are two pointers in struct xfrm_state_offload, *dev, *real_dev.
These are used in callback functions of struct xfrmdev_ops.
The *dev points whether bonding interface or real interface.
If bonding ipsec offload is used, it points bonding interface If not,
it points real interface.
And real_dev always points real interface.
So, netdevsim should always use real_dev instead of dev.
Of course, real_dev always not be null.

Test commands:
    ip netns add A
    ip netns exec A bash
    modprobe netdevsim
    echo "1 1" > /sys/bus/netdevsim/new_device
    ip link add bond0 type bond mode active-backup
    ip link set eth0 master bond0
    ip link set eth0 up
    ip link set bond0 up
    ip x s add proto esp dst 14.1.1.1 src 15.1.1.1 spi 0x07 mode \
transport reqid 0x07 replay-window 32 aead 'rfc4106(gcm(aes))' \
0x44434241343332312423222114131211f4f3f2f1 128 sel src 14.0.0.52/24 \
dst 14.0.0.70/24 proto tcp offload dev bond0 dir in

Splat looks like:
BUG: spinlock bad magic on CPU#5, kworker/5:1/53
 lock: 0xffff8881068c2cc8, .magic: 11121314, .owner: <none>/-1,
.owner_cpu: -235736076
CPU: 5 PID: 53 Comm: kworker/5:1 Not tainted 5.13.0-rc3+ #1168
Workqueue: events linkwatch_event
Call Trace:
 dump_stack+0xa4/0xe5
 do_raw_spin_lock+0x20b/0x270
 ? rwlock_bug.part.1+0x90/0x90
 _raw_spin_lock_nested+0x5f/0x70
 bond_get_stats+0xe4/0x4c0 [bonding]
 ? rcu_read_lock_sched_held+0xc0/0xc0
 ? bond_neigh_init+0x2c0/0x2c0 [bonding]
 ? dev_get_alias+0xe2/0x190
 ? dev_get_port_parent_id+0x14a/0x360
 ? rtnl_unregister+0x190/0x190
 ? dev_get_phys_port_name+0xa0/0xa0
 ? memset+0x1f/0x40
 ? memcpy+0x38/0x60
 ? rtnl_phys_switch_id_fill+0x91/0x100
 dev_get_stats+0x8c/0x270
 rtnl_fill_stats+0x44/0xbe0
 ? nla_put+0xbe/0x140
 rtnl_fill_ifinfo+0x1054/0x3ad0
[ ... ]

Fixes: 272c2330adc9 ("xfrm: bail early on slave pass over skb")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netdevsim/ipsec.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -85,7 +85,7 @@ static int nsim_ipsec_parse_proto_keys(s
 				       u32 *mykey, u32 *mysalt)
 {
 	const char aes_gcm_name[] = "rfc4106(gcm(aes))";
-	struct net_device *dev = xs->xso.dev;
+	struct net_device *dev = xs->xso.real_dev;
 	unsigned char *key_data;
 	char *alg_name = NULL;
 	int key_len;
@@ -134,7 +134,7 @@ static int nsim_ipsec_add_sa(struct xfrm
 	u16 sa_idx;
 	int ret;
 
-	dev = xs->xso.dev;
+	dev = xs->xso.real_dev;
 	ns = netdev_priv(dev);
 	ipsec = &ns->ipsec;
 
@@ -194,7 +194,7 @@ static int nsim_ipsec_add_sa(struct xfrm
 
 static void nsim_ipsec_del_sa(struct xfrm_state *xs)
 {
-	struct netdevsim *ns = netdev_priv(xs->xso.dev);
+	struct netdevsim *ns = netdev_priv(xs->xso.real_dev);
 	struct nsim_ipsec *ipsec = &ns->ipsec;
 	u16 sa_idx;
 
@@ -211,7 +211,7 @@ static void nsim_ipsec_del_sa(struct xfr
 
 static bool nsim_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 {
-	struct netdevsim *ns = netdev_priv(xs->xso.dev);
+	struct netdevsim *ns = netdev_priv(xs->xso.real_dev);
 	struct nsim_ipsec *ipsec = &ns->ipsec;
 
 	ipsec->ok++;


