Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10AD114824F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391448AbgAXL0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:26:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391599AbgAXL0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:26:53 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34CE42075D;
        Fri, 24 Jan 2020 11:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865213;
        bh=/Xyrt+GlzXqdolnXrvTicWdp54n+ZBtuc5H/3+PFcwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tG86WkaZ41hkudbrW1tw2iBb9uryAnHvnqLDbVIHRq4V/TJvSdw84jmr2agEYHi8q
         q1YvC7C7tmoZ/iECseRN++fZjr4WuNtJs40XieAJiWPeYjIuTsp1h+iE9cl12tgEdM
         xnOCWGVrjkW7ui/jaD8eSm0NJERzffiPGLUSg53g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Minghuan Lian <Minghuan.Lian@nxp.com>,
        Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 471/639] PCI: mobiveil: Fix the valid check for inbound and outbound windows
Date:   Fri, 24 Jan 2020 10:30:41 +0100
Message-Id: <20200124093146.440853123@linuxfoundation.org>
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
index 476be4f3c7f6e..14f816591e844 100644
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



