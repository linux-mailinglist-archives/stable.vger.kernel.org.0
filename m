Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD5C3032CB
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbhAZEih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:38:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbhAYMvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 07:51:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3233222F9;
        Mon, 25 Jan 2021 12:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611579055;
        bh=UjDoBeFYelZMuB+VxEwk6WDvkWvuefpCNK4nN0+uaes=;
        h=From:To:Cc:Subject:Date:From;
        b=rDx1dBTsyoT3lVwZK41eQqKkTMWxKEM81hehefB75gPvh57ZdZ8X7SIxcgnPAH3n5
         pPO/P7ND167R/ckDrI/UQ0ATv9qa4D8ice2NjybMMaU98IESGp/8BKom/v1Ak+6ffW
         /I3FcvqJ1TW1ZmCmKTf+OdC3UXd2X4lARf7O9/Sz77cbDZcbKheL1xr+dQWV9bknCF
         mfNuloCtfS4nkbK7t6x1c3anTzWdf+PHxzJdM76SII8Tf7zBK0Z9mNU3HX/DEYU/XM
         Oroxs+yWaHieK8Su8qfEG8uqSDqyNueBkyj2I6hyW0sUGtlqea3sId9yhfZAAqqFED
         7QenohHVP3owg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Al Cooper <alcooperx@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: brcmstb: Fix sdhci_pltfm_suspend link error
Date:   Mon, 25 Jan 2021 13:50:45 +0100
Message-Id: <20210125125050.102605-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

sdhci_pltfm_suspend() is only available when CONFIG_PM_SLEEP
support is built into the kernel, which caused a regression
in a recent bugfix:

ld.lld: error: undefined symbol: sdhci_pltfm_suspend
>>> referenced by sdhci-brcmstb.c
>>>               mmc/host/sdhci-brcmstb.o:(sdhci_brcmstb_shutdown) in archive drivers/built-in.a

Making the call conditional on the symbol fixes the link
error.

Fixes: 5b191dcba719 ("mmc: sdhci-brcmstb: Fix mmc timeout errors on S5 suspend")
Fixes: e7b5d63a82fe ("mmc: sdhci-brcmstb: Add shutdown callback")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
It would be helpful if someone could test this to ensure that the
driver works correctly even when CONFIG_PM_SLEEP is disabled
---
 drivers/mmc/host/sdhci-brcmstb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-brcmstb.c b/drivers/mmc/host/sdhci-brcmstb.c
index f9780c65ebe9..dc9280b149db 100644
--- a/drivers/mmc/host/sdhci-brcmstb.c
+++ b/drivers/mmc/host/sdhci-brcmstb.c
@@ -314,7 +314,8 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 
 static void sdhci_brcmstb_shutdown(struct platform_device *pdev)
 {
-	sdhci_pltfm_suspend(&pdev->dev);
+	if (IS_ENABLED(CONFIG_PM_SLEEP))
+		sdhci_pltfm_suspend(&pdev->dev);
 }
 
 MODULE_DEVICE_TABLE(of, sdhci_brcm_of_match);
-- 
2.29.2

