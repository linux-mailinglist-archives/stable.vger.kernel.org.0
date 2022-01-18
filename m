Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0FB4915CE
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345709AbiARCbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:31:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43884 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245275AbiARC0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:26:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95AB16114A;
        Tue, 18 Jan 2022 02:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1F3C36AEF;
        Tue, 18 Jan 2022 02:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472802;
        bh=Ie4qdRRo3GQzYifj9cDxbYRfZvg5hjiq7dfpnsXoKsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGC8YnLd52t8iA9ndiDekE6nhqnGQKv//6UJxUQ13ew2LDYDFCy/nj9fjXbm0YcdG
         rRLEEAEvvJn0WTtm0DUWceFmg2YOuKOvwpa/G/kOaeUBcD2h+yY4VJ5P/AEeItBK9m
         v0jlzri69xecKzZV4sgROPKXGFLax60QwJUWAnOZCVXWkFwx0iePsUdZiyfkaWbdJT
         jLl7HvNmnNqaMP1xF+ZLJS9kcw6IqJgJNt1IaU3gG7WLGCF5LigxCXEqSiyYLYvRgJ
         cHLxsCMRnk437wCYAifh8R0it1rIE2oaTeybxt64Xny6Tdjl3QWrL6vGBi9Jhfbtvy
         fE2xXh5YGlh6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Sasha Levin <sashal@kernel.org>, tiantao6@hisilicon.com,
        kwmad.kim@samsung.com, linus.walleij@linaro.org, huyue2@yulong.com,
        linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 138/217] mmc: core: Fixup storing of OCR for MMC_QUIRK_NONSTD_SDIO
Date:   Mon, 17 Jan 2022 21:18:21 -0500
Message-Id: <20220118021940.1942199-138-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 68edf7a615be5..5447c47157aa5 100644
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

