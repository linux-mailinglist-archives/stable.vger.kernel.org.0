Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18F83DD8DC
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhHBNzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235960AbhHBNym (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3079261100;
        Mon,  2 Aug 2021 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912382;
        bh=9w+AKdstYzJS+D1LFVHyh0EdriL9Ar92AZpiVv6btYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fs59DOLKOIn7LcmkWjuo3KtxpKjBNqusglQsvl5iiDLMTzlinHRephGwTuzkIPXNK
         MKrlXcE26Dl3XOMPy3ptdw/Jjaeg6NRaoZCNBALN6mztqQx/5ic5OsB3RhuqS8dHm8
         ybm66AEa5jSyIRqJ0TW4fz0zHaVO0nIdJFzVy6i4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/67] i40e: Fix queue-to-TC mapping on Tx
Date:   Mon,  2 Aug 2021 15:44:58 +0200
Message-Id: <20210802134340.214356935@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit 89ec1f0886c127c7e41ac61a6b6d539f4fb2510b ]

In SW DCB mode the packets sent receive incorrect UP tags. They are
constructed correctly and put into tx_ring, but UP is later remapped by
HW on the basis of TCTUPR register contents according to Tx queue
selected, and BW used is consistent with the new UP values. This is
caused by Tx queue selection in kernel not taking into account DCB
configuration. This patch fixes the issue by implementing the
ndo_select_queue NDO callback.

Fixes: fd0a05ce74ef ("i40e: transmit, receive, and NAPI")
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |  1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 50 +++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  2 +
 3 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 112a18dd13c4..b3a9dec414a5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12809,6 +12809,7 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_poll_controller	= i40e_netpoll,
 #endif
 	.ndo_setup_tc		= __i40e_setup_tc,
+	.ndo_select_queue	= i40e_lan_select_queue,
 	.ndo_set_features	= i40e_set_features,
 	.ndo_set_vf_mac		= i40e_ndo_set_vf_mac,
 	.ndo_set_vf_vlan	= i40e_ndo_set_vf_port_vlan,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index c40ac82db863..615802b07521 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3524,6 +3524,56 @@ dma_error:
 	return -1;
 }
 
+static u16 i40e_swdcb_skb_tx_hash(struct net_device *dev,
+				  const struct sk_buff *skb,
+				  u16 num_tx_queues)
+{
+	u32 jhash_initval_salt = 0xd631614b;
+	u32 hash;
+
+	if (skb->sk && skb->sk->sk_hash)
+		hash = skb->sk->sk_hash;
+	else
+		hash = (__force u16)skb->protocol ^ skb->hash;
+
+	hash = jhash_1word(hash, jhash_initval_salt);
+
+	return (u16)(((u64)hash * num_tx_queues) >> 32);
+}
+
+u16 i40e_lan_select_queue(struct net_device *netdev,
+			  struct sk_buff *skb,
+			  struct net_device __always_unused *sb_dev)
+{
+	struct i40e_netdev_priv *np = netdev_priv(netdev);
+	struct i40e_vsi *vsi = np->vsi;
+	struct i40e_hw *hw;
+	u16 qoffset;
+	u16 qcount;
+	u8 tclass;
+	u16 hash;
+	u8 prio;
+
+	/* is DCB enabled at all? */
+	if (vsi->tc_config.numtc == 1)
+		return i40e_swdcb_skb_tx_hash(netdev, skb,
+					      netdev->real_num_tx_queues);
+
+	prio = skb->priority;
+	hw = &vsi->back->hw;
+	tclass = hw->local_dcbx_config.etscfg.prioritytable[prio];
+	/* sanity check */
+	if (unlikely(!(vsi->tc_config.enabled_tc & BIT(tclass))))
+		tclass = 0;
+
+	/* select a queue assigned for the given TC */
+	qcount = vsi->tc_config.tc_info[tclass].qcount;
+	hash = i40e_swdcb_skb_tx_hash(netdev, skb, qcount);
+
+	qoffset = vsi->tc_config.tc_info[tclass].qoffset;
+	return qoffset + hash;
+}
+
 /**
  * i40e_xmit_xdp_ring - transmits an XDP buffer to an XDP Tx ring
  * @xdpf: data to transmit
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 2feed920ef8a..93ac201f68b8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -449,6 +449,8 @@ static inline unsigned int i40e_rx_pg_order(struct i40e_ring *ring)
 
 bool i40e_alloc_rx_buffers(struct i40e_ring *rxr, u16 cleaned_count);
 netdev_tx_t i40e_lan_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
+u16 i40e_lan_select_queue(struct net_device *netdev, struct sk_buff *skb,
+			  struct net_device *sb_dev);
 void i40e_clean_tx_ring(struct i40e_ring *tx_ring);
 void i40e_clean_rx_ring(struct i40e_ring *rx_ring);
 int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring);
-- 
2.30.2



