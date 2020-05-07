Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B221C8F91
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgEGOdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbgEGO3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:29:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 971D524955;
        Thu,  7 May 2020 14:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861781;
        bh=yjK0K18/yKGNc2Fe44IN8aGXKpjykOVM6YYbZaoJKEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sG/KrzW91pjBPcp5RrupX/nD8BxVE8O5Va0XMPgvc3d+1A679wR9Ellc6H6iBixqd
         Y51SbK6aYgcICdj+yHVM2WAk3ItLvoas7FlWGvzuRVnodW+QF6y5JrYRs9zJzpZ/Lu
         Dd7YBQu1hM5V3b3BMtozxpKyk5+5mp8TjMn59Tjw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tang Bin <tangbin@cmss.chinamobile.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 20/20] iommu/qcom: Fix local_base status check
Date:   Thu,  7 May 2020 10:29:16 -0400
Message-Id: <20200507142917.26612-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142917.26612-1-sashal@kernel.org>
References: <20200507142917.26612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit b52649aee6243ea661905bdc5fbe28cc5f6dec76 ]

The function qcom_iommu_device_probe() does not perform sufficient
error checking after executing devm_ioremap_resource(), which can
result in crashes if a critical error path is encountered.

Fixes: 0ae349a0f33f ("iommu/qcom: Add qcom_iommu")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20200418134703.1760-1-tangbin@cmss.chinamobile.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/qcom_iommu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/qcom_iommu.c b/drivers/iommu/qcom_iommu.c
index 9a6ed5eeaad16..b0a4a3d2f60ea 100644
--- a/drivers/iommu/qcom_iommu.c
+++ b/drivers/iommu/qcom_iommu.c
@@ -797,8 +797,11 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	qcom_iommu->dev = dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res)
+	if (res) {
 		qcom_iommu->local_base = devm_ioremap_resource(dev, res);
+		if (IS_ERR(qcom_iommu->local_base))
+			return PTR_ERR(qcom_iommu->local_base);
+	}
 
 	qcom_iommu->iface_clk = devm_clk_get(dev, "iface");
 	if (IS_ERR(qcom_iommu->iface_clk)) {
-- 
2.20.1

