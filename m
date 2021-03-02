Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B88432AF28
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbhCCAPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383854AbhCBMLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:11:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD88464F43;
        Tue,  2 Mar 2021 11:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686217;
        bh=2830jk0Yx1O8DCWoLForj/JZjaz5APv9kJxORQ/tqTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rw5nnSsuMhWSuNPvC0uvlUGUMwnpqjNtinxaApNaSDaRH8o3tgWxkkFNlqipdZLa1
         mizAr9akMYco/tDsY9icamxz/iuDrjWewnAtoYFJfOo3sOutRTjCaRxgwEAgwxBN9a
         9kD8X6D3eoXTkaIplQPbQmJEdJZ27cabRA03139bWMNF8Zah4eew7AEdu1ZzgW/5gT
         9KCzHLV4kW/O8EC2CzEcZy54vE9ABlDBfkcNy+AHCJsLfj1mneGDq+me3c6qjeSVc/
         YxQVW1UmRAqemr5muCMSIJKBQl8HNGhD2XCVES9yH15jxYmofR7Vqd91YmdzrxXF/L
         Pgqj9xEvw6PAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/47] mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'
Date:   Tue,  2 Mar 2021 06:56:07 -0500
Message-Id: <20210302115646.62291-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
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
index 75007f61df97..4fbbff03137c 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -643,7 +643,7 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 
 	ret = mmc_of_parse(mmc);
 	if (ret)
-		goto out_clk_disable;
+		goto out_free_dma;
 
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
-- 
2.30.1

