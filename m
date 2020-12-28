Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950202E64B5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391360AbgL1PwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:52:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391304AbgL1NiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F87620719;
        Mon, 28 Dec 2020 13:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162655;
        bh=GcYb3UGm+AeIRSJLrACdD7S2tv92iHyqNyHnlw1TMr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lv+A+Kb51lI/4/1cdx6pot+cjNTaa8CqjM87d32K6UEsSiyDLuhEmV0SnC40v8jUK
         AzZD44hsCOc+PERINW4TiGwHc6auPFudwwXIf+gaAUjgCQimnWViqz8AI3mbVYkR81
         B4pLafSVTdo+TVwlsa1T+vAXT/8Vrz936MyFfG7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/453] gpio: eic-sprd: break loop when getting NULL device resource
Date:   Mon, 28 Dec 2020 13:44:23 +0100
Message-Id: <20201228124938.565468823@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit 263ade7166a2e589c5b605272690c155c0637dcb ]

EIC controller have unfixed numbers of banks on different Spreadtrum SoCs,
and each bank has its own base address, the loop of getting there base
address in driver should break if the resource gotten via
platform_get_resource() is NULL already. The later ones would be all NULL
even if the loop continues.

Fixes: 25518e024e3a ("gpio: Add Spreadtrum EIC driver support")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Link: https://lore.kernel.org/r/20201209055106.840100-1-zhang.lyra@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-eic-sprd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-eic-sprd.c b/drivers/gpio/gpio-eic-sprd.c
index 8c97577740100..a69b3faf51ef0 100644
--- a/drivers/gpio/gpio-eic-sprd.c
+++ b/drivers/gpio/gpio-eic-sprd.c
@@ -598,7 +598,7 @@ static int sprd_eic_probe(struct platform_device *pdev)
 		 */
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (!res)
-			continue;
+			break;
 
 		sprd_eic->base[i] = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(sprd_eic->base[i]))
-- 
2.27.0



