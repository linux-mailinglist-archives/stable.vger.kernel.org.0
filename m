Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C68246A70
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbgHQPgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730259AbgHQPfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:35:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B866B2078D;
        Mon, 17 Aug 2020 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678551;
        bh=4FCTFl2gzUbVg54z/gtL1p8dbf5EZnnL4xV1WIitkvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yos5Veve62MInGjDgBzfM/VTh1AEEwfFaOa6rwkJR6wcAmHL7IfpCfrL80woMUyyf
         haGLhx3vSVfpLdBlR+CuehkMOxgYH2nr2lHRNoaxPJyHWyUPTbI1l9+N1c3sXfmeH4
         DWZcfGPfskSQyGtFdFWT9qUnM+Cyi1Gg8WXpkK+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 373/464] media: mtk-mdp: Fix a refcounting bug on error in init
Date:   Mon, 17 Aug 2020 17:15:26 +0200
Message-Id: <20200817143851.641745549@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit dd4eddc4ba31fbf4554fc5fa12d3a553b50e1469 ]

We need to call of_node_put(comp->dev_node); on the error paths in this
function.

Fixes: c8eb2d7e8202 ("[media] media: Add Mediatek MDP Driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_comp.c b/drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
index 58abfbdfb82d3..90b6d939f3adb 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
@@ -96,6 +96,7 @@ int mtk_mdp_comp_init(struct device *dev, struct device_node *node,
 {
 	struct device_node *larb_node;
 	struct platform_device *larb_pdev;
+	int ret;
 	int i;
 
 	if (comp_id < 0 || comp_id >= MTK_MDP_COMP_ID_MAX) {
@@ -113,8 +114,8 @@ int mtk_mdp_comp_init(struct device *dev, struct device_node *node,
 		if (IS_ERR(comp->clk[i])) {
 			if (PTR_ERR(comp->clk[i]) != -EPROBE_DEFER)
 				dev_err(dev, "Failed to get clock\n");
-
-			return PTR_ERR(comp->clk[i]);
+			ret = PTR_ERR(comp->clk[i]);
+			goto put_dev;
 		}
 
 		/* Only RDMA needs two clocks */
@@ -133,20 +134,27 @@ int mtk_mdp_comp_init(struct device *dev, struct device_node *node,
 	if (!larb_node) {
 		dev_err(dev,
 			"Missing mediadek,larb phandle in %pOF node\n", node);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_dev;
 	}
 
 	larb_pdev = of_find_device_by_node(larb_node);
 	if (!larb_pdev) {
 		dev_warn(dev, "Waiting for larb device %pOF\n", larb_node);
 		of_node_put(larb_node);
-		return -EPROBE_DEFER;
+		ret = -EPROBE_DEFER;
+		goto put_dev;
 	}
 	of_node_put(larb_node);
 
 	comp->larb_dev = &larb_pdev->dev;
 
 	return 0;
+
+put_dev:
+	of_node_put(comp->dev_node);
+
+	return ret;
 }
 
 void mtk_mdp_comp_deinit(struct device *dev, struct mtk_mdp_comp *comp)
-- 
2.25.1



