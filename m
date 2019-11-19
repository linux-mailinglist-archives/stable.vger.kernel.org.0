Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 459E11014B1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbfKSFg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:36:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:57758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729952AbfKSFg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:36:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12FD722317;
        Tue, 19 Nov 2019 05:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141786;
        bh=SnSXXWbCh4DGjwAfNxcppyi0n+IUynSU9WgHWmixTn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNqVwO7roHjtth9wfyKHa07NxHCs7pmfNIFxvobIDOUjI7x8DmXhQjT6t/OPCTgUV
         9Jw8CahHbrbdtWHa4eiOYAvZ0P62UBPnlG3I/3anrJrONYT0dwmDAwlvnKYI3OglZb
         Al3j7egw/zHaxeAE4ReXBcQ5D//VWomnPekicgqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 281/422] net: hns3: Fix cmdq registers initialization issue for vf
Date:   Tue, 19 Nov 2019 06:17:58 +0100
Message-Id: <20191119051417.194636468@linuxfoundation.org>
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

[ Upstream commit 37dc9cdbdc1bd64bd3b6ea285a9c2e811404dc82 ]

According to hardware's description, the head pointer register should
be written before the tail pointer register while initializing the vf
command queue. Otherwise, it may trigger an interrupt even though there
is no command received.

Fixes: fedd0c15d288 ("net: hns3: Add HNS3 VF IMP(Integrated Management Proc) cmd interface")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index fb471fe2c4946..d8c0cc8e04c9d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -132,8 +132,8 @@ static int hclgevf_init_cmd_queue(struct hclgevf_dev *hdev,
 		reg_val |= HCLGEVF_NIC_CMQ_ENABLE;
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_DEPTH_REG, reg_val);
 
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_TAIL_REG, 0);
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_HEAD_REG, 0);
+		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_TAIL_REG, 0);
 		break;
 	case HCLGEVF_TYPE_CRQ:
 		reg_val = (u32)ring->desc_dma_addr;
@@ -145,8 +145,8 @@ static int hclgevf_init_cmd_queue(struct hclgevf_dev *hdev,
 		reg_val |= HCLGEVF_NIC_CMQ_ENABLE;
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_DEPTH_REG, reg_val);
 
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_TAIL_REG, 0);
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_HEAD_REG, 0);
+		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_TAIL_REG, 0);
 		break;
 	}
 
-- 
2.20.1



