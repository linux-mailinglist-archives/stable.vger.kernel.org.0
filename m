Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E77657F55
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbiL1QEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbiL1QDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:03:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97221903B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:03:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86CB26156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9837CC433D2;
        Wed, 28 Dec 2022 16:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243421;
        bh=cX+wMTyhYScw4iy2M8vV03P9zVumoBhGCoBlIjXFqiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVeT2SoT8Z8olKYDy4SfxtSyAUMMkPSsPFvMpj7hf2EnJHaF2GwBF0nZy4Cc70Hr5
         sZh3d7XaGTLjnGeVvmDMpe0KweVv641DfU4xpQVmofvrdCNG4zZoY6r0MC+ZLp/Ft1
         mtVZEPwVsHIr1C1MZrFtGuVOX4Uhe9igSemHr2eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <oliver.sang@intel.com>,
        Richard Gobert <richardbgobert@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0527/1073] net: setsockopt: fix IPV6_UNICAST_IF option for connected sockets
Date:   Wed, 28 Dec 2022 15:35:15 +0100
Message-Id: <20221228144342.358907746@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Gobert <richardbgobert@gmail.com>

[ Upstream commit 526682b458b1b56d2e0db027df535cb5cdcfde59 ]

Change the behaviour of ip6_datagram_connect to consider the interface
set by the IPV6_UNICAST_IF socket option, similarly to udpv6_sendmsg.

This change is the IPv6 counterpart of the fix for IP_UNICAST_IF.
The tests introduced by that patch showed that the incorrect
behavior is present in IPv6 as well.
This patch fixes the broken test.

Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/r/202210062117.c7eef1a3-oliver.sang@intel.com
Fixes: 0e4d354762ce ("net-next: Fix IP_UNICAST_IF option behavior for connected sockets")

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/datagram.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 5ecb56522f9d..ba28aeb7cade 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -42,24 +42,29 @@ static void ip6_datagram_flow_key_init(struct flowi6 *fl6, struct sock *sk)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct ipv6_pinfo *np = inet6_sk(sk);
+	int oif = sk->sk_bound_dev_if;
 
 	memset(fl6, 0, sizeof(*fl6));
 	fl6->flowi6_proto = sk->sk_protocol;
 	fl6->daddr = sk->sk_v6_daddr;
 	fl6->saddr = np->saddr;
-	fl6->flowi6_oif = sk->sk_bound_dev_if;
 	fl6->flowi6_mark = sk->sk_mark;
 	fl6->fl6_dport = inet->inet_dport;
 	fl6->fl6_sport = inet->inet_sport;
 	fl6->flowlabel = np->flow_label;
 	fl6->flowi6_uid = sk->sk_uid;
 
-	if (!fl6->flowi6_oif)
-		fl6->flowi6_oif = np->sticky_pktinfo.ipi6_ifindex;
+	if (!oif)
+		oif = np->sticky_pktinfo.ipi6_ifindex;
 
-	if (!fl6->flowi6_oif && ipv6_addr_is_multicast(&fl6->daddr))
-		fl6->flowi6_oif = np->mcast_oif;
+	if (!oif) {
+		if (ipv6_addr_is_multicast(&fl6->daddr))
+			oif = np->mcast_oif;
+		else
+			oif = np->ucast_oif;
+	}
 
+	fl6->flowi6_oif = oif;
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
 }
 
-- 
2.35.1



