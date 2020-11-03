Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006E82A57C3
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgKCUwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731696AbgKCUwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23CEC2071E;
        Tue,  3 Nov 2020 20:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436754;
        bh=0rj+ug9R9MpMJQzwapoymSxbfpj6sNKwYChpyIoCe0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+ldPxR3tPGmIIjuUzeuURyfYuzoVrLl4BhH+xISLxE+SMp8NsVy7QJeVCU9m6+5h
         EIeiwVyCrYsn1VP+gJgH45TQbHDijXK0Qh6f/X0OhXX03vlMrP268Jfe6zgwYmPi0p
         w/rYd7Bf6acX5jX6uK5KiKBNiZDyLpELCknYQUh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.9 350/391] mmc: sdhci-of-esdhc: make sure delay chain locked for HS400
Date:   Tue,  3 Nov 2020 21:36:41 +0100
Message-Id: <20201103203410.755470067@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>

commit 011fde48394b7dc8dfd6660d1013b26a00157b80 upstream.

For eMMC HS400 mode initialization, the DLL reset is a required step
if DLL is enabled to use previously, like in bootloader.
This step has not been documented in reference manual, but the RM will
be fixed sooner or later.

This patch is to add the step of DLL reset, and make sure delay chain
locked for HS400.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20201020081116.20918-1-yangbo.lu@nxp.com
Fixes: 54e08d9a95ca ("mmc: sdhci-of-esdhc: add hs400 mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-esdhc.h    |    2 ++
 drivers/mmc/host/sdhci-of-esdhc.c |   17 +++++++++++++++++
 2 files changed, 19 insertions(+)

--- a/drivers/mmc/host/sdhci-esdhc.h
+++ b/drivers/mmc/host/sdhci-esdhc.h
@@ -5,6 +5,7 @@
  * Copyright (c) 2007 Freescale Semiconductor, Inc.
  * Copyright (c) 2009 MontaVista Software, Inc.
  * Copyright (c) 2010 Pengutronix e.K.
+ * Copyright 2020 NXP
  *   Author: Wolfram Sang <kernel@pengutronix.de>
  */
 
@@ -88,6 +89,7 @@
 /* DLL Config 0 Register */
 #define ESDHC_DLLCFG0			0x160
 #define ESDHC_DLL_ENABLE		0x80000000
+#define ESDHC_DLL_RESET			0x40000000
 #define ESDHC_DLL_FREQ_SEL		0x08000000
 
 /* DLL Config 1 Register */
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -4,6 +4,7 @@
  *
  * Copyright (c) 2007, 2010, 2012 Freescale Semiconductor, Inc.
  * Copyright (c) 2009 MontaVista Software, Inc.
+ * Copyright 2020 NXP
  *
  * Authors: Xiaobo Xie <X.Xie@freescale.com>
  *	    Anton Vorontsov <avorontsov@ru.mvista.com>
@@ -19,6 +20,7 @@
 #include <linux/clk.h>
 #include <linux/ktime.h>
 #include <linux/dma-mapping.h>
+#include <linux/iopoll.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>
 #include "sdhci-pltfm.h"
@@ -743,6 +745,21 @@ static void esdhc_of_set_clock(struct sd
 		if (host->mmc->actual_clock == MMC_HS200_MAX_DTR)
 			temp |= ESDHC_DLL_FREQ_SEL;
 		sdhci_writel(host, temp, ESDHC_DLLCFG0);
+
+		temp |= ESDHC_DLL_RESET;
+		sdhci_writel(host, temp, ESDHC_DLLCFG0);
+		udelay(1);
+		temp &= ~ESDHC_DLL_RESET;
+		sdhci_writel(host, temp, ESDHC_DLLCFG0);
+
+		/* Wait max 20 ms */
+		if (read_poll_timeout(sdhci_readl, temp,
+				      temp & ESDHC_DLL_STS_SLV_LOCK,
+				      10, 20000, false,
+				      host, ESDHC_DLLSTAT0))
+			pr_err("%s: timeout for delay chain lock.\n",
+			       mmc_hostname(host->mmc));
+
 		temp = sdhci_readl(host, ESDHC_TBCTL);
 		sdhci_writel(host, temp | ESDHC_HS400_WNDW_ADJUST, ESDHC_TBCTL);
 


