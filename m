Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C42F188155
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgCQLIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbgCQLIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:08:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85E9C205ED;
        Tue, 17 Mar 2020 11:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443321;
        bh=hStZTAikJ4mR+H04KZxQZDse0O8nFl5ucKv4VVTsc5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyGPozANhfXqU4PEnPRmvATB5n48bArpwi0tr+xoa0djfsDOuRAvsOkfF1EuQKUNV
         YjZPoznKsY62e7itTjUB8GO1lEPWJ0VmA1ItNIHl4LSxSzVfIqoEwbFcRyuP08r8Z4
         Ui9jUMzX431Kn1DPWjz+dh/MrK1jvbb9yoxojYts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 044/151] net: hns3: fix RMW issue for VLAN filter switch
Date:   Tue, 17 Mar 2020 11:54:14 +0100
Message-Id: <20200317103329.740320337@linuxfoundation.org>
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

[ Upstream commit 903b85d3adce99a5301d5959c4d3c9d14a7974d4 ]

According to the user manual, the ingress and egress VLAN filter
are configured at the same time. Currently, hclge_init_vlan_config()
and hclge_set_vlan_spoofchk() will both change the VLAN filter
switch. So it's necessary to read the old configuration before
modifying it.

Fixes: 22044f95faa0 ("net: hns3: add support for spoof check setting")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |   19 ++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7727,16 +7727,27 @@ static int hclge_set_vlan_filter_ctrl(st
 	struct hclge_desc desc;
 	int ret;
 
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_FILTER_CTRL, false);
-
+	/* read current vlan filter parameter */
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_FILTER_CTRL, true);
 	req = (struct hclge_vlan_filter_ctrl_cmd *)desc.data;
 	req->vlan_type = vlan_type;
-	req->vlan_fe = filter_en ? fe_type : 0;
 	req->vf_id = vf_id;
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get vlan filter config, ret = %d.\n", ret);
+		return ret;
+	}
+
+	/* modify and write new config parameter */
+	hclge_cmd_reuse_desc(&desc, false);
+	req->vlan_fe = filter_en ?
+			(req->vlan_fe | fe_type) : (req->vlan_fe & ~fe_type);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
-		dev_err(&hdev->pdev->dev, "set vlan filter fail, ret =%d.\n",
+		dev_err(&hdev->pdev->dev, "failed to set vlan filter, ret = %d.\n",
 			ret);
 
 	return ret;


