Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289D02F466
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbfE3DMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729210AbfE3DMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:46 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFD86244B0;
        Thu, 30 May 2019 03:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185965;
        bh=xEQL8cLkJontcf8UKMDxuTMBWccBYxd86576sMJ/CxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdFH3qHpEIgMcJGyv4aSKSDeJ9guBnl9VKcMzA/g0GS+QnfH1/q85YG5RrK1wcD83
         mPfy6Nt2H07fhwpsJZrugmylaecwoXOu5MwRvaoBsK96+hWYvvVfHTTSZjv6B/+NKF
         6cT2q6AIf1kFZgngnS2Cr09GnlQjwUkDYXjGcuSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 393/405] ASoC: ti: fix davinci_mcasp_probe dependencies
Date:   Wed, 29 May 2019 20:06:31 -0700
Message-Id: <20190530030600.490522223@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7d7b25d05ef1c5a1a9320190e1eeb55534847558 ]

The SND_SOC_DAVINCI_MCASP driver can use either edma or sdma as
a back-end, and it takes the presence of the respective dma engine
drivers in the configuration as an indication to which ones should be
built. However, this is flawed in multiple ways:

- With CONFIG_TI_EDMA=m and CONFIG_SND_SOC_DAVINCI_MCASP=y,
  is enabled as =m, and we get a link error:
  sound/soc/ti/davinci-mcasp.o: In function `davinci_mcasp_probe':
  davinci-mcasp.c:(.text+0x930): undefined reference to `edma_pcm_platform_register'

- When CONFIG_SND_SOC_DAVINCI_MCASP=m has already been selected by
  another driver, the same link error appears even if CONFIG_TI_EDMA
  is disabled

There are possibly other issues here, but it seems that the only reasonable
solution is to always build both SND_SOC_TI_EDMA_PCM and
SND_SOC_TI_SDMA_PCM as a dependency here. Both are fairly small and
do not have any other compile-time dependencies, so the cost is
very small, and makes the configuration stage much more consistent.

Fixes: f2055e145f29 ("ASoC: ti: Merge davinci and omap directories")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/ti/Kconfig b/sound/soc/ti/Kconfig
index 4bf3c15d4e514..ee7c202c69b77 100644
--- a/sound/soc/ti/Kconfig
+++ b/sound/soc/ti/Kconfig
@@ -21,8 +21,8 @@ config SND_SOC_DAVINCI_ASP
 
 config SND_SOC_DAVINCI_MCASP
 	tristate "Multichannel Audio Serial Port (McASP) support"
-	select SND_SOC_TI_EDMA_PCM if TI_EDMA
-	select SND_SOC_TI_SDMA_PCM if DMA_OMAP
+	select SND_SOC_TI_EDMA_PCM
+	select SND_SOC_TI_SDMA_PCM
 	help
 	  Say Y or M here if you want to have support for McASP IP found in
 	  various Texas Instruments SoCs like:
-- 
2.20.1



