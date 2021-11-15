Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FDA451453
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240629AbhKOUHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:07:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233206AbhKOTZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24FD661AE3;
        Mon, 15 Nov 2021 18:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002796;
        bh=xOqVvg8VOnDakoS8A0uy/GAWZNDSyLh9z2+uhiRlxRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlsmgcQmtcnv3H2mLzNUDM05dwdmptXytRJDSnl346R6+pBEd9YnVG4Y0QafSOabK
         AuLDivc2wDS8HcFaAwz6gQMyvJsDe2oO+0ca9KYtS9jKYGqZ6WbZzZROCRs0CjGAcb
         tyfuYgBIp3jRLW7KcBmOqXm9iyecKKoCei+XjbnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 667/917] phy: qcom-qmp: another fix for the sc8180x PCIe definition
Date:   Mon, 15 Nov 2021 18:02:42 +0100
Message-Id: <20211115165451.512048564@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 26f71abef580537d978f6299330689f029ee1e6c ]

Commit f839f14e24f2 ("phy: qcom-qmp: Add sc8180x PCIe support") added
SC8180X PCIe tables, but used sm8250_qmp_pcie_serdes_tbl as a serdes
table because of the copy paste error. Commit bfccd9a71a08 ("phy:
qcom-qmp: Fix sc8180x PCIe definition") corrected part of this mistake
by pointing serdes_tbl to sc8180x_qmp_pcie_serdes_tbl, however the
serdes_tbl_num field was not updated to use sc8180x table. So let's now
fix the serdes_tbl_num field too.

Fixes: bfccd9a71a08 ("phy: qcom-qmp: Fix sc8180x PCIe definition")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211020155604.1374530-1-dmitry.baryshkov@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index f14032170b1c1..06b04606dd7ea 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -3632,7 +3632,7 @@ static const struct qmp_phy_cfg sc8180x_pciephy_cfg = {
 	.nlanes = 1,
 
 	.serdes_tbl		= sc8180x_qmp_pcie_serdes_tbl,
-	.serdes_tbl_num		= ARRAY_SIZE(sm8250_qmp_pcie_serdes_tbl),
+	.serdes_tbl_num		= ARRAY_SIZE(sc8180x_qmp_pcie_serdes_tbl),
 	.tx_tbl			= sc8180x_qmp_pcie_tx_tbl,
 	.tx_tbl_num		= ARRAY_SIZE(sc8180x_qmp_pcie_tx_tbl),
 	.rx_tbl			= sc8180x_qmp_pcie_rx_tbl,
-- 
2.33.0



