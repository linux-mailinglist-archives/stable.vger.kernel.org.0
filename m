Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9741C8F30
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgEGOaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728743AbgEGOaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:30:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FE5024953;
        Thu,  7 May 2020 14:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861802;
        bh=esUhlF+uB8ANdHPzxeuK+vw4vjfe+BKm5c7xYKPBzco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWiTVCSpaqG0Fh8Bhhrh4O8h+TQPuHi9lr2zpgM6I2s8lxEWDr0jeFQwBtN/7d9ed
         30zNHzKJ3yoTUb78yKcbsUemkyTucZ0JgOEdG576eI0bj5KfoB0blapEo4EPmbNuwx
         L2nwlfu0UWUzb0Ha28btvn3MUP1B7eCjX7bq4WyA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tang Bin <tangbin@cmss.chinamobile.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.14 16/16] iommu/qcom: Fix local_base status check
Date:   Thu,  7 May 2020 10:29:43 -0400
Message-Id: <20200507142943.26848-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142943.26848-1-sashal@kernel.org>
References: <20200507142943.26848-1-sashal@kernel.org>
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
index b08002851e068..920a5df319bc4 100644
--- a/drivers/iommu/qcom_iommu.c
+++ b/drivers/iommu/qcom_iommu.c
@@ -775,8 +775,11 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
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

