Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2328812C810
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731882AbfL2Ruc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:50:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:35058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731446AbfL2Ruc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA72821744;
        Sun, 29 Dec 2019 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641831;
        bh=lg1eM6eSNzhc2+nPlAyhsXsY4TfqmfwJx2U1+xYisZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvYULXVG0MjlopPusgd6iRkv/KMCkcOrixp4Nx69EzYI+cTRikEIYh1Y7PoNQKNuR
         VTHnmaydvDSJpSr+WBJtuNCOJQ+JYGntkWLZulhRgCXVO6FCIG6SjBN+8ox6DdYDph
         cY9T1rQGNmWaHc9r11/GBPRgQGIAHeWc05/4OlHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 227/434] cpufreq: sun50i: Fix CPU speed bin detection
Date:   Sun, 29 Dec 2019 18:24:40 +0100
Message-Id: <20191229172716.941563070@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

[ Upstream commit c23734487fb44ee16c1b007ba72d793c085e4ec4 ]

I have observed failures to boot on Orange Pi 3, because this driver
determined that my SoC is from the normal bin, but my SoC only works
reliably with the OPP values for the slowest bin.

By querying H6 owners, it was found that e-fuse values found in the wild
are in the range of 1-3, value of 7 was not reported, yet. From this and
from unused defines in BSP code, it can be assumed that meaning of efuse
values on H6 actually is:

- 1 = slowest bin
- 2 = normal bin
- 3 = fastest bin

Vendor code actually treats 0 and 2 as invalid efuse values, but later
treats all invalid values as a normal bin. This looks like a mistake in
bin detection code, that was plastered over by a hack in cpufreq code,
so let's not repeat it here. It probably only works because there are no
SoCs in the wild with efuse value of 0, and fast bin SoCs are made to
use normal bin OPP tables, which is also safe.

Let's play it safe and interpret 0 as the slowest bin, but fix detection
of other bins to match this research. More research will be done before
actual OPP tables are merged.

Fixes: f328584f7bff ("cpufreq: Add sun50i nvmem based CPU scaling driver")
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Ondrej Jirman <megous@megous.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sun50i-cpufreq-nvmem.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/sun50i-cpufreq-nvmem.c b/drivers/cpufreq/sun50i-cpufreq-nvmem.c
index eca32e443716..9907a165135b 100644
--- a/drivers/cpufreq/sun50i-cpufreq-nvmem.c
+++ b/drivers/cpufreq/sun50i-cpufreq-nvmem.c
@@ -25,7 +25,7 @@
 static struct platform_device *cpufreq_dt_pdev, *sun50i_cpufreq_pdev;
 
 /**
- * sun50i_cpufreq_get_efuse() - Parse and return efuse value present on SoC
+ * sun50i_cpufreq_get_efuse() - Determine speed grade from efuse value
  * @versions: Set to the value parsed from efuse
  *
  * Returns 0 if success.
@@ -69,21 +69,16 @@ static int sun50i_cpufreq_get_efuse(u32 *versions)
 		return PTR_ERR(speedbin);
 
 	efuse_value = (*speedbin >> NVMEM_SHIFT) & NVMEM_MASK;
-	switch (efuse_value) {
-	case 0b0001:
-		*versions = 1;
-		break;
-	case 0b0011:
-		*versions = 2;
-		break;
-	default:
-		/*
-		 * For other situations, we treat it as bin0.
-		 * This vf table can be run for any good cpu.
-		 */
+
+	/*
+	 * We treat unexpected efuse values as if the SoC was from
+	 * the slowest bin. Expected efuse values are 1-3, slowest
+	 * to fastest.
+	 */
+	if (efuse_value >= 1 && efuse_value <= 3)
+		*versions = efuse_value - 1;
+	else
 		*versions = 0;
-		break;
-	}
 
 	kfree(speedbin);
 	return 0;
-- 
2.20.1



