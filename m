Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF46CD74F
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfJFR0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfJFR0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:26:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3066B2070B;
        Sun,  6 Oct 2019 17:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382813;
        bh=XtQveHy+7t5bV9H6S02QhmT222autKJXMjgLRbyvI9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMc/rdUBP94r+kQQqte16GGm4CKbbGhXDIEmUVl8fkMwkl2rUByHdltRU7XM2Q08B
         B5dXMXT3OX+ujZg6He1JeeNOC0lrv06nrN0oYHY710wN8bWQ2welvcv+mNLhgpsqkt
         9kX4Ucp9StlZOtSKmKeKyRlZxce0XhfKGcdyfXvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 50/68] erspan: remove the incorrect mtu limit for erspan
Date:   Sun,  6 Oct 2019 19:21:26 +0200
Message-Id: <20191006171131.476641420@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

[ Upstream commit 0e141f757b2c78c983df893e9993313e2dc21e38 ]

erspan driver calls ether_setup(), after commit 61e84623ace3
("net: centralize net_device min/max MTU checking"), the range
of mtu is [min_mtu, max_mtu], which is [68, 1500] by default.

It causes the dev mtu of the erspan device to not be greater
than 1500, this limit value is not correct for ipgre tap device.

Tested:
Before patch:
# ip link set erspan0 mtu 1600
Error: mtu greater than device maximum.
After patch:
# ip link set erspan0 mtu 1600
# ip -d link show erspan0
21: erspan0@NONE: <BROADCAST,MULTICAST> mtu 1600 qdisc noop state DOWN
mode DEFAULT group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 0

Fixes: 61e84623ace3 ("net: centralize net_device min/max MTU checking")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1424,6 +1424,7 @@ nla_put_failure:
 static void erspan_setup(struct net_device *dev)
 {
 	ether_setup(dev);
+	dev->max_mtu = 0;
 	dev->netdev_ops = &erspan_netdev_ops;
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;


