Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B964F1482C6
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404270AbgAXLan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:30:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404266AbgAXLam (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:30:42 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2836520718;
        Fri, 24 Jan 2020 11:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865441;
        bh=WSf9n9pmlVw8tIhCjRErcT3hSSW6Jlsr3zR/jY4OcMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rnn3E5TqKc3BKeGg1INt5rw8PrLHl2zc/SeJ5jMuNh43NCalx/Acz9kJpeW8s8jmj
         HSaeLXFCrBQ7qFCU1ZqKtwyYOr/QGB6rCDD9P/wTES3Scz56uIpo0MgdN1aCHZnlR+
         KUCcuKgK29hT8i7+9RQnta17ytxfnFltfDXfrLlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 547/639] net: hns3: fix error VF index when setting VLAN offload
Date:   Fri, 24 Jan 2020 10:31:57 +0100
Message-Id: <20200124093157.652539658@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit d9c0f2756a33833b2653f7a3612814fa5f52a568 ]

In original codes, the VF index used incorrectly in function
hclge_set_vlan_rx_offload_cfg() and hclge_set_vlan_rx_offload_cfg().
When VF id is greater than 8, for example 9, it will set the
same bit with VF id 1.

This patch fixes it by using  vport->vport_id % HCLGE_VF_NUM_PER_CMD /
HCLGE_VF_NUM_PER_BYTE as the array index, instead of vport->vport_id /
HCLGE_VF_NUM_PER_CMD.

Fixes: 052ece6dc19c ("net: hns3: add ethtool related offload command")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4b9f898a1620c..d575dd9a329d9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4833,6 +4833,7 @@ static int hclge_set_vlan_tx_offload_cfg(struct hclge_vport *vport)
 	struct hclge_vport_vtag_tx_cfg_cmd *req;
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_desc desc;
+	u16 bmap_index;
 	int status;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_PORT_TX_CFG, false);
@@ -4855,8 +4856,10 @@ static int hclge_set_vlan_tx_offload_cfg(struct hclge_vport *vport)
 	hnae3_set_bit(req->vport_vlan_cfg, HCLGE_CFG_NIC_ROCE_SEL_B, 0);
 
 	req->vf_offset = vport->vport_id / HCLGE_VF_NUM_PER_CMD;
-	req->vf_bitmap[req->vf_offset] =
-		1 << (vport->vport_id % HCLGE_VF_NUM_PER_BYTE);
+	bmap_index = vport->vport_id % HCLGE_VF_NUM_PER_CMD /
+			HCLGE_VF_NUM_PER_BYTE;
+	req->vf_bitmap[bmap_index] =
+		1U << (vport->vport_id % HCLGE_VF_NUM_PER_BYTE);
 
 	status = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
@@ -4873,6 +4876,7 @@ static int hclge_set_vlan_rx_offload_cfg(struct hclge_vport *vport)
 	struct hclge_vport_vtag_rx_cfg_cmd *req;
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_desc desc;
+	u16 bmap_index;
 	int status;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_PORT_RX_CFG, false);
@@ -4888,8 +4892,10 @@ static int hclge_set_vlan_rx_offload_cfg(struct hclge_vport *vport)
 		      vcfg->vlan2_vlan_prionly ? 1 : 0);
 
 	req->vf_offset = vport->vport_id / HCLGE_VF_NUM_PER_CMD;
-	req->vf_bitmap[req->vf_offset] =
-		1 << (vport->vport_id % HCLGE_VF_NUM_PER_BYTE);
+	bmap_index = vport->vport_id % HCLGE_VF_NUM_PER_CMD /
+			HCLGE_VF_NUM_PER_BYTE;
+	req->vf_bitmap[bmap_index] =
+		1U << (vport->vport_id % HCLGE_VF_NUM_PER_BYTE);
 
 	status = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
-- 
2.20.1



