Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D95F1380AB
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731293AbgAKKcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:32:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729256AbgAKKcy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:32:54 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9DD620842;
        Sat, 11 Jan 2020 10:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738773;
        bh=QOcdDaWnWLLs1wtbgqB4q+1P23t6Kamg/vmjCzaWMqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1s3kCIwD1wPx+KB1Ir8ewrUp88yZakPTmL+B7jxFXCjLk6iVmHDDFbtf29yKirEjW
         NPSC02QT5sA25158EVLzxsw4mexF6DaftlxkwCfvpcpQ16Pi1XaJ6MlvK5jpqtosQI
         gCjiL3FNdEx78tFV121vEs4nXera7JbGGNaRvQN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/165] hv_netvsc: Fix unwanted rx_table reset
Date:   Sat, 11 Jan 2020 10:50:54 +0100
Message-Id: <20200111094936.961024266@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
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
index fb547f37af1e..e74f2d1def80 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -169,7 +169,6 @@ struct rndis_device {
 
 	u8 hw_mac_adr[ETH_ALEN];
 	u8 rss_key[NETVSC_HASH_KEYLEN];
-	u16 rx_table[ITAB_NUM];
 };
 
 
@@ -938,6 +937,8 @@ struct net_device_context {
 
 	u32 tx_table[VRSS_SEND_TAB_SIZE];
 
+	u16 rx_table[ITAB_NUM];
+
 	/* Ethtool settings */
 	u8 duplex;
 	u32 speed;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 963509add611..78e3e689a733 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1659,7 +1659,7 @@ static int netvsc_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 	rndis_dev = ndev->extension;
 	if (indir) {
 		for (i = 0; i < ITAB_NUM; i++)
-			indir[i] = rndis_dev->rx_table[i];
+			indir[i] = ndc->rx_table[i];
 	}
 
 	if (key)
@@ -1689,7 +1689,7 @@ static int netvsc_set_rxfh(struct net_device *dev, const u32 *indir,
 				return -EINVAL;
 
 		for (i = 0; i < ITAB_NUM; i++)
-			rndis_dev->rx_table[i] = indir[i];
+			ndc->rx_table[i] = indir[i];
 	}
 
 	if (!key) {
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index e3d3c9097ff1..f81e58267a6e 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -767,6 +767,7 @@ static int rndis_set_rss_param_msg(struct rndis_device *rdev,
 				   const u8 *rss_key, u16 flag)
 {
 	struct net_device *ndev = rdev->ndev;
+	struct net_device_context *ndc = netdev_priv(ndev);
 	struct rndis_request *request;
 	struct rndis_set_request *set;
 	struct rndis_set_complete *set_complete;
@@ -806,7 +807,7 @@ static int rndis_set_rss_param_msg(struct rndis_device *rdev,
 	/* Set indirection table entries */
 	itab = (u32 *)(rssp + 1);
 	for (i = 0; i < ITAB_NUM; i++)
-		itab[i] = rdev->rx_table[i];
+		itab[i] = ndc->rx_table[i];
 
 	/* Set hask key values */
 	keyp = (u8 *)((unsigned long)rssp + rssp->hashkey_offset);
@@ -1305,6 +1306,7 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
 				      struct netvsc_device_info *device_info)
 {
 	struct net_device *net = hv_get_drvdata(dev);
+	struct net_device_context *ndc = netdev_priv(net);
 	struct netvsc_device *net_device;
 	struct rndis_device *rndis_device;
 	struct ndis_recv_scale_cap rsscap;
@@ -1391,9 +1393,11 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
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



