Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71BB5188157
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgCQLIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:08:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728877AbgCQLIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:08:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81E3F20658;
        Tue, 17 Mar 2020 11:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443324;
        bh=nWLuPFOQVOPLikwVQh7fKPutOMPbZCw7WgkfAD8CmnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3x1WzuvDBNmT7BXpGSKPk4u1EdCXoSp9lJ3C4Tr73ljuLF/CMlYxaRaZ6U7lhO0m
         OE4i2LRku1Yj1xpZmmzh0QWcibyUO9/s/9R9Rvc9fQSufb+IQjFIUAe56RnVgqwNNZ
         GmYveYXsh5GXz9Wq1POkmS7UBDwjpqTDJ8Eyn97g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 045/151] net: hns3: clear port base VLAN when unload PF
Date:   Tue, 17 Mar 2020 11:54:15 +0100
Message-Id: <20200317103329.807375517@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 59359fc8a2f7af062777692e6a7aae73483729ec ]

Currently, PF missed to clear the port base VLAN for VF when
unload. In this case, the VLAN id will remain in the VLAN
table. This patch fixes it.

Fixes: 92f11ea177cd ("net: hns3: fix set port based VLAN issue for VF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |   23 ++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8486,6 +8486,28 @@ static int hclge_set_vf_vlan_filter(stru
 	}
 }
 
+static void hclge_clear_vf_vlan(struct hclge_dev *hdev)
+{
+	struct hclge_vlan_info *vlan_info;
+	struct hclge_vport *vport;
+	int ret;
+	int vf;
+
+	/* clear port base vlan for all vf */
+	for (vf = HCLGE_VF_VPORT_START_NUM; vf < hdev->num_alloc_vport; vf++) {
+		vport = &hdev->vport[vf];
+		vlan_info = &vport->port_base_vlan_cfg.vlan_info;
+
+		ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
+					       vport->vport_id,
+					       vlan_info->vlan_tag, true);
+		if (ret)
+			dev_err(&hdev->pdev->dev,
+				"failed to clear vf vlan for vf%d, ret = %d\n",
+				vf - HCLGE_VF_VPORT_START_NUM, ret);
+	}
+}
+
 int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 			  u16 vlan_id, bool is_kill)
 {
@@ -9895,6 +9917,7 @@ static void hclge_uninit_ae_dev(struct h
 	struct hclge_mac *mac = &hdev->hw.mac;
 
 	hclge_reset_vf_rate(hdev);
+	hclge_clear_vf_vlan(hdev);
 	hclge_misc_affinity_teardown(hdev);
 	hclge_state_uninit(hdev);
 


