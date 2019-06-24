Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA6A508A7
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbfFXKVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbfFXKVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:21:40 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDA622089F;
        Mon, 24 Jun 2019 10:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371699;
        bh=BoomFJW/1NNweO7euA096XJIfZxFk1tLT5l9P0tVrGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y42C/gbu52flmSZyMLl+sv9KefvWED24MLUHYdbidUiUIwIWu1UtrpL3H22IFnqTI
         NAw/RwNBw+6CV2eP5y+8yRif2K7VQyc+MmvPSNtCEn65IZKn4sAcpeFdtydNATVDyb
         SFQTJ9y0MnaiJmQqAHviy0RcTa7LSpaYp+nwKaNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 079/121] net: ipvlan: Fix ipvlan device tso disabled while NETIF_F_IP_CSUM is set
Date:   Mon, 24 Jun 2019 17:56:51 +0800
Message-Id: <20190624092324.908699931@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ceae266bf0ae6564ac16d086bf749a096fa90ded ]

There's some NICs, such as hinic, with NETIF_F_IP_CSUM and NETIF_F_TSO
on but NETIF_F_HW_CSUM off. And ipvlan device features will be
NETIF_F_TSO on with NETIF_F_IP_CSUM and NETIF_F_IP_CSUM both off as
IPVLAN_FEATURES only care about NETIF_F_HW_CSUM. So TSO will be
disabled in netdev_fix_features.
For example:
Features for enp129s0f0:
rx-checksumming: on
tx-checksumming: on
        tx-checksum-ipv4: on
        tx-checksum-ip-generic: off [fixed]
        tx-checksum-ipv6: on

Fixes: a188222b6ed2 ("net: Rename NETIF_F_ALL_CSUM to NETIF_F_CSUM_MASK")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index bbeb1623e2d5..717fce6edeb7 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -112,7 +112,7 @@ static void ipvlan_port_destroy(struct net_device *dev)
 }
 
 #define IPVLAN_FEATURES \
-	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
+	(NETIF_F_SG | NETIF_F_CSUM_MASK | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
 	 NETIF_F_GSO | NETIF_F_TSO | NETIF_F_GSO_ROBUST | \
 	 NETIF_F_TSO_ECN | NETIF_F_TSO6 | NETIF_F_GRO | NETIF_F_RXCSUM | \
 	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER)
-- 
2.20.1



