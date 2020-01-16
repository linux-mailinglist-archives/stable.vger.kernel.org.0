Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D4613E4A2
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389737AbgAPRJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:09:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389420AbgAPRJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B3F7206D9;
        Thu, 16 Jan 2020 17:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194583;
        bh=yGgVaHGgBR6n1ABHhk0gvfmtZc0p3oSmfcOIHIkwBdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ng2qEHLLw856nVVkl4zL8YyDFArRc/4yBJbUNuqEhfC5SNZE3GxMBHufSPCQEAW8l
         jAvXMd4kT93ugllclMDiw0lo7jpKKCXywzj+HLY9SUQcM12Jx/PUMLId8xaf1Ed4W0
         gVpFqrf3CVNxNxGIQCqp56D4LkQRJt8KlfQ2DcMk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Minghuan Lian <Minghuan.Lian@nxp.com>,
        Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 456/671] PCI: mobiveil: Fix the valid check for inbound and outbound windows
Date:   Thu, 16 Jan 2020 12:01:34 -0500
Message-Id: <20200116170509.12787-193-sashal@kernel.org>
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

From: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>

[ Upstream commit ccd34dac2ed596b1f26079912bdf638e002a3979 ]

In program_ib/ob_windows() check the window index from the function
parameter instead of the total number of initialized windows to
determine if the specified window is valid.

Fixes: 9af6bcb11e12 ("PCI: mobiveil: Add Mobiveil PCIe Host Bridge IP driver")
Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Minghuan Lian <Minghuan.Lian@nxp.com>
Reviewed-by: Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mobiveil.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-mobiveil.c b/drivers/pci/controller/pcie-mobiveil.c
index 476be4f3c7f6..14f816591e84 100644
--- a/drivers/pci/controller/pcie-mobiveil.c
+++ b/drivers/pci/controller/pcie-mobiveil.c
@@ -395,7 +395,7 @@ static void program_ib_windows(struct mobiveil_pcie *pcie, int win_num,
 	int amap_ctrl_dw;
 	u64 size64 = ~(size - 1);
 
-	if ((pcie->ib_wins_configured + 1) > pcie->ppio_wins) {
+	if (win_num >= pcie->ppio_wins) {
 		dev_err(&pcie->pdev->dev,
 			"ERROR: max inbound windows reached !\n");
 		return;
@@ -429,7 +429,7 @@ static void program_ob_windows(struct mobiveil_pcie *pcie, int win_num,
 	u32 value, type;
 	u64 size64 = ~(size - 1);
 
-	if ((pcie->ob_wins_configured + 1) > pcie->apio_wins) {
+	if (win_num >= pcie->apio_wins) {
 		dev_err(&pcie->pdev->dev,
 			"ERROR: max outbound windows reached !\n");
 		return;
-- 
2.20.1

