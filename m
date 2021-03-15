Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5F033B8B2
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhCOOEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233102AbhCOOAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 845C364F44;
        Mon, 15 Mar 2021 14:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816826;
        bh=riBP4cCMfjoDZkOhUYUpGao3Je2K4TW0wlX8Sj6xuls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAW1KbIgTIqitr5zw5iV6YKfIDxLYYJ64p8p2Xdm3Flx3pbdKf8lqxRJbea0rsoU0
         DrPIzCZ4qqRP4gaAmhou+x+traSLUVVqHLwQzbUfFFx6y4Jvo8RMM1gA966VWlZIoY
         TCt6IZ+PyGbmJpK+suZe4AqVx+mt2GUBfiHmH7Hk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/290] mmc: mxs-mmc: Fix a resource leak in an error handling path in mxs_mmc_probe()
Date:   Mon, 15 Mar 2021 14:53:49 +0100
Message-Id: <20210315135546.508552356@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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



