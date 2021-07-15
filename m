Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BAA3CAA81
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242575AbhGOTN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241587AbhGOTL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:11:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3122E613DC;
        Thu, 15 Jul 2021 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376110;
        bh=wOVrGgzmc5xXjjsu0Ye3UynUuRmj4nk7BBzK9QZuw7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6ZYRv3zKxFA4r1TsJRXKjY5d4pEqI50SxVT7/PpUKDl5/OhiaNqNI3DKu+kVv/Th
         cTN1BZepnfe+BMYYQyTWu/UQ73jOu56KACMSygjgb63/XmHOCQb95Gs05Iy8WgLMf2
         kTXGAFCYXd3YYdrgMkXVLj1+AStScEs7b7idGPXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Fugang Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 132/266] net: fec: add ndo_select_queue to fix TX bandwidth fluctuations
Date:   Thu, 15 Jul 2021 20:38:07 +0200
Message-Id: <20210715182637.182595673@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit 52c4a1a85f4b346c39c896c0168f4a843b3385ff ]

As we know that AVB is enabled by default, and the ENET IP design is
queue 0 for best effort, queue 1&2 for AVB Class A&B. Bandwidth of each
queue 1&2 set in driver is 50%, TX bandwidth fluctuated when selecting
tx queues randomly with FEC_QUIRK_HAS_AVB quirk available.

This patch adds ndo_select_queue callback to select queues for
transmitting to fix this issue. It will always return queue 0 if this is
not a vlan packet, and return queue 1 or 2 based on priority of vlan
packet.

You may complain that in fact we only use single queue for trasmitting
if we are not targeted to VLAN. Yes, but seems we have no choice, since
AVB is enabled when the driver probed, we can't switch this feature
dynamicly. After compare multiple queues to single queue, TX throughput
almost no improvement.

One way we can implemet is to configure the driver to multiple queues
with Round-robin scheme by default. Then add ndo_setup_tc callback to
enable/disable AVB feature for users. Unfortunately, ENET AVB IP seems
not follow the standard 802.1Qav spec. We only can program
DMAnCFG[IDLE_SLOPE] field to calculate bandwidth fraction. And idle
slope is restricted to certain valus (a total of 19). It's far away from
CBS QDisc implemented in Linux TC framework. If you strongly suggest to do
this, I think we only can support limited numbers of bandwidth and reject
others, but it's really urgly and wried.

With this patch, VLAN tagged packets route to queue 0/1/2 based on vlan
priority; VLAN untagged packets route to queue 0.

Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 98cd38379275..8aea707a65a7 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -76,6 +76,8 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
 
 #define DRIVER_NAME	"fec"
 
+static const u16 fec_enet_vlan_pri_to_queue[8] = {0, 0, 1, 1, 1, 2, 2, 2};
+
 /* Pause frame feild and FIFO threshold */
 #define FEC_ENET_FCE	(1 << 5)
 #define FEC_ENET_RSEM_V	0x84
@@ -3240,10 +3242,40 @@ static int fec_set_features(struct net_device *netdev,
 	return 0;
 }
 
+static u16 fec_enet_get_raw_vlan_tci(struct sk_buff *skb)
+{
+	struct vlan_ethhdr *vhdr;
+	unsigned short vlan_TCI = 0;
+
+	if (skb->protocol == htons(ETH_P_ALL)) {
+		vhdr = (struct vlan_ethhdr *)(skb->data);
+		vlan_TCI = ntohs(vhdr->h_vlan_TCI);
+	}
+
+	return vlan_TCI;
+}
+
+static u16 fec_enet_select_queue(struct net_device *ndev, struct sk_buff *skb,
+				 struct net_device *sb_dev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	u16 vlan_tag;
+
+	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
+		return netdev_pick_tx(ndev, skb, NULL);
+
+	vlan_tag = fec_enet_get_raw_vlan_tci(skb);
+	if (!vlan_tag)
+		return vlan_tag;
+
+	return fec_enet_vlan_pri_to_queue[vlan_tag >> 13];
+}
+
 static const struct net_device_ops fec_netdev_ops = {
 	.ndo_open		= fec_enet_open,
 	.ndo_stop		= fec_enet_close,
 	.ndo_start_xmit		= fec_enet_start_xmit,
+	.ndo_select_queue       = fec_enet_select_queue,
 	.ndo_set_rx_mode	= set_multicast_list,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= fec_timeout,
-- 
2.30.2



