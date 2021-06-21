Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FFB3AEFBF
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhFUQlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233324AbhFUQjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:39:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08F9B61436;
        Mon, 21 Jun 2021 16:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293005;
        bh=2seRv+oWTq/eXrL599aTNntv1wxojapTE296o8mjVmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXuwfGc4SdrwdOzcD3ao7bLwvgVhI+rBvn0WpcJ6YHRuUscoZF4E4K8PHMi9uqBlk
         LN9hY09tQfjqempIuWPxeMQim/H5/ASe2iTThfDbPbMLly9Lp9SfkVuiDCE1pjSXpl
         33R/srZwDNDLu7eAkR7IlIl9JiWMjbqyJO92FzHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 020/178] vrf: fix maximum MTU
Date:   Mon, 21 Jun 2021 18:13:54 +0200
Message-Id: <20210621154922.384320994@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 9bb392f62447d73cc7dd7562413a2cd9104c82f8 ]

My initial goal was to fix the default MTU, which is set to 65536, ie above
the maximum defined in the driver: 65535 (ETH_MAX_MTU).

In fact, it's seems more consistent, wrt min_mtu, to set the max_mtu to
IP6_MAX_MTU (65535 + sizeof(struct ipv6hdr)) and use it by default.

Let's also, for consistency, set the mtu in vrf_setup(). This function
calls ether_setup(), which set the mtu to 1500. Thus, the whole mtu config
is done in the same function.

Before the patch:
$ ip link add blue type vrf table 1234
$ ip link list blue
9: blue: <NOARP,MASTER> mtu 65536 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether fa:f5:27:70:24:2a brd ff:ff:ff:ff:ff:ff
$ ip link set dev blue mtu 65535
$ ip link set dev blue mtu 65536
Error: mtu greater than device maximum.

Fixes: 5055376a3b44 ("net: vrf: Fix ping failed when vrf mtu is set to 0")
CC: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 503e2fd7ce51..28a6c4cfe9b8 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1183,9 +1183,6 @@ static int vrf_dev_init(struct net_device *dev)
 
 	dev->flags = IFF_MASTER | IFF_NOARP;
 
-	/* MTU is irrelevant for VRF device; set to 64k similar to lo */
-	dev->mtu = 64 * 1024;
-
 	/* similarly, oper state is irrelevant; set to up to avoid confusion */
 	dev->operstate = IF_OPER_UP;
 	netdev_lockdep_set_classes(dev);
@@ -1685,7 +1682,8 @@ static void vrf_setup(struct net_device *dev)
 	 * which breaks networking.
 	 */
 	dev->min_mtu = IPV6_MIN_MTU;
-	dev->max_mtu = ETH_MAX_MTU;
+	dev->max_mtu = IP6_MAX_MTU;
+	dev->mtu = dev->max_mtu;
 }
 
 static int vrf_validate(struct nlattr *tb[], struct nlattr *data[],
-- 
2.30.2



