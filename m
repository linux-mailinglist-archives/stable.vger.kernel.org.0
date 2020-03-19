Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8757918B687
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730928AbgCSN1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730331AbgCSN1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:27:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51B49208C3;
        Thu, 19 Mar 2020 13:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624462;
        bh=vwFQSTRGBXIuEHRlKDxDsMBN5Lx7bJ4941rvcPOxF5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIsSJplxxEd0ZIRVJ1E0NqmkAz5NtRoOrqXJQyACZ05qKTjL/VtYmtmCgLmLXIWXK
         5AWFA8f+ZaVWWCJtsZSPboKzAm/rfS8wTpPCCC84LTN1l7zsoJZl949G5Q8TNIJIs2
         gz4yp5FLbn441xpgf6+BgJstMvJoYqWtKXQYgq00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 53/65] net: rmnet: fix packet forwarding in rmnet bridge mode
Date:   Thu, 19 Mar 2020 14:04:35 +0100
Message-Id: <20200319123943.072434015@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit ad3cc31b599ea80f06b29ebdc18b3a39878a48d6 ]

Packet forwarding is not working in rmnet bridge mode.
Because when a packet is forwarded, skb_push() for an ethernet header
is needed. But it doesn't call skb_push().
So, the ethernet header will be lost.

Test commands:
    modprobe rmnet
    ip netns add nst
    ip netns add nst2
    ip link add veth0 type veth peer name veth1
    ip link add veth2 type veth peer name veth3
    ip link set veth1 netns nst
    ip link set veth3 netns nst2

    ip link add rmnet0 link veth0 type rmnet mux_id 1
    ip link set veth2 master rmnet0
    ip link set veth0 up
    ip link set veth2 up
    ip link set rmnet0 up
    ip a a 192.168.100.1/24 dev rmnet0

    ip netns exec nst ip link set veth1 up
    ip netns exec nst ip a a 192.168.100.2/24 dev veth1
    ip netns exec nst2 ip link set veth3 up
    ip netns exec nst2 ip a a 192.168.100.3/24 dev veth3
    ip netns exec nst2 ping 192.168.100.2

Fixes: 60d58f971c10 ("net: qualcomm: rmnet: Implement bridge mode")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 074a8b326c304..29a7bfa2584dc 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -159,6 +159,9 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
 static void
 rmnet_bridge_handler(struct sk_buff *skb, struct net_device *bridge_dev)
 {
+	if (skb_mac_header_was_set(skb))
+		skb_push(skb, skb->mac_len);
+
 	if (bridge_dev) {
 		skb->dev = bridge_dev;
 		dev_queue_xmit(skb);
-- 
2.20.1



