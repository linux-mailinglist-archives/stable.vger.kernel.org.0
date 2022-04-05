Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43AB4F29E2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241784AbiDEIf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239348AbiDEIT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CD6BC872;
        Tue,  5 Apr 2022 01:11:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BD58609AD;
        Tue,  5 Apr 2022 08:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBFDC385A1;
        Tue,  5 Apr 2022 08:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146302;
        bh=EHsZ8E2Brdkpwt7Xp80ysA7vNQCtBemTSOm/CnO5Ew4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ntj3CCwtWIE5pOZrJLShMWJ2Zng3Zy519OgQjVrwecNi3VJASNRxL+iWdv66N+m27
         QbX7XGHxwDLM94E5Ef22cn0dcJClJMq7We+pdD9HL5j9vs+TENkkJSJw23i4ZoTm8Z
         nj4wjIafMPZJaz3SVuf3l69HEPv1hrMGrJZ+wctY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0677/1126] bareudp: use ipv6_mod_enabled to check if IPv6 enabled
Date:   Tue,  5 Apr 2022 09:23:44 +0200
Message-Id: <20220405070427.494809987@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit e077ed58c243afc197bc2a2ba0e1ff61135e4ec2 ]

bareudp_create_sock() use AF_INET6 by default if IPv6 CONFIG enabled.
But if user start kernel with ipv6.disable=1, the bareudp sock will
created failed, which cause the interface open failed even with ethertype
ip. e.g.

 # ip link add bareudp1 type bareudp dstport 2 ethertype ip
 # ip link set bareudp1 up
 RTNETLINK answers: Address family not supported by protocol

Fix it by using ipv6_mod_enabled() to check if IPv6 enabled. There is
no need to check IS_ENABLED(CONFIG_IPV6) as ipv6_mod_enabled() will
return false when CONFIG_IPV6 no enabled in include/linux/ipv6.h.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20220315062618.156230-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index ba587e5fc24f..683203f87ae2 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -148,14 +148,14 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	skb_reset_network_header(skb);
 	skb_reset_mac_header(skb);
 
-	if (!IS_ENABLED(CONFIG_IPV6) || family == AF_INET)
+	if (!ipv6_mod_enabled() || family == AF_INET)
 		err = IP_ECN_decapsulate(oiph, skb);
 	else
 		err = IP6_ECN_decapsulate(oiph, skb);
 
 	if (unlikely(err)) {
 		if (log_ecn_error) {
-			if  (!IS_ENABLED(CONFIG_IPV6) || family == AF_INET)
+			if  (!ipv6_mod_enabled() || family == AF_INET)
 				net_info_ratelimited("non-ECT from %pI4 "
 						     "with TOS=%#x\n",
 						     &((struct iphdr *)oiph)->saddr,
@@ -221,11 +221,12 @@ static struct socket *bareudp_create_sock(struct net *net, __be16 port)
 	int err;
 
 	memset(&udp_conf, 0, sizeof(udp_conf));
-#if IS_ENABLED(CONFIG_IPV6)
-	udp_conf.family = AF_INET6;
-#else
-	udp_conf.family = AF_INET;
-#endif
+
+	if (ipv6_mod_enabled())
+		udp_conf.family = AF_INET6;
+	else
+		udp_conf.family = AF_INET;
+
 	udp_conf.local_udp_port = port;
 	/* Open UDP socket */
 	err = udp_sock_create(net, &udp_conf, &sock);
@@ -448,7 +449,7 @@ static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	rcu_read_lock();
-	if (IS_ENABLED(CONFIG_IPV6) && info->mode & IP_TUNNEL_INFO_IPV6)
+	if (ipv6_mod_enabled() && info->mode & IP_TUNNEL_INFO_IPV6)
 		err = bareudp6_xmit_skb(skb, dev, bareudp, info);
 	else
 		err = bareudp_xmit_skb(skb, dev, bareudp, info);
@@ -478,7 +479,7 @@ static int bareudp_fill_metadata_dst(struct net_device *dev,
 
 	use_cache = ip_tunnel_dst_cache_usable(skb, info);
 
-	if (!IS_ENABLED(CONFIG_IPV6) || ip_tunnel_info_af(info) == AF_INET) {
+	if (!ipv6_mod_enabled() || ip_tunnel_info_af(info) == AF_INET) {
 		struct rtable *rt;
 		__be32 saddr;
 
-- 
2.34.1



