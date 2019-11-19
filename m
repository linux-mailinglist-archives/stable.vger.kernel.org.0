Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4E21018AE
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfKSF1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbfKSF1u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE2A021939;
        Tue, 19 Nov 2019 05:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141269;
        bh=j6XVAzC0ieNUfh1cyp9AOv/YHbTteimGWOdKlSY9CQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhBRuHLLwZTxeKyYpatrlrhWbEbZ32npFmooHZYOhL4j9sqcN6O1FmsUviTfh8Tws
         RalUcUwXYsOd7LcL+0DVevH+DQg2TaSlet+MUIhTUcLUM0A57meWNfiLiKvtZYIPfl
         bDiUFz4YxkXvX+xm2+z8Vo5p7TJu5/tmzCnqmc00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/422] net: hns3: Fix error of checking used vlan id
Date:   Tue, 19 Nov 2019 06:15:01 +0100
Message-Id: <20191119051405.938621122@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 54e97d117bafa161b08c6ade243a335d92890d94 ]

PF uses hdev->vlan_table to manage the port vlan table. In function
hclge_set_vlan_filter_hw(), it checks whether a vlan id has been used,
by foreach all the vport bits. It should use macro HCLGE_VPORT_NUM,
not VLAN_N_VID as the foreach condition.

Fixes: 6c251711b37f ("net: hns3: Disable vf vlan filter when vf vlan table is full")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 44d0cb3f73a44..0e7c92f624e91 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4784,7 +4784,7 @@ static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
 		return -EINVAL;
 	}
 
-	for_each_set_bit(vport_idx, hdev->vlan_table[vlan_id], VLAN_N_VID)
+	for_each_set_bit(vport_idx, hdev->vlan_table[vlan_id], HCLGE_VPORT_NUM)
 		vport_num++;
 
 	if ((is_kill && vport_num == 0) || (!is_kill && vport_num == 1))
-- 
2.20.1



