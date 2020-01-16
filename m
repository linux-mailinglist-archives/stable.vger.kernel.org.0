Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACC513F63F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388709AbgAPRFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:05:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388684AbgAPRFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89FDF2077B;
        Thu, 16 Jan 2020 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194342;
        bh=xybzNEW3gagGYev3jsj1LC82FcimqtoXS0anepIdcYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HewKpN7KRq4Qbjd1xle3+98nQcRAMDVp632EIn9fSghPr0/hue6vi7/Xhw/2LhRxp
         Ml+2mBFB+BGaIgU9zZd+Xw3oqgYn+jqImcmqSznkPh/FxGCWpq1bSRVQYa1rtdnSYQ
         ZxqpyROlJBfCsqzmsGbxFXnMnWBdAP/mL6PJaEkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Gonzalez <marc.w.gonzalez@free.fr>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 285/671] clk: qcom: Skip halt checks on gcc_pcie_0_pipe_clk for 8998
Date:   Thu, 16 Jan 2020 11:58:43 -0500
Message-Id: <20200116170509.12787-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Gonzalez <marc.w.gonzalez@free.fr>

[ Upstream commit c0ee0e43c049a13d11e913edf875e4ee376dc84b ]

See similar issue solved by commit 5f2420ed2189
("clk: qcom: Skip halt checks on gcc_usb3_phy_pipe_clk for 8998")

Without this patch, PCIe PHY init fails:

qcom-qmp-phy 1c06000.phy: pipe_clk enable failed err=-16
phy phy-1c06000.phy.0: phy init failed --> -16

Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
Fixes: b5f5f525c547 ("clk: qcom: Add MSM8998 Global Clock Control (GCC) driver")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8998.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-msm8998.c b/drivers/clk/qcom/gcc-msm8998.c
index 4e23973b6cd1..772a08101ddf 100644
--- a/drivers/clk/qcom/gcc-msm8998.c
+++ b/drivers/clk/qcom/gcc-msm8998.c
@@ -2144,7 +2144,7 @@ static struct clk_branch gcc_pcie_0_mstr_axi_clk = {
 
 static struct clk_branch gcc_pcie_0_pipe_clk = {
 	.halt_reg = 0x6b018,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x6b018,
 		.enable_mask = BIT(0),
-- 
2.20.1

