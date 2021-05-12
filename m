Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C667C37C58D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbhELPlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236082AbhELPg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:36:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2648D6143E;
        Wed, 12 May 2021 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832697;
        bh=LqY23mqsAFpIvQnrCLo5cQvDh4VvIBBAw2GlXQxu0M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AofRuVOTHczr+fj2eqZhXNZyvsSnGDG2e/KziLhbctbfrGo+Rbecz6PLpMCD+/j9Q
         d9KnEoDJt5fFq3XT5TrCGvOYu4v8iwki9VWQLoUuD8ctmjt3ShCTSvJWdDA1AxBNKg
         OTl2dXIMCluMtfcB8IVeh4yuhz4r9NH9e2jEoNsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 386/530] net: hns3: Limiting the scope of vector_ring_chain variable
Date:   Wed, 12 May 2021 16:48:16 +0200
Message-Id: <20210512144832.459723775@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index a362516a3185..070bef303d18 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3526,7 +3526,6 @@ static void hns3_nic_set_cpumask(struct hns3_nic_priv *priv)
 
 static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 {
-	struct hnae3_ring_chain_node vector_ring_chain;
 	struct hnae3_handle *h = priv->ae_handle;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	int ret;
@@ -3558,6 +3557,8 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 	}
 
 	for (i = 0; i < priv->vector_num; i++) {
+		struct hnae3_ring_chain_node vector_ring_chain;
+
 		tqp_vector = &priv->tqp_vector[i];
 
 		tqp_vector->rx_group.total_bytes = 0;
-- 
2.30.2



