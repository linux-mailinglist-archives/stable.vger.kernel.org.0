Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B597A910D
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390637AbfIDSNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389686AbfIDSNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:13:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40C9F206BA;
        Wed,  4 Sep 2019 18:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620795;
        bh=mA2DhB+6Rg5ByISkbf4esgGtUUyDXFyVrivqcA2XaVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mv0LiCylzZkpc5xm36f3Bc8OpWI/xVTpUNMNjBwRiQ9Cx3+icPbq9Xm31O8yaeN8T
         3/+8UcMH2GABtYjnhibpEsTO5UZPkWaOd0cm29pH6IwRHSSRm/dfuhXHahvAAircw5
         qNqmQTspJiT8iYFfsRgb3+tYyICIuYOM0zslZFqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.2 096/143] mmc: sdhci-sprd: fixed incorrect clock divider
Date:   Wed,  4 Sep 2019 19:53:59 +0200
Message-Id: <20190904175317.933325229@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

commit efdaf27517a892238e0dfa046cd91184b039d681 upstream.

The register SDHCI_CLOCK_CONTROL should be cleared before config clock
divider, otherwise the frequency configured maybe lower than we
expected.

Fixes: fb8bd90f83c4 ("mmc: sdhci-sprd: Add Spreadtrum's initial host controller")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Chunyan Zhang <zhang.lyra@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linaro.org>
Tested-by: Baolin Wang <baolin.wang@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-sprd.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -174,10 +174,11 @@ static inline void _sdhci_sprd_set_clock
 	struct sdhci_sprd_host *sprd_host = TO_SPRD_HOST(host);
 	u32 div, val, mask;
 
-	div = sdhci_sprd_calc_div(sprd_host->base_rate, clk);
+	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
 
-	clk |= ((div & 0x300) >> 2) | ((div & 0xFF) << 8);
-	sdhci_enable_clk(host, clk);
+	div = sdhci_sprd_calc_div(sprd_host->base_rate, clk);
+	div = ((div & 0x300) >> 2) | ((div & 0xFF) << 8);
+	sdhci_enable_clk(host, div);
 
 	/* enable auto gate sdhc_enable_auto_gate */
 	val = sdhci_readl(host, SDHCI_SPRD_REG_32_BUSY_POSI);


