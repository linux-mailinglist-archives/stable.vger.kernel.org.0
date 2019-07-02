Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29FD35CA63
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfGBIDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727485AbfGBIDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:03:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930AC21874;
        Tue,  2 Jul 2019 08:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054620;
        bh=BRP7Ql1eActHI1tbBOAzaSFubYS8GkEJ87I9ftlT1/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/xUv6cmxlNwSBAQGzYoJ18b8qUqNRzBEzNfdn1I+ACY1v8P52oGBhw+zWvjt97z/
         /NwP4b5UGWjCCdBv21bodm+Sz/8zGHyrZmujr2yH+kNS3FYunMCOQn8vrouyfbMLwO
         52smwMk/x/0tf6Of9Jl9LL1zIuze52F7olcIa3Ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        YueHaibing <yuehaibing@huawei.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 31/55] bonding: Always enable vlan tx offload
Date:   Tue,  2 Jul 2019 10:01:39 +0200
Message-Id: <20190702080125.750796171@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 30d8177e8ac776d89d387fad547af6a0f599210e ]

We build vlan on top of bonding interface, which vlan offload
is off, bond mode is 802.3ad (LACP) and xmit_hash_policy is
BOND_XMIT_POLICY_ENCAP34.

Because vlan tx offload is off, vlan tci is cleared and skb push
the vlan header in validate_xmit_vlan() while sending from vlan
devices. Then in bond_xmit_hash, __skb_flow_dissect() fails to
get information from protocol headers encapsulated within vlan,
because 'nhoff' is points to IP header, so bond hashing is based
on layer 2 info, which fails to distribute packets across slaves.

This patch always enable bonding's vlan tx offload, pass the vlan
packets to the slave devices with vlan tci, let them to handle
vlan implementation.

Fixes: 278339a42a1b ("bonding: propogate vlan_features to bonding master")
Suggested-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4321,12 +4321,12 @@ void bond_setup(struct net_device *bond_
 	bond_dev->features |= NETIF_F_NETNS_LOCAL;
 
 	bond_dev->hw_features = BOND_VLAN_FEATURES |
-				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
 	bond_dev->features |= bond_dev->hw_features;
+	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
 }
 
 /* Destroy a bonding device.


