Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA931CABD2
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbgEHMrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:47:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728910AbgEHMrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B46762145D;
        Fri,  8 May 2020 12:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942041;
        bh=h2Dov4v0MzbMEzmv1CmMyWTLr6lrUvqmv5WvQ2wsE7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dy+BdTKHG35h963S6qimYgIHqQB5j1J9Pcz7k+EVKmRjTBlfUMi+cauF28VFDQaMU
         DxxD6l0FP6agG2rIDN3krl5lLgCkAoyug9BFrISpHE9WRo9sGWGeUbPr1hCXxEFJhm
         vRvDQwwPdaO2TwlsJ+Og2rWJJPAQbiaoyz/3Aaoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 233/312] net: vrf: Fix dst reference counting
Date:   Fri,  8 May 2020 14:33:44 +0200
Message-Id: <20200508123140.815999828@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsa@cumulusnetworks.com>

commit 9ab179d83b4e31ea277a123492e419067c2f129a upstream.

Vivek reported a kernel exception deleting a VRF with an active
connection through it. The root cause is that the socket has a cached
reference to a dst that is destroyed. Converting the dst_destroy to
dst_release and letting proper reference counting kick in does not
work as the dst has a reference to the device which needs to be released
as well.

I talked to Hannes about this at netdev and he pointed out the ipv4 and
ipv6 dst handling has dst_ifdown for just this scenario. Rather than
continuing with the reinvented dst wheel in VRF just remove it and
leverage the ipv4 and ipv6 versions.

Fixes: 193125dbd8eb2 ("net: Introduce VRF device driver")
Fixes: 35402e3136634 ("net: Add IPv6 support to VRF device")

Signed-off-by: David Ahern <dsa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/vrf.c       |  177 ++++--------------------------------------------
 include/net/ip6_route.h |    3 
 include/net/route.h     |    3 
 net/ipv4/route.c        |    7 +
 net/ipv6/route.c        |    7 +
 5 files changed, 30 insertions(+), 167 deletions(-)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -71,41 +71,6 @@ struct pcpu_dstats {
 	struct u64_stats_sync	syncp;
 };
 
-static struct dst_entry *vrf_ip_check(struct dst_entry *dst, u32 cookie)
-{
-	return dst;
-}
-
-static int vrf_ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb)
-{
-	return ip_local_out(net, sk, skb);
-}
-
-static unsigned int vrf_v4_mtu(const struct dst_entry *dst)
-{
-	/* TO-DO: return max ethernet size? */
-	return dst->dev->mtu;
-}
-
-static void vrf_dst_destroy(struct dst_entry *dst)
-{
-	/* our dst lives forever - or until the device is closed */
-}
-
-static unsigned int vrf_default_advmss(const struct dst_entry *dst)
-{
-	return 65535 - 40;
-}
-
-static struct dst_ops vrf_dst_ops = {
-	.family		= AF_INET,
-	.local_out	= vrf_ip_local_out,
-	.check		= vrf_ip_check,
-	.mtu		= vrf_v4_mtu,
-	.destroy	= vrf_dst_destroy,
-	.default_advmss	= vrf_default_advmss,
-};
-
 /* neighbor handling is done with actual device; do not want
  * to flip skb->dev for those ndisc packets. This really fails
  * for multiple next protocols (e.g., NEXTHDR_HOP). But it is
@@ -363,46 +328,6 @@ static netdev_tx_t vrf_xmit(struct sk_bu
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static struct dst_entry *vrf_ip6_check(struct dst_entry *dst, u32 cookie)
-{
-	return dst;
-}
-
-static struct dst_ops vrf_dst_ops6 = {
-	.family		= AF_INET6,
-	.local_out	= ip6_local_out,
-	.check		= vrf_ip6_check,
-	.mtu		= vrf_v4_mtu,
-	.destroy	= vrf_dst_destroy,
-	.default_advmss	= vrf_default_advmss,
-};
-
-static int init_dst_ops6_kmem_cachep(void)
-{
-	vrf_dst_ops6.kmem_cachep = kmem_cache_create("vrf_ip6_dst_cache",
-						     sizeof(struct rt6_info),
-						     0,
-						     SLAB_HWCACHE_ALIGN,
-						     NULL);
-
-	if (!vrf_dst_ops6.kmem_cachep)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void free_dst_ops6_kmem_cachep(void)
-{
-	kmem_cache_destroy(vrf_dst_ops6.kmem_cachep);
-}
-
-static int vrf_input6(struct sk_buff *skb)
-{
-	skb->dev->stats.rx_errors++;
-	kfree_skb(skb);
-	return 0;
-}
-
 /* modelled after ip6_finish_output2 */
 static int vrf_finish_output6(struct net *net, struct sock *sk,
 			      struct sk_buff *skb)
@@ -445,67 +370,34 @@ static int vrf_output6(struct net *net,
 			    !(IP6CB(skb)->flags & IP6SKB_REROUTED));
 }
 
