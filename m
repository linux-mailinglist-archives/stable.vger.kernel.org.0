Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1795D419BE2
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbhI0RXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237120AbhI0RV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F5D86120A;
        Mon, 27 Sep 2021 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762828;
        bh=CNdvHFKKm2Q17p3SUkR32fZQT3wmccT1YF5V9jHGZIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qy/9DEKzgFlS1bCj2O1Ar96mL7sDTZMq/Z7Mq7udXXUpiX8gPW3nqlGTNMMWoIsvq
         TAx7G2oozWAso/Tx6JzB3Eilv5sF1JB1KXyA4ljBuoO6n+rmuMA6Mof80+CZXFmxEz
         O94Map0KvRpYNmI8o5Y3iSBVAFyFi+46gnIY8Vkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liaoguojia <liaoguojia@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 067/162] net: hns3: check vlan id before using it
Date:   Mon, 27 Sep 2021 19:01:53 +0200
Message-Id: <20210927170235.777864475@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: liaoguojia <liaoguojia@huawei.com>

[ Upstream commit ef39d632608e66f428c1246836fd060cf4818d67 ]

The input parameters may not be reliable, so check the vlan id before
using it, otherwise may set wrong vlan id into hardware.

Fixes: dc8131d846d4 ("net: hns3: Fix for packet loss due wrong filter config in VLAN tbls")
Signed-off-by: liaoguojia <liaoguojia@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3f8d56ccc057..556dfc854763 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9810,6 +9810,9 @@ static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
 	if (is_kill && !vlan_id)
 		return 0;
 
+	if (vlan_id >= VLAN_N_VID)
+		return -EINVAL;
+
 	ret = hclge_set_vf_vlan_common(hdev, vport_id, is_kill, vlan_id);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-- 
2.33.0



