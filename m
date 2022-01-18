Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E18249185A
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344661AbiARCq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:46:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51720 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347833AbiARCnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A23FEB811CF;
        Tue, 18 Jan 2022 02:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48122C36AE3;
        Tue, 18 Jan 2022 02:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473784;
        bh=B2YGg1HiTboR3+vNlNEgYYE4wVzcEZ6wXCmA6wwvLOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGYH2riCg4VFVBItBV8J6aZvKLtcy37vQzHVCvJM4aPaK+r0Uuxi+msoiShlwbR80
         bb732f09gQNPzhLYse5o5S9XoVJ8iENhjOx9GxesCD1IZkMENJa2NKiZQbxLNwM29Y
         A/WLPZeyVjf68LEnY9aMCPFisWQqUxZ9p3f3EOjCvcCF9DsUUkmzRXQ/D4dArBVNli
         Jy302qYSnS6F1nHSb8E2ojlHjkLVSE1MNJUaYMEq5/lqEVAnr0DXV7KDG5d/eNCUgW
         pVs1auOGRSQFhz1/d3WiIDLKKVMu94ngg3TAM4RMVG/Anh1Fv14y9ENWrG2tzvi3jU
         SXeYOhGoMeedw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        tiantao6@hisilicon.com, kwmad.kim@samsung.com, huyue2@yulong.com,
        linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 070/116] mmc: core: Fixup storing of OCR for MMC_QUIRK_NONSTD_SDIO
Date:   Mon, 17 Jan 2022 21:39:21 -0500
Message-Id: <20220118024007.1950576-70-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 1b0853a82189a..99a4ce68d82f1 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -708,6 +708,8 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	if (host->ops->init_card)
 		host->ops->init_card(host, card);
 
+	card->ocr = ocr_card;
+
 	/*
 	 * If the host and card support UHS-I mode request the card
 	 * to switch to 1.8V signaling level.  No 1.8v signalling if
@@ -820,7 +822,7 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 			goto mismatch;
 		}
 	}
-	card->ocr = ocr_card;
+
 	mmc_fixup_device(card, sdio_fixup_methods);
 
 	if (card->type == MMC_TYPE_SD_COMBO) {
-- 
2.34.1

