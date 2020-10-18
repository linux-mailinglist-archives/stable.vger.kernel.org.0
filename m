Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526B3291A05
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgJRTVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:32966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729216AbgJRTVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26F0A222E7;
        Sun, 18 Oct 2020 19:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048865;
        bh=+8n3zIMFKJL0z8oTl5RIgi6vXA1uqJNn2INj3/z1hNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+tCkmqr6XeIsUGHlBkqLANylq06nxMzAW4KOm3uN7QkmH1jSFvy/ZexslWQfYfeM
         /YwYwjJXabP+o0ugdKSMVZeuN7C6j5KLoMR94lB7a4rEePQU+rcKRhZJ5k8dJyGOgR
         WbCK4eJhM8e+8Xgc07kcoHUgYX0d0vPFSdkCP7fs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajendra Nayak <rnayak@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 031/101] media: venus: core: Fix error handling in probe
Date:   Sun, 18 Oct 2020 15:19:16 -0400
Message-Id: <20201018192026.4053674-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajendra Nayak <rnayak@codeaurora.org>

[ Upstream commit 98cd831088c64aa8fe7e1d2a8bb94b6faba0462b ]

Post a successful pm_ops->core_get, an error in probe
should exit by doing a pm_ops->core_put which seems
to be missing. So fix it.

Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 203c6538044fb..bfcaba37d60fe 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -224,13 +224,15 @@ static int venus_probe(struct platform_device *pdev)
 
 	ret = dma_set_mask_and_coherent(dev, core->res->dma_mask);
 	if (ret)
-		return ret;
+		goto err_core_put;
 
 	if (!dev->dma_parms) {
 		dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
 					      GFP_KERNEL);
-		if (!dev->dma_parms)
-			return -ENOMEM;
+		if (!dev->dma_parms) {
+			ret = -ENOMEM;
+			goto err_core_put;
+		}
 	}
 	dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
 
@@ -242,11 +244,11 @@ static int venus_probe(struct platform_device *pdev)
 					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 					"venus", core);
 	if (ret)
-		return ret;
+		goto err_core_put;
 
 	ret = hfi_create(core, &venus_core_ops);
 	if (ret)
-		return ret;
+		goto err_core_put;
 
 	pm_runtime_enable(dev);
 
@@ -302,6 +304,9 @@ static int venus_probe(struct platform_device *pdev)
 	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
 	hfi_destroy(core);
+err_core_put:
+	if (core->pm_ops->core_put)
+		core->pm_ops->core_put(dev);
 	return ret;
 }
 
-- 
2.25.1

