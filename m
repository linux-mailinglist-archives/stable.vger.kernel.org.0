Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBE31DB67E
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgETOZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:25:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33036 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727017AbgETOW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-000369-Vi; Wed, 20 May 2020 15:22:20 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-007DQf-0f; Wed, 20 May 2020 15:22:19 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "YueHaibing" <yuehaibing@huawei.com>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>,
        "Lubomir Rintel" <lkundrak@v3.sk>
Date:   Wed, 20 May 2020 15:14:03 +0100
Message-ID: <lsq.1589984008.562400019@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 35/99] pxa168fb: Fix the function used to release
 some memory in an error handling path
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 3c911fe799d1c338d94b78e7182ad452c37af897 upstream.

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
[bwh: Backported to 3.16: Use dma_free_writecombine().]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/fbdev/pxa168fb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/video/fbdev/pxa168fb.c
+++ b/drivers/video/fbdev/pxa168fb.c
@@ -772,8 +772,8 @@ failed_free_cmap:
 failed_free_clk:
 	clk_disable(fbi->clk);
 failed_free_fbmem:
-	dma_free_coherent(fbi->dev, info->fix.smem_len,
-			info->screen_base, fbi->fb_start_dma);
+	dma_free_writecombine(fbi->dev, info->fix.smem_len,
+			      info->screen_base, fbi->fb_start_dma);
 failed_free_info:
 	kfree(info);
 failed_put_clk:
@@ -809,7 +809,7 @@ static int pxa168fb_remove(struct platfo
 
 	irq = platform_get_irq(pdev, 0);
 
-	dma_free_writecombine(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
+	dma_free_writecombine(fbi->dev, info->fix.smem_len,
 				info->screen_base, info->fix.smem_start);
 
 	clk_disable(fbi->clk);

