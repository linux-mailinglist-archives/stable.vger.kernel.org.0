Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC744994F6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391910AbiAXUuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35226 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388844AbiAXUkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 812CC6136C;
        Mon, 24 Jan 2022 20:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCECC340E5;
        Mon, 24 Jan 2022 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056811;
        bh=cW6i1+FYbM41Py1EygcwC6wNPoFKzRktOYZzcq8jPVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03GPsngxWqwqz5xSai1Gfu5/H62jd7QttUjklXKiWifKDzMA9SixO4WITYhrY6Ytc
         +hiwIc77R/H9A6lJROmmn1OInngW5hRwEdgCz1BfrKfJ3tfrHdHISFZcpRZQY9Ev4L
         dVUJ4vvDJiPS3m1nE1ILW0vMK+6SMXzCiHzEDnjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 607/846] mlxsw: pci: Avoid flow control for EMAD packets
Date:   Mon, 24 Jan 2022 19:42:04 +0100
Message-Id: <20220124184121.963318420@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit d43e4271747ace01a27a49a97a397cb4219f6487 ]

Locally generated packets ingress the device through its CPU port. When
the CPU port is congested and there are not enough credits in its
headroom buffer, packets can be dropped.

While this might be acceptable for data packets that traverse the
network, configuration packets exchanged between the host and the device
(EMADs) should not be subjected to this flow control.

The "sdq_lp" bit in the SDQ (Send Descriptor Queue) context allows the
host to instruct the device to treat packets sent on this queue as
"local processing" and always process them, regardless of the state of
the CPU port's headroom.

Add the definition of this bit and set it for the dedicated SDQ reserved
for the transmission of EMAD packets. This makes the "local processing"
bit in the WQE (Work Queue Element) redundant, so clear it.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/pci.c |  6 +++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 392ce3cb27f72..51b260d54237e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -935,6 +935,18 @@ static inline int mlxsw_cmd_sw2hw_rdq(struct mlxsw_core *mlxsw_core,
  */
 MLXSW_ITEM32(cmd_mbox, sw2hw_dq, cq, 0x00, 24, 8);
 
+enum mlxsw_cmd_mbox_sw2hw_dq_sdq_lp {
+	MLXSW_CMD_MBOX_SW2HW_DQ_SDQ_LP_WQE,
+	MLXSW_CMD_MBOX_SW2HW_DQ_SDQ_LP_IGNORE_WQE,
+};
+
+/* cmd_mbox_sw2hw_dq_sdq_lp
+ * SDQ local Processing
+ * 0: local processing by wqe.lp
+ * 1: local processing (ignoring wqe.lp)
+ */
+MLXSW_ITEM32(cmd_mbox, sw2hw_dq, sdq_lp, 0x00, 23, 1);
+
 /* cmd_mbox_sw2hw_dq_sdq_tclass
  * SDQ: CPU Egress TClass
  * RDQ: Reserved
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 01c3235ab2bdf..d9f9cbba62465 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -285,6 +285,7 @@ static int mlxsw_pci_sdq_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 			      struct mlxsw_pci_queue *q)
 {
 	int tclass;
+	int lp;
 	int i;
 	int err;
 
@@ -292,9 +293,12 @@ static int mlxsw_pci_sdq_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 	q->consumer_counter = 0;
 	tclass = q->num == MLXSW_PCI_SDQ_EMAD_INDEX ? MLXSW_PCI_SDQ_EMAD_TC :
 						      MLXSW_PCI_SDQ_CTL_TC;
+	lp = q->num == MLXSW_PCI_SDQ_EMAD_INDEX ? MLXSW_CMD_MBOX_SW2HW_DQ_SDQ_LP_IGNORE_WQE :
+						  MLXSW_CMD_MBOX_SW2HW_DQ_SDQ_LP_WQE;
 
 	/* Set CQ of same number of this SDQ. */
 	mlxsw_cmd_mbox_sw2hw_dq_cq_set(mbox, q->num);
+	mlxsw_cmd_mbox_sw2hw_dq_sdq_lp_set(mbox, lp);
 	mlxsw_cmd_mbox_sw2hw_dq_sdq_tclass_set(mbox, tclass);
 	mlxsw_cmd_mbox_sw2hw_dq_log2_dq_sz_set(mbox, 3); /* 8 pages */
 	for (i = 0; i < MLXSW_PCI_AQ_PAGES; i++) {
@@ -1678,7 +1682,7 @@ static int mlxsw_pci_skb_transmit(void *bus_priv, struct sk_buff *skb,
 
 	wqe = elem_info->elem;
 	mlxsw_pci_wqe_c_set(wqe, 1); /* always report completion */
-	mlxsw_pci_wqe_lp_set(wqe, !!tx_info->is_emad);
+	mlxsw_pci_wqe_lp_set(wqe, 0);
 	mlxsw_pci_wqe_type_set(wqe, MLXSW_PCI_WQE_TYPE_ETHERNET);
 
 	err = mlxsw_pci_wqe_frag_map(mlxsw_pci, wqe, 0, skb->data,
-- 
2.34.1



