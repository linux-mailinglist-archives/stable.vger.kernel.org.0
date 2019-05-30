Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A31B2EC43
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731924AbfE3DTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:19:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731919AbfE3DTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:31 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDFA024893;
        Thu, 30 May 2019 03:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186370;
        bh=MmIkGhU8yGNON9B772QdRYAIc7GER/U26lleh8N4WcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0CGy/jHEyYRS2k9Ws3sT9GOvrGregCdWSbDlRWSuCrPTMW2X8ehXH1yf/hbvQJdf
         GyzPzmf5apjQRkwHEaBzfwNidDyTgV1whX5vci8luYBD/X8B+nBx96JYOgWYEe+b5a
         H3qUaPQrsax+fQkP9b2wIKI5vIbv+Lf23oXOY+aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinbo Zhu <yinbo.zhu@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 119/193] mmc: sdhci-of-esdhc: add erratum eSDHC5 support
Date:   Wed, 29 May 2019 20:06:13 -0700
Message-Id: <20190530030505.202984416@linuxfoundation.org>
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

[ Upstream commit a46e42712596b51874f04c73f1cdf1017f88df52 ]

Software writing to the Transfer Type configuration register
(system clock domain) can cause a setup/hold violation in the
CRC flops (card clock domain), which can cause write accesses
to be sent with corrupt CRC values. This issue occurs only for
write preceded by read. this erratum is to fix this issue.

Signed-off-by: Yinbo Zhu <yinbo.zhu@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-esdhc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 7b7d077e40fd4..9207820514ceb 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -880,6 +880,9 @@ static int sdhci_esdhc_probe(struct platform_device *pdev)
 	if (esdhc->vendor_ver > VENDOR_V_22)
 		host->quirks &= ~SDHCI_QUIRK_NO_BUSY_IRQ;
 
+	if (of_find_compatible_node(NULL, NULL, "fsl,p2020-esdhc"))
+		host->quirks2 |= SDHCI_QUIRK_RESET_AFTER_REQUEST;
+
 	if (of_device_is_compatible(np, "fsl,p5040-esdhc") ||
 	    of_device_is_compatible(np, "fsl,p5020-esdhc") ||
 	    of_device_is_compatible(np, "fsl,p4080-esdhc") ||
-- 
2.20.1



