Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3740B15EF1E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389121AbgBNRpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388782AbgBNQCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:02:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74F2E217F4;
        Fri, 14 Feb 2020 16:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696154;
        bh=b/DkCkBjfmugWgVNNhk4QMI2Ne6zMW1uGQ9tVLzx0OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGbZ/rZ7YnQnQDN0uTxGA3bMTwi4TVvrO/+Z4q7I1OFPhm3KdDl95W9sipI+R8lL5
         wUY1riN++RyljP6vWzWoYCLDcdZ/VWKhRqqk/jiyD4N8cSMBT2jewE8F+w9eyYk+Z5
         W32j+XeM/aYmf6Qv8ooYlw2tJEndpfOvFNwzSMmE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lubomir Rintel <lkundrak@v3.sk>,
        YueHaibing <yuehaibing@huawei.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 033/459] pxa168fb: Fix the function used to release some memory in an error handling path
Date:   Fri, 14 Feb 2020 10:54:43 -0500
Message-Id: <20200214160149.11681-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -766,8 +766,8 @@ static int pxa168fb_probe(struct platform_device *pdev)
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