-static void vrf_rt6_destroy(struct net_vrf *vrf)
+static void vrf_rt6_release(struct net_vrf *vrf)
 {
-	dst_destroy(&vrf->rt6->dst);
-	free_percpu(vrf->rt6->rt6i_pcpu);
+	dst_release(&vrf->rt6->dst);
 	vrf->rt6 = NULL;
 }
 
 static int vrf_rt6_create(struct net_device *dev)
 {
 	struct net_vrf *vrf = netdev_priv(dev);
-	struct dst_entry *dst;
+	struct net *net = dev_net(dev);
 	struct rt6_info *rt6;
-	int cpu;
 	int rc = -ENOMEM;
 
-	rt6 = dst_alloc(&vrf_dst_ops6, dev, 0,
-			DST_OBSOLETE_NONE,
-			(DST_HOST | DST_NOPOLICY | DST_NOXFRM));
+	rt6 = ip6_dst_alloc(net, dev,
+			    DST_HOST | DST_NOPOLICY | DST_NOXFRM | DST_NOCACHE);
 	if (!rt6)
 		goto out;
 
-	dst = &rt6->dst;
-
-	rt6->rt6i_pcpu = alloc_percpu_gfp(struct rt6_info *, GFP_KERNEL);
-	if (!rt6->rt6i_pcpu) {
-		dst_destroy(dst);
-		goto out;
-	}
-	for_each_possible_cpu(cpu) {
-		struct rt6_info **p = per_cpu_ptr(rt6->rt6i_pcpu, cpu);
-		*p =  NULL;
-	}
-
-	memset(dst + 1, 0, sizeof(*rt6) - sizeof(*dst));
-
-	INIT_LIST_HEAD(&rt6->rt6i_siblings);
-	INIT_LIST_HEAD(&rt6->rt6i_uncached);
-
-	rt6->dst.input	= vrf_input6;
 	rt6->dst.output	= vrf_output6;
-
-	rt6->rt6i_table = fib6_get_table(dev_net(dev), vrf->tb_id);
-
-	atomic_set(&rt6->dst.__refcnt, 2);
-
+	rt6->rt6i_table = fib6_get_table(net, vrf->tb_id);
+	dst_hold(&rt6->dst);
 	vrf->rt6 = rt6;
 	rc = 0;
 out:
 	return rc;
 }
 #else
-static int init_dst_ops6_kmem_cachep(void)
-{
-	return 0;
-}
-
-static void free_dst_ops6_kmem_cachep(void)
-{
-}
-
-static void vrf_rt6_destroy(struct net_vrf *vrf)
+static void vrf_rt6_release(struct net_vrf *vrf)
 {
 }
 
@@ -577,11 +469,11 @@ static int vrf_output(struct net *net, s
 			    !(IPCB(skb)->flags & IPSKB_REROUTED));
 }
 
-static void vrf_rtable_destroy(struct net_vrf *vrf)
+static void vrf_rtable_release(struct net_vrf *vrf)
 {
 	struct dst_entry *dst = (struct dst_entry *)vrf->rth;
 
-	dst_destroy(dst);
+	dst_release(dst);
 	vrf->rth = NULL;
 }
 
