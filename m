Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AABC37CDB8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhELQ5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244102AbhELQmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F75661D1D;
        Wed, 12 May 2021 16:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835839;
        bh=AWduXJg6FgG0c+arjJooAVgmGUR5qA93G1hB7ewf7CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCOwU58dww34whxnNYi14AsGOYK/bBiNwmGiXXYcg8RE08rzvBdA/5zaEb6ieuG3+
         CWPAx0TwUX0NLEyNyOLSNcdP5DeyPcWRyyIQLJJftGhyAdMXA+/zUG4V2fLzDJR21l
         YBzpSb9fZGawwuwKWsOJ1Gd80EHcrSO4lf4t/h1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 488/677] net: hns3: Limiting the scope of vector_ring_chain variable
Date:   Wed, 12 May 2021 16:48:54 +0200
Message-Id: <20210512144853.597154700@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index bf4302a5cf95..65752f363f43 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3704,7 +3704,6 @@ static void hns3_nic_set_cpumask(struct hns3_nic_priv *priv)
 
 static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 {
-	struct hnae3_ring_chain_node vector_ring_chain;
 	struct hnae3_handle *h = priv->ae_handle;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	int ret;
@@ -3736,6 +3735,8 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 	}
 
 	for (i = 0; i < priv->vector_num; i++) {
+		struct hnae3_ring_chain_node vector_ring_chain;
+
 		tqp_vector = &priv->tqp_vector[i];
 
 		tqp_vector->rx_group.total_bytes = 0;
-- 
2.30.2



