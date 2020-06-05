Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7F81EFB3D
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgFEOZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbgFEOQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8415B20835;
        Fri,  5 Jun 2020 14:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366617;
        bh=2+TLxM3G8QfbMlQcupi4uaoiUaXyEpZ8gudy8Moj2iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yascjMMdbbacvJBj5T8hgyukCA4FLzwSe6Yj+ediCA/ezyEDSzZBZcGEdfeUn+5KI
         CbhHlL5qP9ZtG43h9cLkjhjATDJTOdI96flxRw98Qka+j5zRf7hTbQc3JQDemW3yAK
         lew0uykjBAWHeG4nJTjr4Kahb0gs6oiLMzBhToG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 25/43] net: ethernet: ti: fix some return value check of cpsw_ale_create()
Date:   Fri,  5 Jun 2020 16:14:55 +0200
Message-Id: <20200605140153.842363853@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 3469660d1b15ccfdf7b33295c306b6298ca730aa ]

cpsw_ale_create() can return both NULL and PTR_ERR(), but all of
the caller only check NULL for error handling. This patch convert
it to only return PTR_ERR() in all error cases, and the caller using
IS_ERR() instead of NULL test.

Fixes: 4b41d3436796 ("net: ethernet: ti: cpsw: allow untagged traffic on host port")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_ale.c    | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.c   | 4 ++--
 drivers/net/ethernet/ti/netcp_ethss.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index ecdbde539eb7..4eb14b174c1a 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -917,7 +917,7 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 
 	ale = devm_kzalloc(params->dev, sizeof(*ale), GFP_KERNEL);
 	if (!ale)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	ale->p0_untag_vid_mask =
 		devm_kmalloc_array(params->dev, BITS_TO_LONGS(VLAN_N_VID),
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 97a058ca60ac..d0b6c418a870 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -490,9 +490,9 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 	ale_params.ale_ports		= CPSW_ALE_PORTS_NUM;
 
 	cpsw->ale = cpsw_ale_create(&ale_params);
-	if (!cpsw->ale) {
+	if (IS_ERR(cpsw->ale)) {
 		dev_err(dev, "error initializing ale engine\n");
-		return -ENODEV;
+		return PTR_ERR(cpsw->ale);
 	}
 
 	dma_params.dev		= dev;
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index fb36115e9c51..fdbae734acce 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -3704,9 +3704,9 @@ static int gbe_probe(struct netcp_device *netcp_device, struct device *dev,
 		ale_params.nu_switch_ale = true;
 	}
 	gbe_dev->ale = cpsw_ale_create(&ale_params);
-	if (!gbe_dev->ale) {
+	if (IS_ERR(gbe_dev->ale)) {
 		dev_err(gbe_dev->dev, "error initializing ale engine\n");
-		ret = -ENODEV;
+		ret = PTR_ERR(gbe_dev->ale);
 		goto free_sec_ports;
 	} else {
 		dev_dbg(gbe_dev->dev, "Created a gbe ale engine\n");
-- 
2.25.1



