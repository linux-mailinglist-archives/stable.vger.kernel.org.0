Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA2F148112
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389679AbgAXLQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390419AbgAXLQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:16:47 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F25B520704;
        Fri, 24 Jan 2020 11:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864606;
        bh=dExcBcGAWKP7IlXaZlS37lYKI9YwuOlr4ID0inXC1ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+VVXKNSQ7TfOHLHuSDxYCtS8Sbd1o/84ij1QaeHhTHIx+mbs7T/LcAx90y5Lo0pU
         oUFG9JaEwxj4WxGjiuzMmOcYzjHZgJ06kqm6heW4X7as69nWBroWBcjnHl9WbMxmlo
         tmsgmyVtFXdqDapHTfL/WeZFmJo/HuxPdJe/Io3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Gonzalez <marc.w.gonzalez@free.fr>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 300/639] clk: qcom: Skip halt checks on gcc_pcie_0_pipe_clk for 8998
Date:   Fri, 24 Jan 2020 10:27:50 +0100
Message-Id: <20200124093124.507613997@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4e23973b6cd16..772a08101ddf2 100644
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



