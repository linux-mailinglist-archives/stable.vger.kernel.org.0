Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76172114B09
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 03:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfLFCrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 21:47:23 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15852 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbfLFCrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 21:47:22 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5de9c1290002>; Thu, 05 Dec 2019 18:47:05 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 05 Dec 2019 18:47:21 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 05 Dec 2019 18:47:21 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec
 2019 02:47:21 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 6 Dec 2019 02:47:21 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.163.171]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5de9c1390003>; Thu, 05 Dec 2019 18:47:21 -0800
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <skomatineni@nvidia.com>
CC:     <stable@vger.kernel.org>
Subject: [PATCH v3 09/15] ASoC: tegra: Add fallback for audio mclk
Date:   Thu, 5 Dec 2019 18:47:12 -0800
Message-ID: <1575600438-26795-10-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575600438-26795-1-git-send-email-skomatineni@nvidia.com>
References: <1575600438-26795-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575600425; bh=QpuTCwWQ7OA+cLjLXqsb+rGtt5ndNflALwObfnlfPq8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=CPFHD0mkAFULSPWg9IxXIMKCimxQf32uUYBMqKNNoqpk6e3v16NdGvEDqU5HWqiRd
         IN8N5iQBx++t+eoT8fEXfuJ4DxjWB1uEaG7BK1vJ1wS3+irw2l7TiqrNCgAX9BAUTK
         VJQU/Exq4OeNlHNmj8SWoBI4qE/fUT4aUhfqDyBokDfR2s3ayUQfsjElMgBt332RoV
         MAfw0CXXNn7F2FbV0oJce1qr5cq4AI4AIJTOMre5zWn9RLP4Prbj8r9iXVhN/UFGEr
         UItrf797/aGEx4edhU28+C4QVd3lOtbkhdrIR/oWQatNmf+5qFpGkDyzdAWkUYsLJI
         76/7WXIlA/p9w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

mclk is from clk_out_1 which is part of Tegra PMC block and pmc clocks
are moved to Tegra PMC driver with pmc as clock provider and using pmc
clock ids.

New device tree uses clk_out_1 from pmc clock provider.

So, this patch adds fallback to extern1 in case of retrieving mclk fails
to be backward compatible of new device tree with older kernels.

Cc: stable@vger.kernel.org

Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 sound/soc/tegra/tegra_asoc_utils.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/tegra/tegra_asoc_utils.c b/sound/soc/tegra/tegra_asoc_utils.c
index 8e3a3740df7c..f7408d5240c0 100644
--- a/sound/soc/tegra/tegra_asoc_utils.c
+++ b/sound/soc/tegra/tegra_asoc_utils.c
@@ -211,8 +211,14 @@ int tegra_asoc_utils_init(struct tegra_asoc_utils_data *data,
 	data->clk_cdev1 = clk_get(dev, "mclk");
 	if (IS_ERR(data->clk_cdev1)) {
 		dev_err(data->dev, "Can't retrieve clk cdev1\n");
-		ret = PTR_ERR(data->clk_cdev1);
-		goto err_put_pll_a_out0;
+		data->clk_cdev1 = clk_get_sys("clk_out_1", "extern1");
+		if (IS_ERR(data->clk_cdev1)) {
+			dev_err(data->dev, "Can't retrieve clk extern1\n");
+			ret = PTR_ERR(data->clk_cdev1);
+			goto err_put_pll_a_out0;
+		}
+
+		dev_err(data->dev, "Falling back to extern1\n");
 	}
 
 	/*
-- 
2.7.4

