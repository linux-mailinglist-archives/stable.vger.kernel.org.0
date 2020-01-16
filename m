Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5419413E0CC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgAPQpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:45:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729652AbgAPQps (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:45:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A22920663;
        Thu, 16 Jan 2020 16:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193147;
        bh=XE2klW2Xr95+dG2ep4W7epYAmE+ecpW6fcCc9rcxbBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQCZjiTiE6M8wGsqd+Km871d8geYdviEvQ2bWqdb5bCgBCK9FcdPLH6r9Vfuqf+Rn
         yh0oQrk3VbMrU4T+T7ho5Ydsadj94wU4z0holo5351flDWTPyleMUL2dN8l186ihQ2
         DP43sY08nyK6Ewy2sDAxQTxyAVvdjKyjIDI4HeOs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>,
        Evan Green <evgreen@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 034/205] soc: qcom: llcc: Name regmaps to avoid collisions
Date:   Thu, 16 Jan 2020 11:40:09 -0500
Message-Id: <20200116164300.6705-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 2bfd3e7651addcaf48f12d4f11ea9d8fca6c3aa8 ]

We'll end up with debugfs collisions if we don't give names to the
regmaps created by this driver. Change the name of the config before
registering it so we don't collide in debugfs.

Fixes: 7f9c136216c7 ("soc: qcom: Add broadcast base for Last Level Cache Controller (LLCC)")
Cc: Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/llcc-slice.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/llcc-slice.c b/drivers/soc/qcom/llcc-slice.c
index 9090ea12eaf3..4a6111635f82 100644
--- a/drivers/soc/qcom/llcc-slice.c
+++ b/drivers/soc/qcom/llcc-slice.c
@@ -48,7 +48,7 @@
 
 static struct llcc_drv_data *drv_data = (void *) -EPROBE_DEFER;
 
-static const struct regmap_config llcc_regmap_config = {
+static struct regmap_config llcc_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
@@ -323,6 +323,7 @@ static struct regmap *qcom_llcc_init_mmio(struct platform_device *pdev,
 	if (IS_ERR(base))
 		return ERR_CAST(base);
 
+	llcc_regmap_config.name = name;
 	return devm_regmap_init_mmio(&pdev->dev, base, &llcc_regmap_config);
 }
 
-- 
2.20.1

