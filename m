Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E23C91F00D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732589AbfEOL3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729916AbfEOL3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:29:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE0682089E;
        Wed, 15 May 2019 11:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919781;
        bh=2uV+ZTq8AYn4p8wD8+jiKUpcpJBue73+IgwNqmd6hDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07ZMUC7jZ0ftvvJDXKj6S5HO/UbcAhsFvLiTXlT2kNrYt01FctPIKErSynuChNyzi
         Qajyg6FcY4okg2JRqVGhO+/dEylrqSIVvYfF3memaSlH3kSRZdfsHhuSyMlTuKSuqi
         QcO/mro6ZEA87D/MrE2Z42g6SWgP0L61+NB4Oh+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <wanghui104@huawei.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 092/137] net: vrf: Fix operation not supported when set vrf mac
Date:   Wed, 15 May 2019 12:56:13 +0200
Message-Id: <20190515090700.221301019@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6819e3f6d83a24777813b0d031ebe0861694db5a ]

Vrf device is not able to change mac address now because lack of
ndo_set_mac_address. Complete this in case some apps need to do
this.

Reported-by: Hui Wang <wanghui104@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index cd15c32b2e436..9ee4d7402ca23 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -875,6 +875,7 @@ static const struct net_device_ops vrf_netdev_ops = {
 	.ndo_init		= vrf_dev_init,
 	.ndo_uninit		= vrf_dev_uninit,
 	.ndo_start_xmit		= vrf_xmit,
+	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_get_stats64	= vrf_get_stats64,
 	.ndo_add_slave		= vrf_add_slave,
 	.ndo_del_slave		= vrf_del_slave,
@@ -1274,6 +1275,7 @@ static void vrf_setup(struct net_device *dev)
 	/* default to no qdisc; user can add if desired */
 	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->priv_flags |= IFF_NO_RX_HANDLER;
+	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
 	/* VRF devices do not care about MTU, but if the MTU is set
 	 * too low then the ipv4 and ipv6 protocols are disabled
-- 
2.20.1



