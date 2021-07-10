Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C96D3C2F17
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhGJCa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234813AbhGJC3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1353A613DF;
        Sat, 10 Jul 2021 02:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884021;
        bh=nro3MGa7h3qaKoTs4yw4efAa7zU3Ahe3U9SERvsOMXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZaRvaPjZgKB7LWVnHcqjfNykrKAhY5LsNL/tSs6RuyncCFhJ8Q+tObvKS8NcIafB
         cSNplMDAKLp7AH/mHUJ7WpAbHA4cbb5dmTiQ7E2kUjwSyCGUvGH9XeSlqL+GPnBJGk
         P+fEYcMBEJ28VgPxcpWrW/lOEXBCChuX/E1F6YHPq2EMmJhDYL07CK6Rn1rqLoWByY
         1Ja1v5uaYYQE7UHE56Y2aI/ffJ21Fwu2ugj7gJ19hYIO7lKqcvvYD8RLtpHkriR4Yq
         LNufWWGzs85++g6fgpHZNUPVaKd4XBFhIP2E3KCEYxvzkAjunjS6BcOWXVuFOb1dMq
         4MzLR3Qn0ZD2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rashmi A <rashmi.a@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-phy@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 91/93] phy: intel: Fix for warnings due to EMMC clock 175Mhz change in FIP
Date:   Fri,  9 Jul 2021 22:24:25 -0400
Message-Id: <20210710022428.3169839-91-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
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

