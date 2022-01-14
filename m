Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33AF148E520
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbiANH7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 02:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbiANH7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 02:59:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E548C061574;
        Thu, 13 Jan 2022 23:59:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59F66B82429;
        Fri, 14 Jan 2022 07:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3B5C36AEA;
        Fri, 14 Jan 2022 07:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642147178;
        bh=6gx+Rodw8cvBoMVxE+Y4vZD/tVT81r9J3THpcB3YR0Q=;
        h=From:To:Cc:Subject:Date:From;
        b=ifG4g1Z5D8niC9jSd62XffyPrxPTPWZQa23pmX0b7EUOwK5MuPJjjSwh7Elt2kvRQ
         3fss1wTzG2rCTGM9RQUhIij47guoFhdrvd1S5qhW9+8CaUQ+bf+j6JfWt0YQQTNPRw
         8RnmbFTR6VdOszcDgaDHat7W8P3vZ4Y8kwU/6xlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        linux-mmc@vger.kernel.org, stable <stable@vger.kernel.org>,
        whitehat002 <hackyzh002@gmail.com>
Subject: [PATCH] moxart: fix potential use-after-free on remove path
Date:   Fri, 14 Jan 2022 08:59:34 +0100
Message-Id: <20220114075934.302464-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1710; h=from:subject; bh=6gx+Rodw8cvBoMVxE+Y4vZD/tVT81r9J3THpcB3YR0Q=; b=owGbwMvMwCRo6H6F97bub03G02pJDIkPdZM/TjgqdvP12rD3HOXWN4ojdmyKY6l4NeH1m7qIZ5Pc TXsjO2JZGASZGGTFFFm+bOM5ur/ikKKXoe1pmDmsTCBDGLg4BWAik50Y5mkfFwjVKqvWsYqqE+pRSf hVET1/NcNstugZ12/M77TJmZK1vab9wqQkl4VTAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It was reported that the mmc host structure could be accessed after it
was freed in moxart_remove(), so fix this by saving the base register of
the device and using it instead of the pointer dereference.

Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Xin Xiong <xiongx18@fudan.edu.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Cc: linux-mmc@vger.kernel.org
Cc: stable <stable@vger.kernel.org>
Reported-by: whitehat002 <hackyzh002@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/moxart-mmc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 16d1c7a43d33..f5d96940a9b8 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -697,6 +697,7 @@ static int moxart_remove(struct platform_device *pdev)
 {
 	struct mmc_host *mmc = dev_get_drvdata(&pdev->dev);
 	struct moxart_host *host = mmc_priv(mmc);
+	void __iomem *base = host->base;
 
 	dev_set_drvdata(&pdev->dev, NULL);
 
@@ -707,10 +708,10 @@ static int moxart_remove(struct platform_device *pdev)
 	mmc_remove_host(mmc);
 	mmc_free_host(mmc);
 
-	writel(0, host->base + REG_INTERRUPT_MASK);
-	writel(0, host->base + REG_POWER_CONTROL);
-	writel(readl(host->base + REG_CLOCK_CONTROL) | CLK_OFF,
-	       host->base + REG_CLOCK_CONTROL);
+	writel(0, base + REG_INTERRUPT_MASK);
+	writel(0, base + REG_POWER_CONTROL);
+	writel(readl(base + REG_CLOCK_CONTROL) | CLK_OFF,
+	       base + REG_CLOCK_CONTROL);
 
 	return 0;
 }
-- 
2.34.1

