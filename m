Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC23A4F3C2B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239607AbiDEMFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358237AbiDEK2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:28:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1BE26F7;
        Tue,  5 Apr 2022 03:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88D9961777;
        Tue,  5 Apr 2022 10:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEACC385A0;
        Tue,  5 Apr 2022 10:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153839;
        bh=4pqGxkskrWE83X7/O4wtvxnLKOLOnMpMjiOgycSXnrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjz33JUEOOpXn7e5jTI/4DLfUU+xRvJNkXlJ0LK3GeIh5ro7fAN5rlDyySVEdtoh5
         DeQtra9AGg/hJUjRlysqTgZcxrTC4I0Xj5nnN46P93dWr/ejRPclDglJkqgNML5vbD
         ORvvVJ/TbUG/N9PtC7aejJ1FhrleziUaee29MNt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 363/599] bareudp: use ipv6_mod_enabled to check if IPv6 enabled
Date:   Tue,  5 Apr 2022 09:30:57 +0200
Message-Id: <20220405070309.633052193@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
 drivers/net/bareudp.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -140,14 +140,14 @@ static int bareudp_udp_encap_recv(struct
 	oiph = skb_network_header(skb);
 	skb_reset_network_header(skb);
 
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
@@ -213,11 +213,12 @@ static struct socket *bareudp_create_soc
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
@@ -439,7 +440,7 @@ static netdev_tx_t bareudp_xmit(struct s
 	}
 
 	rcu_read_lock();
-	if (IS_ENABLED(CONFIG_IPV6) && info->mode & IP_TUNNEL_INFO_IPV6)
+	if (ipv6_mod_enabled() && info->mode & IP_TUNNEL_INFO_IPV6)
 		err = bareudp6_xmit_skb(skb, dev, bareudp, info);
 	else
 		err = bareudp_xmit_skb(skb, dev, bareudp, info);
@@ -469,7 +470,7 @@ static int bareudp_fill_metadata_dst(str
 
 	use_cache = ip_tunnel_dst_cache_usable(skb, info);
 
-	if (!IS_ENABLED(CONFIG_IPV6) || ip_tunnel_info_af(info) == AF_INET) {
+	if (!ipv6_mod_enabled() || ip_tunnel_info_af(info) == AF_INET) {
 		struct rtable *rt;
 		__be32 saddr;
 


