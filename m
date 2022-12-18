Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5333650381
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 18:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbiLRRFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 12:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiLRRE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 12:04:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFAC1DF04;
        Sun, 18 Dec 2022 08:21:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC955B80BA8;
        Sun, 18 Dec 2022 16:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C5DC433F2;
        Sun, 18 Dec 2022 16:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380501;
        bh=3ptt4x1QO6Oa6YakayJezGEpSKUVTYNbXUAgLDfh708=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZzvruv0aMVpBYP3EkblyOvO7XpupZpcolBmzSIQn5qQVfH9TdfXlnEFvtw9XLgXb
         gqpTKMu10CCBPUF/ZAk4+pEpka+GLCcMY/fsNwDPeNdiad1lTs5GJ7H1DlaXhUIcZt
         nWI/zYvnV82hKK9LUZYNPCeFniLjgibGIO6XXqnw4gCB4LEoKjaH/tvdVG0Uvdw8mo
         0RNQ0Nosze1hu0OK7NHmNOYO7qje+GfFXNdHIlQt19sz8R7X9jwyFzScvQd5ES2X5U
         LQMa5uRv+fsWdakk0gNzv8uEq/uBX6z2G8ASwMjjYCsESADdnYVsSIfg3eok5y0bm7
         QywsxuFOOfD0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, adrian.hunter@intel.com,
        linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/26] mmc: f-sdh30: Add quirks for broken timeout clock capability
Date:   Sun, 18 Dec 2022 11:20:14 -0500
Message-Id: <20221218162016.934280-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218162016.934280-1-sashal@kernel.org>
References: <20221218162016.934280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit aae9d3a440736691b3c1cb09ae2c32c4f1ee2e67 ]

There is a case where the timeout clock is not supplied to the capability.
Add a quirk for that.

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Acked-by: Jassi Brar <jaswinder.singh@linaro.org>
Link: https://lore.kernel.org/r/20221111081033.3813-7-hayashi.kunihiko@socionext.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci_f_sdh30.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/sdhci_f_sdh30.c b/drivers/mmc/host/sdhci_f_sdh30.c
index 485f7591fae4..ca9e05440da1 100644
--- a/drivers/mmc/host/sdhci_f_sdh30.c
+++ b/drivers/mmc/host/sdhci_f_sdh30.c
@@ -199,6 +199,9 @@ static int sdhci_f_sdh30_probe(struct platform_device *pdev)
 	if (reg & SDHCI_CAN_DO_8BIT)
 		priv->vendor_hs200 = F_SDH30_EMMC_HS200;
 
+	if (!(reg & SDHCI_TIMEOUT_CLK_MASK))
+		host->quirks |= SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK;
+
 	ret = sdhci_add_host(host);
 	if (ret)
 		goto err_add_host;
-- 
2.35.1

