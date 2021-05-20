Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD90138A4DE
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbhETKKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235672AbhETKHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5883A61945;
        Thu, 20 May 2021 09:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503709;
        bh=D+bkgRJxQO/b+9lGgmG3j2SvcHf6Wk6c7K2LayJa5OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doSPsqgvEJd6gNlvAuP043gLJNxz9AdYCeRKFfdIdWBuywIOpx4NwNe8AwYaXosp1
         2DhQjMOksXJ5fHAov3RjPpHCmf6ZbxaW30/j/bRJ4bvrQYpsco9lwTEzOy0GeDR3Po
         xmLj2Rguw68RylQiugIWv7H6SQELJYMtcIVrebEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 345/425] net: hns3: disable phy loopback setting in hclge_mac_start_phy
Date:   Thu, 20 May 2021 11:21:54 +0200
Message-Id: <20210520092142.749544235@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 472497d0bdae890a896013332a0b673f9acdf2bf ]

If selftest and reset are performed at the same time, the phy
loopback setting may be still in enable state after the reset,
and device cannot link up. So fix this issue by disabling phy
loopback before phy_start().

Fixes: 256727da7395 ("net: hns3: Add MDIO support to HNS3 Ethernet driver for hip08 SoC")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 03491e8ebb73..d0fa344f0a84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -235,6 +235,8 @@ void hclge_mac_start_phy(struct hclge_dev *hdev)
 	if (!phydev)
 		return;
 
+	phy_loopback(phydev, false);
+
 	phy_start(phydev);
 }
 
-- 
2.30.2



