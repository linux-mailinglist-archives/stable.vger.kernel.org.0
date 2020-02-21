Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 218D616709B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgBUHqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:46:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728728AbgBUHqh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:46:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 245F2208C4;
        Fri, 21 Feb 2020 07:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271196;
        bh=N/eg8j7+/VQQpWPilvFEU0iKw1etYKG95foZ33uOEK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWvp4PFna/T+NlL852+waHXlVkDcG16CEHhqSWe8N90fo+BbY+/wNzBkHA2Z87F+W
         r1ttj+l53+BLGBDTziMhcSm27QYMcm+37EdzN/XkHgXcExhu4/yrgy46USfDFFbrQu
         sWztvGgYACCuSVIXXmU9ItH0OpzqDNrsouxEjf4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lubomir Rintel <lkundrak@v3.sk>,
        YueHaibing <yuehaibing@huawei.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 038/399] pxa168fb: Fix the function used to release some memory in an error handling path
Date:   Fri, 21 Feb 2020 08:36:03 +0100
Message-Id: <20200221072406.065092273@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3c911fe799d1c338d94b78e7182ad452c37af897 ]

In the probe function, some resources are allocated using 'dma_alloc_wc()',
they should be released with 'dma_free_wc()', not 'dma_free_coherent()'.

We already use 'dma_free_wc()' in the remove function, but not in the
error handling path of the probe function.

Also, remove a useless 'PAGE_ALIGN()'. 'info->fix.smem_len' is already
PAGE_ALIGNed.

Fixes: 638772c7553f ("fb: add support of LCD display controller on pxa168/910 (base layer)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Lubomir Rintel <lkundrak@v3.sk>
CC: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190831100024.3248-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pxa168fb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/pxa168fb.c b/drivers/video/fbdev/pxa168fb.c
index 1410f476e135d..1fc50fc0694bc 100644
--- a/drivers/video/fbdev/pxa168fb.c
+++ b/drivers/video/fbdev/pxa168fb.c
@@ -766,8 +766,8 @@ failed_free_cmap:
 failed_free_clk:
 	clk_disable_unprepare(fbi->clk);
 failed_free_fbmem:
-	dma_free_coherent(fbi->dev, info->fix.smem_len,
-			info->screen_base, fbi->fb_start_dma);
+	dma_free_wc(fbi->dev, info->fix.smem_len,
+		    info->screen_base, fbi->fb_start_dma);
 failed_free_info:
 	kfree(info);
 
@@ -801,7 +801,7 @@ static int pxa168fb_remove(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 
-	dma_free_wc(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
+	dma_free_wc(fbi->dev, info->fix.smem_len,
 		    info->screen_base, info->fix.smem_start);
 
 	clk_disable_unprepare(fbi->clk);
-- 
2.20.1



