Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304A2491B02
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348574AbiARDD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350417AbiARC5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:57:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E05C061367;
        Mon, 17 Jan 2022 18:46:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09CD5612F3;
        Tue, 18 Jan 2022 02:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79440C36AE3;
        Tue, 18 Jan 2022 02:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473960;
        bh=d5GVjZ6obPglEZpSjEHJXfWgYTRRMgBBCLUNr9063mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ztp0qEiuFsDNlzeAiswSH6/ZftP2qttrx4OcgRNR5QYdUr6cF4TjiiiTINjkIsD18
         ggpDy84t3ovintIRoBwIdBDMXmkTJZm1zKaBA+JFb8zhKf2cSUCiXglS9sHDgdkGTG
         7pwfw3wWI4PKpFv0r2EX9P9ctUiTU3EZj5K2KCDZnwTxSUsdphMemS83oXi1Ww8HTy
         hqZpE81JEEEZwey58GymbBZTeX/fo/cF5fl1HDTjd80soXk8dB+8yTSBLwGu91TPts
         Eu5d7NjLtVFia9nKxwirBGPYJQh8KEAzgQ6tZFFBa9LR7CZsOmVem2cJnrax8R8aYt
         sDvcgvJ5uy0PQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Sasha Levin <sashal@kernel.org>, tiantao6@hisilicon.com,
        huyue2@yulong.com, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 42/73] mmc: core: Fixup storing of OCR for MMC_QUIRK_NONSTD_SDIO
Date:   Mon, 17 Jan 2022 21:44:01 -0500
Message-Id: <20220118024432.1952028-42-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 8c3e5b74b9e2146f564905e50ca716591c76d4f1 ]

The mmc core takes a specific path to support initializing of a
non-standard SDIO card. This is triggered by looking for the card-quirk,
MMC_QUIRK_NONSTD_SDIO.

In mmc_sdio_init_card() this gets rather messy, as it causes the code to
bail out earlier, compared to the usual path. This leads to that the OCR
doesn't get saved properly in card->ocr. Fortunately, only omap_hsmmc has
been using the MMC_QUIRK_NONSTD_SDIO and is dealing with the issue, by
assigning a hardcoded value (0x80) to card->ocr from an ->init_card() ops.

To make the behaviour consistent, let's instead rely on the core to save
the OCR in card->ocr during initialization.

Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://lore.kernel.org/r/e7936cff7fc24d187ef2680d3b4edb0ade58f293.1636564631.git.hns@goldelico.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/sdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 0bf33786fc5c5..9e0791332ef38 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -626,6 +626,8 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	if (host->ops->init_card)
 		host->ops->init_card(host, card);
 
+	card->ocr = ocr_card;
+
 	/*
 	 * If the host and card support UHS-I mode request the card
 	 * to switch to 1.8V signaling level.  No 1.8v signalling if
@@ -738,7 +740,7 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 			goto mismatch;
 		}
 	}
-	card->ocr = ocr_card;
+
 	mmc_fixup_device(card, sdio_fixup_methods);
 
 	if (card->type == MMC_TYPE_SD_COMBO) {
-- 
2.34.1

