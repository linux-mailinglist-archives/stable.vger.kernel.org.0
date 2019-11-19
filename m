Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7551018C4
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbfKSF3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:29:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728549AbfKSF3t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:29:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B511E222DF;
        Tue, 19 Nov 2019 05:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141389;
        bh=L5ZKUrc/TBLLpyooRleWyieQNY5ylLKmZ/vovfO3UOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQMvbvgEy2wF2X4wtvV5qg/5XqDQQ33YsRaquCU2AKusc1DXwnAEm2cn7NhvvuPOp
         bAICiL78RV3Yn+mBHQ4vFuoMId9OoWYBQ5kkxhoXv8gYXPBd8j8bBzWFa8mfhloOY0
         UQ+Oz6E63WNSfll9dbmbVkUOjf/OIO8oIntrSIiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/422] net: hns3: Fix for multicast failure
Date:   Tue, 19 Nov 2019 06:15:00 +0100
Message-Id: <20191119051405.885975982@linuxfoundation.org>
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

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit fd5f9da3f6583046215d614a87792b46e55785e2 ]

When the lower 24 bits of the IPV6 link-local addresses at both
ends are the same, the multicast MAC address for Neigbour Discovery
is the same. The multicast for Neigbour Discovery will fail.

This patch fixes it by including the bonding uplink port in the
multicast group.

Fixes: 46a3df9f9718("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 89ca69fa2b97b..44d0cb3f73a44 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4374,7 +4374,7 @@ int hclge_add_mc_addr_common(struct hclge_vport *vport,
 	hnae3_set_bit(req.flags, HCLGE_MAC_VLAN_BIT0_EN_B, 1);
 	hnae3_set_bit(req.entry_type, HCLGE_MAC_VLAN_BIT0_EN_B, 0);
 	hnae3_set_bit(req.entry_type, HCLGE_MAC_VLAN_BIT1_EN_B, 1);
-	hnae3_set_bit(req.mc_mac_en, HCLGE_MAC_VLAN_BIT0_EN_B, 0);
+	hnae3_set_bit(req.mc_mac_en, HCLGE_MAC_VLAN_BIT0_EN_B, 1);
 	hclge_prepare_mac_addr(&req, addr);
 	status = hclge_lookup_mac_vlan_tbl(vport, &req, desc, true);
 	if (!status) {
@@ -4441,7 +4441,7 @@ int hclge_rm_mc_addr_common(struct hclge_vport *vport,
 	hnae3_set_bit(req.flags, HCLGE_MAC_VLAN_BIT0_EN_B, 1);
 	hnae3_set_bit(req.entry_type, HCLGE_MAC_VLAN_BIT0_EN_B, 0);
 	hnae3_set_bit(req.entry_type, HCLGE_MAC_VLAN_BIT1_EN_B, 1);
-	hnae3_set_bit(req.mc_mac_en, HCLGE_MAC_VLAN_BIT0_EN_B, 0);
+	hnae3_set_bit(req.mc_mac_en, HCLGE_MAC_VLAN_BIT0_EN_B, 1);
 	hclge_prepare_mac_addr(&req, addr);
 	status = hclge_lookup_mac_vlan_tbl(vport, &req, desc, true);
 	if (!status) {
-- 
2.20.1



