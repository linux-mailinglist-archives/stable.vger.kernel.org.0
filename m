Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F25D10BCE1
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbfK0VDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730860AbfK0VDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:03:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF6722176D;
        Wed, 27 Nov 2019 21:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888595;
        bh=0ptIyz2rwTGU2srGHJGqVEpxkJkoXMIW8fkoSVCQ1YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGT/7KDiGupKPZgJtTobamnxAtmplylwvn681e8DMddj518Vv+nUCAu2DWblEa3KS
         AY1XFZqj5Vf5ORhkWJJtZlZOFKFEDAUVXF+Q5TofT87/QiFBj8fGHeYr02ZDuYAibg
         ChBxO0iSpaJF2GbpXzk3htS3MOSwjvTAcvIFWWbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 188/306] net: hns3: bugfix for hclge_mdio_write and hclge_mdio_read
Date:   Wed, 27 Nov 2019 21:30:38 +0100
Message-Id: <20191127203128.992694144@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 1c12493809924deda6c0834cb2f2c5a6dc786390 ]

When there is a PHY, the driver needs to complete some operations through
MDIO during reset reinitialization, so HCLGE_STATE_CMD_DISABLE is more
suitable than HCLGE_STATE_RST_HANDLING to prevent the MDIO operation from
being sent during the hardware reset.

Fixes: b50ae26c57cb ("net: hns3: never send command queue message to IMP when reset)
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 398971a062f47..03491e8ebb730 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -54,7 +54,7 @@ static int hclge_mdio_write(struct mii_bus *bus, int phyid, int regnum,
 	struct hclge_desc desc;
 	int ret;
 
-	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+	if (test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state))
 		return 0;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_MDIO_CONFIG, false);
@@ -92,7 +92,7 @@ static int hclge_mdio_read(struct mii_bus *bus, int phyid, int regnum)
 	struct hclge_desc desc;
 	int ret;
 
-	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+	if (test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state))
 		return 0;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_MDIO_CONFIG, true);
-- 
2.20.1



