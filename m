Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3290371BEF
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhECQuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233244AbhECQrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:47:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F1CE613E1;
        Mon,  3 May 2021 16:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059977;
        bh=gXiOxhMbUGRqAdnAYW3ioYWMt2JDeB0OfgFadacRKuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3NhOCF3R3255tdKWpG1EeoYgJJBGCEBNKt4y5WIMUY1+/93mzMgovtaWgDuIGRRV
         w90tl8gepN9uSrJid2qyKMisx3l1o8GPEUiglHoPJvz8ZXGXPGlAQ1zSAP+hZ5Hbn9
         iGPVsJ57Et2W7kZyOu8/ddFxV9nvj8gtQVmvBkTN+y8mYYMyUQRy16rFWvMrotbZpj
         sGE5SR3pGhvcoqnxOV6wj+1Ux61EHKq83Cudk9X71/f+4jCCS48n0nA5gj24LFCseN
         o40xzFcml7y+u3XqGgSRXlj0ZbBHHi2zQ+BPaRNb7SyJqRSN4yirTbSuMptDfyAptG
         y1rynWLrrBisw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 044/100] mmc: sdhci-brcmstb: Remove CQE quirk
Date:   Mon,  3 May 2021 12:37:33 -0400
Message-Id: <20210503163829.2852775-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Cooper <alcooperx@gmail.com>

[ Upstream commit f0bdf98fab058efe7bf49732f70a0f26d1143154 ]

Remove the CQHCI_QUIRK_SHORT_TXFR_DESC_SZ quirk because the
latest chips have this fixed and earlier chips have other
CQE problems that prevent the feature from being enabled.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20210325192834.42955-1-alcooperx@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-brcmstb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-brcmstb.c b/drivers/mmc/host/sdhci-brcmstb.c
index f9780c65ebe9..f24623aac2db 100644
--- a/drivers/mmc/host/sdhci-brcmstb.c
+++ b/drivers/mmc/host/sdhci-brcmstb.c
@@ -199,7 +199,6 @@ static int sdhci_brcmstb_add_host(struct sdhci_host *host,
 	if (dma64) {
 		dev_dbg(mmc_dev(host->mmc), "Using 64 bit DMA\n");
 		cq_host->caps |= CQHCI_TASK_DESC_SZ_128;
-		cq_host->quirks |= CQHCI_QUIRK_SHORT_TXFR_DESC_SZ;
 	}
 
 	ret = cqhci_init(cq_host, host->mmc, dma64);
-- 
2.30.2

