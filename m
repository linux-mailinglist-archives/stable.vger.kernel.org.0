Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1493111E5F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbfLCWzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:55:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbfLCWzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:55:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E05372053B;
        Tue,  3 Dec 2019 22:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413749;
        bh=lYKka7mtVHbQ/4kpHelX0YbKeThZTD6/2UrcxUWeCbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhaKVk57BDBOIWEpANFJ26mRiqzST0R/8zHvxBvLRmN845ITkCwp/DlwRbd+gEW0M
         fJ7rE1NmIbE8v0/pFGPSm/TCxLWYf/xnYYULgDseIYxODkY540ktR00UZrVInovTvp
         oc8i8oBdvlzZVcRBgFicszxfzxgfJ3QNnqbNtG2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 246/321] net: hns3: fix an issue for hclgevf_ae_get_hdev
Date:   Tue,  3 Dec 2019 23:35:12 +0100
Message-Id: <20191203223439.937342013@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

[ Upstream commit eed9535f9f716a532ec0c5d6cc7a48584acdf435 ]

HNS3 VF driver support NIC and Roce, hdev stores NIC
handle and Roce handle, should use correct parameter for
container_of.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index beae1e2cd59b1..67db19709deaa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -26,7 +26,12 @@ MODULE_DEVICE_TABLE(pci, ae_algovf_pci_tbl);
 static inline struct hclgevf_dev *hclgevf_ae_get_hdev(
 	struct hnae3_handle *handle)
 {
-	return container_of(handle, struct hclgevf_dev, nic);
+	if (!handle->client)
+		return container_of(handle, struct hclgevf_dev, nic);
+	else if (handle->client->type == HNAE3_CLIENT_ROCE)
+		return container_of(handle, struct hclgevf_dev, roce);
+	else
+		return container_of(handle, struct hclgevf_dev, nic);
 }
 
 static int hclgevf_tqps_update_stats(struct hnae3_handle *handle)
-- 
2.20.1



