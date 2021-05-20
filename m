Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF8138A470
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhETKFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234648AbhETKCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:02:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30BE56191B;
        Thu, 20 May 2021 09:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503590;
        bh=Z/7fkRUSnsbC0u1LZ+b9iDIGpfTrWbn6J1qhb62N6YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcy+l2ag4POKUOr0cs2wG+Ka1nTNUZ15kBc07l71V95rsmDba53ScVGlgo6UVVMvz
         rlXOKsPi0SGdfW+K642Td3WccNAD6WbuOtP9pntYV3cAmOTIdc3ITXt27fU90C0KQO
         s6N6yATRcvx8bPVxpLn5bOJbHx0OYRShmsUwhJG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 256/425] net: hns3: Limiting the scope of vector_ring_chain variable
Date:   Thu, 20 May 2021 11:20:25 +0200
Message-Id: <20210520092139.845823756@linuxfoundation.org>
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

From: Salil Mehta <salil.mehta@huawei.com>

[ Upstream commit d392ecd1bc29ae15b0e284d5f732c2d36f244271 ]

Limiting the scope of the variable vector_ring_chain to the block where it
is used.

Fixes: 424eb834a9be ("net: hns3: Unified HNS3 {VF|PF} Ethernet Driver for hip08 SoC")
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 3eb8b85f6afb..3b89673f09da 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2639,7 +2639,6 @@ static void hns3_add_ring_to_group(struct hns3_enet_ring_group *group,
 
 static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 {
-	struct hnae3_ring_chain_node vector_ring_chain;
 	struct hnae3_handle *h = priv->ae_handle;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	int ret = 0;
@@ -2669,6 +2668,8 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 	}
 
 	for (i = 0; i < priv->vector_num; i++) {
+		struct hnae3_ring_chain_node vector_ring_chain;
+
 		tqp_vector = &priv->tqp_vector[i];
 
 		tqp_vector->rx_group.total_bytes = 0;
-- 
2.30.2



