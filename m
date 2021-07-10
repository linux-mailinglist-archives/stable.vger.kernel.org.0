Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44A53C2EC9
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhGJC23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233244AbhGJC1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D70C61419;
        Sat, 10 Jul 2021 02:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883861;
        bh=nro3MGa7h3qaKoTs4yw4efAa7zU3Ahe3U9SERvsOMXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YIxfmYMUeKdfMAIdgx4bWlvMri3OdC057+uCtM/+0rryuXlpxIj48HRpRDy7pm9wK
         zwWHU+gurv+KZZivqMPPovZ4wJcjxJP5UbaCfLWM/onfhXll5AxP/I0d//6Y7H2InE
         9EnIxISSNJXu6nB3rV+VlFCtd0Idc9xnRRg1lALyXRuXdjQ0UDhIzc6W34K+OiRN38
         y71+LITiZiDhQQ4kGf8HfAeBAhNpIN70TjvAdGPjMXwludQpV+DCTukgNOR/KhM8xY
         CdqNW+sViKXviL8ah3aE45NeL0ziHHunDpZ6btTfgqSGGapMGd3e0YBavGNFhNvGeY
         T7dOFEkRpPIhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rashmi A <rashmi.a@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-phy@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 102/104] phy: intel: Fix for warnings due to EMMC clock 175Mhz change in FIP
Date:   Fri,  9 Jul 2021 22:21:54 -0400
Message-Id: <20210710022156.3168825-102-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rashmi A <rashmi.a@intel.com>

[ Upstream commit 2f2b73a29d2aabf5ad0150856c3e5cb6e04dcfc1 ]

Since the EMMC clock was changed from 200Mhz to 175Mhz in FIP,
there were some warnings introduced, as the frequency values
being checked was still wrt 200Mhz in code. Hence, the frequency
checks are now updated based on the current 175Mhz EMMC clock changed
in FIP.

Spamming kernel log msg:
"phy phy-20290000.mmc_phy.2: Unsupported rate: 43750000"

Signed-off-by: Rashmi A <rashmi.a@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-By: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210603182242.25733-3-rashmi.a@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/intel/phy-intel-keembay-emmc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/intel/phy-intel-keembay-emmc.c b/drivers/phy/intel/phy-intel-keembay-emmc.c
index eb7c635ed89a..0eb11ac7c2e2 100644
--- a/drivers/phy/intel/phy-intel-keembay-emmc.c
+++ b/drivers/phy/intel/phy-intel-keembay-emmc.c
@@ -95,7 +95,8 @@ static int keembay_emmc_phy_power(struct phy *phy, bool on_off)
 	else
 		freqsel = 0x0;
 
-	if (mhz < 50 || mhz > 200)
+	/* Check for EMMC clock rate*/
+	if (mhz > 175)
 		dev_warn(&phy->dev, "Unsupported rate: %d MHz\n", mhz);
 
 	/*
-- 
2.30.2

