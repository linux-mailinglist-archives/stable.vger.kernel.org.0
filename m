Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CD5378429
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhEJKux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232850AbhEJKrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:47:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6230619B0;
        Mon, 10 May 2021 10:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643043;
        bh=gXiOxhMbUGRqAdnAYW3ioYWMt2JDeB0OfgFadacRKuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEhqKOTXrvR/oHWrmW/CPLSVpQ+DjHzJBEBxAEIMRdPKDh2LJFBI0yyZUJv8cu8sj
         IrXSZlV79uNNQBYy3b05leKCr78qtnL6iXtqobLfVuF0rsbrzfKzwvALLBppVv8PDp
         rvIgiHTkNAFMwRhbYUiN1mpRvxrM1iM2WuJQwiIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/299] mmc: sdhci-brcmstb: Remove CQE quirk
Date:   Mon, 10 May 2021 12:19:10 +0200
Message-Id: <20210510102010.004502600@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



