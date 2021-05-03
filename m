Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D7E371A83
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhECQj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:39:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231393AbhECQif (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:38:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63B85613BC;
        Mon,  3 May 2021 16:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059815;
        bh=gXiOxhMbUGRqAdnAYW3ioYWMt2JDeB0OfgFadacRKuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tq+Vcy8DyqMjXH8Y9bvPI0MDFCG1hf/c//r+AuFdB6A8OVore1q2EI2IwBjNHS7Yv
         AmuwJ/QmOFHX2FMYlD21GqCFTWN1kv8KxaEpO1Jf5Ti1LVWu8tkBcJ5NyB1l0yyVYl
         I/mtceg6mTl+P+Jvf/MG8yu6RjVHzZR2SWpyotgyrEgQPQB6intcX8eBJCL+Jt27Af
         in82qEbVKRfJtDDCwLS231GDDRmrNUGo3zZWgwid9N5q7IyoLCpkW1+FvyLHcwh0z4
         +uX1lT2hGcGiRzDQEYCicd04Z1VLZ3ZOczHUZH6Y9FvOKm51cu1Dpq4Oegb9CWBI3k
         fBbIgTKzsNLqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 065/134] mmc: sdhci-brcmstb: Remove CQE quirk
Date:   Mon,  3 May 2021 12:34:04 -0400
Message-Id: <20210503163513.2851510-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
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

