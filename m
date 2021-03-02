Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B76D32B0AC
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhCCAii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:38:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351402AbhCBOWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 09:22:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6960464FCD;
        Tue,  2 Mar 2021 11:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686378;
        bh=XQ2zSEW/W21CTzIhc5QdKoiwCXhCc8zccWUX161ff7M=;
        h=From:To:Cc:Subject:Date:From;
        b=Rqi1eerSfWOqcYuuYkcpBKEdWaaavIA7i5Dx++//HkotRIvfUhsnOBPvN6me+w1fM
         S//vcK7HXurtBjgPjaD/AnYbGzTrweB4lAzBe8gXh5cTwGpR6zDgzZSz3KOb0zWyBq
         CYeM87bHgzNPvCZC30i3v4kjfRBSfk0iZy8xQbbGrBSU5KfCxB/x6vMXosXnd+2sgR
         y4zHDbmF7F9yLKD8nas19XBMlYFdXAr4kJ669Oi7hXH0e3SxzjJR+vlHv21FfNPtVK
         bF1wGTBgTVWYFFnHLE1u4jx0IAPEfmmFywTcIQ8DfMpFtvghCzpXnVQ2i9yVwaLvvT
         dh6+NAUpOgdiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/8] mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'
Date:   Tue,  2 Mar 2021 06:59:28 -0500
Message-Id: <20210302115935.63777-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 0bb7e560f821c7770973a94e346654c4bdccd42c ]

If 'mmc_of_parse()' fails, we must undo the previous 'dma_request_chan()'
call.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201208203527.49262-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mxs-mmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index c8b8ac66ff7e..687fd68fbbcd 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -651,7 +651,7 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 
 	ret = mmc_of_parse(mmc);
 	if (ret)
-		goto out_clk_disable;
+		goto out_free_dma;
 
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
-- 
2.30.1

