Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0EF37C9B9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbhELQUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239788AbhELQQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:16:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A28E61D60;
        Wed, 12 May 2021 15:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834165;
        bh=lSLJoT4QIk1xUJrNIZJtih3pn/Y6owWdbCNbvLmhp6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GN3yzS/5Vy4t8CEiZJ4j29MDfUgJwr7Ne/pzVjlFhaCxKcYpOasiDQ7vt0uA/vJt4
         AS5G83S3c3CxH7EOmBon/g8N06P24XvzY+CYLvxgodwey+mumOIcRLHpB4fJ/vh02B
         2ktbVFquhi0cP99eWn0gMoQrI9VeOVi33FcfDhVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 433/601] net: hns3: Limiting the scope of vector_ring_chain variable
Date:   Wed, 12 May 2021 16:48:30 +0200
Message-Id: <20210512144842.096906128@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index 405e49033417..c8a43a725ebc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3709,7 +3709,6 @@ static void hns3_nic_set_cpumask(struct hns3_nic_priv *priv)
 
 static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 {
-	struct hnae3_ring_chain_node vector_ring_chain;
 	struct hnae3_handle *h = priv->ae_handle;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	int ret;
@@ -3741,6 +3740,8 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 	}
 
 	for (i = 0; i < priv->vector_num; i++) {
+		struct hnae3_ring_chain_node vector_ring_chain;
+
 		tqp_vector = &priv->tqp_vector[i];
 
 		tqp_vector->rx_group.total_bytes = 0;
-- 
2.30.2



