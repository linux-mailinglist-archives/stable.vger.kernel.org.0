Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62097383006
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239172AbhEQOXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233863AbhEQOVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:21:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A7E61074;
        Mon, 17 May 2021 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260695;
        bh=Y/n4T2711BR/Em/i97lCqubjvDBR4y1g7v/IQE6yZ64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aay3TZi4aOGiosY2JozEsG6Z3tzQhxbbURxv7zVLtPvh68A7ELyNyxhId/ENpGMeS
         Ej66a94pY8NiIJ4MGAxpK8fHqlGh1M6FeTUW8BDI/mEIuMDqoz//D7LoZEjg1oU5/C
         gLLObTO86mevBUnBDZEU2R57x4bjiEDdywBjzCUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 198/363] net: hns3: disable phy loopback setting in hclge_mac_start_phy
Date:   Mon, 17 May 2021 16:01:04 +0200
Message-Id: <20210517140309.282841137@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
index e89820702540..c194bba187d6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -255,6 +255,8 @@ void hclge_mac_start_phy(struct hclge_dev *hdev)
 	if (!phydev)
 		return;
 
+	phy_loopback(phydev, false);
+
 	phy_start(phydev);
 }
 
-- 
2.30.2