@@ -590,22 +482,10 @@ static struct rtable *vrf_rtable_create(
 	struct net_vrf *vrf = netdev_priv(dev);
 	struct rtable *rth;
 
-	rth = dst_alloc(&vrf_dst_ops, dev, 2,
-			DST_OBSOLETE_NONE,
-			(DST_HOST | DST_NOPOLICY | DST_NOXFRM));
+	rth = rt_dst_alloc(dev, 0, RTN_UNICAST, 1, 1, 0);
 	if (rth) {
 		rth->dst.output	= vrf_output;
-		rth->rt_genid	= rt_genid_ipv4(dev_net(dev));
-		rth->rt_flags	= 0;
-		rth->rt_type	= RTN_UNICAST;
-		rth->rt_is_input = 0;
-		rth->rt_iif	= 0;
-		rth->rt_pmtu	= 0;
-		rth->rt_gateway	= 0;
-		rth->rt_uses_gateway = 0;
 		rth->rt_table_id = vrf->tb_id;
-		INIT_LIST_HEAD(&rth->rt_uncached);
-		rth->rt_uncached_list = NULL;
 	}
 
 	return rth;
@@ -739,8 +619,8 @@ static void vrf_dev_uninit(struct net_de
 //	struct list_head *head = &queue->all_slaves;
 //	struct slave *slave, *next;
 
-	vrf_rtable_destroy(vrf);
-	vrf_rt6_destroy(vrf);
+	vrf_rtable_release(vrf);
+	vrf_rt6_release(vrf);
 
 //	list_for_each_entry_safe(slave, next, head, list)
 //		vrf_del_slave(dev, slave->dev);
@@ -772,7 +652,7 @@ static int vrf_dev_init(struct net_devic
 	return 0;
 
 out_rth:
-	vrf_rtable_destroy(vrf);
+	vrf_rtable_release(vrf);
 out_stats:
 	free_percpu(dev->dstats);
 	dev->dstats = NULL;
@@ -805,7 +685,7 @@ static struct rtable *vrf_get_rtable(con
 		struct net_vrf *vrf = netdev_priv(dev);
 
 		rth = vrf->rth;
-		atomic_inc(&rth->dst.__refcnt);
+		dst_hold(&rth->dst);
 	}
 
 	return rth;
@@ -856,7 +736,7 @@ static struct dst_entry *vrf_get_rt6_dst
 		struct net_vrf *vrf = netdev_priv(dev);
 
 		rt = vrf->rt6;
-		atomic_inc(&rt->dst.__refcnt);
+		dst_hold(&rt->dst);
 	}
 
 	return (struct dst_entry *)rt;
@@ -1003,19 +883,6 @@ static int __init vrf_init_module(void)
 {
 	int rc;
 
-	vrf_dst_ops.kmem_cachep =
-		kmem_cache_create("vrf_ip_dst_cache",
-				  sizeof(struct rtable), 0,
-				  SLAB_HWCACHE_ALIGN,
-				  NULL);
-
-	if (!vrf_dst_ops.kmem_cachep)
-		return -ENOMEM;
-
-	rc = init_dst_ops6_kmem_cachep();
-	if (rc != 0)
-		goto error2;
-
 	register_netdevice_notifier(&vrf_notifier_block);
 
 	rc = rtnl_link_register(&vrf_link_ops);
@@ -1026,22 +893,10 @@ static int __init vrf_init_module(void)
 
 error:
 	unregister_netdevice_notifier(&vrf_notifier_block);
-	free_dst_ops6_kmem_cachep();
-error2:
-	kmem_cache_destroy(vrf_dst_ops.kmem_cachep);
 	return rc;
 }
 
-static void __exit vrf_cleanup_module(void)
-{
-	rtnl_link_unregister(&vrf_link_ops);
-	unregister_netdevice_notifier(&vrf_notifier_block);
-	kmem_cache_destroy(vrf_dst_ops.kmem_cachep);
-	free_dst_ops6_kmem_cachep();
-}
-
 module_init(vrf_init_module);
-module_exit(vrf_cleanup_module);
 MODULE_AUTHOR("Shrijeet Mukherjee, David Ahern");
 MODULE_DESCRIPTION("Device driver to instantiate VRF domains");
 MODULE_LICENSE("GPL");
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -103,6 +103,9 @@ void fib6_force_start_gc(struct net *net
 struct rt6_info *addrconf_dst_alloc(struct inet6_dev *idev,
 				    const struct in6_addr *addr, bool anycast);
 
+struct rt6_info *ip6_dst_alloc(struct net *net, struct net_device *dev,
+			       int flags);
+
 /*
  *	support functions for ND
  *
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -210,6 +210,9 @@ unsigned int inet_addr_type_dev_table(st
 void ip_rt_multicast_event(struct in_device *);
 int ip_rt_ioctl(struct net *, unsigned int cmd, void __user *arg);
 void ip_rt_get_source(u8 *src, struct sk_buff *skb, struct rtable *rt);
+struct rtable *rt_dst_alloc(struct net_device *dev,
+			     unsigned int flags, u16 type,
+			     bool nopolicy, bool noxfrm, bool will_cache);
 
 struct in_ifaddr;
 void fib_add_ifaddr(struct in_ifaddr *);
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1500,9 +1500,9 @@ static void rt_set_nexthop(struct rtable
 #endif
 }
 
-static struct rtable *rt_dst_alloc(struct net_device *dev,
-				   unsigned int flags, u16 type,
-				   bool nopolicy, bool noxfrm, bool will_cache)
+struct rtable *rt_dst_alloc(struct net_device *dev,
+			    unsigned int flags, u16 type,
+			    bool nopolicy, bool noxfrm, bool will_cache)
 {
 	struct rtable *rt;
 
@@ -1531,6 +1531,7 @@ static struct rtable *rt_dst_alloc(struc
 
 	return rt;
 }
+EXPORT_SYMBOL(rt_dst_alloc);
 
 /* called in rcu_read_lock() section */
 static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -339,9 +339,9 @@ static struct rt6_info *__ip6_dst_alloc(
 	return rt;
 }
 
-static struct rt6_info *ip6_dst_alloc(struct net *net,
-				      struct net_device *dev,
-				      int flags)
+struct rt6_info *ip6_dst_alloc(struct net *net,
+			       struct net_device *dev,
+			       int flags)
 {
 	struct rt6_info *rt = __ip6_dst_alloc(net, dev, flags);
 
@@ -365,6 +365,7 @@ static struct rt6_info *ip6_dst_alloc(st
 
 	return rt;
 }
+EXPORT_SYMBOL(ip6_dst_alloc);
 
 static void ip6_dst_destroy(struct dst_entry *dst)
 {


