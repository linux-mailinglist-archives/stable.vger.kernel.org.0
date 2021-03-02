Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4455B32AF09
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhCCAOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238203AbhCBL70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 06:59:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B044B64F1B;
        Tue,  2 Mar 2021 11:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686148;
        bh=BC4iG+BAX7fOeoIk8Z5bILRpPLlWS+DdRMqYxHDgz3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXXvbPxYG5etPmuRdnHUde1WG2GIoD/oj3eUzP4dQzRBbIpgCsyu+4bfuR9klpUdS
         AjvABnRhao29soqTbAI3cijQMPrHVPEE+UY1BZAsh/DCrPUrVpnTT1piXAHaA246Ux
         WpqTJWrkFXcTdHTM6L72XwfhHh6xhT0KGrhXMDWs01IaSBn3w27VHQEi9AnxU/o1Mn
         54vjKfAUrGjZqVnZV38BrMNv1bs3K4bzjNKCzEAUrFOn3E5Frys6xnubOCIRdK582F
         9tIyfqxVrbqPIMiRV/7Xjc5iKy6ZN8GvQz9Q78Lne4DmuZ6196uDX/2DXPaKLcb4rA
         YYI42B1Ipil1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 10/52] mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'
Date:   Tue,  2 Mar 2021 06:54:51 -0500
Message-Id: <20210302115534.61800-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
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
index 56bbc6cd9c84..947581de7860 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -628,7 +628,7 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 
 	ret = mmc_of_parse(mmc);
 	if (ret)
-		goto out_clk_disable;
+		goto out_free_dma;
 
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
-- 
2.30.1

