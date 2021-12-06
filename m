Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6080469C58
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348295AbhLFPV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38610 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347445AbhLFPTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:19:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 237B561345;
        Mon,  6 Dec 2021 15:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066A9C341C2;
        Mon,  6 Dec 2021 15:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803764;
        bh=58+9mBtUDyf/bQKjXDZfwgK+jBcyodiJKbjRhPj2Hnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFualTV5Wcj2/7yXy1RoDDt/icLUxlp7Bs4vAnjrPrmEdnRB6jYg/ZyIGpKI0tfjs
         Bo82z1byUUDibIRlL9Moocp34gPVgYcL+4gdFCUmjMQa4qb3wHINB2T7dM+sSi9PMF
         8k3dNE8WbjavnEQasexpZKIV1On+kVweoFCXfsXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 031/130] vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit
Date:   Mon,  6 Dec 2021 15:55:48 +0100
Message-Id: <20211206145600.718913283@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>

commit ee201011c1e1563c114a55c86eb164b236f18e84 upstream.

IPCB/IP6CB need to be initialized when processing outbound v4 or v6 pkts
in the codepath of vrf device xmit function so that leftover garbage
doesn't cause futher code that uses the CB to incorrectly process the
pkt.

One occasion of the issue might occur when MPLS route uses the vrf
device as the outgoing device such as when the route is added using "ip
-f mpls route add <label> dev <vrf>" command.

The problems seems to exist since day one. Hence I put the day one
commits on the Fixes tags.

Fixes: 193125dbd8eb ("net: Introduce VRF device driver")
Fixes: 35402e313663 ("net: Add IPv6 support to VRF device")
Cc: stable@vger.kernel.org
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20211130162637.3249-1-ssuryaextr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vrf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -497,6 +497,7 @@ static netdev_tx_t vrf_process_v6_outbou
 	/* strip the ethernet header added for pass through VRF device */
 	__skb_pull(skb, skb_network_offset(skb));
 
+	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 	ret = vrf_ip6_local_out(net, skb->sk, skb);
 	if (unlikely(net_xmit_eval(ret)))
 		dev->stats.tx_errors++;
@@ -580,6 +581,7 @@ static netdev_tx_t vrf_process_v4_outbou
 					       RT_SCOPE_LINK);
 	}
 
+	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 	ret = vrf_ip_local_out(dev_net(skb_dst(skb)->dev), skb->sk, skb);
 	if (unlikely(net_xmit_eval(ret)))
 		vrf_dev->stats.tx_errors++;


