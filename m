Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D56582DB1
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241171AbiG0RBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237919AbiG0RBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:01:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5742857230;
        Wed, 27 Jul 2022 09:38:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1F71601CD;
        Wed, 27 Jul 2022 16:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAE1C433C1;
        Wed, 27 Jul 2022 16:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939878;
        bh=b4toqc/QbDYniqKpZ6WSq9fi4n5gdJWLetTFuuGFIp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdPUUlpOFZimCE4bEBumTsiMHBvYXc7NYtvaYzopY9TgYnn9reR8lMIakB8aAduHn
         x5R+SoYkh1KQJ+UdGRwXLRdEquPcBDhr6L8uXdmFHEqd8ft/YmAyBjjUuYIhb5B4H5
         GBL0q3Skd4fcX82oG+/PjWjNiMgIw4L8jh8H246I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 028/201] ip: Fix data-races around sysctl_ip_default_ttl.
Date:   Wed, 27 Jul 2022 18:08:52 +0200
Message-Id: <20220727161028.070987983@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 8281b7ec5c56b71cb2cc5a1728b41607be66959c upstream.

While reading sysctl_ip_default_ttl, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c |    2 +-
 include/net/route.h                                |    2 +-
 net/ipv4/ip_sockglue.c                             |    2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |    4 ++--
 net/ipv4/proc.c                                    |    2 +-
 net/netfilter/nf_synproxy_core.c                   |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -472,7 +472,7 @@ nfp_fl_set_tun(struct nfp_app *app, stru
 			set_tun->ttl = ip4_dst_hoplimit(&rt->dst);
 			ip_rt_put(rt);
 		} else {
-			set_tun->ttl = net->ipv4.sysctl_ip_default_ttl;
+			set_tun->ttl = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 		}
 	}
 
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -360,7 +360,7 @@ static inline int ip4_dst_hoplimit(const
 	struct net *net = dev_net(dst->dev);
 
 	if (hoplimit == 0)
-		hoplimit = net->ipv4.sysctl_ip_default_ttl;
+		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 	return hoplimit;
 }
 
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1597,7 +1597,7 @@ static int do_ip_getsockopt(struct sock
 	{
 		struct net *net = sock_net(sk);
 		val = (inet->uc_ttl == -1 ?
-		       net->ipv4.sysctl_ip_default_ttl :
+		       READ_ONCE(net->ipv4.sysctl_ip_default_ttl) :
 		       inet->uc_ttl);
 		break;
 	}
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -62,7 +62,7 @@ struct sk_buff *nf_reject_skb_v4_tcp_res
 
 	skb_reserve(nskb, LL_MAX_HEADER);
 	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
-				   net->ipv4.sysctl_ip_default_ttl);
+				   READ_ONCE(net->ipv4.sysctl_ip_default_ttl));
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
 	niph->tot_len = htons(nskb->len);
 	ip_send_check(niph);
@@ -115,7 +115,7 @@ struct sk_buff *nf_reject_skb_v4_unreach
 
 	skb_reserve(nskb, LL_MAX_HEADER);
 	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_ICMP,
-				   net->ipv4.sysctl_ip_default_ttl);
+				   READ_ONCE(net->ipv4.sysctl_ip_default_ttl));
 
 	skb_reset_transport_header(nskb);
 	icmph = skb_put_zero(nskb, sizeof(struct icmphdr));
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -387,7 +387,7 @@ static int snmp_seq_show_ipstats(struct
 
 	seq_printf(seq, "\nIp: %d %d",
 		   IPV4_DEVCONF_ALL(net, FORWARDING) ? 1 : 2,
-		   net->ipv4.sysctl_ip_default_ttl);
+		   READ_ONCE(net->ipv4.sysctl_ip_default_ttl));
 
 	BUILD_BUG_ON(offsetof(struct ipstats_mib, mibs) != 0);
 	snmp_get_cpu_field64_batch(buff64, snmp4_ipstats_list,
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -427,7 +427,7 @@ synproxy_build_ip(struct net *net, struc
 	iph->tos	= 0;
 	iph->id		= 0;
 	iph->frag_off	= htons(IP_DF);
-	iph->ttl	= net->ipv4.sysctl_ip_default_ttl;
+	iph->ttl	= READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 	iph->protocol	= IPPROTO_TCP;
 	iph->check	= 0;
 	iph->saddr	= saddr;


