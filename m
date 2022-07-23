Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D0457F01E
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 17:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiGWPh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 11:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGWPh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 11:37:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9E61DA6A
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 08:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53184B80D09
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 15:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33E7C341C0;
        Sat, 23 Jul 2022 15:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658590673;
        bh=6dkuciq4xz3pTP9Y/lf1OEP7ypLsnn5R0D8+8d+eNSM=;
        h=Subject:To:Cc:From:Date:From;
        b=gZf6jP3u606ysHE7RHjYgdysS4p6VB0UBij5XhGp0yiemcSt7lB4PN9Q7cfmW9YU0
         s8F/Fw/bRA19boYflVrXseERlkpT3Xc1G0lwGNPkLNa1QqsNxHblST3phaX34p6gWp
         zV57k2g/UPqqES45bypeLioCZh7/VMXCzUH21rTQ=
Subject: FAILED: patch "[PATCH] ip: Fix data-races around sysctl_ip_default_ttl." failed to apply to 4.9-stable tree
To:     kuniyu@amazon.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 23 Jul 2022 17:37:39 +0200
Message-ID: <16585906592561@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8281b7ec5c56b71cb2cc5a1728b41607be66959c Mon Sep 17 00:00:00 2001
From: Kuniyuki Iwashima <kuniyu@amazon.com>
Date: Wed, 13 Jul 2022 13:51:51 -0700
Subject: [PATCH] ip: Fix data-races around sysctl_ip_default_ttl.

While reading sysctl_ip_default_ttl, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 0147de405365..ffb6f6d05a07 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -474,7 +474,7 @@ nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
 			set_tun->ttl = ip4_dst_hoplimit(&rt->dst);
 			ip_rt_put(rt);
 		} else {
-			set_tun->ttl = net->ipv4.sysctl_ip_default_ttl;
+			set_tun->ttl = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 		}
 	}
 
diff --git a/include/net/route.h b/include/net/route.h
index 991a3985712d..bbcf2aba149f 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -373,7 +373,7 @@ static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
 	struct net *net = dev_net(dst->dev);
 
 	if (hoplimit == 0)
-		hoplimit = net->ipv4.sysctl_ip_default_ttl;
+		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 	return hoplimit;
 }
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 445a9ecaefa1..d497d525dea3 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1606,7 +1606,7 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	{
 		struct net *net = sock_net(sk);
 		val = (inet->uc_ttl == -1 ?
-		       net->ipv4.sysctl_ip_default_ttl :
+		       READ_ONCE(net->ipv4.sysctl_ip_default_ttl) :
 		       inet->uc_ttl);
 		break;
 	}
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 918c61fda0f3..d640adcaf1b1 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -62,7 +62,7 @@ struct sk_buff *nf_reject_skb_v4_tcp_reset(struct net *net,
 
 	skb_reserve(nskb, LL_MAX_HEADER);
 	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
-				   net->ipv4.sysctl_ip_default_ttl);
+				   READ_ONCE(net->ipv4.sysctl_ip_default_ttl));
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
 	niph->tot_len = htons(nskb->len);
 	ip_send_check(niph);
@@ -117,7 +117,7 @@ struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
 
 	skb_reserve(nskb, LL_MAX_HEADER);
 	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_ICMP,
-				   net->ipv4.sysctl_ip_default_ttl);
+				   READ_ONCE(net->ipv4.sysctl_ip_default_ttl));
 
 	skb_reset_transport_header(nskb);
 	icmph = skb_put_zero(nskb, sizeof(struct icmphdr));
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 28836071f0a6..0088a4c64d77 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -387,7 +387,7 @@ static int snmp_seq_show_ipstats(struct seq_file *seq, void *v)
 
 	seq_printf(seq, "\nIp: %d %d",
 		   IPV4_DEVCONF_ALL(net, FORWARDING) ? 1 : 2,
-		   net->ipv4.sysctl_ip_default_ttl);
+		   READ_ONCE(net->ipv4.sysctl_ip_default_ttl));
 
 	BUILD_BUG_ON(offsetof(struct ipstats_mib, mibs) != 0);
 	snmp_get_cpu_field64_batch(buff64, snmp4_ipstats_list,
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index e479dd0561c5..16915f8eef2b 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -405,7 +405,7 @@ synproxy_build_ip(struct net *net, struct sk_buff *skb, __be32 saddr,
 	iph->tos	= 0;
 	iph->id		= 0;
 	iph->frag_off	= htons(IP_DF);
-	iph->ttl	= net->ipv4.sysctl_ip_default_ttl;
+	iph->ttl	= READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 	iph->protocol	= IPPROTO_TCP;
 	iph->check	= 0;
 	iph->saddr	= saddr;

