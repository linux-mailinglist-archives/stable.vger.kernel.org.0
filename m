Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FC229B1DE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760622AbgJ0Ofb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760619AbgJ0Ofa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:35:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6178207BB;
        Tue, 27 Oct 2020 14:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809329;
        bh=EgbG8939x54jC/rOVlyRwTqvBNMYsEeSwPgAzubUMt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEqnzTm9k6/fE68E2M+RRuVJtueFdAfPoMAUgv8gzCzvQ33CSY6Uv7y8cuizU38Oy
         tvoQ002O3EmPMZSw9eGyCWUJMbkD+Jxm2yvDl/m+LdCHMaq9zwlA5J5mFG+gkZ8xIh
         dgIpyniNzpsdz5N554UE9/EBgmJVntgCUt5ndmOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 158/408] spi: omap2-mcspi: Improve performance waiting for CHSTAT
Date:   Tue, 27 Oct 2020 14:51:36 +0100
Message-Id: <20201027135502.423189837@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit 7b1d96813317358312440d0d07abbfbeb0ef8d22 ]

This reverts commit 13d515c796 (spi: omap2-mcspi: Switch to
readl_poll_timeout()).

The amount of time spent polling for the MCSPI_CHSTAT bits to be set on
AM335x-icev2 platform is less than 1us (about 0.6us) in most cases, with
or without using DMA. So, in most cases the function need not sleep.
Also, setting the sleep_usecs to zero would not be optimal here because
ktime_add_us() used in readl_poll_timeout() is slower compared to the
direct addition used after the revert. So, it is sub-optimal to use
readl_poll_timeout in this case.

When DMA is not enabled, this revert results in an increase of about 27%
in throughput and decrease of about 20% in CPU usage. However, the CPU
usage and throughput are almost the same when used with DMA.

Therefore, fix this by reverting the commit which switched to using
readl_poll_timeout().

Fixes: 13d515c796ad ("spi: omap2-mcspi: Switch to readl_poll_timeout()")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Link: https://lore.kernel.org/r/20200910122624.8769-1-a-govindraju@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 4433cb4de564e..7646b4b56bed9 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -24,7 +24,6 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/gcd.h>
-#include <linux/iopoll.h>
 
 #include <linux/spi/spi.h>
 #include <linux/gpio.h>
@@ -348,9 +347,19 @@ static void omap2_mcspi_set_fifo(const struct spi_device *spi,
 
 static int mcspi_wait_for_reg_bit(void __iomem *reg, unsigned long bit)
 {
-	u32 val;
-
-	return readl_poll_timeout(reg, val, val & bit, 1, MSEC_PER_SEC);
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(1000);
+	while (!(readl_relaxed(reg) & bit)) {
+		if (time_after(jiffies, timeout)) {
+			if (!(readl_relaxed(reg) & bit))
+				return -ETIMEDOUT;
+			else
+				return 0;
+		}
+		cpu_relax();
+	}
+	return 0;
 }
 
 static int mcspi_wait_for_completion(struct  omap2_mcspi *mcspi,
-- 
2.25.1



