Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCBD6648FB
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbjAJSQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239082AbjAJSQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:16:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C183DBE1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:14:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C95E961852
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52B3C433D2;
        Tue, 10 Jan 2023 18:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374469;
        bh=NdONkRqDfhfsmbWdxtQFJ41sg3zPuAhjcGzhWYNQdZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Qo2nihdGsNB4fyHS0DrrQrmhbW9dL9H914WHhb4nTqol++8TS2I8rA5rC1lI9us1
         i+fCOymQh8nQqMsvWxXRXB01Uqo/rebIX5W167HzkYeBLeTFQ/XFC7rQuzCcBt/b9n
         1EY1ISlbSTJQVmBJc0AlOkg3G4m5o/Tsm1c8XRes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jianlin Shi <jishi@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/159] net: vrf: determine the dst using the original ifindex for multicast
Date:   Tue, 10 Jan 2023 19:02:48 +0100
Message-Id: <20230110180018.954614625@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit f2575c8f404911da83f25b688e12afcf4273e640 ]

Multicast packets received on an interface bound to a VRF are marked as
belonging to the VRF and the skb device is updated to point to the VRF
device itself. This was fine even when a route was associated to a
device as when performing a fib table lookup 'oif' in fib6_table_lookup
(coming from 'skb->dev->ifindex' in ip6_route_input) was set to 0 when
FLOWI_FLAG_SKIP_NH_OIF was set.

With commit 40867d74c374 ("net: Add l3mdev index to flow struct and
avoid oif reset for port devices") this is not longer true and multicast
traffic is not received on the original interface.

Instead of adding back a similar check in fib6_table_lookup determine
the dst using the original ifindex for multicast VRF traffic. To make
things consistent across the function do the above for all strict
packets, which was the logic before commit 6f12fa775530 ("vrf: mark skb
for multicast or link-local as enslaved to VRF"). Note that reverting to
this behavior should be fine as the change was about marking packets
belonging to the VRF, not about their dst.

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20221220171825.1172237-1-atenart@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index badf6f09ae51..f6dcec66f0a4 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1385,8 +1385,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
-	 * For strict packets with a source LLA, determine the dst using the
-	 * original ifindex.
+	 * For non-loopback strict packets, determine the dst using the original
+	 * ifindex.
 	 */
 	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
 		skb->dev = vrf_dev;
@@ -1395,7 +1395,7 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 
 		if (skb->pkt_type == PACKET_LOOPBACK)
 			skb->pkt_type = PACKET_HOST;
-		else if (ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)
+		else
 			vrf_ip6_input_dst(skb, vrf_dev, orig_iif);
 
 		goto out;
-- 
2.35.1



