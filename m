Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFDED137F37
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgAKKR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:17:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728946AbgAKKR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:17:26 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 870802077C;
        Sat, 11 Jan 2020 10:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737845;
        bh=9za9VCes88hNcwEd72PxsJEF/HoEC2B5BUm7jVnIZqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2AtRbPishnjMgZJ1V4T0lTa6dgPxvMtLnUTkgS1WxhnvSwSqrhg+YSamvnfwrT7jr
         vn0pCHWVh9e/QIsl98otVcI4dV1WsUwCfUGjT2bOwjc1IqEJ/XfmZak6gnp0NRwXvt
         qXbQi8u+qFID6XrDnNWzUE1Oe0P3u0ZSE/ZnJW+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 59/84] hv_netvsc: Fix unwanted rx_table reset
Date:   Sat, 11 Jan 2020 10:50:36 +0100
Message-Id: <20200111094908.483642770@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit b0689faa8efc5a3391402d7ae93bd373b7248e51 ]

In existing code, the receive indirection table, rx_table, is in
struct rndis_device, which will be reset when changing MTU, ringparam,
etc. User configured receive indirection table values will be lost.

To fix this, move rx_table to struct net_device_context, and check
netif_is_rxfh_configured(), so rx_table will be set to default only
if no user configured value.

Fixes: ff4a44199012 ("netvsc: allow get/set of RSS indirection table")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/hyperv_net.h   |  3 ++-
 drivers/net/hyperv/netvsc_drv.c   |  4 ++--
 drivers/net/hyperv/rndis_filter.c | 10 +++++++---
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 31d8d83c25ac..50709c76b672 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -181,7 +181,6 @@ struct rndis_device {
 
 	u8 hw_mac_adr[ETH_ALEN];
 	u8 rss_key[NETVSC_HASH_KEYLEN];
-	u16 rx_table[ITAB_NUM];
 };
 
 
@@ -933,6 +932,8 @@ struct net_device_context {
 
 	u32 tx_table[VRSS_SEND_TAB_SIZE];
 
+	u16 rx_table[ITAB_NUM];
+
 	/* Ethtool settings */
 	u8 duplex;
 	u32 speed;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index b7a71c203aa3..1f9f7fcdb0eb 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1688,7 +1688,7 @@ static int netvsc_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 	rndis_dev = ndev->extension;
 	if (indir) {
 		for (i = 0; i < ITAB_NUM; i++)
-			indir[i] = rndis_dev->rx_table[i];
+			indir[i] = ndc->rx_table[i];
 	}
 
 	if (key)
@@ -1718,7 +1718,7 @@ static int netvsc_set_rxfh(struct net_device *dev, const u32 *indir,
 				return -EINVAL;
 
 		for (i = 0; i < ITAB_NUM; i++)
-			rndis_dev->rx_table[i] = indir[i];
+			ndc->rx_table[i] = indir[i];
 	}
 
 	if (!key) {
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 53c6039bffb6..f47e36ac42a7 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -719,6 +719,7 @@ static int rndis_set_rss_param_msg(struct rndis_device *rdev,
 				   const u8 *rss_key, u16 flag)
 {
 	struct net_device *ndev = rdev->ndev;
+	struct net_device_context *ndc = netdev_priv(ndev);
 	struct rndis_request *request;
 	struct rndis_set_request *set;
 	struct rndis_set_complete *set_complete;
@@ -758,7 +759,7 @@ static int rndis_set_rss_param_msg(struct rndis_device *rdev,
 	/* Set indirection table entries */
 	itab = (u32 *)(rssp + 1);
 	for (i = 0; i < ITAB_NUM; i++)
-		itab[i] = rdev->rx_table[i];
+		itab[i] = ndc->rx_table[i];
 
 	/* Set hask key values */
 	keyp = (u8 *)((unsigned long)rssp + rssp->hashkey_offset);
@@ -1244,6 +1245,7 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
 				      struct netvsc_device_info *device_info)
 {
 	struct net_device *net = hv_get_drvdata(dev);
+	struct net_device_context *ndc = netdev_priv(net);
 	struct netvsc_device *net_device;
 	struct rndis_device *rndis_device;
 	struct ndis_recv_scale_cap rsscap;
@@ -1330,9 +1332,11 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
 	/* We will use the given number of channels if available. */
 	net_device->num_chn = min(net_device->max_chn, device_info->num_chn);
 
-	for (i = 0; i < ITAB_NUM; i++)
-		rndis_device->rx_table[i] = ethtool_rxfh_indir_default(
+	if (!netif_is_rxfh_configured(net)) {
+		for (i = 0; i < ITAB_NUM; i++)
+			ndc->rx_table[i] = ethtool_rxfh_indir_default(
 						i, net_device->num_chn);
+	}
 
 	atomic_set(&net_device->open_chn, 1);
 	vmbus_set_sc_create_callback(dev->channel, netvsc_sc_open);
-- 
2.20.1



