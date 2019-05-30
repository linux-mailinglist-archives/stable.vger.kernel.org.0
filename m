Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1921F2EF10
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbfE3DwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730925AbfE3DTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:37 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93B03248B2;
        Thu, 30 May 2019 03:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186376;
        bh=NillSkqfbpvRu5S8cZZUAJb/cicGykUwujOc+hao+As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9J2r203qlMf4mmwb6fxFlSYhNAo08BGcAfvckgsrcwV5JgM/8UWG53OOR5TaFNi4
         5BKD+PeiXfP11Su9x21DH1hCjKn2Rkib1JGE0GIYzRHrRzW3d6sFKoCtZJICmQfazx
         mpt5bcFWLGVb08bB2VGHes1z0OOfWtxSFaER2iHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinbo Zhu <yinbo.zhu@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 120/193] mmc: sdhci-of-esdhc: add erratum A-009204 support
Date:   Wed, 29 May 2019 20:06:14 -0700
Message-Id: <20190530030505.419421964@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5dd195522562542bc6ebe6e7bd47890d8b7ca93c ]

In the event of that any data error (like, IRQSTAT[DCE]) occurs
during an eSDHC data transaction where DMA is used for data
transfer to/from the system memory, setting the SYSCTL[RSTD]
register may cause a system hang. If software sets the register
SYSCTL[RSTD] to 1 for error recovery while DMA transferring is
not complete, eSDHC may hang the system bus. This happens because
the software register SYSCTL[RSTD] resets the DMA engine without
waiting for the completion of pending system transactions. This
erratum is to fix this issue.

Signed-off-by: Yinbo Zhu <yinbo.zhu@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-esdhc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 9207820514ceb..e26efda46b995 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -610,6 +610,9 @@ static void esdhc_reset(struct sdhci_host *host, u8 mask)
 	sdhci_writel(host, host->ier, SDHCI_INT_ENABLE);
 	sdhci_writel(host, host->ier, SDHCI_SIGNAL_ENABLE);
 
+	if (of_find_compatible_node(NULL, NULL, "fsl,p2020-esdhc"))
+		mdelay(5);
+
 	if (mask & SDHCI_RESET_ALL) {
 		val = sdhci_readl(host, ESDHC_TBCTL);
 		val &= ~ESDHC_TB_EN;
-- 
2.20.1



