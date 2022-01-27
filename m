Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A98E49DB4A
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 08:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbiA0HQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 02:16:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53462 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237229AbiA0HQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 02:16:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2C446199A;
        Thu, 27 Jan 2022 07:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7F1C340E4;
        Thu, 27 Jan 2022 07:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643267802;
        bh=aQTabdo3x60SROvtozm0EwIIrGbHYLocFPhck/zO6Jc=;
        h=From:To:Cc:Subject:Date:From;
        b=WslhGgR2y00UODDn5KbT/IGStk9Xi80kxmJs6CULbXBHErlwVoZ7CxofUHxur9+a3
         DHiPmbq4wV0grNLjMnn9mIp7lLUTOHp+0r9W91wAXZiYMCCREJ8SwPHxKSRd4ZrCrQ
         bcGYE3MZnnGdbkk5TVE9Q6qs6Kr/Ekj9HZlRRRXQ=
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
Subject: [PATCH v2] moxart: fix potential use-after-free on remove path
Date:   Thu, 27 Jan 2022 08:16:38 +0100
Message-Id: <20220127071638.4057899-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1450; h=from:subject; bh=aQTabdo3x60SROvtozm0EwIIrGbHYLocFPhck/zO6Jc=; b=owGbwMvMwCRo6H6F97bub03G02pJDImf3C5bhW/+b7q/OKvoGUODesuaq7cvrl4U9jPYmsNCJMmX U+1sRywLgyATg6yYIsuXbTxH91ccUvQytD0NM4eVCWQIAxenAEwkXYRhvt9Vjf2/Le8uWS7Xtufs8t mijtYPHjHMr+t7NvNmU4BmRegqrqCUheXJBS1NAA==
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
v2: changed to only move mmc_free_host() call as per Ulf's request

 drivers/mmc/host/moxart-mmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 16d1c7a43d33..b6eb75f4bbfc 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -705,12 +705,12 @@ static int moxart_remove(struct platform_device *pdev)
 	if (!IS_ERR_OR_NULL(host->dma_chan_rx))
 		dma_release_channel(host->dma_chan_rx);
 	mmc_remove_host(mmc);
-	mmc_free_host(mmc);
 
 	writel(0, host->base + REG_INTERRUPT_MASK);
 	writel(0, host->base + REG_POWER_CONTROL);
 	writel(readl(host->base + REG_CLOCK_CONTROL) | CLK_OFF,
 	       host->base + REG_CLOCK_CONTROL);
+	mmc_free_host(mmc);
 
 	return 0;
 }
-- 
2.35.0

