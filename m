Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6029E1FB9BF
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgFPQGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732360AbgFPPsL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:48:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA41B20776;
        Tue, 16 Jun 2020 15:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322491;
        bh=sOxhzpmmDRjatJXqcSrLLVy74KxqIyRrFovwlWN37Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxUnijn1Z4bKrSY3m2/sitFtLUrbZsgxLcYghTAbXBo98IXJY/iGcjS1ybZfmZu4I
         33cP5nBprKqM6dy5RlopDvWxwwlmucLTPgfBnsYT4x9yqM9wcvzcHq2AO+nzftBJ23
         M+SupOJMHWmFgvCR1UdKO55Fff3RSiMLPjui96+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.7 151/163] mmc: sdhci-of-at91: fix CALCR register being rewritten
Date:   Tue, 16 Jun 2020 17:35:25 +0200
Message-Id: <20200616153114.038248740@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

commit dbdea70f71d672c12bc4454e7c258a8f78194d74 upstream.

When enabling calibration at reset, the CALCR register was completely
rewritten. This may cause certain bits being deleted unintentedly.
Fix by issuing a read-modify-write operation.

Fixes: 727d836a375a ("mmc: sdhci-of-at91: add DT property to enable calibration on full reset")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Link: https://lore.kernel.org/r/20200527105659.142560-1-eugen.hristev@microchip.com
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-at91.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-of-at91.c
+++ b/drivers/mmc/host/sdhci-of-at91.c
@@ -120,9 +120,12 @@ static void sdhci_at91_reset(struct sdhc
 	    || mmc_gpio_get_cd(host->mmc) >= 0)
 		sdhci_at91_set_force_card_detect(host);
 
-	if (priv->cal_always_on && (mask & SDHCI_RESET_ALL))
-		sdhci_writel(host, SDMMC_CALCR_ALWYSON | SDMMC_CALCR_EN,
+	if (priv->cal_always_on && (mask & SDHCI_RESET_ALL)) {
+		u32 calcr = sdhci_readl(host, SDMMC_CALCR);
+
+		sdhci_writel(host, calcr | SDMMC_CALCR_ALWYSON | SDMMC_CALCR_EN,
 			     SDMMC_CALCR);
+	}
 }
 
 static const struct sdhci_ops sdhci_at91_sama5d2_ops = {


