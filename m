Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528EE10162A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbfKSFuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:50:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730300AbfKSFuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:50:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B3B4214D9;
        Tue, 19 Nov 2019 05:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142650;
        bh=Fqy9Df9VV1p/fXocuqWjl0pJ6+pzlHmrrdfJKPeH+lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCQYShrtaKMFPdcUukprgBJM6k2//mbac7gafhEsKv3feTphRR7rj+cH7GwdVXwYs
         9v2WYERadfwHFLSxmF7VK98u8j+rCfzNP8OGid+nrYa2Y0WvWdNnkF7i2188BVD5Nk
         SCJfpVJwDalL6+cw0CF3xtRn9OHbZMGsTs0ZNXcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fuyun Liang <liangfuyun1@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 153/239] net: hns3: Fix for setting speed for phy failed problem
Date:   Tue, 19 Nov 2019 06:19:13 +0100
Message-Id: <20191119051332.842670211@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fuyun Liang <liangfuyun1@huawei.com>

[ Upstream commit fd8133148eb6a733f9cfdaecd4d99f378e21d582 ]

The function of genphy_read_status is that reading phy information
from HW and using these information to update SW variable. If user
is using ethtool to setting the speed of phy and service task is calling
by hclge_get_mac_phy_link, the result of speed setting is uncertain.
Because ethtool cmd will modified phydev and hclge_get_mac_phy_link also
will modified phydev.

Because phy state machine will update phy link periodically, we can
just use phydev->link to check the link status. This patch removes
function call of genphy_read_status. To ensure accuracy, this patch
adds a phy state check. If phy state is not PHY_RUNNING, we consider
link is down. Because in some scenarios, phydev->link may be link up,
but phy state is not PHY_RUNNING. This is just an intermediate state.
In fact, the link is not ready yet.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Fuyun Liang <liangfuyun1@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 86523e8993cb9..3bb6181ff0548 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2179,7 +2179,7 @@ static int hclge_get_mac_phy_link(struct hclge_dev *hdev)
 	mac_state = hclge_get_mac_link_status(hdev);
 
 	if (hdev->hw.mac.phydev) {
-		if (!genphy_read_status(hdev->hw.mac.phydev))
+		if (hdev->hw.mac.phydev->state == PHY_RUNNING)
 			link_stat = mac_state &
 				hdev->hw.mac.phydev->link;
 		else
-- 
2.20.1



